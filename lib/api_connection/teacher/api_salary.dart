import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../provider/auth_provider.dart';
import '../../provider/teacher/provider_salary.dart';
import '../../static_files/my_color.dart';
import '../../static_files/my_url.dart';
import '../auth_connection.dart';
import 'package:logger/logger.dart';

class TeacherSalaryAPI extends GetConnect {
  final Map? dataProvider = Get.put(TokenProvider()).userData;

  getSalary(String _year) async {
    EasyLoading.show(status: "جار جلب البيانات");
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response = await get('${mainApi}teacher/salary/study_year/$_year',
          headers: _headers);
      if (response.statusCode == 401) {
        
Logger().i("redirect");Auth().redirect();      } else if (response.body["error"] == false) {
        Get.put(TeacherSalaryProvider()).changeLoading(false);
        Get.put(TeacherSalaryProvider()).addData(response.body['results']);
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

  getFullSalary(String _year) async {
    EasyLoading.show(status: "جار جلب البيانات");
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response = await get(
          '${mainApi}teacher/salary/details/study_year/$_year',
          headers: _headers);
      if (response.statusCode == 401) {
        
Logger().i("redirect");Auth().redirect();      } else if (!response.body["error"]) {
        Get.put(TeacherFullSalaryProvider()).changeLoading(false);
        Get.put(TeacherFullSalaryProvider()).addData(response.body['results']);
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
        return {"error": true};
      }
    } catch (e) {
      Logger().i("error");
      EasyLoading.dismiss();
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }
}
