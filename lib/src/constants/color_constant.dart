import 'package:flutter/material.dart';

class COLOR_CONST {
  static const primaryColor = Color(0xFF9948ac);
  static const primaryLightColor = Color(0xffe26dff);
  static const backgroundColor = Color(0xfff6f6f6);

  static const secondaryColor = Color(0xFF979797);
  static const textColor = Color(0xFF4a4a4a);

  ///Singleton factory
  static final COLOR_CONST _instance = COLOR_CONST._internal();

  factory COLOR_CONST() {
    return _instance;
  }

  COLOR_CONST._internal();
}

const mAnimationDuration = Duration(milliseconds: 200);
