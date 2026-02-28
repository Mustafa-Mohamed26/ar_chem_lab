import 'package:ar_chem_lab/data/data_sources/remote/periodic_table_data_source.dart';
import 'package:ar_chem_lab/domain/entities/periodic_table_response.dart';
import 'package:ar_chem_lab/domain/repositories/periodic_table_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: PeriodicTableRepository)
class PeriodicTableRepositoryImp implements PeriodicTableRepository {
  PeriodicTableDataSource remoteDataSource;
  PeriodicTableRepositoryImp(this.remoteDataSource);
  @override
  Future<List<PeriodicTableResponse>?> getPeriodicTableData() {
    return remoteDataSource.getPeriodicTableData();
  }
}
