import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:template/core/Extensions/extensions.dart';
import 'package:template/presentation/views/Home/viewModel/home_page_view_model.dart';
import 'package:collection/collection.dart';
import '../../../api/models/screen_params.dart';
import '../../../api/services/service/firebasestorage_service.dart';
import '../../styles/app_colors.dart';
import '../../styles/text_styles.dart';

class IdentifiedDetailsPanel extends ConsumerStatefulWidget {
  const IdentifiedDetailsPanel({
    super.key,
  });

  @override
  ConsumerState<IdentifiedDetailsPanel> createState() =>
      _IdentifiedDetailsPanelState();
}

class _IdentifiedDetailsPanelState
    extends ConsumerState<IdentifiedDetailsPanel> {
  @override
  Widget build(BuildContext context) {
    double highestPredictable = 0;

    final provider = ref.watch(homePageVM);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              provider.panelController!.isPanelOpen
                  ? provider.panelController!.close()
                  : provider.panelController!.open();
            },
            child: Center(
              child: Container(
                height: 6,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),
          15.0.verticalSpace(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  provider.identifiedLabels.value.isEmpty
                      ? "EyeDentified Objects will be shown here"
                      : provider.identifiedLabels.value.first.text
                          .capitalizeByWord(),
                  style: AppTextStyle.bodyTwo.copyWith(
                    fontSize: provider.identifiedLabels.value.isEmpty ? 18 : 24,
                    color: AppColors.black,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F3F3),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset("assets/icons/devicon-google.svg"),
                    8.0.horizontalSpace(),
                    const Text(
                      "Search",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          10.0.verticalSpace(),
          provider.identifiedLabels.value.isEmpty
              ? const SizedBox()
              : Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 10,
                  children: provider.identifiedLabels.value
                      .take(3)
                      .mapIndexed<Widget>((index, element) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${(element.confidence * 100).toStringAsFixed(0)}% ${element.text.capitalizeByWord()}",
                          style: const TextStyle(
                            color: AppColors.textGray,
                            fontSize: 16,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Icon(
                            Icons.circle,
                            color: AppColors.textGray,
                            size: 10,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
          60.0.verticalSpace(),
          Center(
            child: InkWell(
              onTap: () async {
                await ref
                    .read(storageServiceProvider)
                    .downloadUrl(provider.currentScannedObjectID);
              },
              child: Transform.scale(
                scale: 5,
                child: Lottie.asset(
                  "assets/animations/wave.json",
                ),
              ),
            ),
          ),
          10.0.verticalSpace(),
          const Center(
            child: Text(
              "Speaking...",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          5.0.verticalSpace(),
          Center(
            child: InkWell(
              onTap: () async {
                await ref
                    .read(storageServiceProvider)
                    .downloadUrl(provider.currentScannedObjectID);
              },
              child: Text(
                "Tap to Pause/Play",
                style: AppTextStyle.bodyOne.copyWith(
                  fontSize: 14,
                  color: AppColors.gray.shade300,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          15.0.verticalSpace(),
          Center(
            child: SizedBox(
              width: ScreenParams.screenSize.width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Aliqua ullamco dolore consectetur nulla voluptate labore proident. Labore velit ea incididunt incididunt exercitation. Do quis incididunt ad ex velit amet laboris reprehenderit. Do incididunt magna ut duis excepteur sit. Nostrud nisi nostrud ullamco laborum anim non.,",
                    // textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(),
                  ),
                  15.0.verticalSpace(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.expand_less,
                        color: AppColors.textGray,
                      ),
                      5.0.horizontalSpace(),
                      const Text(
                        "Hide description",
                        style: TextStyle(
                          color: AppColors.textGray,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          30.0.verticalSpace(),
          Text(
            "Other Possible Results",
            style: AppTextStyle.headerFive.copyWith(
              color: AppColors.textGray,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }
}
