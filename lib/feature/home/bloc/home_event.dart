part of 'home_bloc.dart';

abstract class HomeEvent {}

class FileDroppedEvent extends HomeEvent {
  final File droppedFile;
  FileDroppedEvent({required this.droppedFile});
}

class ChooseFileEvent extends HomeEvent {}
