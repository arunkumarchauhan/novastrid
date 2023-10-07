part of 'text_description_bloc.dart';

abstract class TextDescriptionEvent extends Equatable {
  const TextDescriptionEvent();

  @override
  List<Object> get props => [];
}

class ChangeTextStyleEvent extends TextDescriptionEvent {
  final Text? text;
  const ChangeTextStyleEvent({required this.text});
}
