import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../api_connection/student/api_degree.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/student/provider_degree.dart';
import '../../../static_files/my_appbar.dart';
import '../../../static_files/my_color.dart';
import '../../../static_files/my_loading.dart';

class ExamSchedule extends StatefulWidget {
  const ExamSchedule({Key? key}) : super(key: key);

  @override
  _ExamScheduleState createState() => _ExamScheduleState();
}

class _ExamScheduleState extends State<ExamSchedule> {
  final MainDataGetProvider _mainDataGetProvider = Get.put(MainDataGetProvider());
  @override
  void initState() {
    Map _data = {
      "study_year": _mainDataGetProvider.mainData['setting'][0]['setting_year'],
      "class_school": _mainDataGetProvider.mainData['account']['account_division_current']['_id'],
    };
    DegreeStudentAPI().getExamsSchedule(_data);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar("جدول الامتحانات",MyColor.pink),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: GetBuilder<ExamsProvider>(builder: (val) {
          return val.isLoading
              ? loading()
              : val.data.isEmpty
                  ? EmptyWidget(
                      image: null,
                      packageImage: PackageImage.Image_1,
                      title: 'لايوجد جدول',
                      subTitle: 'لم يتم اضافة الجدول بعد',
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
                        return Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                              color: MyColor.turquoise2.withOpacity(0.5),
                              border: Border.all(color: MyColor.turquoise),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: ExpansionTile(
                            title: Text(
                              val.data[indexes]['exams_name'].toString(),
                              style: const TextStyle(color: MyColor.grayDark),
                            ),
                            children:
                                _children(val.data[indexes]['exams_schedule']),
                          ),
                        );
                      });
        }),
      ),
    );
  }

  _children(List res) {
    List<Widget> _widget = [
      Container(
        padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
        color: MyColor.white0,
        child: Row(
          children: const [
            Expanded(
              flex: 1,
              child: Icon(
                Icons.info,
                size: 20,
                color: MyColor.pink,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                "اليوم",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: MyColor.pink),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                "التاريخ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: MyColor.pink),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                "المادة",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: MyColor.pink),
              ),
            ),
          ],
        ),
      )
    ];
    for (var _d in res) {
      _widget.add(GestureDetector(
        onTap: () {
          if (_d['schedule_exam_description'] != null) {
            Get.defaultDialog(title: "المادة الامتحانية", content: Text(_d['schedule_exam_description'].toString()));
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
            color: MyColor.white0,
          ),
          padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
          child: Row(
            children: [
              const Expanded(
                flex: 1,
                child: Icon(
                  Icons.info_outline_rounded,
                  size: 20,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  _d['schedule_exams_day'].toString(),
                  style: const TextStyle(color: MyColor.pink, fontSize: 11),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  _d['schedule_exams_date'].toString(),
                  style: const TextStyle(color: MyColor.pink, fontSize: 11),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  _d['schedule_exams_subject'].toString(),
                  style: const TextStyle(color: MyColor.pink, fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ));
    }
    return _widget;
  }
}
