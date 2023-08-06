import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template/presentation/views/Home/viewModel/home_page_view_model.dart';
import 'package:tflite/tflite.dart';

class HomePage extends ConsumerStatefulWidget {
  static const routeIdentifier = "HOME_PAGE";
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.wait([
        ref.read(homePageVM).initCamera(),
        ref.read(homePageVM).initTFLite()
      ]);
    });
  }

  @override
  void dispose() {
    ref.read(homePageVM).cameraController.dispose();
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(homePageVM);
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ValueListenableBuilder(
        valueListenable: provider.isCameraInitialized,
        builder: (context, isCameraInitialized, child) {
          if (isCameraInitialized) {
            return Stack(
              children: [
                CameraPreview(provider.cameraController),
                Positioned(
                  top: provider.y * 700,
                  right: provider.x * 500,
                  child: Container(
                    width: provider.w * 100 * size.width / 100,
                    height: provider.h * 100 * size.height / 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.green,
                        width: 4,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          color: Colors.white,
                          child: Text(
                            provider.label,
                            style: const TextStyle(color: Colors.black),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          }
          return const Center(
            child: Text("Loading Preview..."),
          );
        },
      ),
    );
  }
}
