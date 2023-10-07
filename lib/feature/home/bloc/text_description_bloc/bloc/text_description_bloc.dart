import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'text_description_event.dart';
part 'text_description_state.dart';

class TextDescriptionBloc
    extends Bloc<TextDescriptionEvent, TextDescriptionState> {
  TextDescriptionBloc()
      : super(const ChangeTextDescriptionStyleState(
            text: Text(
              "",
              style: TextStyle(),
            ),
            dateTime: 0)) {
    on<TextDescriptionEvent>((event, emit) {});
    on<ChangeTextStyleEvent>((event, emit) {
      emit(ChangeTextDescriptionStyleState(
          text: event.text, dateTime: DateTime.now().microsecondsSinceEpoch));
    });
  }
}
