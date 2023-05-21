import 'dart:io';
import 'package:get/get.dart';

class FetchVideoFiles extends GetxController {
  Future<List<String>> fetchMusic() async {
    Directory directory = Directory('/storage/emulated/0');
    List<FileSystemEntity> files = directory.listSync(recursive: true);
    List<String> mp4Files = [];
    for (FileSystemEntity file in files) {
      if (file.path.endsWith('.mp4')) {
        mp4Files.add(file.path);
      }
    }
    return mp4Files;
  }
}
