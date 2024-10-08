import 'package:flutter/material.dart';

import 'my_color.dart';

AppBar myAppBar(String title, Color backgroundColor) {
  return AppBar(
    backgroundColor: backgroundColor,
    title: Text(
      title,
      style: const TextStyle(color: MyColor.white0),
    ),
    centerTitle: true,
    iconTheme: const IconThemeData(
      color: MyColor.white0,
    ),
    elevation: 0,
  );
}
