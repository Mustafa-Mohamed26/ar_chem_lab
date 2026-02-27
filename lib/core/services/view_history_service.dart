import 'package:ar_chem_lab/presentation/periodic_table/element_model.dart';
import 'package:flutter/foundation.dart';

class ViewHistoryService {
  static final ViewHistoryService _instance = ViewHistoryService._internal();

  factory ViewHistoryService() {
    return _instance;
  }

  ViewHistoryService._internal();

  final ValueNotifier<List<ElementModel>> mostViewedElements =
      ValueNotifier<List<ElementModel>>([]);

  void addElement(ElementModel element) {
    if (element.isEmpty) return;

    List<ElementModel> currentList = List.from(mostViewedElements.value);

    // If element already exists, remove it to move it to the end (most recent)
    currentList.remove(element);

    // Add to the end
    currentList.add(element);

    // Keep only the last 10
    if (currentList.length > 10) {
      currentList.removeAt(0);
    }

    mostViewedElements.value = currentList;
  }
}
