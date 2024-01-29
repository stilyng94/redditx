import 'package:flutter/material.dart';

abstract class AppTheme {
  static const blackColor = Color.fromRGBO(1, 1, 1, 1);
  static const greyColor = Color.fromRGBO(26, 39, 45, 1);
  static const drawerColor = Color.fromRGBO(18, 18, 18, 1);
  static const whiteColor = Colors.white;
  static var redColor = Colors.red.shade500;
  static var blueColor = Colors.blue.shade300;

  static final lightTheme = ThemeData.light().copyWith(
      scaffoldBackgroundColor: whiteColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      cardColor: greyColor,
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      }),
      appBarTheme: const AppBarTheme(
          backgroundColor: whiteColor,
          elevation: 0,
          iconTheme: IconThemeData(color: blackColor)),
      drawerTheme: const DrawerThemeData(backgroundColor: whiteColor),
      primaryColor: redColor,
      colorScheme: const ColorScheme.light(background: whiteColor));

  static final darkTheme = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: blackColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      cardColor: greyColor,
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      }),
      appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: drawerColor,
          iconTheme: IconThemeData(color: Colors.white)),
      drawerTheme: const DrawerThemeData(backgroundColor: drawerColor),
      primaryColor: redColor,
      colorScheme: const ColorScheme.dark(background: drawerColor));
}
