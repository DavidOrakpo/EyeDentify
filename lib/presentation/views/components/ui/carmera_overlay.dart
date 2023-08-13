import 'package:flutter/material.dart';

import 'overlay_painter.dart';

class CameraDarkOverlay extends StatelessWidget {
  // final double scanWindowHeight;
  // final double scanWindowWidth;
  const CameraDarkOverlay({
    Key? key,
    required this.overlayColour,
    // required this.scanWindowHeight,
    // required this.scanWindowWidth,
  }) : super(key: key);

  final Color overlayColour;

  @override
  Widget build(BuildContext context) {
    // // Changing the size of scanner cutout dependent on the device size.
    double scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 240.0
        : 330.0;
    final newScanArea = MediaQuery.sizeOf(context).width * 0.85;
    return Stack(children: [
      ColorFiltered(
        colorFilter: ColorFilter.mode(
            overlayColour, BlendMode.srcOut), // This one will create the magic
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: Colors.red,
                  backgroundBlendMode: BlendMode
                      .dstOut), // This one will handle background + difference out
            ),
            Align(
              alignment: const Alignment(0, -0.3),
              // alignment: Alignment.center,
              child: Container(
                height: newScanArea,
                width: newScanArea,
                // height: scanWindowHeight,
                // width: scanWindowWidth,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
      Align(
        alignment: const Alignment(0, -0.3),
        child: CustomPaint(
          foregroundPainter: BorderPainter(),
          child: SizedBox(
            width: newScanArea,
            height: newScanArea,
          ),
        ),
      ),
    ]);
  }
}
