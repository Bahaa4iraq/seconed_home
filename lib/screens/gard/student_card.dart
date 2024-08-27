import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:secondhome2/screens/gard/gard_controller.dart';
import 'package:secondhome2/screens/gard/student_model.dart';
import 'package:secondhome2/static_files/my_color.dart';
import 'package:toastification/toastification.dart';

class StudentCard extends StatelessWidget {
  const StudentCard({super.key, required this.student});
  final StudentGardModel student;
  static GardController controller = Get.put(GardController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                flex: 2,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    student.accountName ?? '',
                    textAlign: TextAlign.center,
                  ),
                )),
            Expanded(
                child: Column(
              children: [
                IconButton(
                    onPressed: () {
                      if (student.inCreatedAt == null) {
                        controller.editStudentStatus(student.sId!, 'دخول');
                      } else {
                        toastification.show(
                          context: context,
                          description: RichText(
                              text: const TextSpan(
                                  text: 'تم تسجيل الدخول مسبقاً')),
                          type: ToastificationType.success,
                          style: ToastificationStyle.flat,
                          autoCloseDuration: const Duration(seconds: 2),
                          alignment: Alignment.topRight,
                          animationDuration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x07000000),
                              blurRadius: 16,
                              offset: Offset(0, 16),
                              spreadRadius: 0,
                            )
                          ],
                          animationBuilder:
                              (context, animation, alignment, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          icon: const Icon(Icons.check),
                          showIcon: true,
                          primaryColor: Colors.green,
                          backgroundColor: Colors.white,
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    )),
                student.inCreatedAt == null
                    ? const SizedBox()
                    : Text(
                        DateFormat('hh:mm')
                            .format(DateTime.parse(student.inCreatedAt!)),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      )
              ],
            )),
            Expanded(
                child: Column(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.cancel,
                      color: Colors.red,
                    )),
                student.outCreatedAt == null
                    ? const SizedBox()
                    : Text(
                        DateFormat('hh:mm')
                            .format(DateTime.parse(student.outCreatedAt!)),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      )
              ],
            )),
          ],
        ),
        const Divider(
          color: MyColor.grayDark,
        ),
      ],
    );
  }
}
