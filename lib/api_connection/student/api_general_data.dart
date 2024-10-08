import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart' as dio;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../provider/auth_provider.dart';
import '../../provider/student/provider_genral_data.dart';
import '../../static_files/my_color.dart';
import '../../static_files/my_url.dart';

class GeneralData extends GetConnect {


  getSchools() async {
    try {
      final response = await get('${mainApi}schools');
      if (!response.body['error']) {
        Get.put(SchoolsProvider()).changeLoading(false);
        Get.put(SchoolsProvider()).addData(response.body['results']);
        return response.body['results'];
      } else {
        return false;
      }
    } catch (e) {
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }

  getGovernorate() async {
    try {
      final response = await get('${mainApi}governorate');
      if (!response.body['error']) {
        Get.put(SchoolsProvider()).changeLoading(false);
        Get.put(SchoolsProvider()).addData(response.body['results']);
        return response.body['results'];
      } else {
        return false;
      }
    } catch (e) {
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }

  getContact() async {
    final Map? dataProvider = Get.put(TokenProvider()).userData;
    try {
      Map<String, String> _headers = {"Authorization": dataProvider!['token']};
      final response = await get(mainApi + 'schools/getOneSchool',headers: _headers );
      print(response);
      if (!response.body['error']) {
        Get.put(ContactProvider()).changeLoading(false);
        Get.put(ContactProvider()).changeContentUrl(response.body['content_url']);
        Get.put(ContactProvider()).addData(response.body['results']);
      } else {
        return false;
      }
    } catch (e) {
      Logger().i("error");
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }


  joinUsSchool(Map data) async {
    try {
      final response = await post('${mainApi}student/register/school', data);
      return response.body;
    } catch (e) {
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }

  joinUsKindergarten(Map data) async {
    try {
      final response = await post('${mainApi}student/register', data);
      return response.body;
    } catch (e) {
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }

  hireRequest(dio.FormData _data) async {
    try {
      final response = await dio.Dio().post(
        mainApi + 'hireRequest', data: _data,
        onSendProgress: (int sent, int total) {
          EasyLoading.showProgress(sent / total, status: "جار الرفع...");
          if (sent == total) {
            EasyLoading.instance.userInteractions = true;
            EasyLoading.showSuccess("تم الرفع بنجاح", dismissOnTap: true);
            Timer(const Duration(seconds: 2), () {
              EasyLoading.dismiss();
            });
          }
        },
        // uploadProgress: (progress) {
        //   double _newProgress = double.parse(progress.toStringAsFixed(1));
        //   EasyLoading.showProgress(_newProgress / 100, status: "جار الرفع...");
        //   if (_newProgress == 100.0) {
        //     EasyLoading.instance.userInteractions = true;
        //     EasyLoading.showSuccess("تم الرفع بنجاح", dismissOnTap: true);
        //     Timer(const Duration(seconds: 2), () {
        //       EasyLoading.dismiss();
        //     });
        //   }
        // }
      );
      print(response.data);
      if (response.data['error']) {
        EasyLoading.show(status: response.data['message'], dismissOnTap: true);
        return {"error": true};
      } else {
        return response.data;
      }
    } catch (e) {
      Logger().i("error");
      log(e.toString());
      Get.snackbar("خطأ", 'الرجاء التاكد من اتصالك في الانترنت',
          colorText: MyColor.white0, backgroundColor: MyColor.red);
    }
  }


// getSubject(String _subjectName) async {
  //   Map _data = {
  //     "className" : _subjectName
  //   };
  //   try {
  //     final response = await post(MyUrl().apiUrl + 'classes/subject',_data);
  //     if (!response.body['error']) {
  //       Get.put(SubjectProvider()).changeContentUrl(response.body['content_url']);
  //       Get.put(SubjectProvider()).addToSubject(response.body['results']);
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     Get.snackbar("خطأ".tr, 'الرجاء التاكد من اتصالك في الانترنت', colorText: MyColor.white, backgroundColor: MyColor.red);
  //   }
  // }
  //
  // getTeachers(Map _data) async {
  //   try {
  //     final response = await post(MyUrl().apiUrl + 'getTeachersBySubject',_data);
  //     if (!response.body['error']) {
  //       Get.put(TeachersProvider()).changeContentUrl(response.body['content_url']);
  //       Get.put(TeachersProvider()).addToTeachers(response.body['results']);
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     Get.snackbar("خطأ".tr, 'الرجاء التاكد من اتصالك في الانترنت', colorText: MyColor.white, backgroundColor: MyColor.red);
  //   }
  // }
}
