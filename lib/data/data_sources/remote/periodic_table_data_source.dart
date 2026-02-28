import 'package:ar_chem_lab/domain/entities/periodic_table_response.dart';

abstract class PeriodicTableDataSource {
  Future<List<PeriodicTableResponse>> getPeriodicTableData();
}
