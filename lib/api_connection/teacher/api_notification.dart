import 'dart:async';

import 'package:dio/dio.dart' as dio;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../provider/auth_provider.dart';
import '../../provider/teacher/provider_notification.dart';
import '../../static_files/my_color.dart';
import '../../static_files/my_url.dart';
import '../auth_connection.dart';

class NotificationsAPI extends GetConnect {
  final Map? dataProvider = Get.put(TokenProvider()).userData;
  final NotificationProviderE _notificationProviderE =
      Get.put(NotificationProviderE());

  final NotificationProviderIntimation _notificationProviderIntimation =
      Get.put(NotificationProviderIntimation());

  getNotifications(Map _data) async {
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      Logger().i(_data);
      final response = await post(mainApi + 'teacher/notification', _data,
          headers: _headers);
      if (response.statusCode == 401) {
        Logger().i("redirect");
        Auth().redirect();
      } else if (!response.body["error"]) {
        Get.put(TeacherNotificationProvider()).changeLoading(false);
        Get.put(TeacherNotificationProvider())
            .changeContentUrl(response.body['content_url']);
        Get.put(TeacherNotificationProvider()).changeCount(
            response.body['results']['count_all'],
            response.body['results']['count_read'],
            response.body['results']['count_unread']);
        Get.put(TeacherNotificationProvider())
            .insertData(response.body['results']['data']);
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
        return {"error": true};
      }
    } catch (e) {
      Logger().i("error $e $_data");
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }

  updateReadNotifications(String _id) async {
    Map _data = {"notification_id": _id};
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response =
          await put(mainApi + 'teacher/notification', _data, headers: _headers);
      if (response.statusCode == 401) {
        Logger().i("redirect");
        Auth().redirect();
      } else if (!response.body["error"]) {
        Get.put(TeacherNotificationProvider()).editReadMap(_id);
      }
    } catch (e) {
      Logger().i("error");
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }

  addNotification(dio.FormData _data) async {
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response = await dio.Dio().post(
        mainApi + 'teacher/notification/add',
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
      if (!response.data['error']) {
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

  deleteNotification(Map _data) async {
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response = await post(
          mainApi + 'teacher/notification/remove', _data,
          headers: _headers);
      if (response.statusCode == 401) {
        Logger().i("redirect");
        Auth().redirect();
      } else if (!response.body["error"]) {
        Get.put(TeacherNotificationProvider())
            .deleteNotification(_data["notifications_id"]);
        EasyLoading.showSuccess("تم حذف الاشعار بنجاح");
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

  getHomeworkAnswers(String _notificationId, int page) async {
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response = await get(
          mainApi +
              'teacher/homeworkAnswers/notification_id/$_notificationId/page/$page',
          headers: _headers);
      if (response.statusCode == 401) {
        Logger().i("redirect");
        Auth().redirect();
      } else if (!response.body["error"]) {
        Get.put(TeacherHomeworkAnswersProvider()).changeLoading(false);
        Get.put(TeacherHomeworkAnswersProvider())
            .changeContentUrl(response.body['content_url']);
        Get.put(TeacherHomeworkAnswersProvider())
            .insertData(response.body['results']['data']);
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

  addCorrect(Map _data) async {
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response = await put(mainApi + 'teacher/homeworkAnswers', _data,
          headers: _headers);
      if (response.statusCode == 401) {
        Logger().i("redirect");
        Auth().redirect();
      } else {
        return response.body;
      }
    } catch (e) {
      Logger().i("error");
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }

  getNotificationsE(Map _data) async {
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response = await post('${mainApi}teacher/notification', _data,
          headers: _headers);
      if (response.statusCode == 401) {
        Auth().redirect();
        //NotificationProviderE
      } else if (!response.body["error"]) {
        _notificationProviderE.changeLoading(false);
        _notificationProviderE.changeContentUrl(response.body['content_url']);
        _notificationProviderE.changeCount(
            response.body['results']['count_all'],
            response.body['results']['count_read'],
            response.body['results']['count_unread']);
        _notificationProviderE.insertData(response.body['results']['data']);
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
        return {"error": true};
      }
    } catch (e) {
      Logger().i("error $_data");
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }

  updateReadNotificationsE(String _id) async {
    Map _data = {"notification_id": _id};
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response =
          await put('${mainApi}teacher/notification', _data, headers: _headers);
      if (response.statusCode == 401) {
        Logger().i("redirect");
        Auth().redirect();
      } else if (!response.body["error"]) {
        print(response);
        Get.put(NotificationProviderE()).editReadMap(_id);
      }
    } catch (e) {
      Logger().i("error");
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }

  getNotificationsIntimation(Map _data) async {
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response = await post('${mainApi}teacher/notification', _data,
          headers: _headers);
      if (response.statusCode == 401) {
        Auth().redirect();
        //NotificationProviderE
      } else if (!response.body["error"]) {
        _notificationProviderIntimation.changeLoading(false);
        _notificationProviderIntimation.changeContentUrl(response.body['content_url']);
        _notificationProviderIntimation.changeCount(
            response.body['results']['count_all'],
            response.body['results']['count_read'],
            response.body['results']['count_unread']);
        _notificationProviderIntimation.insertData(response.body['results']['data']);
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
        return {"error": true};
      }
    } catch (e) {
      Logger().i("error $_data");
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }

  updateReadNotificationsIntimation(String _id) async {
    Map _data = {"notification_id": _id};
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    try {
      final response =
          await put('${mainApi}teacher/notification', _data, headers: _headers);
      if (response.statusCode == 401) {
        Logger().i("redirect");
        Auth().redirect();
      } else if (!response.body["error"]) {
        print(response);
        Get.put(NotificationProviderIntimation()).editReadMap(_id);
      }
    } catch (e) {
      Logger().i("error");
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }
}
