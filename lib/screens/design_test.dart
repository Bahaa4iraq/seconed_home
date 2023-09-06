import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:secondhome2/screens/student/home_page_student.dart';
import 'package:secondhome2/static_files/my_color.dart';
import 'package:secondhome2/static_files/my_translations.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

import '../../firebase_options.dart';
import '../../init_data.dart';
import '../../provider/auth_provider.dart';
import '../../static_files/my_firebase_notification.dart';
import '../../static_files/my_url.dart';
import 'student/dashboard_student/notification_all.dart' as s;
import 'nursery/dashboard_nursery/notification_all.dart' as n;
import 'nursery_teacher/pages/notifications/notification_all.dart' as nt;
import 'kindergarten_teacher/pages/notifications/notification_all.dart' as st;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  receivedMessages(message);
}
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await init();
  final user = {
    'token':
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdHVkZW50RGF0YSI6eyJfaWQiOiI2NGUxZThlODZhZGQ3NWQ1ZDY3ZGEyODYiLCJhY2NvdW50X3NjaG9vbCI6IjY0ZDEzYWU5NjVjYTVkYmZiOGJiZjc0MCIsImFjY291bnRfdHlwZSI6InRlYWNoZXIifSwiaWF0IjoxNjk0MDE2MzkxfQ.l8xYNdcd_CF4kXAwUvgbAHpO9JP9E__RN-Gt7jl_1Ls',
    '_id': '62fe0a3539659d9979168282',
    'account_name': 'teacher kinder',
    'account_mobile': 07820202098,
    'account_type': 'teacher',
    'account_email': 'teacher2@secondhome.com',
    'account_birthday': '2016-08-20T00:00:00.000Z',
    'account_address': ' المنصور',
    "is_kindergarten": false
  };
  final box = GetStorage();
  Map? userData = box.read('_userData');

  socketURL = socketURLKindergarten;
  Get.put(TokenProvider()).addToken(userData);
  runApp(GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: TranslationsItems(),
      defaultTransition: Transition.fade,
      fallbackLocale: const Locale('ar', 'IQ'),
      locale: const Locale('ar', 'IQ'),
      theme: ThemeData(
        fontFamily: 'Almarai',
        scaffoldBackgroundColor: MyColor.white2,
        primarySwatch: MyColor().turquoiseMaterial,
        tabBarTheme: const TabBarTheme(
          labelStyle: TextStyle(fontFamily: 'Almarai'),
          unselectedLabelStyle: TextStyle(fontFamily: 'Almarai'),
        ),
      ),
      builder: EasyLoading.init(
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
      ),
      home: Builder(builder: (context) {
        return Storybook(
          initialStory: 'Screen/o',
          stories: [
            Story(
            name: 'Screen/o',
            builder:(c) => HomePageStudent(
              userData: user,
            ),
          ) ,Story(
            name: 'Screen/s',
            builder:(c) => s.NotificationAll(
              userData: user,
            ),
          ),Story(
            name: 'Screen/n',
            builder:(c) => n.NotificationAll(
              userData: user,
            ),
          ),Story(
            name: 'Screen/nt',
            builder:(c) => nt.NotificationTeacherAll(
              userData: user,
            ),
          ),Story(
            name: 'Screen/st',
            builder:(c) => st.NotificationTeacherAll(
              userData: user,
            ),
          ),],
        );
      })));
}