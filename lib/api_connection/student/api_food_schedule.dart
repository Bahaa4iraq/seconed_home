import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../provider/auth_provider.dart';
import '../../provider/student/food_schedule_provider.dart';
import '../../static_files/my_color.dart';
import '../../static_files/my_url.dart';
import '../auth_connection.dart';
import 'package:logger/logger.dart';

class FoodScheduleAPI extends GetConnect {
  final Map? dataProvider = Get.put(TokenProvider()).userData;
  FoodScheduleProvider foodScheduleProvider =  Get.put(FoodScheduleProvider());
  getSchedule(String id) async {
    EasyLoading.show(status: "جار جلب البيانات");
    Map<String, String> headers = {"Authorization": dataProvider!['token']};
    try {
      final response = await get('${mainApi}student/schedule_food/class_school/$id',
          headers: headers);
      if (response.statusCode == 401) {
        
Logger().i("redirect");Auth().redirect();      } else if (response.body["error"] == false) {
        foodScheduleProvider.changeLoading(false);
        foodScheduleProvider.addData(response.body['results']);
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
