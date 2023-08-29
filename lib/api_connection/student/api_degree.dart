import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../provider/auth_provider.dart';
import '../../provider/student/provider_degree.dart';
import '../../static_files/my_color.dart';
import '../../static_files/my_url.dart';
import '../auth_connection.dart';
import 'package:logger/logger.dart';

class DegreeStudentAPI extends GetConnect {
  final Map? dataProvider = Get.put(TokenProvider()).userData;

  getExamsSchedule(Map _data) async {
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response = await get(
          '${mainApi}student/exams/class_school/${_data['class_school']}/study_year/${_data['study_year']}',
          headers: _headers);
      if (response.statusCode == 401) {
        
Logger().i("redirect");Auth().redirect();      } else if (!response.body["error"]) {
        Get.put(ExamsProvider()).changeLoading(false);
        Get.put(ExamsProvider()).insertData(response.body['results']);
        EasyLoading.dismiss();
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

  getExamsDegree(Map _data) async {
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response = await get(
          '${mainApi}student/degrees/class_school/${_data['class_school']}/study_year/${_data['study_year']}',
          headers: _headers);
      if (response.statusCode == 401) {
        
Logger().i("redirect");Auth().redirect();      } else if (!response.body["error"]) {
        Get.put(DegreeProvider()).changeLoading(false);
        Get.put(DegreeProvider()).insertData(response.body['results']);
        EasyLoading.dismiss();
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
