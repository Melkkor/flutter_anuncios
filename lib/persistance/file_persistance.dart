import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_anuncios/model/item.dart';

class FilePersistance {
  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    String _localPath = directory.path;
    File localFile = File('$_localPath/tasklist.json');
    if (localFile.existsSync()) {
      return localFile;
    } else {
      return localFile.create(recursive: true);
    }
  }

  Future saveData(List<Item> tasks) async {
    File localFile = await _getLocalFile();
    List<Map<String, dynamic>> data = [];

    tasks.forEach((task) {
      data.add(task.toMap());
    });

    String json = jsonEncode(data);
    return localFile.writeAsStringSync(json);
  }

  Future readData() async {
    try {
      File localData = await _getLocalFile();
      String json = localData.readAsStringSync();

      List<Map<String, dynamic>> data = jsonDecode(json);
      List<Item> tasks = List.empty(growable: true);

      data.forEach((element) {
        tasks.add(Item.fromMap(element));
      });

      return tasks;
    } catch (error) {
      print(error);
      return null;
    }
  }
}
