import 'package:get/get.dart';

import '../../../provider/auth_provider.dart';
import '../../../static_files/my_color.dart';
import '../../../static_files/my_url.dart';
import '../../auth_connection.dart';

class ChatTeacherListAPI extends GetConnect {
  final Map? dataProvider = Get.put(TokenProvider()).userData;

  getStudentList(Map data) async {
    Map<String, String> headers = {"Authorization": dataProvider!['token']};
    try {
      final response =
          await post('${mainApi}student/chat/teachers', data, headers: headers);
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

  getChatOfTeacher(Map data) async {
    Map<String, String> headers = {"Authorization": dataProvider!['token']};
    try {
      final response =
          await post('${mainApi}student/chat', data, headers: headers);
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
