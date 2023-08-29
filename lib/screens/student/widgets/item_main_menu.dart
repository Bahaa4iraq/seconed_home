// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../static_files/my_features_message.dart';

class ItemMainMenu extends StatelessWidget {
  final String title;
  final String img;
  final Widget nav;
  final bool features;

  const ItemMainMenu({
    Key? key,
    this.title = '',
    required this.img,
    required this.nav,
    this.features = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int index = 0;
    return AnimationConfiguration.staggeredGrid(
      position: index++,
      duration: const Duration(milliseconds: 375),
      columnCount: 9,
      child: SlideAnimation(
        //verticalOffset: 50.0,
        child: ScaleAnimation(
          child: GestureDetector(
            onTap: () {
              // ignore: unrelated_type_equality_checks
              if (features == true) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => nav),
                );
              } else {
                featureAttention();
              }
            },
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 9,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 15,
                          left: 15,
                        ),
                        child: Image.asset(
                          img,
                          height: 40,
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
