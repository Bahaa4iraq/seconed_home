import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:secondhome2/static_files/my_color.dart';

import '../../../../static_files/my_appbar.dart';

class LiveEducation extends StatefulWidget {
  const LiveEducation({Key? key}) : super(key: key);

  @override
  State<LiveEducation> createState() => _LiveEducationState();
}

class _LiveEducationState extends State<LiveEducation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar("التعليم الالكتروني",MyColor.turquoise),
      body: Center(
        child: SizedBox(
          width: 250,
          child: EmptyWidget(
            image: null,
            packageImage: PackageImage.Image_1,
            title: 'لاتوجد بيانات',
            subTitle: 'لم يتم اضافة البيانات',
            titleTextStyle: const TextStyle(
              fontSize: 22,
              color: Color(0xff9da9c7),
              fontWeight: FontWeight.w500,
            ),
            subtitleTextStyle: const TextStyle(
              fontSize: 14,
              color: Color(0xffabb8d6),
            ),
          ),
        ),
      ),
    );
  }
}
