import 'dart:async';

import 'package:dio/dio.dart' as dio;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../provider/auth_provider.dart';
import '../../provider/student/provider_notification.dart';
import '../../static_files/my_color.dart';
import '../../static_files/my_url.dart';
import '../auth_connection.dart';

class NotificationsAPI extends GetConnect {
  final Map? dataProvider = Get.put(TokenProvider()).userData;

  final ClothesNotificationProvider _notificationProviderClothes =
      Get.put(ClothesNotificationProvider());

  final TrainingNotificationProvider _notificationProviderTraining =
      Get.put(TrainingNotificationProvider());

  final SleepNotificationProvider _notificationProviderSleep =
      Get.put(SleepNotificationProvider());
  final NappyNotificationProvider _notificationProviderNappy =
      Get.put(NappyNotificationProvider());

  final FoodNotificationProvider _notificationProviderFood =
      Get.put(FoodNotificationProvider());

  final NotificationProviderE _notificationProviderE =
      Get.put(NotificationProviderE());
  final NotificationProviderHomeWork _notificationProviderHomeWork =
      Get.put(NotificationProviderHomeWork());

  final MonthlyMessageNotificationProvider _notificationProviderMonthlyMessage =
      Get.put(MonthlyMessageNotificationProvider());

  getNotifications(Map data) async {
    Map<String, String> headers = {"Authorization": dataProvider!['token']};
    try {
      final response =
          await post('${mainApi}student/notification', data, headers: headers);
      if (response.statusCode == 401) {
        Auth().redirect();
      } else if (!response.body["error"]) {
        Get.put(NotificationProvider()).changeLoading(false);
        Get.put(NotificationProvider())
            .changeContentUrl(response.body['content_url']);
        Get.put(NotificationProvider()).changeCount(
            response.body['results']['count_all'],
            response.body['results']['count_read'],
            response.body['results']['count_unread']);
        Get.put(NotificationProvider())
            .insertData(response.body['results']['data']);
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

  getNotificationsE(Map data) async {
    Map<String, String> headers = {"Authorization": dataProvider!['token']};
    try {
      final response =
          await post('${mainApi}student/notification', data, headers: headers);
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
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }

  getNotificationsHomework(Map data) async {
    Map<String, String> headers = {"Authorization": dataProvider!['token']};
    try {
      final response =
          await post('${mainApi}student/notification', data, headers: headers);
      if (response.statusCode == 401) {
        Auth().redirect();
        //NotificationProviderE
      } else if (!response.body["error"]) {
        _notificationProviderHomeWork.changeLoading(false);
        _notificationProviderHomeWork
            .changeContentUrl(response.body['content_url']);
        _notificationProviderHomeWork.changeCount(
            response.body['results']['count_all'],
            response.body['results']['count_read'],
            response.body['results']['count_unread']);
        _notificationProviderHomeWork
            .insertData(response.body['results']['data']);
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

  updateReadNotifications(String id) async {
    Map data = {"notification_id": id};
    Map<String, String> headers = {"Authorization": dataProvider!['token']};
    try {
      final response =
          await put('${mainApi}student/notification', data, headers: headers);
      if (response.statusCode == 401) {
        Auth().redirect();
      } else if (!response.body["error"]) {
        print(response);
        Get.put(NotificationProvider()).editReadMap(id);
      }
    } catch (e) {
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }

  updateReadHomework(String id) async {
    Map data = {"notification_id": id};
    Map<String, String> headers = {"Authorization": dataProvider!['token']};
    try {
      final response =
          await put('${mainApi}student/notification', data, headers: headers);
      if (response.statusCode == 401) {
        Auth().redirect();
      } else if (!response.body["error"]) {
        print(response);
        Get.put(NotificationProviderHomeWork()).editReadMap(id);
      }
    } catch (e) {
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }

  updateReadNotificationsE(String id) async {
    Map data = {"notification_id": id};
    Map<String, String> headers = {"Authorization": dataProvider!['token']};
    try {
      final response =
          await put('${mainApi}student/notification', data, headers: headers);
      if (response.statusCode == 401) {
        Auth().redirect();
      } else if (!response.body["error"]) {
        print(response);
        Get.put(NotificationProviderE()).editReadMap(id);
      }
    } catch (e) {
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }

  homeworkAnswer(dio.FormData data) async {
    Map<String, String> headers = {"Authorization": dataProvider!['token']};
    try {
      final response = await dio.Dio().post(
        '${mainApi}student/homeworkAnswers',
        data: data,
        options: dio.Options(headers: headers),
        onSendProgress: (int sent, int total) {
          EasyLoading.showProgress(sent / total, status: "جار الرفع...");
          if (sent == total) {
            EasyLoading.instance.userInteractions = true;
            EasyLoading.showSuccess("تم الرفع بنجاح", dismissOnTap: true);
            Timer(const Duration(seconds: 1), () {});
          }
        },
      );
      if (response.data['error']) {
        EasyLoading.showError(response.data['message'],
            dismissOnTap: true, duration: const Duration(seconds: 5));
        return response.data;
      } else {
        return response.data;
      }
    } catch (e) {
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
    try {
      await post('${mainApi}student/homeworkAnswers', data, headers: headers);
    } catch (e) {
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }

  getNotificationsMonthlyMessage(Map data) async {
    Map<String, String> headers = {"Authorization": dataProvider!['token']};
    try {
      final response =
          await post('${mainApi}student/notification', data, headers: headers);
      if (response.statusCode == 401) {
        Auth().redirect();
        //NotificationProviderE
      } else if (!response.body["error"]) {
        _notificationProviderMonthlyMessage.changeLoading(false);
        _notificationProviderMonthlyMessage
            .changeContentUrl(response.body['content_url']);
        _notificationProviderMonthlyMessage.changeCount(
            response.body['results']['count_all'],
            response.body['results']['count_read'],
            response.body['results']['count_unread']);
        _notificationProviderMonthlyMessage
            .insertData(response.body['results']['data']);
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

  updateReadMonthlyMessage(String id) async {
    Map data = {"notification_id": id};
    Map<String, String> headers = {"Authorization": dataProvider!['token']};
    try {
      final response =
          await put('${mainApi}student/notification', data, headers: headers);
      if (response.statusCode == 401) {
        Auth().redirect();
      } else if (!response.body["error"]) {
        print(response);
        Get.put(MonthlyMessageNotificationProvider()).editReadMap(id);
      }
    } catch (e) {
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }

  getNotificationsClothes(Map data) async {
    Map<String, String> headers = {"Authorization": dataProvider!['token']};
    try {
      final response =
          await post('${mainApi}student/notification', data, headers: headers);
      if (response.statusCode == 401) {
        Auth().redirect();
        //NotificationProviderE
      } else if (!response.body["error"]) {
        _notificationProviderClothes.changeLoading(false);
        _notificationProviderClothes
            .changeContentUrl(response.body['content_url']);
        _notificationProviderClothes.changeCount(
            response.body['results']['count_all'],
            response.body['results']['count_read'],
            response.body['results']['count_unread']);
        _notificationProviderClothes
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

  updateReadClothes(String id) async {
    Map data = {"notification_id": id};
    Map<String, String> headers = {"Authorization": dataProvider!['token']};
    try {
      final response =
          await put('${mainApi}student/notification', data, headers: headers);
      if (response.statusCode == 401) {
        Logger().i("redirect");
        Auth().redirect();
      } else if (!response.body["error"]) {
        print(response);
        Get.put(ClothesNotificationProvider()).editReadMap(id);
      }
    } catch (e) {
      Logger().i("error");
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }

  getNotificationsFood(Map data) async {
    Map<String, String> headers = {"Authorization": dataProvider!['token']};
    try {
      final response =
          await post('${mainApi}student/notification', data, headers: headers);
      if (response.statusCode == 401) {
        Auth().redirect();
        //NotificationProviderE
      } else if (!response.body["error"]) {
        _notificationProviderFood.changeLoading(false);
        _notificationProviderFood
            .changeContentUrl(response.body['content_url']);
        _notificationProviderFood.changeCount(
            response.body['results']['count_all'],
            response.body['results']['count_read'],
            response.body['results']['count_unread']);
        _notificationProviderFood.insertData(response.body['results']['data']);
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

  updateReadFood(String id) async {
    Map data = {"notification_id": id};
    Map<String, String> headers = {"Authorization": dataProvider!['token']};
    try {
      final response =
          await put('${mainApi}student/notification', data, headers: headers);
      if (response.statusCode == 401) {
        Logger().i("redirect");
        Auth().redirect();
      } else if (!response.body["error"]) {
        print(response);
        Get.put(FoodNotificationProvider()).editReadMap(id);
      }
    } catch (e) {
      Logger().i("error");
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }

  getNotificationsSleep(Map data) async {
    Map<String, String> headers = {"Authorization": dataProvider!['token']};
    try {
      final response =
          await post('${mainApi}student/notification', data, headers: headers);
      if (response.statusCode == 401) {
        Auth().redirect();
        //NotificationProviderE
      } else if (!response.body["error"]) {
        _notificationProviderSleep.changeLoading(false);
        _notificationProviderSleep
            .changeContentUrl(response.body['content_url']);
        _notificationProviderSleep.changeCount(
            response.body['results']['count_all'],
            response.body['results']['count_read'],
            response.body['results']['count_unread']);
        _notificationProviderSleep.insertData(response.body['results']['data']);
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

  updateReadSleep(String id) async {
    Map data = {"notification_id": id};
    Map<String, String> headers = {"Authorization": dataProvider!['token']};
    try {
      final response =
          await put('${mainApi}student/notification', data, headers: headers);
      if (response.statusCode == 401) {
        Logger().i("redirect");
        Auth().redirect();
      } else if (!response.body["error"]) {
        print(response);
        Get.put(SleepNotificationProvider()).editReadMap(id);
      }
    } catch (e) {
      Logger().i("error");
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }

  getNotificationsNappy(Map data) async {
    Map<String, String> headers = {"Authorization": dataProvider!['token']};
    try {
      final response =
          await post('${mainApi}student/notification', data, headers: headers);
      if (response.statusCode == 401) {
        Auth().redirect();
        //NotificationProviderE
      } else if (!response.body["error"]) {
        _notificationProviderNappy.changeLoading(false);
        _notificationProviderNappy
            .changeContentUrl(response.body['content_url']);
        _notificationProviderNappy.changeCount(
            response.body['results']['count_all'],
            response.body['results']['count_read'],
            response.body['results']['count_unread']);
        _notificationProviderNappy.insertData(response.body['results']['data']);
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

  updateReadNappy(String id) async {
    Map data = {"notification_id": id};
    Map<String, String> headers = {"Authorization": dataProvider!['token']};
    try {
      final response =
          await put('${mainApi}student/notification', data, headers: headers);
      if (response.statusCode == 401) {
        Logger().i("redirect");
        Auth().redirect();
      } else if (!response.body["error"]) {
        print(response);
        Get.put(NappyNotificationProvider()).editReadMap(id);
      }
    } catch (e) {
      Logger().i("error");
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }

  getNotificationsTraining(Map data) async {
    Map<String, String> headers = {"Authorization": dataProvider!['token']};
    try {
      final response =
          await post('${mainApi}student/notification', data, headers: headers);
      if (response.statusCode == 401) {
        Auth().redirect();
        //NotificationProviderE
      } else if (!response.body["error"]) {
        _notificationProviderTraining.changeLoading(false);
        _notificationProviderTraining
            .changeContentUrl(response.body['content_url']);
        _notificationProviderTraining.changeCount(
            response.body['results']['count_all'],
            response.body['results']['count_read'],
            response.body['results']['count_unread']);
        _notificationProviderTraining
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

  updateReadTraining(String id) async {
    Map data = {"notification_id": id};
    Map<String, String> headers = {"Authorization": dataProvider!['token']};
    try {
      final response =
          await put('${mainApi}student/notification', data, headers: headers);
      if (response.statusCode == 401) {
        Logger().i("redirect");
        Auth().redirect();
      } else if (!response.body["error"]) {
        print(response);
        Get.put(TrainingNotificationProvider()).editReadMap(id);
      }
    } catch (e) {
      Logger().i("error");
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }
}
