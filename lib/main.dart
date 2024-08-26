import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'init_data.dart';
import 'provider/auth_provider.dart';
import 'screens/auth/login_page.dart';
import 'screens/nursery/nursery_home.dart';
import 'screens/nursery_teacher/teacher_nursery_home.dart';
import 'screens/student/home_page_student.dart';
import 'screens/kindergarten_teacher/teacher_kindergarten_home.dart';
import 'static_files/my_color.dart';
import 'static_files/my_firebase_notification.dart' show receivedMessages;
import 'static_files/my_translations.dart';

//parse
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  receivedMessages(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(seconds: 1));
  FlutterNativeSplash.remove();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translations: TranslationsItems(),
        defaultTransition: Transition.fade,
        fallbackLocale: const Locale('ar', 'IQ'),
        locale: const Locale('ar', 'IQ'),
        theme: ThemeData(
          fontFamily: 'Almarai',
          scaffoldBackgroundColor: MyColor.white0,
          tabBarTheme: const TabBarTheme(
            labelStyle: TextStyle(fontFamily: 'Almarai'),
            unselectedLabelStyle: TextStyle(fontFamily: 'Almarai'),
          ),
        ),
        builder: EasyLoading.init(
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: child!,
            );
          },
        ),
        home: Builder(builder: (context) {
          return _redirectToPage();
        }));
  }
}

Widget _redirectToPage() {
  final box = GetStorage();
  Map? userData = box.read('_userData');
  Get.put(TokenProvider()).addToken(userData);
  if (userData == null) {
    return const LoginPage();
  } else if (userData["account_type"] == "student") {
    Get.put(TokenProvider()).addToken(userData);
    if (userData["is_kindergarten"]) {
      return HomePageStudent(userData: userData);
    } else {
      return HomePageNursery(userData: userData);
    }
  } else if (userData["account_type"] == "teacher") {
    Get.put(TokenProvider()).addToken(userData);
    if (userData["is_kindergarten"]) {
      return HomePageKindergartenTeacher(userData: userData);
    } else {
      return HomePageNurseryTeacher(userData: userData);
    }
  } else {
    return const LoginPage();
  }
}
