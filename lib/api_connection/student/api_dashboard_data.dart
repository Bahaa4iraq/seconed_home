import 'package:get/get.dart';

import '../../provider/auth_provider.dart';
import '../../provider/student/student_provider.dart';
import '../../static_files/my_color.dart';
import '../../static_files/my_url.dart';
import '../auth_connection.dart';

class DashboardDataAPI extends GetConnect {
  final Map? dataProvider = Get.put(TokenProvider()).userData;
  latestNews() async {
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response = await get(mainApi + 'latestNews', headers: _headers);
      if (response.statusCode == 401) {
        Auth().redirect();
      } else if (response.body["error"] == false) {
        Get.put(LatestNewsProvider())
            .changeContentUrl(response.body['content_url']);
        Get.put(LatestNewsProvider()).addData(response.body['results']);
      } else {
        return {"error": true};
      }
    } catch (e) {
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }
}
