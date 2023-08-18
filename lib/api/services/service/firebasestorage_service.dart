import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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
    firebase_storage.ListResult result = await storage.ref('docs').listAll();

    for (var ref in result.items) {
      logger.e('Found file $ref');
    }

    return result;
  }

  Future<String> downloadUrl(String imageName) async {
    String downloadUrl = await storage.ref('test/$imageName').getDownloadURL();

    return downloadUrl;
  }
}

class FireBaseTextToSpeechExtension {
  final FirebaseFirestore _firestore;

  FireBaseTextToSpeechExtension({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> sendTextToSpeek(String text) async {
    final ref = await _firestore.collection('docs').add({
      "text": text,
      "languageCode": "en-US", // Optional if per-document overrides are enabled
      "ssmlGender": "FEMALE", // Optional if per-document overrides are enabled
      "audioEncoding": "MP3", // Optional if per-document overrides are enabled
      "voiceName":
          "en-US-Wavenet-A" // Optional if per-document overrides are enabled
    });

    ref.snapshots().listen((event) {
      logger.e(event.data());
    });
  }
}
