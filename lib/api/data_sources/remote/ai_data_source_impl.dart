import 'package:ar_chem_lab/api/mapper/gemini_mapper.dart';
import 'package:ar_chem_lab/api/web_services.dart';
import 'package:ar_chem_lab/core/exceptions/app_exceptions.dart';
import 'package:ar_chem_lab/data/data_sources/remote/ai_data_source.dart';
import 'package:ar_chem_lab/domain/entities/ai_message.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AiDataSource)
class AiDataSourceImpl implements AiDataSource {
  final WebServices webServices;
  AiDataSourceImpl({required this.webServices});

  @override
  Future<AiMessage> sendMessage(String text) async {
    try {
      final request = text.toGeminiDto();
      final response = await webServices.sendMessage(request);
      return response.toDomain();
    } on DioException catch (e) {
      if (e.error is AppExceptions) {
        throw e.error as AppExceptions;
      }
      throw ServerException(message: e.message ?? "Server Error");
    } catch (e) {
      throw UnexpectedException(message: e.toString());
    }
  }
}
