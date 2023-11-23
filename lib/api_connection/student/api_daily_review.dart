import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../provider/auth_provider.dart';
import '../../provider/student/provider_daily_review.dart';
import '../../static_files/my_color.dart';
import '../../static_files/my_url.dart';
import '../auth_connection.dart';

class DailyReviewAPI extends GetConnect {
  final Map? dataProvider = Get.put(TokenProvider()).userData;

  getDailyReview() async {
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response = await get(mainApi + 'student/daily/review', headers: _headers);
      if (response.statusCode == 401) {
        Auth().redirect();
      } else if (response.body["error"] == false) {
        Get.put(ReviewDailyDateProvider()).changeLoading(false);
        Get.put(ReviewDailyDateProvider()).insertData(response.body['results']);
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

  addDailyReview(String _text, String reviewId) async {
    Map _data = {"review_father_note": _text, "review_id": reviewId};
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response =
      await put(mainApi + 'student/daily/review', _data, headers: _headers);
      if (response.statusCode == 401) {
        Auth().redirect();
      } else {
        return response.body;
      }
    } catch (e) {
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }
}
