import 'package:flutter/material.dart';
Map<int, Color> color1 = {
  50: const Color.fromRGBO(56, 70, 158, .1),
  100: const Color.fromRGBO(56, 70, 158, .2),
  200: const Color.fromRGBO(56, 70, 158, .3),
  300: const Color.fromRGBO(56, 70, 158, .4),
  400: const Color.fromRGBO(56, 70, 158, .5),
  500: const Color.fromRGBO(56, 70, 158, .6),
  600: const Color.fromRGBO(56, 70, 158, .7),
  700: const Color.fromRGBO(56, 70, 158, .8),
  800: const Color.fromRGBO(56, 70, 158, .9),
  900: const Color.fromRGBO(56, 70, 158, 1),
};
Map<int, Color> pinkSwatch = {
  50: const Color.fromRGBO(239,50,82, .1),
  100: const Color.fromRGBO(239,50,82, .2),
  200: const Color.fromRGBO(239,50,82, .3),
  300: const Color.fromRGBO(239,50,82, .4),
  400: const Color.fromRGBO(239,50,82, .5),
  500: const Color.fromRGBO(239,50,82, .6),
  600: const Color.fromRGBO(239,50,82, .7),
  700: const Color.fromRGBO(239,50,82, .8),
  800: const Color.fromRGBO(239,50,82, .9),
  900: const Color.fromRGBO(239,50,82, 1),
};

Map<int, Color> turquoiseSwatch = {
  50: const Color.fromRGBO(102,201,207, .1),
  100: const Color.fromRGBO(102,201,207, .2),
  200: const Color.fromRGBO(102,201,207, .3),
  300: const Color.fromRGBO(102,201,207, .4),
  400: const Color.fromRGBO(102,201,207, .5),
  500: const Color.fromRGBO(102,201,207, .6),
  600: const Color.fromRGBO(102,201,207, .7),
  700: const Color.fromRGBO(102,201,207, .8),
  800: const Color.fromRGBO(102,201,207, .9),
  900: const Color.fromRGBO(102,201,207, 1),
};


Map<int, Color> color2 = {
  50: const Color.fromRGBO(225, 137, 39, .1),
  100: const Color.fromRGBO(225, 137, 39, .2),
  200: const Color.fromRGBO(225, 137, 39, .3),
  300: const Color.fromRGBO(225, 137, 39, .4),
  400: const Color.fromRGBO(225, 137, 39, .5),
  500: const Color.fromRGBO(225, 137, 39, .6),
  600: const Color.fromRGBO(225, 137, 39, .7),
  700: const Color.fromRGBO(225, 137, 39, .8),
  800: const Color.fromRGBO(225, 137, 39, .9),
  900: const Color.fromRGBO(225, 137, 39, 1),
};

class MyColor {
  static const white0 = Color(0xffffffff);
  static const turquoise = Color(0xff66c9cf);
  static const turquoise2 = Color(0xff81d9dc);
  static const pink = Color(0xffEF3252);

  static const black = Color(0xff000000);
  static const grayDark = Color(0xff4d4d4d);
  static const red = Colors.red;
  static const white1 = Color(0xffe6e6e6);
  static const white2 = Color(0xffe2e2e2);
  static const white4 = Color(0xffe1e1e1);
  static const white3 = Color(0xffd3cfe6);
  static const green = Colors.green;

 // static const purple = Color(0xff38469E);
  static const yellow = Color(0xffE18927);


  MaterialColor purpleMaterial = MaterialColor(0xff38469E, color1);
  MaterialColor yellowMaterial = MaterialColor(0xffFFB206, color2);
  MaterialColor pinkMaterial = MaterialColor(0xffEF3252, pinkSwatch);
  MaterialColor turquoiseMaterial = MaterialColor(0xff66c9cf, turquoiseSwatch);


}
