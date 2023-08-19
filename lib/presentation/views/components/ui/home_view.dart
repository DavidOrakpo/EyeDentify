import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:template/api/models/recognition.dart';
import 'package:template/api/services/service/firebasestorage_service.dart';
import 'package:template/presentation/views/Home/viewModel/home_page_view_model.dart';
import 'package:template/presentation/views/SlidingPanel/sliding_panel.dart';
import 'package:template/presentation/views/components/mlkit/object_detector_view.dart';
import 'package:template/presentation/views/components/ui/floating_actions.dart';

import '../../../../api/models/screen_params.dart';
import '../../../styles/app_colors.dart';
import 'detector_widget.dart';

/// [HomeView] stacks [DetectorWidget]
class HomeView extends ConsumerStatefulWidget {
  static const routeIdentifier = "HOME_PAGE";
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  static const double initialHeightValue = 200;
  double fabHeight = 0;
  List<Recognition>? identifiedRecognition = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(homePageVM).panelController?.hide();
    });
  }

  @override
  void dispose() {
    ref.read(homePageVM).audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenParams.screenSize = MediaQuery.sizeOf(context);
    final panelMinHeight = ScreenParams.screenSize.height * 0.2;
    final floatingInitialHeight = ScreenParams.screenSize.height * 0.22;
    final panelMaxHeight = ScreenParams.screenSize.height * 0.8;
    return Scaffold(
      key: GlobalKey(),
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   title: const Text("DSFsdfsdf"),
      // ),
      // appBar: AppBar(
      //   title: Image.asset(
      //     'assets/images/tfl_logo.png',
      //     fit: BoxFit.contain,
      //   ),
      // ),
      body: Consumer(
        builder: (context, ref, child) {
          final provider = ref.watch(homePageVM);
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              SlidingUpPanel(
                minHeight: panelMinHeight,
                controller: provider.panelController,
                maxHeight: panelMaxHeight,
                parallaxEnabled: true,
                color: Colors.transparent,
                parallaxOffset: 0.1,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                onPanelSlide: (position) {
                  // log(position.toString());
                  provider.panelPosition.value = position;
                },
                onPanelOpened: () async {
                  if (provider.isSpeaking.value == false) {
                    await ref
                        .read(storageServiceProvider)
                        .getDescribedTextFromPalmApi()
                        .then((value) async {
                      provider.isSpeaking.value = true;
                      await ref
                          .read(storageServiceProvider)
                          .downloadUrl(provider.currentScannedObjectID);
                    });
                  }
                },
                // collapsed: const Text("Collapsed View"),
                // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                // header: const Text(
                //   "Header",
                //   textAlign: TextAlign.center,
                // ),
                backdropEnabled: true,
                backdropOpacity: 0.8,
                // body: Container(
                //   color: Colors.purple,
                // ),

                // body: const DetectorWidget(),
                body: ObjectDetectorView(),
                panelBuilder: (panelController) {
                  // return Container(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 15, vertical: 15),
                  //   decoration: const BoxDecoration(
                  //     color: AppColors.white,
                  //     borderRadius: BorderRadius.vertical(
                  //       top: Radius.circular(20),
                  //     ),
                  //   ),
                  // );
                  return const IdentifiedDetailsPanel(
                      // identifiedRecognitions: identifiedRecognition,
                      );
                },
              ),
              FloatingActionsWidget(
                panelMaxHeight: panelMaxHeight,
                panelMinHeight: panelMinHeight,
                floatingInitialHeight: floatingInitialHeight,
                // identifiedRecognitions: identifiedRecognition,
              ),
            ],
          );
        },
      ),
    );
  }
}
