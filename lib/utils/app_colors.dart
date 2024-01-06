import 'package:flutter/material.dart';

class AppColors {
  static const MaterialColor primaryBackground =
      MaterialColor(_primaryBackgroundValue, <int, Color>{
    50: Color(0xFFF9FCFC),
    100: Color(0xFFF0F7F6),
    200: Color(0xFFE6F2F1),
    300: Color(0xFFDBECEB),
    400: Color(0xFFD4E8E6),
    500: Color(_primaryBackgroundValue),
    600: Color(0xFFC7E1DF),
    700: Color(0xFFC0DDDA),
    800: Color(0xFFB9D9D6),
    900: Color(0xFFADD1CF),
  });
  static const int _primaryBackgroundValue = 0xFFCCE4E2;

  static const MaterialColor primaryHighlight =
      MaterialColor(_primaryHighlightValue, <int, Color>{
    50: Color(0xFFFCFDFD),
    100: Color(0xFFF8FBFB),
    200: Color(0xFFF3F9F9),
    300: Color(0xFFEEF6F6),
    400: Color(0xFFEAF4F4),
    500: Color(_primaryHighlightValue),
    600: Color(0xFFE3F0F0),
    700: Color(0xFFDFEEEE),
    800: Color(0xFFDBECEC),
    900: Color(0xFFD5E8E8),
  });
  static const int _primaryHighlightValue = 0xFFE6F2F2;

  static const MaterialColor primaryShadow =
      MaterialColor(_primaryShadowValue, <int, Color>{
    50: Color(0xFFF1F1F2),
    100: Color(0xFFDBDDDD),
    200: Color(0xFFC3C6C7),
    300: Color(0xFFABAFB1),
    400: Color(0xFF999EA0),
    500: Color(_primaryShadowValue),
    600: Color(0xFF7F8587),
    700: Color(0xFF747A7C),
    800: Color(0xFF6A7072),
    900: Color(0xFF575D60),
  });
  static const int _primaryShadowValue = 0xFF878D8F;

  static const MaterialColor secondaryBackground =
      MaterialColor(_secondaryBackgroundValue, <int, Color>{
    50: Color(0xFFFFFEFD),
    100: Color(0xFFFFFCFA),
    200: Color(0xFFFFFAF6),
    300: Color(0xFFFFF8F2),
    400: Color(0xFFFFF7F0),
    500: Color(_secondaryBackgroundValue),
    600: Color(0xFFFFF4EB),
    700: Color(0xFFFFF2E8),
    800: Color(0xFFFFF0E5),
    900: Color(0xFFFFEEE0),
  });
  static const int _secondaryBackgroundValue = 0xFFFFF5ED;

  static const MaterialColor secondaryMedium =
      MaterialColor(_secondaryMediumValue, <int, Color>{
    50: Color(0xFFFCFAF7),
    100: Color(0xFFF7F2EB),
    200: Color(0xFFF2E9DD),
    300: Color(0xFFEDE0CF),
    400: Color(0xFFE9DAC5),
    500: Color(_secondaryMediumValue),
    600: Color(0xFFE2CEB5),
    700: Color(0xFFDEC8AC),
    800: Color(0xFFDAC2A4),
    900: Color(0xFFD3B796),
  });
  static const int _secondaryMediumValue = 0xFFE5D3BB;

  static const MaterialColor lightBackground =
      MaterialColor(_lightBackgroundValue, <int, Color>{
    50: Color(0xFFFDFDFD),
    100: Color(0xFFFBFBFB),
    200: Color(0xFFF9F9F9),
    300: Color(0xFFF6F6F6),
    400: Color(0xFFF4F4F4),
    500: Color(_lightBackgroundValue),
    600: Color(0xFFF0F0F0),
    700: Color(0xFFEEEEEE),
    800: Color(0xFFECECEC),
    900: Color(0xFFE8E8E8),
  });
  static const int _lightBackgroundValue = 0xFFF2F2F2;

  static const MaterialColor white =
      MaterialColor(_whitePrimaryValue, <int, Color>{
    50: Color(0xFFFFFFFF),
    100: Color(0xFFFFFFFF),
    200: Color(0xFFFFFFFF),
    300: Color(0xFFFFFFFF),
    400: Color(0xFFFFFFFF),
    500: Color(_whitePrimaryValue),
    600: Color(0xFFFFFFFF),
    700: Color(0xFFFFFFFF),
    800: Color(0xFFFFFFFF),
    900: Color(0xFFFFFFFF),
  });
  static const int _whitePrimaryValue = 0xFFFFFFFF;

  static const Color successRateChartBlue = Color.fromRGBO(75, 135, 185, 1);
  static const Color successRateChartBrown = Color.fromRGBO(192, 108, 132, 1);
  static const Color successRateChartPink = Color.fromRGBO(246, 114, 128, 1);
  static const Color successRateChartOrange = Color.fromRGBO(248, 177, 149, 1);
}
