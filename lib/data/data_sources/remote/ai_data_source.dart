import 'package:ar_chem_lab/domain/entities/ai_message.dart';

abstract class AiDataSource {
  Future<AiMessage> sendMessage(String text);
}
