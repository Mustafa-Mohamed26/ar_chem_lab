import 'package:ar_chem_lab/api/api_endpoints.dart';
import 'package:ar_chem_lab/api/models/request/gemini_request_dto.dart';
import 'package:ar_chem_lab/api/models/response/periodic_table_response_dto.dart';
import 'package:ar_chem_lab/api/models/response/gemini_response_dto.dart';
import 'package:dio/dio.dart';
import 'package:ar_chem_lab/api/models/request/user_request_dto.dart';
import 'package:ar_chem_lab/api/models/request/login_request_dto.dart';

class WebServices {
  final Dio dio;

  WebServices(this.dio);

  Future<String> register(UserRequestDto request) async {
    try {
      final response = await dio.post(
        ApiEndpoints.register,
        data: request.toJson(),
      );
      return response.data["message"] as String;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> login(LoginRequestDto request) async {
    try {
      final response = await dio.post(
        ApiEndpoints.login,
        data: request.toJson(),
      );
      return response.data["access_token"] as String;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PeriodicTableResponseDto>> getPeriodicTable() async {
    try {
      final response = await dio.get(
        "https://pubchem.ncbi.nlm.nih.gov/rest/pug/periodictable/JSON",
      );
      final data = response.data;
      final columns = List<String>.from(data["Table"]["Columns"]["Column"]);
      final rows = data["Table"]["Row"] as List;

      return rows.map((row) {
        return PeriodicTableResponseDto.fromRow(columns, row["Cell"]);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<GeminiResponseDto> sendMessage(GeminiRequestDto request) async {
    try {
      final response = await dio.post(
        ApiEndpoints.geminiChat,
        data: request.toJson(),
      );
      return GeminiResponseDto.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
