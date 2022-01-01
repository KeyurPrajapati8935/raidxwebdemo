import 'package:flutter/material.dart';

class Palette {

  static const Color colorStart = Color(0xFF0d47a1);
  static const Color colorEnd = Color(0xFF1565c0);


  static const appThemeColor = const Color(0xFF0A905D);
  static const appThemeLightColor = const Color(0xFFF3FEF7);
  static const appThemeDarkColor = const Color(0xFF064f33);
  static const greyLight = const Color(0xFFEEEEEE);
  static const greyDarkMax = const Color(0xFF303030);
  static const greyDark = const Color(0xFF757575);
  static const greyMedium = const Color(0xFFA6A6A6);
  static const greyRegular = const Color(0xFF9E9E9E);
  static const red = const Color(0xFFFF0000);

  //status colors
  static const acceptedYellow = const Color(0xFFFAC01E);
  static const completedGreen = const Color(0xFF0A905D);
  static const cancelledRed = const Color(0xFFE42426);
  static const pendingGrey = const Color(0xFF757575);

  static const buttonGradient = const LinearGradient(
    colors: const [colorStart, colorEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
