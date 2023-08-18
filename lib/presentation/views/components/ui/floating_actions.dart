import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:template/api/services/service/firebasestorage_service.dart';
import 'package:template/core/Extensions/extensions.dart';
import 'package:template/core/Utilities/utils/utils.dart';
import 'package:template/presentation/views/Home/viewModel/home_page_view_model.dart';
import 'package:darq/darq.dart';
// import 'package:template/core/Extensions/extensions.dart';
import '../../../../api/models/screen_params.dart';
import '../../../../core/Enums/ready_state.dart';
import '../../../styles/app_colors.dart';
import '../blurred_container.dart';
import '../dual_value_listenable_builder.dart';

class FloatingActionsWidget extends ConsumerWidget {
  final double panelMaxHeight, panelMinHeight, floatingInitialHeight;
  double fabHeight = 0;

  FloatingActionsWidget({
    super.key,
    required this.panelMaxHeight,
    required this.panelMinHeight,
    required this.floatingInitialHeight,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(homePageVM);
    FireBaseTextToSpeechExtension firebaseText =
        FireBaseTextToSpeechExtension();

    return DualValueListenableBuilder(
      provider.panelPosition,
      provider.currentScanState,
      builder: (context, panelPosition, scanState, child) {
        var maxScrollExtent = panelMaxHeight - panelMinHeight;

        fabHeight = panelPosition * maxScrollExtent + floatingInitialHeight;
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
                        provider.currentScanState.value = ScanState.PRESCANNED;
                        provider.identifiedDetectedObjects.value = [];
                        if (scanState == ScanState.SCANNED) {
                          provider.panelController!.isPanelShown
                              ? provider.panelController!.hide()
                              : provider.panelController!.show();
                        }
                      }
                    : () async {
                        provider.currentScanState.value = ScanState.SCANNING;
                        await Future.delayed(
                          const Duration(milliseconds: 750),
                          () {
                            provider.currentScanState.value = ScanState.SCANNED;
                            // provider.identifiedRecognitions.value!
                            //     .addAllUniqueRecognitions(
                            //         provider.currentRecognizedObjects.value!);
                            // provider.identifiedRecognitions.value =
                            //     provider.currentRecognizedObjects.value;

                            provider.identifiedDetectedObjects.value =
                                provider.currentDetectedObjects.value;
                            // if (provider.identifiedRecognitions.value == null) {
                            //   provider.currentScanState.value =
                            //       ScanState.SCANNEDEMPTY;
                            //   return;
                            // }
                            if (provider
                                .identifiedDetectedObjects.value.isEmpty) {
                              provider.currentScanState.value =
                                  ScanState.SCANNEDEMPTY;
                              return;
                            }
                            provider.identifiedLabels.value =
                                provider.identifiedDetectedObjects.value
                                    .map((e) {
                                      return e.labels;
                                    })
                                    .toList()
                                    .expand((element) => element)
                                    .toList()
                                    .distinct(
                                      (element) => element.text,
                                    )
                                    .toList();
                            // provider.identifiedDetectedObjects.value =
                            //     provider.identifiedDetectedObjects.value
                            //         .distinct(
                            //           (element) => element.labels,
                            //         )
                            //         .toList();
                            // provider.identifiedRecognitions.value?.wher;
                            log("Identified Labels:${provider.identifiedLabels.value}");
                            // log("Current Recognition:${provider.currentRecognizedObjects.value}");
                            provider.panelController!.isPanelShown
                                ? provider.panelController!.hide()
                                : provider.panelController!.show();

                            firebaseText.sendTextToSpeek(
                                provider.identifiedLabels.value.first.text);
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(
                  scanState == ScanState.PRESCANNED
                      ? "Tap the button to EyeDentify"
                      : scanState == ScanState.SCANNING
                          ? "EyeDentifying..."
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
    );
  }
}
