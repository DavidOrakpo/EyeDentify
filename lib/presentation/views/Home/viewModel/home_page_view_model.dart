import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:template/api/models/recognition.dart';
import 'package:template/core/Enums/ready_state.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:tflite/tflite.dart';

// import '../../../../core/Utilities/screen_params.dart';

final homePageVM = ChangeNotifierProvider((ref) => HomePageViewModel());

class HomePageViewModel with ChangeNotifier {
  ValueNotifier<bool> isCameraInitialized = ValueNotifier(false);

  late CameraController cameraController;
  late List<CameraDescription> camerasList;

  var cameraCount = 0;
  var x = 0.0, y = 0.0, w = 0.0, h = 0.0;
  var top = 0.0;
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
        // ScreenParams.previewSize = cameraController.value.previewSize!;
      });
      isCameraInitialized.value = true;
      notifyListeners();
    }
  }

  PanelController? _panelController = PanelController();
  AudioPlayer audioPlayer = AudioPlayer();
  PanelController? get panelController => _panelController;

  String currentScannedObjectID = "";

  set panelController(PanelController? value) {
    _panelController = value;
    notifyListeners();
  }

  ValueNotifier<double> panelPosition = ValueNotifier(0);

  ValueNotifier<List<Recognition>?> currentRecognizedObjects =
      ValueNotifier(null);

  ValueNotifier<List<Label>> identifiedLabels = ValueNotifier([]);

  ValueNotifier<List<DetectedObject>> currentDetectedObjects =
      ValueNotifier([]);
  ValueNotifier<List<DetectedObject>> identifiedDetectedObjects =
      ValueNotifier([]);

  ValueNotifier<List<Recognition>?> identifiedRecognitions = ValueNotifier([]);
  ValueNotifier<ScanState> currentScanState =
      ValueNotifier(ScanState.PRESCANNED);

  bool? _isPanelOpen = false;
  bool? get isPanelOpen => _isPanelOpen;

  set isPanelOpen(bool? value) {
    _isPanelOpen = value;
    notifyListeners();
  }

  double? _panelPosition = 0;

  // double? get panelPosition => _panelPosition;

  // set panelPosition(double? value) {
  //   _panelPosition = value;
  //   notifyListeners();
  // }

  Future<void> objectDetector(CameraImage image) async {
    //   var detector = await Tflite.detectObjectOnFrame(
    //     bytesList: image.planes.map((e) {
    //       return e.bytes;
    //     }).toList(),
    //     model: "SSDMobileNet",
    //     imageHeight: image.height,
    //     imageWidth: image.width,
    //     imageMean: 127.5, // defaults to 127.5
    //     imageStd: 127.5, // defaults to 127.5
    //     rotation: 90, // defaults to 90, Android only
    //     numResultsPerClass: 5,
    //     // numBoxesPerBlock: 10,
    //     asynch: true,
    //     threshold: 0.4,
    //   );

    //   if (detector != null) {
    //     if (detector.isEmpty) {
    //       return;
    //     }
    //     var detectedObject = detector.firstOrNull;
    //     if (detectedObject == null) {
    //       return;
    //     }

    //     label = detectedObject["detectedClass"].toString();
    //     if (detectedObject["confidenceInClass"] <= 0.6) {
    //       return;
    //     }
    //     top = image.height / image.width;
    //     h = detectedObject["rect"]["h"];
    //     w = detectedObject["rect"]["w"];
    //     x = detectedObject["rect"]["x"];
    //     y = detectedObject["rect"]["y"];
    //     log("Result is $detector");
    //     notifyListeners();
    //   }
    // }

    // Rect renderLocation() {
    //   log("Screen preview width size is${ScreenParams.screenPreviewSize.width}");
    //   log("Screen preview height size is${ScreenParams.screenPreviewSize.height}");
    //   final double scaleX = ScreenParams.screenPreviewSize.width / 300;
    //   final double scaleY = ScreenParams.screenPreviewSize.height / 300;
    //   return Rect.fromLTWH(
    //     x * scaleX,
    //     y * scaleY,
    //     w * scaleX,
    //     h * scaleY,
    //   );
    // }

    // Future<void> initTFLite() async {
    //   await Tflite.loadModel(
    //     model: "assets/models/ssd_mobilenet.tflite",
    //     labels: "assets/models/ssd_mobilenet.txt",
    //     isAsset: true,
    //     numThreads: 1,
    //     useGpuDelegate: false,
    //   );
    // }
  }

  Future<void> launMychUrl(String? word) async {
    final Uri _url = Uri.parse('https://www.google.com/search?q=$word');
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}
