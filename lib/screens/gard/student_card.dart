import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:secondhome2/screens/gard/gard_controller.dart';
import 'package:secondhome2/screens/gard/student_model.dart';
import 'package:secondhome2/static_files/my_color.dart';

class StudentCard extends StatelessWidget {
  const StudentCard({super.key, required this.student, required this.token});
  final StudentGardModel student;
  final String token;
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
                        controller.editStudentStatus(
                          student.sId!,
                          'دخول',token
                        );
                      } else {
                        EasyLoading.showError('الطالب دخل بالفعل');
                      }
                    },
                    icon: student.inCreatedAt != null
                        ? const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          )
                        : const Icon(
                            Icons.cancel,
                            color: Colors.red,
                          )),
                student.inCreatedAt == null
                    ? const SizedBox()
                    : Text(
                        student.inCreatedAt!,
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
                    onPressed: () async {
                      if (student.inCreatedAt == null) {
                        EasyLoading.showError('الطالب لم يدخل بعد');
                      } else if (student.outCreatedAt == null) {
                        controller.editStudentStatus(student.sId!, 'خروج',token);
                      } else {
                        EasyLoading.showError('الطالب خرج بالفعل');
                      }
                    },
                    icon: student.outCreatedAt != null
                        ? const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          )
                        : const Icon(
                            Icons.cancel,
                            color: Colors.red,
                          )),
                student.outCreatedAt == null
                    ? const SizedBox()
                    : Text(
                        student.outCreatedAt!,
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
