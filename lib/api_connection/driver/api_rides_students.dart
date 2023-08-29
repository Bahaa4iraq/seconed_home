import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../provider/auth_provider.dart';
import '../../provider/driver/provider_rides_students.dart';
import '../../static_files/my_color.dart';
import '../../static_files/my_url.dart';
import '../auth_connection.dart';
import 'package:logger/logger.dart';

class RidesStudentsAPI extends GetConnect {
  final Map? dataProvider = Get.put(TokenProvider()).userData;

  getStudents() async {
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response = await get(mainApi + 'driver/rides', headers: _headers);
      if (response.statusCode == 401) {

Logger().i("redirect");Auth().redirect();      } else if (!response.body["error"]) {
        Get.put(RidesStudentsProvider()).changeLoading(false);
        Get.put(RidesStudentsProvider()).insertData(response.body['results']);
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

  addStudentStatus(String _studentId, String _type) async {
    Map _data = {"student_id": _studentId, "status": _type};
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response =
          await post(mainApi + 'driver/rides', _data, headers: _headers);
      if (response.statusCode == 401) {

Logger().i("redirect");Auth().redirect();      } else if (!response.body["error"]) {
        EasyLoading.showSuccess(response.body['message'].toString());
        getStudents();
      } else {
        EasyLoading.showError(response.body['message'].toString());
      }
    } catch (e) {
      Logger().i("error");
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }
}
