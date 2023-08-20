/// Extension on [String] that capitalizes the first letter of the first word in a sentence
import 'package:flutter/material.dart';
import 'package:template/api/models/recognition.dart' as Recognize;

extension FigmaDimension on double {
  double toFigmaHeight(double fontSize) {
    return this / fontSize;
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String capitalizeByWord() {
    if (trim().isEmpty) {
      return '';
    }
    return split(' ')
        .map((element) =>
            "${element[0].toUpperCase()}${element.substring(1).toLowerCase()}")
        .join(" ");
  }
}

class MyScrollBehaviour extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class NoScalingAnimation extends FloatingActionButtonAnimator {
  double? _x;
  double? _y;
  @override
  Offset getOffset({Offset? begin, Offset? end, double? progress}) {
    return end!;
  }

  @override
  Animation<double> getRotationAnimation({Animation<double>? parent}) {
    return Tween<double>(begin: 1.0, end: 1.0).animate(parent!);
  }

  @override
  Animation<double> getScaleAnimation({Animation<double>? parent}) {
    return Tween<double>(begin: 1.0, end: 1.0).animate(parent!);
  }
}

extension addPadding on Widget {
  Widget padding({required EdgeInsets padding}) {
    return Padding(
      padding: padding,
      child: this,
    );
  }
}

extension DoubleToHeight on double {
  SizedBox verticalSpace() {
    return SizedBox(
      height: this,
    );
  }

  SizedBox horizontalSpace() {
    return SizedBox(
      width: this,
    );
  }
}

extension ListExtension<E> on List<E> {
  void addAllUnique(Iterable<E> iterable) {
    for (var element in iterable) {
      if (!contains(element)) {
        add(element);
      }
    }
  }
}

extension IterableExtension<T> on Iterable<T> {
  Iterable<T> distinctBy(Object Function(T e) getCompareValue) {
    var result = <T>[];
    for (var element in this) {
      if (!result.any((x) => getCompareValue(x) == getCompareValue(element))) {
        result.add(element);
      }
    }

    return result;
  }
}

extension ListRecognition<Recognition> on List<Recognize.Recognition> {
  void addAllUniqueRecognitions(Iterable<Recognize.Recognition> iterable) {
    for (var element in iterable) {
      if (!contains(element.label)) {
        add(element);
      }
    }
  }
}
