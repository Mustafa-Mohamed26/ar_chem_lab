import 'package:ar_chem_lab/domain/entities/ai_message.dart';
import 'package:ar_chem_lab/domain/repositories/ai_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChatBotUseCase {
  final AiRepository aiRepository;

  ChatBotUseCase(this.aiRepository);

  Future<AiMessage> invoke(String text) => aiRepository.sendMessage(text);
}
