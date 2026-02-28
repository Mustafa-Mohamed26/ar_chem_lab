import 'package:ar_chem_lab/api/web_services.dart';
import 'package:ar_chem_lab/core/exceptions/app_exceptions.dart';
import 'package:ar_chem_lab/data/data_sources/remote/periodic_table_data_source.dart';
import 'package:ar_chem_lab/domain/entities/periodic_table_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: PeriodicTableDataSource)
class PeriodicTableDataSourceImpl implements PeriodicTableDataSource {
  WebServices webServices;
  PeriodicTableDataSourceImpl({required this.webServices});

  @override
  Future<List<PeriodicTableResponse>> getPeriodicTableData() async {
    try {
      var response = await webServices.getPeriodicTable();
      // convert response to domain model
      return response.map((dto) => dto.toDomain()).toList();
    } on DioException catch (e) {
      String message = "Server Error";
      if (e.error is AppExceptions) {
        message = (e.error as AppExceptions).message;
      } else if (e.message != null) {
        message = e.message!;
      }
      throw ServerException(message: message);
    } catch (e) {
      rethrow;
    }
  }
}
