import 'dart:convert';
import 'dart:io';

import 'package:secondhome2/screens/gard/gard_home.dart';
import 'package:secondhome2/screens/kindergarten_teacher/teacher_kindergarten_home.dart';
import 'package:secondhome2/screens/nursery/nursery_home.dart';
import 'package:secondhome2/screens/nursery_teacher/teacher_nursery_home.dart';
import 'package:secondhome2/screens/student/home_page_student.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:secondhome2/provider/auth_provider.dart';
import 'package:secondhome2/screens/auth/login_page.dart';

import 'package:secondhome2/static_files/my_color.dart';
import 'package:open_file/open_file.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class CheckUpdateController extends GetConnect {
  String link =
      'https://api.lm-uat.com/api/mobile/app_versions/روضة سكند هوم الأهلية';
//    روضة سكند هوم الأهلية
  checkForNewVersion() async {
    try {
      final response = await http.get(Uri.parse(link));
      // print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        final latestVersion = data['results']['version'];
        final currentVersion = await getCurrentVersion();

        bool isNewVersionAvailable = latestVersion != currentVersion;

        EasyLoading.dismiss();

        if (isNewVersionAvailable) {
          EasyLoading.show(status: "تنزيل التحديث...");
          String url = data['results']['url'];

          final filePath =
              await downloadNewVersion("https://api.lm-uat.com/$url");
          EasyLoading.dismiss();

          await installNewVersion(filePath);
        } else {
          redirectToPage();
          Get.snackbar("نجاح", "تم التحديث الى اخر اصدار",
              colorText: MyColor.white0, backgroundColor: MyColor.green);
        }
        return;
      }
      return false;
    } catch (e) {
      EasyLoading.dismiss();
      redirectToPage();
    }
  }

  redirectToPage() {
    final box = GetStorage();
    Map? userData = box.read('_userData');
    Get.put(TokenProvider()).addToken(userData);
    if (userData == null) {
      Get.offAll(() => const LoginPage());
    } else if (userData["account_type"] == "student") {
      Get.put(TokenProvider()).addToken(userData);
      if (userData["is_kindergarten"]) {
        Get.offAll(() => HomePageStudent(userData: userData));
      } else {
        Get.offAll(() => HomePageNursery(userData: userData));
      }
    } else if (userData["account_type"] == "teacher") {
      Get.put(TokenProvider()).addToken(userData);
      if (userData["is_kindergarten"]) {
        Get.offAll(() => HomePageKindergartenTeacher(userData: userData));
      } else {
        Get.offAll(() => HomePageNurseryTeacher(userData: userData));
      }
    } else if (userData["account_type"] == "gard") {
      Get.offAll(() => GardHome(userData: userData));
    } else {
      Get.offAll(() => const LoginPage());
    }
  }

  void checkAndUpdateApp() async {
    if (Platform.isAndroid) {
      EasyLoading.show(status: "التحقق من التحديث...");
      await checkForNewVersion();
    } else {
      redirectToPage();
    }
  }

  Future<String> getCurrentVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();

    return packageInfo.version;
  }

  Future<String> downloadNewVersion(String url) async {
    final directory = await getExternalStorageDirectory();
    final filePath = '${directory?.path}/new_version.apk';
    final response = await http.get(Uri.parse(url));
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future<void> requestInstallPackagesPermission() async {
    if (await Permission.requestInstallPackages.isDenied) {
      await Permission.requestInstallPackages.request();
    }
  }

  Future<void> installNewVersion(String filePath) async {
    await requestInstallPackagesPermission();

    try {
      await OpenFile.open(filePath);
    } catch (e) {}
  }
}
