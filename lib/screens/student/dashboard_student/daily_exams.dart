import 'package:intl/intl.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api_connection/student/api_daily_exams.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/student/provider_daily_exams.dart';
import '../../../static_files/my_appbar.dart';
import '../../../static_files/my_color.dart';
import '../../../static_files/my_loading.dart';
import '../../../static_files/my_times.dart';

class DailyExams extends StatefulWidget {
  const DailyExams({super.key});

  @override
  State<DailyExams> createState() => _DailyExamsState();
}

class _DailyExamsState extends State<DailyExams> {
  final MainDataGetProvider _mainDataGetProvider =
      Get.put(MainDataGetProvider());
  final ScrollController _scrollController = ScrollController();

  _getData() {
    String year = _mainDataGetProvider.mainData['setting'][0]['setting_year'];
    String classId = _mainDataGetProvider.mainData['account']
        ['account_division_current']['_id'];
    DailyExamsAPI().getDailyExams(year, classId);
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
      appBar: myAppBar("الامتحانات اليومية", MyColor.turquoise),
      body: GetBuilder<DailyExamsProvider>(builder: (val) {
        return val.isLoading
            ? loading()
            : val.data.isEmpty
                ? EmptyWidget(
                    image: null,
                    packageImage: PackageImage.Image_1,
                    title: 'لاتوجد بيانات',
                    subTitle: 'لم يتم اضافة الجدول',
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
                    controller: _scrollController,
                    itemCount: val.data.length,
                    itemBuilder: (BuildContext context, int indexes) {
                      return listTileData(val.data[indexes]);
                    });
      }),
    );
  }
}

Container listTileData(Map data) {
  return Container(
    padding: const EdgeInsets.all(10),
    margin: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(width: 1.0, color: MyColor.turquoise),
    ),
    child: GestureDetector(
      onTap: () {
        if (data['daily_exam_note'] != null) {
          dialog(data['daily_exam_note'].toString());
        }
      },
      child: Column(
        children: [
          Row(
            children: [
              const Text("المادة: "),
              Text(data['daily_exam_subject'].toString()),
              const Spacer(),
              if (data['daily_exam_note'] != null)
                IconButton(
                    onPressed: () {
                      dialog(data['daily_exam_note'].toString());
                    },
                    icon: const Icon(Icons.info_outline_rounded))
            ],
          ),
          Row(
            children: [
              const Text("درجة الطالب: "),
              data['daily_exam_degrees'].isEmpty
                  ? const Text("--")
                  : Text(data['daily_exam_degrees']['degree'].toString()),
            ],
          ),
          Row(
            children: [
              const Text("الدرجة العظمى: "),
              Text(data['daily_exam_max_degree'].toString()),
            ],
          ),
          Row(
            children: [
              const Text("تاريخ الامتحان: "),
              Text(data['daily_exam_date'].toString()),
            ],
          ),
          Row(
            children: [
              const Text("يوم الامتحان: "),
              Text(stringToDayOfWeek(data['daily_exam_date'])),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "تاريخ الاضافة: ",
                style: TextStyle(color: MyColor.grayDark.withOpacity(0.3)),
              ),
              Text(
                toDateOnly(data['created_at']),
                style: TextStyle(color: MyColor.grayDark.withOpacity(0.3)),
              ),
            ],
          ),
          //toDayOnly
        ],
      ),
    ),
  );
}

dialog(String dailyExamNote) {
  return Get.defaultDialog(
      title: "المادة الامتحانية", content: Text(dailyExamNote));
}
