import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import '../../../provider/auth_provider.dart';
import '../../../static_files/my_color.dart';
import '../../../static_files/my_url.dart';
import '../../auth_connection.dart';
import 'package:logger/logger.dart';

class ChatGroupListAPI extends GetConnect {
  final Map? dataProvider = Get.put(TokenProvider()).userData;

  getGroupList() async {
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response =
          await get(mainApi + 'teacher/chatGroup/get', headers: _headers);
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

  getChatOfGroup(String _groupId, int page) async {
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response = await get(
          mainApi + 'teacher/chatGroup/messages/groupId/$_groupId/page/$page',
          headers: _headers);
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

  createGroup(dio.FormData _data) async {
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response = await dio.Dio().post(
        mainApi + 'teacher/chatGroup/create',
        data: _data,
        options: dio.Options(headers: _headers),
        onSendProgress: (int sent, int total) {
          EasyLoading.showProgress(sent / total, status: "جار الرفع...");
          if (sent == total) {
            EasyLoading.instance.userInteractions = true;
            EasyLoading.showSuccess("تم الرفع بنجاح", dismissOnTap: true);
            Timer(const Duration(seconds: 1), () {});
          }
        },
      );
      if (response.data['error'] == false) {
        EasyLoading.showSuccess(response.data['message'].toString());
      } else {
        EasyLoading.showError(response.data['message'].toString());
      }
      return response.data;
    } catch (e) {
      Logger().i("error");
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }
}
