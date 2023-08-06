import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite/tflite.dart';

final homePageVM = ChangeNotifierProvider((ref) => HomePageViewModel());

class HomePageViewModel with ChangeNotifier {
  ValueNotifier<bool> isCameraInitialized = ValueNotifier(false);

  late CameraController cameraController;
  late List<CameraDescription> camerasList;

  var cameraCount = 0;
  var x = 0.0, y = 0.0, w = 0.0, h = 0.0;
  var label = "";

  Future<void> initCamera() async {
    if (await Permission.camera.request().isGranted) {
      camerasList = await availableCameras();
      cameraController = CameraController(camerasList[0], ResolutionPreset.max);
      await cameraController.initialize().then((value) {
        cameraController.startImageStream((image) {
          cameraCount++;
          if (cameraCount % 10 == 0) {
            cameraCount = 0;
            objectDetector(image);
          }
          notifyListeners();
        });
      });
      isCameraInitialized.value = true;
      notifyListeners();
    }
  }

  Future<void> objectDetector(CameraImage image) async {
    var detector = await Tflite.detectObjectOnFrame(
      bytesList: image.planes.map((e) {
        return e.bytes;
      }).toList(),
      model: "SSDMobileNet",
      imageHeight: image.height,
      imageWidth: image.width,
      imageMean: 127.5, // defaults to 127.5
      imageStd: 127.5, // defaults to 127.5
      rotation: 90, // defaults to 90, Android only
      numResultsPerClass: 5,
      asynch: true,
    );

    if (detector != null) {
      if (detector.isEmpty) {
        return;
      }
      var detectedObject = detector.firstOrNull;
      if (detectedObject == null) {
        return;
      }
      label = detectedObject["detectedClass"].toString();
      h = detectedObject["rect"]["h"];
      w = detectedObject["rect"]["w"];
      x = detectedObject["rect"]["x"];
      y = detectedObject["rect"]["y"];
      log("Result is $detector");
      notifyListeners();
    }
  }

  Future<void> initTFLite() async {
    await Tflite.loadModel(
      model: "assets/models/ssd_mobilenet.tflite",
      labels: "assets/models/ssd_mobilenet.txt",
      isAsset: true,
      numThreads: 1,
      useGpuDelegate: false,
    );
  }
}
