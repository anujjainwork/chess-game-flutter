part of 'bot_dialogues_cubit.dart';

abstract class BotDialoguesState extends Equatable {
  final String message;
  final bool isSmallText;

  const BotDialoguesState(this.message, this.isSmallText);

  @override
  List<Object?> get props => [message, isSmallText];
}

class BotDialoguesInitial extends BotDialoguesState {
  const BotDialoguesInitial() : super('', true);
}

class BotDialogueTriggered extends BotDialoguesState {
  const BotDialogueTriggered(String message) 
      : super(message, message.length < 25);
}
