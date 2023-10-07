part of 'home_bloc.dart';

abstract class HomeEvent {}

class DownloadPickedFile extends HomeEvent {
  final File droppedFile;
  DownloadPickedFile({required this.droppedFile});
}

class UploadDropFileEvent extends HomeEvent {
  final DropDoneDetails droppedDetails;
  UploadDropFileEvent({required this.droppedDetails});
}

class PickFileEvent extends HomeEvent {
  PickFileEvent();
}

class ResetHomeBlocEvent extends HomeEvent {
  ResetHomeBlocEvent();
}
