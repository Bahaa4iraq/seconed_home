//var a = Get.put(MainDataGetProvider()).mainData['setting'][0]['setting_year'];

// ignore_for_file: depend_on_referenced_packages, no_leading_underscores_for_local_identifiers

import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../api_connection/teacher/api_salary.dart';
import '../../../../../provider/auth_provider.dart';
import '../../../../../provider/teacher/provider_salary.dart';
import '../../../../../static_files/my_appbar.dart';
import '../../../../../static_files/my_color.dart';
import '../../../../../static_files/my_loading.dart';
import 'teacher_salary_details.dart';

final formatter = NumberFormat.decimalPattern();

class TeacherSalary extends StatefulWidget {
  const TeacherSalary({Key? key}) : super(key: key);

  @override
  State<TeacherSalary> createState() => _TeacherSalaryState();
}

class _TeacherSalaryState extends State<TeacherSalary> {
  _getData() {
    String _year =
        Get.put(MainDataGetProvider()).mainData['setting'][0]['setting_year'];
    TeacherSalaryAPI().getSalary(_year);
  }

  DateTime now = DateTime.now();
  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar("الراتب",MyColor.turquoise),
      body: GetBuilder<TeacherSalaryProvider>(builder: (val) {
        return val.isLoading
            ? loading()
            : val.data.isEmpty
                ? EmptyWidget(
                    image: null,
                    packageImage: PackageImage.Image_1,
                    title: 'لاتوجد بيانات',
                    subTitle: 'لم يتم اضافة الاثساط',
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
                          "الراتب الاسمي",
                          "${formatter.format(val.data['amount'])} ${val.data['currencySymbol']}",
                          Colors.white),
                      _listTile(
                          "الاستقطاعات",
                          "${formatter.format(val.data['allDiscounts'])} ${val.data['currencySymbol']}",
                          MyColor.turquoise.withOpacity(0.2)),
                      _listTile(
                          "المكافئات",
                          "${formatter.format(val.data['allAdditional'])} ${val.data['currencySymbol']}",
                          MyColor.turquoise.withOpacity(0.2)),
                      _listTile(
                          "المحاضرات",
                          "${formatter.format(val.data['allLectures'])} ${val.data['currencySymbol']}",
                          MyColor.turquoise.withOpacity(0.2)),
                      _listTile(
                          "المراقبات",
                          "${formatter.format(val.data['allWatch'])} ${val.data['currencySymbol']}",
                          MyColor.turquoise.withOpacity(0.2)),
                      const Divider(
                        color: Colors.black,
                      ),
                      _listTile(
                          "المبلغ المستحق",
                          "${formatter.format(val.data['pureMoney'])} ${val.data['currencySymbol']}",
                          Colors.white.withOpacity(0.1)),
                      const Spacer(),
                      TextButton(
                        onPressed: () =>
                            Get.to(() => const TeacherSalaryDetails()),
                        child: const Text(
                          "التفاصيل",
                          style: TextStyle(
                              color: MyColor.grayDark,
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
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                            padding: const EdgeInsets.only(right: 15, left: 15),
                            child: RichText(
                              text: TextSpan(
                                  text: "تاريخ التسليم",
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 11),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: val.data["payment_date"],
                                      style: const TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 11),
                                    ),
                                  ]),
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  );
      }),
    );
  }
}

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
            color: Colors.blueGrey, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
