import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../provider/auth_provider.dart';
import '../../provider/student/attend_provider.dart';
import '../../static_files/my_color.dart';
import '../../static_files/my_url.dart';
import '../auth_connection.dart';
import 'package:logger/logger.dart';

class AttendAPI extends GetConnect {
  final Map? dataProvider = Get.put(TokenProvider()).userData;

  getAttend(Map _data) async {
    EasyLoading.show(status: "جار جلب البيانات");
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    //study_year
    try {
      final response =
          await post(mainApi + 'student/absence', _data, headers: _headers);
      if (response.statusCode == 401) {

Logger().i("redirect");Auth().redirect();      } else if (response.body["error"] == false) {
        Get.put(StudentAttendProvider()).changeLoading(false);
        Get.put(StudentAttendProvider()).addAttendCount(
            response.body['results']['absence'],
            response.body['results']['vacation'],
            response.body['results']['presence'],
            response.body['results']['forThisMonth']['presence']);
        Get.put(StudentAttendProvider())
            .addToList(response.body['results']['data']);
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
