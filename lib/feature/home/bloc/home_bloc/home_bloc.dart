// ignore: depend_on_referenced_packages
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:novastrid/utils/file_saver.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  Uint8List? selectedFileBytes;
  String? selectedFileName;
  HomeBloc() : super(HomeInitialState()) {
    on<HomeEvent>((event, emit) {});
    on<DownloadPickedFile>((event, emit) async {
      emit(DownloadInProgressState());
      try {
        String? message = await FileDownloader.instance
            .downLoadFile(selectedFileBytes!, selectedFileName!);
        if (message == null) {
          emit(DownloadFailedState(
              error: "Failed to download.Please try again"));
          return;
        }
        emit(DownloadCompletedState(message: message));
      } catch (e) {
        emit(DownloadFailedState(error: "Failed to download.Please try again"));
        debugPrint("Exception in DownloadPickedFile $e");
      }
    });
    on<PickFileEvent>((event, emit) async {
      emit(DocUploadInProgressState());
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles();

        if (result != null) {
          Uint8List? tempByteData = result.files.single.bytes;
          tempByteData ??= await File(result.files.single.path!).readAsBytes();
          String fileName = result.files.single.name;
          selectedFileName = fileName;
          selectedFileBytes = tempByteData;
          emit(
            DocUploadSuccessfulState(
              fileBytes: tempByteData,
              fileName: fileName,
            ),
          );
          // final response =
          //     await FileDownloader.instance.downLoadFile(byteData, fileName);

          debugPrint(
              "PickFileEvent ${result.files.first.name} : downloaded fileName : $fileName  ");
        } else {
          emit(DocUploadFailedState(error: "Document Upload Failed"));
        }
      } catch (e) {
        debugPrint("Ecxception in PickFileEvent $e");
        emit(DocUploadFailedState(error: "Document Upload Failed"));
      }
    });
    on<UploadDropFileEvent>((event, emit) async {
      emit(DocUploadInProgressState());
      try {
        if (event.droppedDetails.files.isNotEmpty) {
          if (event.droppedDetails.files.length == 1) {
            final byteData =
                await event.droppedDetails.files.first.readAsBytes();
            final fileName = event.droppedDetails.files.first.name;
            selectedFileBytes = byteData;
            selectedFileName = fileName;

            emit(
              DocUploadSuccessfulState(
                fileBytes: byteData,
                fileName: fileName,
              ),
            );
          } else {
            emit(DocUploadFailedState(
                error: "You can drop only one file at a time"));
          }

          // final result =
          //     await FileDownloader.instance.downLoadFile(byteData, fileName);
          // debugPrint("onDragDone UploadDropFileEvent $result ");
        }
      } catch (e) {
        emit(DocUploadFailedState(error: "Document Upload Failed"));
        debugPrint("Exception in UploadDropFileEvent $e");
      }
    });
    on<ResetHomeBlocEvent>((event, emit) {
      emit(HomeInitialState());
    });
  }
}
