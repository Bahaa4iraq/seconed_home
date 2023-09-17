import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:line_icons/line_icons.dart';

import '../../../api_connection/student/api_attend.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/student/attend_provider.dart';
import '../../../static_files/my_appbar.dart';
import '../../../static_files/my_color.dart';
import '../../../static_files/my_loading.dart';

class StudentAttend extends StatefulWidget {
  final Map userData;
  const StudentAttend({Key? key, required this.userData}) : super(key: key);

  @override
  _StudentAttendState createState() => _StudentAttendState();
}

class _StudentAttendState extends State<StudentAttend> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _search = TextEditingController();
  DateTime selectedDateBirthday = DateTime.now();
  String? firstDate;
  String? secondDate;
  int page = 0;

  Future<void> _selectRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      locale: const Locale("en", "US"),
      firstDate: DateTime.now().add(const Duration(days: -365)),
      lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: MyColor.pink, // <-- SEE HERE
                onPrimary: MyColor.white0, // <-- SEE HERE
                onSurface: MyColor.white0, // <-- SEE HERE
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: MyColor.white0, // button text color
                ),
              ),
            ),
            child: child!,
          );
        });
    if (picked != null) {
      final _formattedDateFirst =
          intl.DateFormat('yyyy-MM-dd').format(picked.start);
      final _formattedDateSecond =
          intl.DateFormat('yyyy-MM-dd').format(picked.end);
      firstDate = _formattedDateFirst;
      secondDate = _formattedDateSecond;
      _search.text = "من $_formattedDateFirst الى $_formattedDateSecond";
      Get.put(StudentAttendProvider()).destroyData();
      _getData();
    }
  }

  _getData() {
    Map _data = {
      "study_year": Get.put(MainDataGetProvider()).mainData['setting'][0]
          ['setting_year'],
      "page": page,
      "firstDate": firstDate,
      "secondDate": secondDate,
    };
    AttendAPI().getAttend(_data);
  }

  @override
  void initState() {
    _getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        page++;
        _getData();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    Get.put(StudentAttendProvider()).changeLoading(true);
    Get.put(StudentAttendProvider()).destroyData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar("الحضور",MyColor.pink),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            constraints: const BoxConstraints(minWidth: 200, maxWidth: 350),
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            child: TextFormField(
              maxLines: 1,
              autofocus: false,
              controller: _search,
              cursorRadius: const Radius.circular(16.0),
              cursorWidth: 2.0,
              textInputAction: TextInputAction.done,
              minLines: 1,
              onTap: () {
                _selectRange(context);
              },
              enableInteractiveSelection: true,
              readOnly: true,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                  labelText: "بحث حسب التاريخ",
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 10),
                  fillColor: MyColor.white4,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: MyColor.black,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: MyColor.white4,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: MyColor.white4,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: MyColor.red,
                    ),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      LineIcons.search,
                    ),
                  ),
                  filled: true
                  //fillColor: Colors.green
                  ),
            ),
          ),
          // Container(
          //   padding: const EdgeInsets.only(top: 5, bottom: 5),
          //   child: GetBuilder<StudentAttendProvider>(builder: (val) {
          //     return Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: [
          //         widgetCount("عدد المحاضرات", val.allPresence),
          //         widgetCount("العدد الحالي", val.forThisMonth),
          //       ],
          //     );
          //   }),
          // ),
          Container(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: GetBuilder<StudentAttendProvider>(builder: (val) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  widgetCount("اجازة", val.allVacation),
                  widgetCount("غياب", val.allAbsence),
                  widgetCount("حضور", val.allPresence),
                ],
              );
            }),
          ),
          Expanded(
            child: Container(
              constraints: const BoxConstraints(minWidth: 200, maxWidth: 350),
              margin: const EdgeInsets.only(top: 10),
              child: GetBuilder<StudentAttendProvider>(
                builder: (val) => val.isLoading
                    ? loading()
                    : val.userList.isEmpty
                        ? EmptyWidget(
                            image: null,
                            packageImage: PackageImage.Image_1,
                            title: 'لاتوجد بيانات',
                            subTitle: 'لم يتم اضافة اي بيانات',
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
                            itemCount: val.userList.length,
                            itemBuilder: (BuildContext context, int indexes) {
                              return listTileData(
                                  val.userList[indexes]['absence_type'],
                                  val.userList[indexes]['absence_date']
                                      .toString());
                            }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget listTileData(String _absenceType, String _date) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
        color: _color(_absenceType).withOpacity(0.25),
        borderRadius: BorderRadius.circular(10)),
    child: ListTile(
      title: Text(
        _date.toString(),
        style:
            const TextStyle(color: MyColor.pink, fontWeight: FontWeight.bold),
      ),
      trailing: _text(_absenceType),
    ),
  );
}

Widget _text(String _text) {
  if (_text == "vacation") {
    return const Text(
      "اجازة",
      style: TextStyle(color: MyColor.pink, fontWeight: FontWeight.bold),
    );
  } else if (_text == "absence") {
    return const Text(
      "غياب",
      style: TextStyle(color: MyColor.pink, fontWeight: FontWeight.bold),
    );
  } else {
    return const Text(
      "حضور",
      style: TextStyle(color: MyColor.pink, fontWeight: FontWeight.bold),
    );
  }
}

Color _color(String _text) {
  if (_text == "vacation") {
    return MyColor.pink;
  } else if (_text == "absence") {
    return MyColor.red;
  } else {
    return MyColor.green;
  }
}

Widget widgetCount(String _title, int _count) {
  return Container(
    decoration: BoxDecoration(
        border: Border.all(
          color: MyColor.pink,
        ),
        borderRadius: BorderRadius.circular(10)),
    child: Row(
      children: [
        Container(
            margin: const EdgeInsets.only(right: 5, left: 5, top: 0, bottom: 0),
            padding: const EdgeInsets.all(3),
            child: Text(
              _title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            )),
        const SizedBox(
          width: 10,
        ),
        Container(
          margin: const EdgeInsets.only(right: 5, left: 5, top: 2, bottom: 2),
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
              color: MyColor.pink, shape: BoxShape.circle),
          child: Text(
            _count.toString(),
            style: const TextStyle(fontSize: 13, color: MyColor.white0),
          ),
        )
      ],
    ),
  );
}
