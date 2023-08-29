import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../provider/auth_provider.dart';
import '../../provider/teacher/provider_weekly_schedule.dart';
import '../../static_files/my_color.dart';
import '../../static_files/my_url.dart';
import '../auth_connection.dart';

class WeeklyScheduleAPI extends GetConnect {
  final Map? dataProvider = Get.put(TokenProvider()).userData;

  getSchedule(String _id) async {
    EasyLoading.show(status: "جار جلب البيانات");
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response = await get(mainApi + 'teacher/schedule/class_school/$_id',
          headers: _headers);
      if (response.statusCode == 401) {

Logger().i("redirect");Auth().redirect();      } else if (response.body["error"] == false) {
        Get.put(TeacherWeeklyScheduleProvider()).changeLoading(false);
        Get.put(TeacherWeeklyScheduleProvider())
            .addData(response.body['results']);
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
        return {"error": true};
      }
    } catch (e) {
      Logger().i("error");
      Logger().i("error");
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }
}
