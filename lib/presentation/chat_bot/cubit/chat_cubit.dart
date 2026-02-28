import 'package:ar_chem_lab/domain/entities/ai_message.dart';
import 'package:ar_chem_lab/domain/use_cases/chat_bot_use_case.dart';
import 'package:ar_chem_lab/presentation/chat_bot/cubit/chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChatCubit extends Cubit<ChatState> {
  final ChatBotUseCase _chatBotUseCase;
  final List<AiMessage> _messages = [];

  ChatCubit(this._chatBotUseCase) : super(ChatInitial());

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = AiMessage(
      text: text,
      isUser: true,
      time: DateTime.now(),
    );

    _messages.add(userMessage);
    emit(ChatSuccess(List.from(_messages)));
    emit(ChatLoading(List.from(_messages)));

    try {
      final botMessage = await _chatBotUseCase.invoke(text);
      _messages.add(botMessage);
      emit(ChatSuccess(List.from(_messages)));
    } catch (e) {
      emit(ChatError(e.toString(), List.from(_messages)));
    }
  }
}
