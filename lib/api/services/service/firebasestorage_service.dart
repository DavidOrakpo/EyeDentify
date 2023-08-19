// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_string/random_string.dart';
import 'package:template/presentation/views/Home/viewModel/home_page_view_model.dart';

import '../../../core/Utilities/utils/utils.dart';

final storageServiceProvider =
    ChangeNotifierProvider((ref) => _StorageService(ref: ref));

class _StorageService with ChangeNotifier {
  Ref ref;
  _StorageService({
    required this.ref,
  });
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
    var temp = await storage.ref("docs");
    // var temp2 = await storage.ref("docs");
    firebase_storage.ListResult result = await storage.ref('docs').listAll();

    for (var ref in result.items) {
      logger.i('Found file $ref');
    }

    return result;
  }

  Future<void> getDescribedTextFromPalmApi() async {
    var snap = await FirebaseFirestore.instance
        .collection('eyeDentifiedObjects')
        .doc(ref.read(homePageVM).currentScannedObjectID)
        .get();
    logger.i(snap.data()?["text"]);
    ref.read(homePageVM).currentDescribedTextFromPalmApi.value =
        snap.data()?["text"] ?? null;
  }

  Future<void> downloadUrl(String assetName) async {
    try {
      const oneMegabyte = 1024 * 1024;
      var downloadedQueryQudio =
          await storage.ref("docs/$assetName.mp3").getData(oneMegabyte);
      if (downloadedQueryQudio == null) {
        return;
      }

      await ref
          .read(homePageVM)
          .audioPlayer
          .play(BytesSource(downloadedQueryQudio));
      // AudioPlayer().play(source)
      // String downloadUrl = await storage.ref('test/$assetName').getDownloadURL();

      // return downloadUrl;
    } catch (e) {
      logger.e(e.toString());
    }
  }
}

class FireBaseTextToSpeechExtension {
  final FirebaseFirestore _firestore;

  FireBaseTextToSpeechExtension({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  static String createID(String text) {
    return "eyeDentified_${text}_${randomAlphaNumeric(14)}";
  }

  Future<void> sendTextToSpeek(String text, String generatedID) async {
    // final generatedID = createID(text);
    await _firestore.collection('eyeDentifiedObjects').doc(generatedID).set({
      "id": generatedID,
      "labels": text,
      "languageCode": "en-GB", // Optional if per-document overrides are enabled
      "ssmlGender": "2", // Optional if per-document overrides are enabled
      // "audioEncoding": "MP3", // Optional if per-document overrides are enabled
      // "voiceName":
      //     "en-US-Wavenet-A" // Optional if per-document overrides are enabled
    });

    // ref.snapshots().listen((event) {
    //   logger.e(event.data());
    // });
  }
}
