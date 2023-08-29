// ignore_for_file: depend_on_referenced_packages, no_leading_underscores_for_local_identifiers

import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show NumberFormat;

import '../../../../api_connection/student/api_salary.dart';
import '../../../../provider/auth_provider.dart';
import '../../../../provider/student/provider_salary.dart';
import '../../../../static_files/my_appbar.dart';
import '../../../../static_files/my_color.dart';
import '../../../../static_files/my_loading.dart';
import 'student_salary_details.dart';

class StudentSalary extends StatefulWidget {
  const StudentSalary({Key? key}) : super(key: key);

  @override
  State<StudentSalary> createState() => _StudentSalaryState();
}

class _StudentSalaryState extends State<StudentSalary> {
  _getData() {
    String _year =
        Get.put(MainDataGetProvider()).mainData['setting'][0]['setting_year'];
    StudentSalaryAPI().getSalary(_year);
  }

  final formatter = NumberFormat.decimalPattern();
  DateTime now = DateTime.now();
  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar("الاقساط",MyColor.turquoise),
      body: GetBuilder<StudentSalaryProvider>(builder: (val) {
        return val.isLoading
            ? loading()
            : val.data.isEmpty
                ? EmptyWidget(
                    image: null,
                    packageImage: PackageImage.Image_1,
                    title: 'لاتوجد بيانات',
                    subTitle: 'لم يتم اضافة اقساط',
                    titleTextStyle: const TextStyle(
                      fontSize: 22,
                      color: Color(0xff9da9c7),
                      fontWeight: FontWeight.w500,
                    ),
                    subtitleTextStyle: const TextStyle(
                      fontSize: 14,
                      color: Color(0xffabb8d6),
                    ),
                  )
                : Column(
                    children: [
                      _listTile(
                          //
                          "اقساط السنة الكلية",
                          "${formatter.format(val.data['forThisYear']['salaryAmount'])} ${val.data['forThisYear']['currencySymbol']}", //${val.currencySymbol}
                          Colors.white),
                      _listTile(
                          "الخصم",
                          "${formatter.format(val.data['forThisYear']['discountAmount'])} ${val.data['forThisYear']['currencySymbol']}", //${val.currency}
                          MyColor.turquoise.withOpacity(0.2)),
                      _listTile(
                          "الواصل",
                          "${formatter.format(val.data['forThisYear']['paymentAmount'])} ${val.data['forThisYear']['currencySymbol']}", //${val.currency}
                          MyColor.turquoise.withOpacity(0.2)),
                      const Divider(
                        color: Colors.black,
                      ),
                      _listTile(
                          "المبلغ المتبقي",
                          "${formatter.format(val.data['forThisYear']['remaining'])} ${val.data['forThisYear']['currencySymbol']}",
                          Colors.white.withOpacity(0.1)),
                      _listTile(
                          "المبلغ المتبقي الكلي",
                          "${formatter.format(val.data['forAllYears']['remaining'])} ${val.data['forAllYears']['currencySymbol']}",
                          Colors.white.withOpacity(0.1)),
                      // _listTile(
                      //     "المبلغ المتبقي الكلي",
                      //     "${formatter.format(val.allSalary)} ${val.currency}",
                      //     Colors.white.withOpacity(0.1)),
                      const Spacer(),
                      TextButton(
                        onPressed: () =>
                            Get.to(() => const StudentSalaryDetails()),
                        child: const Text(
                          "التفاصيل",
                          style: TextStyle(
                              color: MyColor.turquoise,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 8, left: 8),
                          child: Text(
                            "ملاحظة",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      val.data['forThisYear']['remaining'] <= 0
                          ? const Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                  padding: EdgeInsets.only(right: 15, left: 15),
                                  child: Text("لايوجد ديون مترتبة لهذه السنة")),
                            )
                          : Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 15, left: 15),
                                  child: RichText(
                                    text: TextSpan(
                                        text: 'القسط القادم في تاريخ ',
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 15),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: val.data['forThisYear']
                                                ["next_payment"],
                                            style: const TextStyle(
                                                color: MyColor.turquoise,
                                                fontSize: 15),
                                          )
                                        ]),
                                  )),
                            ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  );
      }),
    );
  }
}

//StudentSalaryAPI
_listTile(String _title, String _money, Color _color) {
  return Container(
    color: _color,
    child: ListTile(
      title: Text(
        _title,
        style:
            const TextStyle(color: MyColor.black, fontWeight: FontWeight.bold),
      ),
      trailing: Text(
        _money,
        style: const TextStyle(
            color: MyColor.turquoise,
            fontSize: 18,
            fontWeight: FontWeight.bold),
      ),
    ),
  );
}
