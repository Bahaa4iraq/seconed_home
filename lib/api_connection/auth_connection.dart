import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:secondhome2/local_database/sql_database.dart';
import 'package:secondhome2/provider/student/provider_student_dashboard.dart';
import '../provider/auth_provider.dart';
import '../provider/teacher/provider_teacher_dashboard.dart';
import '../screens/auth/login_page.dart';
import '../static_files/my_color.dart';
import '../static_files/my_url.dart';
import 'package:dio/dio.dart' as dio;
import 'package:logger/logger.dart';

class Auth extends GetConnect {
  final Map? dataProvider = Get.put(TokenProvider()).userData;

  login(Map _data) async {
    final response = await post('${mainApi}login', _data);
    return response.body;
  }

  loginOut() async {
    Map<String, String> _headers = {"Authorization": dataProvider?['token']};
    final response = await get('${mainApi}logout', headers: _headers);
    if (response.status.hasError) {
      return {"error": true};
    } else {
      final box = GetStorage();
      box.erase();
      return response.body;
    }
  }

  getStudentInfo() async {
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response = await get('${mainApi}mainData', headers: _headers);
      if (response.statusCode == 401) {
      Logger().i("error");
      } else {
        if (response.body['error'] == false) {
          Get.put(MainDataGetProvider()).changeContentUrl(response.body['content_url']);
          Get.put(MainDataGetProvider()).addData(response.body['results']);
          //todo subscribe To Topic firebase
          //await FirebaseMessaging.instance.subscribeToTopic("school_${response.body['results']['account_school']}");
          return response.body['results'];
        }
      }
    } catch (e) {
      Logger().i("error");
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت', colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }

  redirect() {
    final box = GetStorage();
    Map? userData = box.read('_userData');
    if (userData?["account_type"] == "student" &&userData?['account_email'].toString() != null) {
      SqlDatabase.db.deleteAccount(userData!['account_email'].toString());
    }
    box.erase();
    Get.delete<TeacherDashboardProvider>();
    Get.delete<StudentDashboardProvider>();
    Get.offAll(() => const LoginPage());
  }

  getIp() async {
    final response = await get("http://ip-api.com/json/?fields=93179");
    return response.body;
  }

  insertStudentInfo(dio.FormData data) async {
    final Map? dataProvider = Get.put(TokenProvider()).userData;
    Map<String, String> headers = {"Authorization": dataProvider!['token']};
    try {
      final response = await dio.Dio().post(
        '${mainApi}student/editInfo',
        data: data,
        options: dio.Options(headers: headers),
        onSendProgress: (int sent, int total) {
          if (sent == total) {
            Get.snackbar("success".tr, "file uploaded success".tr, colorText: MyColor.white0, backgroundColor: MyColor.green);
          }
        },
      );
      if (response.statusCode == 401) {
        redirect();
      } else {
        return response.data;
      }
    } catch (e) {
      Logger().i("error");
      Get.snackbar("خطأ", 'يوجد خطأ من السيرفر', colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }
}
