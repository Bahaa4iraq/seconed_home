import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../provider/auth_provider.dart';
import '../../provider/student/provider_daily_exams.dart';
import '../../provider/student/subjects_provider.dart';
import '../../static_files/my_color.dart';
import '../../static_files/my_url.dart';
import '../auth_connection.dart';

class HomeworkAPI extends GetConnect {
  final Map? dataProvider = Get.put(TokenProvider()).userData;

  getHomeworks(String year, String classId) async {
    EasyLoading.show(status: "جار جلب البيانات");
    Map<String, String> headers = {"Authorization": dataProvider!['token']};
    //study_year
    try {
      final response = await get(
          '${mainApi}student/homework/class_school/$classId/study_year/$year',
          headers: headers);

      if (response.statusCode == 401) {
        
Logger().i("redirect");Auth().redirect();      } else if (response.body["error"] == false) {
        Get.put(DailyExamsProvider()).changeLoading(false);
        Get.put(DailyExamsProvider()).insertData(response.body['results']);
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
        return {"error": true};
      }
    } catch (e) {
      Logger().i("error");
      Get.snackbar("خطأ", 'يوجد خطأ من السيرفر',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }

  getSubjectsList() async {
    EasyLoading.show(status: "جار جلب البيانات");

    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response =
          await get(mainApi + 'student/subject', headers: _headers);

      if (response.statusCode == 401) {
        
Logger().i("redirect");Auth().redirect();      } else if (!response.body["error"]) {
        Get.put(SubjectsProvider()).changeLoading(false);
        Get.put(SubjectsProvider()).insertData(response.body['results']);
        EasyLoading.dismiss();
        return true;
      } else {
        EasyLoading.dismiss();
        return {"error": true};
      }
    } catch (e) {
      Logger().i("error");
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }

  getSubjectsDetails(Map data) async {
    EasyLoading.show(status: "جار جلب البيانات");

    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response =
          await post(mainApi + 'student/dailyStudy', data, headers: _headers);
      if (response.statusCode == 401) {
        
Logger().i("redirect");Auth().redirect();      } else if (!response.body["error"]) {
        Get.put(SubjectsProvider()).changeLoading(false);
        Get.put(SubjectsProvider())
            .insertData(response.body['results']['data']);
        EasyLoading.dismiss();
        return response.body['results']['content_url'];
      } else {
        EasyLoading.dismiss();
        return {"error": true};
      }
    } catch (e) {
      Logger().i("error");

      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }
}
