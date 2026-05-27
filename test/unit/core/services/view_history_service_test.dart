import 'package:ar_chem_lab/core/services/view_history_service.dart';
import 'package:ar_chem_lab/domain/entities/periodic_table_response.dart';
import 'package:ar_chem_lab/presentation/periodic_table/elements_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ViewHistoryService Unit Tests', () {
    late ViewHistoryService service;
    late PeriodicTableResponse hydrogen;
    late PeriodicTableResponse helium;
    late PeriodicTableResponse lithium;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      service = ViewHistoryService();
      // Reset notifier value for each test since it's a singleton
      service.mostViewedElements.value = [];
      
      hydrogen = ElementData.allElements.firstWhere((e) => e.atomicNumber == 1);
      helium = ElementData.allElements.firstWhere((e) => e.atomicNumber == 2);
      lithium = ElementData.allElements.firstWhere((e) => e.atomicNumber == 3);
    });

    test('Singleton instances should be identical', () {
      final instance1 = ViewHistoryService();
      final instance2 = ViewHistoryService();
      expect(identical(instance1, instance2), isTrue);
    });

    test('addElement should not add if element.isEmpty is true', () async {
      const emptyElement = PeriodicTableResponse(isEmpty: true, atomicNumber: 999);
      await service.addElement(emptyElement);
      expect(service.mostViewedElements.value, isEmpty);
    });

    test('addElement should add element to history and save to shared preferences', () async {
      await service.addElement(hydrogen);
      expect(service.mostViewedElements.value.length, 1);
      expect(service.mostViewedElements.value.first, hydrogen);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getStringList('most_viewed_elements'), ['1']);
    });

    test('adding existing element should move it to the end (most recent)', () async {
      await service.addElement(hydrogen);
      await service.addElement(helium);
      // Order should be [hydrogen, helium]
      expect(service.mostViewedElements.value, [hydrogen, helium]);

      // Add hydrogen again, should move to the end
      await service.addElement(hydrogen);
      expect(service.mostViewedElements.value, [helium, hydrogen]);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getStringList('most_viewed_elements'), ['2', '1']);
    });

    test('should limit elements to a maximum of 10', () async {
      // Add 11 unique elements
      for (int i = 1; i <= 11; i++) {
        final element = ElementData.allElements.firstWhere((e) => e.atomicNumber == i);
        await service.addElement(element);
      }

      // Max size is 10
      expect(service.mostViewedElements.value.length, 10);
      // The first element added (atomicNumber: 1, hydrogen) should have been evicted
      expect(service.mostViewedElements.value.any((e) => e.atomicNumber == 1), isFalse);
      expect(service.mostViewedElements.value.last.atomicNumber, 11);
    });

    test('loadHistory should retrieve and map atomic numbers from shared preferences', () async {
      SharedPreferences.setMockInitialValues({
        'most_viewed_elements': ['1', '3', '2']
      });

      await service.loadHistory();
      
      expect(service.mostViewedElements.value.length, 3);
      expect(service.mostViewedElements.value[0], hydrogen);
      expect(service.mostViewedElements.value[1], lithium);
      expect(service.mostViewedElements.value[2], helium);
    });
  });
}
