import 'dart:ui';

import 'package:dear_diary/controller/controller.dart';
import 'package:dear_diary/logpage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:intl/intl.dart';

class animRoute extends AnimatedWidget {
  final Widget child;
  final Animation<double> animationValues;

  animRoute({required this.animationValues, required this.child})
      : super(listenable: animationValues);

  @override
  Widget build(context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
          sigmaX: animationValues.value, sigmaY: animationValues.value),
      child: Container(
        child: child,
      ),
    );
  }
}
