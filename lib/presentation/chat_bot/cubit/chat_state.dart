import 'package:ar_chem_lab/domain/entities/ai_message.dart';

abstract class ChatState {
  final List<AiMessage> messages;
  ChatState(this.messages);
}

class ChatInitial extends ChatState {
  ChatInitial() : super([]);
}

class ChatLoading extends ChatState {
  ChatLoading(super.messages);
}

class ChatSuccess extends ChatState {
  ChatSuccess(super.messages);
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message, super.messages);
}
