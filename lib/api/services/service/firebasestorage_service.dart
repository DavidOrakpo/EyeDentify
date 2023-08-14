import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

import '../../../core/Utilities/utils/utils.dart';

class StorageService {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFile(String filePath, String fileName) async {
    File file = File(filePath);

    try {
      await storage.ref('test/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      logger.e(e.toString());
    }
  }

  Future<firebase_storage.ListResult> listFiles() async {
    firebase_storage.ListResult result = await storage.ref('test').listAll();

    for (var ref in result.items) {
      logger.i('Found file $ref');
    }

    return result;
  }

  Future<String> downloadUrl(String imageName) async {
    String downloadUrl = await storage.ref('test/$imageName').getDownloadURL();

    return downloadUrl;
  }
}
