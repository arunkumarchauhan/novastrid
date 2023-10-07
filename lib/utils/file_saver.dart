import 'package:flutter/foundation.dart';
import 'package:download/download.dart' as downloader;

class FileDownloader {
  FileDownloader._();
  static final FileDownloader _instance = FileDownloader._();
  static FileDownloader get instance => _instance;

  Future<String?> downLoadFile(Uint8List byteData, String docFileName) async {
    try {
      // if (kIsWeb) {
      return _downloadFileFromWeb(byteData, docFileName);
      // }
    } catch (e) {
      debugPrint("Exception in downLoadFile $e");
      return null;
    }
    //  return null;
  }

  Future<String?> _downloadFileFromWeb(
      Uint8List byteData, String docFileName) async {
    try {
      final stream = Stream.fromIterable(byteData);
      final fileName =
          (DateTime.now().toString() + docFileName).replaceAll(" ", "");

      downloader.download(stream, fileName);
      return "$fileName Downloaded";
    } catch (e) {
      debugPrint("Exception saving file from web $e");

      return null;
    }
  }
}
