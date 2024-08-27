import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondhome2/screens/gard/gard_controller.dart';
import 'package:secondhome2/screens/gard/student_card.dart';
import 'package:secondhome2/static_files/my_color.dart';

class EnterStudent extends StatefulWidget {
  const EnterStudent({super.key});

  @override
  State<EnterStudent> createState() => _EnterStudentState();
}

class _EnterStudentState extends State<EnterStudent> {
  GardController controller = Get.put(GardController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: controller.isLoading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : controller.error.value
              ? const Text('error')
              : Column(
                  children: [
                    const DefaultTextStyle(
                      style: TextStyle(
                          fontSize: 16,
                          color: MyColor.grayDark,
                          fontWeight: FontWeight.bold),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: Text(
                                'اسم الطالب',
                                textAlign: TextAlign.center,
                              )),
                          Expanded(child: Text('الدخول')),
                          Expanded(child: Text('الخروج')),
                        ],
                      ),
                    ),
                    const Divider(
                      color: MyColor.grayDark,
                    ),
                    Expanded(
                        child: ListView.builder(
                      itemCount: controller.studentList.length,
                      itemBuilder: (context, index) {
                        return StudentCard(
                            student: controller.studentList[index]);
                      },
                    ))
                  ],
                ),
    );
  }
}
