part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitialState extends HomeState {}

class DownloadInProgressState extends HomeState {}

class DownloadFailedState extends HomeState {
  final String error;
  DownloadFailedState({required this.error});
  @override
  List<Object?> get props => [error];
}

class DownloadCompletedState extends HomeState {
  final String message;

  DownloadCompletedState({required this.message});
}

abstract class DocUploadState extends HomeState {}

class DocUploadInProgressState extends DocUploadState {}

class DocUploadFailedState extends DocUploadState {
  final String error;
  DocUploadFailedState({required this.error});
  @override
  List<Object?> get props => [error];
}

class DocUploadSuccessfulState extends DocUploadState {
  final String fileName;
  final Uint8List fileBytes;
  DocUploadSuccessfulState({required this.fileBytes, required this.fileName});
  @override
  List<Object?> get props => [fileName, ...fileBytes];
}
