import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'bot_dialogues_state.dart';

class BotDialoguesCubit extends Cubit<BotDialoguesState> {
  BotDialoguesCubit() : super(const BotDialoguesInitial());

  void botGotCheck() {
    emit(const BotDialogueTriggered('OOPS, I gotta look out'));
    _resetAfterDelay();
  }

  void botGaveCheck() {
    emit(const BotDialogueTriggered('Check! few moves to victory!'));
    _resetAfterDelay();
  }

  void botGotCheckMate() {
    emit(const BotDialogueTriggered('Oh no!'));
    _resetAfterDelay();
  }

  void botAppreciates() {
    emit(const BotDialogueTriggered('Great move!'));
    _resetAfterDelay();
  }

  void botGreets() {
    emit(const BotDialogueTriggered('Hello, ready to lose?'));
    _resetAfterDelay(duration: 4);
  }

  void botWorries() {
    emit(const BotDialogueTriggered('How did I miss my piece?'));
    _resetAfterDelay();
  }

  void botTeases() {
    debugPrint('Bot teases');
    emit(const BotDialogueTriggered('HAHA you should watch out!'));
    _resetAfterDelay();
  }

  void _resetAfterDelay({int duration = 2}) {
    Future.delayed(Duration(seconds: duration), () {
      emit(const BotDialoguesInitial());  // Reset state
    });
  }
}
