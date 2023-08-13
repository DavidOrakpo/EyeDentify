// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:template/presentation/views/Home/viewModel/home_page_view_model.dart';
// import 'package:tflite/tflite.dart';

// import '../../../core/Utilities/screen_params.dart';

// class HomePage extends ConsumerStatefulWidget {
//   const HomePage({super.key});

//   @override
//   ConsumerState<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends ConsumerState<HomePage> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       await Future.wait([
//         ref.read(homePageVM).initCamera(),
//         ref.read(homePageVM).initTFLite()
//       ]);
//     });
//   }

//   @override
//   void dispose() {
//     ref.read(homePageVM).cameraController.dispose();
//     Tflite.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = ref.watch(homePageVM);
//     ScreenParams.screenSize = MediaQuery.sizeOf(context);
//     final size = MediaQuery.sizeOf(context);
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: ValueListenableBuilder(
//         valueListenable: provider.isCameraInitialized,
//         builder: (context, isCameraInitialized, child) {
//           if (isCameraInitialized) {
//             return Stack(
//               children: [
//                 CameraPreview(provider.cameraController),
//                 Positioned(
//                   top: provider.y * size.height,
//                   left: provider.x * size.width,
//                   child: Container(
//                     width: provider.w * size.width,
//                     height: provider.h * size.height,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(
//                         color: Colors.green,
//                         width: 4,
//                       ),
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Container(
//                           color: Colors.white,
//                           child: Text(
//                             provider.label,
//                             style: const TextStyle(color: Colors.black),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             );
//           }
//           return const Center(
//             child: Text("Loading Preview..."),
//           );
//         },
//       ),
//     );
//   }
// }
