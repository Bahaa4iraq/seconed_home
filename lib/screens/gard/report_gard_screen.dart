import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondhome2/screens/gard/gard_controller.dart';

class ReportGardScreen extends StatelessWidget {
  const ReportGardScreen({super.key});
  static GardController controller = Get.put(GardController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : controller.error.value
              ? EmptyWidget(
                  image: null,
                  packageImage: PackageImage.Image_1,
                  title: 'حدث خطأ',
                  subTitle: 'يرجى المحاولة مرة أخرى',
                )
              : Column(
                  children: [
                    rowInfo('عدد الطلاب الكلي',
                        controller.staticModel!.allStudents.toString()),
                    rowInfo('عدد الطلاب الذين سجلو دخول وخروج',
                        controller.staticModel!.allStudentsInOut.toString()),
                    rowInfo(
                        'عدد الطلاب المتبقين',
                        controller.staticModel!.remainingStudentsThatNotRegister
                            .toString()),
                    rowInfo('عدد الطلاب الذين سجلو دخول فقط',
                        controller.staticModel!.allStudentsIn.toString()),
                    rowInfo('عدد الطلاب الذين سجلو خروج ',
                        controller.staticModel!.allStudentsOut.toString()),
                  ],
                ),
    );
  }
}

rowInfo(String title, String value) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}
