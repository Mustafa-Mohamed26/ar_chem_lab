import 'package:ar_chem_lab/domain/entities/periodic_table_response.dart';
import 'package:ar_chem_lab/domain/repositories/periodic_table_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPeriodicTableUseCase {
  PeriodicTableRepository periodicTableRepository;
  GetPeriodicTableUseCase(this.periodicTableRepository);

  Future<List<PeriodicTableResponse>?> invoke() =>
      periodicTableRepository.getPeriodicTableData();
}
