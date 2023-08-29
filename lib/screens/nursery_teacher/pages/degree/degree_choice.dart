import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_awesome_select/flutter_awesome_select.dart';
import 'package:get/get.dart';

import '../../../../api_connection/teacher/api_degree_teacher.dart';
import '../../../../provider/auth_provider.dart';
import '../../../../static_files/my_appbar.dart';
import '../../../../static_files/my_color.dart';
import 'degree_student_list.dart';

class DegreeChoice extends StatefulWidget {
  const DegreeChoice({Key? key}) : super(key: key);

  @override
  State<DegreeChoice> createState() => _DegreeChoiceState();
}

class _DegreeChoiceState extends State<DegreeChoice> {
  final MainDataGetProvider _mainDataProvider = Get.put(MainDataGetProvider());
  String? _notificationSubject = '';
  String? _examSubject = '';
  String? _classSchool = '';
  List<S2Choice<String>> notificationSubject = [];
  List<S2Choice<String>> examSubject = [];
  List<S2Choice<String>> classSchool = [];

  _showNotificationSubject() {
    if(_mainDataProvider.mainData['account']['account_subject'] != null) {
      for (Map subject in _mainDataProvider.mainData['account']['account_subject']) {
      notificationSubject.add(S2Choice<String>(
        value: subject['_id'],
        title: subject['subject_name'],
      ));
    }
    }
  }

  _examsList(String? _subjectId) {
    EasyLoading.show(status: "جار جلب البيانات");
    DegreeTeacherAPI().getExamsDegree(_subjectId,_mainDataProvider.mainData['setting'][0]['setting_year']).then((res){
      if(!res['error']){
        for (Map examSubjectMap in res['results']) {
          examSubject.add(S2Choice<String>(
            value: examSubjectMap['degree_exam_name'],
            title: examSubjectMap['degree_exam_name'],
          ));
        }
      }
    });
  }

  _classSchoolList(String? _examName) {
    EasyLoading.show(status: "جار جلب البيانات");
    Map _data = {
      "exam_name": _examName,
      "study_year":_mainDataProvider.mainData['setting'][0]['setting_year']
    };
    DegreeTeacherAPI().getSchoolDegree(_data).then((res){
      if(!res['error']){
        for (Map examSubjectMap in res['results']) {
          classSchool.add(S2Choice<String>(
            value: examSubjectMap['class_school']['_id'],
            title: examSubjectMap['class_school']['class_name'].toString() + " - " + examSubjectMap['class_school']['leader'].toString(),
          ));
        }
      }
    });
  }

  @override
  void initState() {
    _showNotificationSubject();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar("الدرجات",MyColor.pink),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: MyColor.pink,
                ),
                color: MyColor.white1,
              ),
              child: SmartSelect<String>.single(
                title: "المادة",
                placeholder: 'اختر',
                selectedValue: _notificationSubject!,
                choiceItems: notificationSubject,
                onChange: (selected) {
                  setState(() {
                    _classSchool = "";
                    classSchool = [];
                    _notificationSubject = selected.value;
                  });
                  _examsList(selected.value);
                },
              ),
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: MyColor.pink,
                ),
                color: MyColor.white1,
              ),
              child: SmartSelect<String>.single(
                title: "الامتحان",

                placeholder: 'اختر',
                selectedValue: _examSubject!,
                choiceItems: examSubject,
                onChange: (selected) {
                  setState(() {
                    _examSubject = "";
                    examSubject = [];
                    _examSubject = selected.value;
                  });
                  _classSchoolList(selected.value);
                  //_examsList(selected.value);
                },
              ),
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: MyColor.pink,
                ),
                color: MyColor.white1,
              ),
              child: SmartSelect<String>.single(
                title: "الصف والشعبة",
                placeholder: 'اختر',
                selectedValue: _classSchool!,
                choiceItems: classSchool,
                onChange: (selected) {
                  setState(() {
                    _classSchool = selected.value;
                  });
                },
              ),
            ),
          ),
          MaterialButton(
            onPressed: _examSubject == ''  || _classSchool == ""? null :(){
              Map _data = {
                "exam_name":_examSubject,
                "study_year":_mainDataProvider.mainData['setting'][0]['setting_year'],
                "class_school":_classSchool,
                "subject_id":_notificationSubject,
              };
              EasyLoading.show(status: "جار جلب البيانات");
              DegreeTeacherAPI().getStudentListDegrees(_data).then((res){
                //DegreeTeacherStudentListProvider
                Get.to(()=> DegreeStudentList(
                    degreeData: res
                ) );
              });
            },
            color: MyColor.pink,
            textColor: MyColor.white0,
            child: const Text("عرض"),
          )
        ],
      ),
    );
  }
}

