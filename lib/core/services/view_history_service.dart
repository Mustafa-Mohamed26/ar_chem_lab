import 'package:ar_chem_lab/domain/entities/periodic_table_response.dart';
import 'package:ar_chem_lab/presentation/periodic_table/elements_data.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewHistoryService {
  static final ViewHistoryService _instance = ViewHistoryService._internal();

  factory ViewHistoryService() {
    return _instance;
  }

  ViewHistoryService._internal();

  static const String _key = 'most_viewed_elements';

  final ValueNotifier<List<PeriodicTableResponse>> mostViewedElements =
      ValueNotifier<List<PeriodicTableResponse>>([]);

  Future<void> loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? savedIds = prefs.getStringList(_key);

      if (savedIds != null && savedIds.isNotEmpty) {
        final List<PeriodicTableResponse> loadedElements = [];
        final allElements = ElementData.allElements;

        for (var idStr in savedIds) {
          final id = int.tryParse(idStr);
          if (id != null) {
            try {
              final element = allElements.firstWhere(
                (e) => e.atomicNumber == id,
              );
              loadedElements.add(element);
            } catch (_) {
              // Element not found in local data, skip
            }
          }
        }
        mostViewedElements.value = loadedElements;
      }
    } catch (e) {
      debugPrint('Error loading history: $e');
    }
  }

  Future<void> _saveHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> idsToSave = mostViewedElements.value
          .map((e) => e.atomicNumber.toString())
          .toList();
      await prefs.setStringList(_key, idsToSave);
    } catch (e) {
      debugPrint('Error saving history: $e');
    }
  }

  void addElement(PeriodicTableResponse element) {
    if (element.isEmpty) return;

    List<PeriodicTableResponse> currentList = List.from(
      mostViewedElements.value,
    );

    // If element already exists, remove it to move it to the end (most recent)
    currentList.remove(element);

    // Add to the end
    currentList.add(element);

    // Keep only the last 10
    if (currentList.length > 10) {
      currentList.removeAt(0);
    }

    mostViewedElements.value = currentList;
    _saveHistory();
  }
}
