import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../provider/auth_provider.dart';
import '../../provider/driver/provider_notification.dart';
import '../../static_files/my_color.dart';
import '../../static_files/my_url.dart';
import '../auth_connection.dart';
import 'package:logger/logger.dart';

class NotificationsAPI extends GetConnect {
  final Map? dataProvider = Get.put(TokenProvider()).userData;

  getNotifications(Map _data) async {
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response =
          await post(mainApi + 'driver/notification', _data, headers: _headers);
      if (response.statusCode == 401) {
        Auth().redirect();      } else if (!response.body["error"]) {
        Get.put(NotificationDriverProvider()).changeLoading(false);
        Get.put(NotificationDriverProvider())
            .changeContentUrl(response.body['content_url']);
        Get.put(NotificationDriverProvider())
            .insertData(response.body['results']);
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

  updateReadNotifications(String _id) async {
    Map _data = {"notification_id": _id};
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response =
          await put(mainApi + 'driver/notification', _data, headers: _headers);
      if (response.statusCode == 401) {

Logger().i("redirect");Auth().redirect();      } else if (!response.body["error"]) {
        Get.put(NotificationDriverProvider()).editReadMap(_id);
      }
    } catch (e) {
      Logger().i("error");
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }
}
