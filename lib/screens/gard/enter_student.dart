import 'package:empty_widget/empty_widget.dart';
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
    return Obx(
      () => controller.isLoading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : controller.error.value
              ? Center(
                  child: EmptyWidget(
                    image: null,
                    packageImage: PackageImage.Image_1,
                    title: 'حدث خطأ',
                    subTitle: 'يرجى المحاولة مرة أخرى',
                  ),
                )
              : controller.studentList.isEmpty
                  ? Center(
                      child: EmptyWidget(
                        image: null,
                        packageImage: PackageImage.Image_1,
                        title: 'لا يوجد طلاب',
                        subTitle: 'يرجى إضافة طلاب',
                      ),
                    )
                  : Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, right: 20, left: 20),
                          child: TextFormField(
                            controller: controller.search,
                            style: const TextStyle(
                              color: MyColor.black,
                            ),
                            onChanged: (value) =>
                                controller.searchStudent(value),
                            decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                hintText: "ابحث عن الطالب",
                                errorStyle:
                                    const TextStyle(color: MyColor.grayDark),
                                fillColor: Colors.transparent,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                    color: MyColor.black,
                                    width: 1,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: MyColor.black, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: MyColor.turquoise, width: 2),
                                ),
                                //prefixIcon: const Icon(LineIcons.user),
                                filled: true
                                //fillColor: Colors.green
                                ),
                            validator: (value) {
                              var result =
                                  value!.length < 3 ? "املئ البيانات" : null;
                              return result;
                            },
                          ),
                        ),
                        DefaultTextStyle(
                          style: const TextStyle(
                              fontSize: 16,
                              color: MyColor.white0,
                              fontWeight: FontWeight.bold),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            color: MyColor.grayDark,
                            child: const Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      'اسم الطالب',
                                      textAlign: TextAlign.center,
                                    )),
                                Expanded(
                                    child: Text(
                                  'الدخول',
                                  textAlign: TextAlign.center,
                                )),
                                Expanded(
                                    child: Text(
                                  'الخروج',
                                  textAlign: TextAlign.center,
                                )),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            child: ListView.builder(
                          itemCount: controller.filterdStudentList.length,
                          itemBuilder: (context, index) {
                            return StudentCard(
                                student: controller.filterdStudentList[index]);
                          },
                        ))
                      ],
                    ),
    );
  }
}
