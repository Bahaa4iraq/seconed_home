import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../provider/auth_provider.dart';
import '../../provider/teacher/provider_other.dart';
import '../../static_files/my_color.dart';
import '../../static_files/my_url.dart';
import '../auth_connection.dart';
import 'package:logger/logger.dart';

class OtherApi extends GetConnect {
  final Map? dataProvider = Get.put(TokenProvider()).userData;

  getStudent(Map _data, bool _showLoading) async {
    if (_showLoading) {
      EasyLoading.show(status: "جار جلب البيانات");
    }
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response =
          await post(mainApi + 'teacher/students', _data, headers: _headers);
      if (response.statusCode == 401) {
        
Logger().i("redirect");Auth().redirect();      } else if (response.body["error"] == false) {
        Get.put(OtherProvider()).addToList(response.body['results']);
        EasyLoading.dismiss();
        return response.body['results'];
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

  getNotificationList() async {
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response =
          await get(mainApi + 'teacher/notificationList', headers: _headers);
      if (response.statusCode == 401) {
        
Logger().i("redirect");Auth().redirect();      } else if (response.body["error"] == false) {
        //Get.put(OtherProvider()).addToList(response.body['results']);
        EasyLoading.dismiss();
        return response.body['results'];
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
