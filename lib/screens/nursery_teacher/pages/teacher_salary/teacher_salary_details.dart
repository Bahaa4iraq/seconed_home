// ignore_for_file: depend_on_referenced_packages

import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../api_connection/teacher/api_salary.dart';
import '../../../../provider/auth_provider.dart';
import '../../../../provider/teacher/provider_salary.dart';
import '../../../../static_files/my_appbar.dart';
import '../../../../static_files/my_color.dart';
import '../../../../static_files/my_loading.dart';

class TeacherSalaryDetails extends StatefulWidget {
  const TeacherSalaryDetails({Key? key}) : super(key: key);

  @override
  State<TeacherSalaryDetails> createState() => _TeacherSalaryDetailsState();
}

class _TeacherSalaryDetailsState extends State<TeacherSalaryDetails> {
  _getData() {
    String _year =
        Get.put(MainDataGetProvider()).mainData['setting'][0]['setting_year'];
    TeacherSalaryAPI().getFullSalary(_year);
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
      appBar: myAppBar("تفاصيل الاقساط" ,MyColor.pink),
      body: GetBuilder<TeacherFullSalaryProvider>(builder: (val) {
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
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: val.data.length,
                    itemBuilder: (BuildContext context, int indexes) {
                      return Card(
                        child: Column(
                          children: [
                            listTile(val.data[indexes]['amount'].toString(),
                                "المبلغ", val.data[indexes]['currencySymbol']),
                            listTile(
                                val.data[indexes]['lectures_number'].toString(),
                                "عدد المحاضرات",
                                null),
                            listTile(
                                val.data[indexes]['per_lectures_price']
                                    .toString(),
                                "مبلغ المحاضرة",
                                val.data[indexes]['currencySymbol']),
                            listTile(
                                val.data[indexes]['watch_number'].toString(),
                                "عدد المراقبات",
                                null),
                            listTile(
                                val.data[indexes]['per_lectures_price']
                                    .toString(),
                                "مبلغ المراقبة",
                                val.data[indexes]['currencySymbol']),
                            listTile(
                                val.data[indexes]['allDiscounts'].toString(),
                                "الخصم الكلي",
                                val.data[indexes]['currencySymbol']),

                            //listTile(val.data[indexes]['service_type'],"النوع",null),
                            listTile(val.data[indexes]['payment_date'],
                                "التاريخ", null),
                            // if(val.data[indexes]['desc'] != null)
                            //   listTile(val.data[indexes]['desc'],"التفاصيل",null),
                            // listTile(val.data[indexes]['paymentAmount'].toString(),"المدفوع",val.data[indexes]['currencySymbol']),
                            // listTile(val.data[indexes]['discountAmount'].toString(),"الخصم",val.data[indexes]['currencySymbol']),
                            // listTile(val.data[indexes]['remaining'].toString(),"المتبقي",val.data[indexes]['currencySymbol']),
                          ],
                        ),
                      );
                    });
      }),
    );
  }
}

ListTile listTile(String title, String leading, String? trailing) {
  return ListTile(
    title: Text(title),
    leading: Text(leading),
    trailing: trailing == null ? null : Text(trailing),
  );
}
