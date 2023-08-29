import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../provider/auth_provider.dart';
import '../../provider/student/provider_review.dart';
import '../../static_files/my_color.dart';
import '../../static_files/my_url.dart';
import '../auth_connection.dart';
import 'package:logger/logger.dart';

class ReviewAPI extends GetConnect {
  final Map? dataProvider = Get.put(TokenProvider()).userData;
//https://api.lm-kids.com/api/web/review/student/account_id/64c22c99d26cc36d50ef6745/study_year/2023-2024
//https://api.lm-kids.com/api/web/review/student/account_id/64c22c99d26cc36d50ef6745/study_year/2023-2024

  getReview() async {
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response = await get(mainApi + 'student/review', headers: _headers);
      if (response.statusCode == 401) {
        
Logger().i("redirect");Auth().redirect();      } else if (response.body["error"] == false) {
        Get.put(ReviewDateProvider()).changeLoading(false);
        Get.put(ReviewDateProvider()).insertData(response.body['results']);
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

  addReview(String _text, String reviewId) async {
    Map _data = {"review_father_note": _text, "review_id": reviewId};
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response =
          await put(mainApi + 'student/review', _data, headers: _headers);
      if (response.statusCode == 401) {
        
Logger().i("redirect");Auth().redirect();      } else {
        return response.body;
      }
    } catch (e) {
      Logger().i("error");
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }
}
