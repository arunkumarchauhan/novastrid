part of 'text_description_bloc.dart';

class TextDescriptionState extends Equatable {
  const TextDescriptionState();

  @override
  List<Object> get props => [];
}

class ChangeTextDescriptionStyleState extends TextDescriptionState {
  final Text? text;
  final int dateTime;
  const ChangeTextDescriptionStyleState(
      {required this.text, required this.dateTime});
  @override
  List<Object> get props => [dateTime];
}
