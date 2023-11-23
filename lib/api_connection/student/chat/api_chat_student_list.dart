import 'package:get/get.dart';

import '../../../provider/auth_provider.dart';
import '../../../static_files/my_color.dart';
import '../../../static_files/my_url.dart';
import '../../auth_connection.dart';

class ChatTeacherListAPI extends GetConnect {
  final Map? dataProvider = Get.put(TokenProvider()).userData;

  getStudentList(Map _data) async {
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response = await post(mainApi + 'student/chat/teachers', _data,
          headers: _headers);
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

  getChatOfTeacher(Map _data) async {
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response =
          await post(mainApi + 'student/chat', _data, headers: _headers);
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
