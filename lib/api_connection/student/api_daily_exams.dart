import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../provider/auth_provider.dart';
import '../../provider/student/provider_daily_exams.dart';
import '../../static_files/my_color.dart';
import '../../static_files/my_url.dart';
import '../auth_connection.dart';

class DailyExamsAPI extends GetConnect {
  final Map? dataProvider = Get.put(TokenProvider()).userData;

  getDailyExams(String _year, String _classId) async {
    EasyLoading.show(status: "جار جلب البيانات");
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    //study_year
    try {
      final response = await get(
          mainApi +
              'student/dailyExams/class_school/$_classId/study_year/$_year',
          headers: _headers);
      if (response.statusCode == 401) {
        Auth().redirect();
      } else if (response.body["error"] == false) {
        Get.put(DailyExamsProvider()).changeLoading(false);
        Get.put(DailyExamsProvider()).insertData(response.body['results']);
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
