import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PersistMessages {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/shouldSync.txt');
  }

  Future<bool> readShouldSync() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();
      
      int value = int.parse(contents);
      return !(value==0);
    } catch (e) {
      // If encountering an error, return 0
      return false;
    }
  }

  Future<File> writeShouldSync(bool shouldSync) async {
    final file = await _localFile;
    int value = shouldSync?1:0;
    // Write the file
    return file.writeAsString('$value');
  }
}