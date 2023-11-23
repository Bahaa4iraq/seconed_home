import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../provider/auth_provider.dart';
import 'package:dio/dio.dart' as dio;
import '../../static_files/my_color.dart';
import '../../static_files/my_url.dart';
import '../auth_connection.dart';

class StudentProfileAPI extends GetConnect {
  final Map? dataProvider = Get.put(TokenProvider()).userData;

  editImgProfile(dio.FormData _data) async {
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response = await dio.Dio().put(
        mainApi + 'student/editImg',
        data: _data,
        options: dio.Options(headers: _headers),
        onSendProgress: (int sent, int total) {
          EasyLoading.showProgress(sent / total, status: "جار الرفع...");
          if (sent == total) {
            EasyLoading.instance.userInteractions = true;
            EasyLoading.showSuccess("تم الرفع بنجاح", dismissOnTap: true);
            Timer(const Duration(seconds: 1), () {
              EasyLoading.dismiss();
            });
          }
        },
      );
      return response.data;
    } catch (e) {
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }

  studentCertificateInsert(dio.FormData _data) async {
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response = await dio.Dio().post(
        mainApi + 'student/certificate',
        data: _data,
        options: dio.Options(headers: _headers),
        onSendProgress: (int sent, int total) {
          EasyLoading.showProgress(sent / total, status: "جار الرفع...");
          if (sent == total) {
            EasyLoading.instance.userInteractions = true;
            EasyLoading.showSuccess("تم الرفع بنجاح", dismissOnTap: true);
            Timer(const Duration(seconds: 1), () {
              EasyLoading.dismiss();
            });
          }
        },
      );
      if (response.statusCode == 401) {
        Auth().redirect();
      } else {
        return response.data;
      }
    } catch (e) {
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }

  studentCertificateGet() async {
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response =
          await get(mainApi + 'student/certificate', headers: _headers);
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
