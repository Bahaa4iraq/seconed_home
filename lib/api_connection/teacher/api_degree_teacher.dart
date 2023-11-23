import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../provider/auth_provider.dart';
import '../../provider/teacher/provider_degree_teacher.dart';
import '../../static_files/my_color.dart';
import '../../static_files/my_url.dart';
import '../auth_connection.dart';

class ExamTeacherAPI extends GetConnect {
  final Map? dataProvider = Get.put(TokenProvider()).userData;

  getExamsSchedule(Map _data) async {
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response = await get(
          '${mainApi}teacher/exams/class_school/${_data['class_school']}/study_year/${_data['study_year']}',
          headers: _headers);
      if (response.statusCode == 401) {
        Auth().redirect();
      } else if (!response.body["error"]) {
        Get.put(ExamsTeacherProvider()).changeLoading(false);
        Get.put(ExamsTeacherProvider()).insertData(response.body['results']);
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
        return {"error": true};
      }
    } catch (e) {
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }
}

class DegreeTeacherAPI extends GetConnect {
  final Map? dataProvider = Get.put(TokenProvider()).userData;

  getExamsDegree(String? _subjectId, String? _year) async {
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response = await get(
          '${mainApi}teacher/degrees/subject_id/$_subjectId/study_year/$_year',
          headers: _headers);
      if (response.statusCode == 401) {
        Auth().redirect();
      } else {
        EasyLoading.dismiss();
        return response.body;
      }
    } catch (e) {
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }

  getSchoolDegree(Map _data) async {
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response = await post(
          '${mainApi}teacher/degrees/class_school', _data,
          headers: _headers);
      if (response.statusCode == 401) {
        Auth().redirect();
      } else {
        EasyLoading.dismiss();
        return response.body;
      }
    } catch (e) {
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }

  getStudentListDegrees(Map _data) async {
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response = await post('${mainApi}teacher/degrees/getData', _data,
          headers: _headers);
      if (response.statusCode == 401) {
        Auth().redirect();
      } else {
        EasyLoading.dismiss();
        return response.body['results'];
      }
    } catch (e) {
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }

  insertDegrees(Map _data) async {
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response = await post('${mainApi}teacher/degrees/addDegrees', _data,
          headers: _headers);
      if (response.statusCode == 401) {
        Auth().redirect();
      } else {
        EasyLoading.dismiss();
        return response.body['results'];
      }
    } catch (e) {
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }
}
