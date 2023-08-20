import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:template/presentation/styles/app_colors.dart';

class BlurredContainer extends StatelessWidget {
  BlurredContainer({
    Key? key,
    this.height,
    this.width,
    this.backgroundColor,
    this.sigmaX,
    this.sigmaY,
    this.padding,
    this.child,
  }) : super(key: key);
  double? height, width, sigmaX, sigmaY;
  Color? backgroundColor;
  EdgeInsets? padding;
  Widget? child;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.black.withOpacity(0.3), width: 2),
        ),
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 14, vertical: 32),
        height: height,
        width: width,
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: sigmaX ?? 4.0, sigmaY: sigmaY ?? 4.0),
              child: Container(),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.15),
                      Colors.white.withOpacity(0.05)
                    ],
                  )),
              // child: child,
            ),
            Center(child: child)
          ],
        ),
      ),
    );
  }
}
