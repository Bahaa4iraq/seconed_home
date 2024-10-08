import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:secondhome2/api_connection/auth_connection.dart';
import 'package:secondhome2/provider/accounts_provider.dart';
import 'package:secondhome2/screens/auth/login_page.dart';
import 'package:secondhome2/screens/gard/enter_student.dart';
import 'package:secondhome2/screens/gard/gard_controller.dart';
import 'package:secondhome2/screens/gard/report_gard_screen.dart';
import 'package:secondhome2/static_files/my_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GardHome extends StatefulWidget {
  const GardHome({super.key, required this.userData});
  final Map userData;

  @override
  State<GardHome> createState() => _GardHomeState();
}

class _GardHomeState extends State<GardHome> {
  final AccountProvider accountProvider = Get.put(AccountProvider());
  GardController controller = Get.put(GardController());
  followTopics() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? schoolId = prefs.getString('school_id');
    await messaging.subscribeToTopic('school_$schoolId');
  }

  @override
  void initState() {
    followTopics();
    controller.getStudentNames();
    controller.getStudentReport();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'الصفحة الرئيسية',
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: MyColor.turquoise2,
              centerTitle: true,
              bottom: const TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: MyColor.grayDark,
                  indicatorColor: MyColor.grayDark,
                  tabs: [
                    Tab(
                      text: 'الطلاب',
                    ),
                    Tab(
                      text: 'التقارير',
                    ),
                  ]),
              actions: [
                IconButton(
                    onPressed: () {
                      controller.getStudentNames();
                      controller.getStudentReport();
                    },
                    icon: const Icon(Icons.refresh))
              ],
              leading: IconButton(
                  onPressed: () {
                    Get.defaultDialog(
                      title: "تسجيل خروج",
                      content: const Text(
                        "هل انت متأكد من عملية تسجيل الخروج؟",
                      ),
                      cancel: MaterialButton(
                        color: MyColor.turquoise,
                        onPressed: () => Get.back(),
                        child: const Text(
                          "الغاء",
                          style: TextStyle(color: MyColor.white0),
                        ),
                      ),
                      confirm: MaterialButton(
                        color: MyColor.turquoise,
                        onPressed: () {
                          Auth().loginOut().then((res) async {
                            if (res['error'] == false) {
                              await accountProvider.deleteAccount(
                                  widget.userData['account_email']);
                              Get.offAll(() => const LoginPage());
                              EasyLoading.showSuccess(
                                  res['message'].toString());
                            } else {
                              EasyLoading.showError(res['message'].toString());
                            }
                          });
                        },
                        child: const Text(
                          "تأكيد",
                          style: TextStyle(color: MyColor.white0),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  )),
            ),
            body: const TabBarView(children: [
              EnterStudent(),
              ReportGardScreen(),
            ])),
      ),
    );
  }
}
