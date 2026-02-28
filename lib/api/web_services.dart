import 'package:ar_chem_lab/api/models/response/element_response_dto.dart';
import 'package:dio/dio.dart';

class WebServices {
  final Dio dio;

  WebServices(this.dio);

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
}
