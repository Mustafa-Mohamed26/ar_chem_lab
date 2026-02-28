import 'package:ar_chem_lab/data/data_sources/remote/ai_data_source.dart';
import 'package:ar_chem_lab/domain/entities/ai_message.dart';
import 'package:ar_chem_lab/domain/repositories/ai_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AiRepository)
class AiRepositoryImpl implements AiRepository {
  final AiDataSource _dataSource;

  AiRepositoryImpl(this._dataSource);

  @override
  Future<AiMessage> sendMessage(String text) async {
    return _dataSource.sendMessage(text);
  }
}
