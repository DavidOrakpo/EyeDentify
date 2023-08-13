import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:template/api/models/recognition.dart';
import 'package:template/core/Enums/ready_state.dart';
import 'package:template/core/Extensions/extensions.dart';
import 'package:template/presentation/styles/text_styles.dart';
import 'package:template/presentation/views/Home/viewModel/home_page_view_model.dart';
import 'package:template/presentation/views/SlidingPanel/sliding_panel.dart';
import 'package:template/presentation/views/components/blurred_container.dart';
import 'package:template/presentation/views/components/dual_value_listenable_builder.dart';

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
                  log(position.toString());
                  provider.panelPosition.value = position;
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

                body: const DetectorWidget(),
                panelBuilder: (panelController) {
                  return IdentifiedDetailsPanel(
                    identifiedRecognitions: identifiedRecognition,
                  );
                },
              ),
              DualValueListenableBuilder(
                provider.panelPosition,
                provider.currentScanState,
                builder: (context, panelPosition, scanState, child) {
                  var maxScrollExtent = panelMaxHeight - panelMinHeight;

                  fabHeight =
                      panelPosition * maxScrollExtent + floatingInitialHeight;
                  return Positioned(
                    bottom: provider.panelController!.isPanelShown
                        ? fabHeight
                        : ScreenParams.screenSize.height * 0.1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: (scanState == ScanState.SCANNED ||
                                  scanState == ScanState.SCANNEDEMPTY)
                              ? () {
                                  provider.currentScanState.value =
                                      ScanState.PRESCANNED;
                                  identifiedRecognition = null;
                                  if (scanState == ScanState.SCANNED) {
                                    provider.panelController!.isPanelShown
                                        ? provider.panelController!.hide()
                                        : provider.panelController!.show();
                                  }
                                }
                              : () async {
                                  provider.currentScanState.value =
                                      ScanState.SCANNING;
                                  await Future.delayed(
                                    const Duration(milliseconds: 750),
                                    () {
                                      provider.currentScanState.value =
                                          ScanState.SCANNED;
                                      identifiedRecognition = provider
                                          .currentRecognizedObjects.value;
                                      if (identifiedRecognition!.isEmpty) {
                                        provider.currentScanState.value =
                                            ScanState.SCANNEDEMPTY;
                                        return;
                                      }

                                      log(identifiedRecognition.toString());
                                      provider.panelController!.isPanelShown
                                          ? provider.panelController!.hide()
                                          : provider.panelController!.show();
                                    },
                                  );
                                },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 53,
                                width: 53,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  // borderRadius: BorderRadius.circular(28),
                                ),
                                child: CircularProgressIndicator(
                                  color: scanState == ScanState.SCANNING
                                      ? Colors.blue
                                      : Colors.transparent,
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: AppColors.white,
                                radius: 25,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: SvgPicture.asset(
                                      "assets/icons/solar-eye-broken.svg"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        10.0.verticalSpace(),
                        BlurredContainer(
                          // height: 30,
                          // width: 200,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Text(
                            scanState == ScanState.PRESCANNED
                                ? "Tap the button to identify"
                                : scanState == ScanState.SCANNING
                                    ? "Identifying..."
                                    : scanState == ScanState.SCANNEDEMPTY
                                        ? "Nothing EyeDentified"
                                        : "Tap here to restart",
                            style: const TextStyle(
                              color: AppColors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              )
            ],
          );
        },
      ),
    );
  }
}
