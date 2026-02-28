import 'package:ar_chem_lab/domain/entities/periodic_table_response.dart';

abstract class PeriodicTableRepository {
  Future<List<PeriodicTableResponse>?> getPeriodicTableData();
}