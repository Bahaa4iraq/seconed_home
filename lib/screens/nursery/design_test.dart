// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:secondhome2/screens/nursery/nursery_home.dart';
// import 'package:secondhome2/static_files/my_color.dart';
// import 'package:storybook_flutter/storybook_flutter.dart';
// import 'package:secondhome2/static_files/my_translations.dart';
//
// import '../../firebase_options.dart';
// import '../../init_data.dart';
// import '../../provider/auth_provider.dart';
// import '../../static_files/my_firebase_notification.dart';
// import '../../static_files/my_url.dart';
// import 'dashboard_student/dashboard.dart';
//
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   receivedMessages(message);
// }
// void main()async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   await init();
//   final user = {
//     'token':
//         'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdHVkZW50RGF0YSI6eyJfaWQiOiI2MmZlMGEzNTM5NjU5ZDk5NzkxNjgyODIiLCJhY2NvdW50X3NjaG9vbCI6IjYyMTY5MzM0ZTUzOWQ3MDE4ODNlOTAxNiIsImFjY291bnRfdHlwZSI6InN0dWRlbnQiLCJhdXRoX3Bob25lX2lkIjoiZWFiY2Q3MzU2YTFjOWY4MyJ9LCJpYXQiOjE2OTIwNDU5NjZ9.w37sGcqcCSdntZc86SpSKci6U1MYZrGDMkIl8x4uVno',
//     '_id': '62fe0a3539659d9979168282',
//     'account_name': ' ليليان احمد كاظم',
//     'account_mobile': 07820202098,
//     'account_type': 'student',
//     'account_email': 'lilian@lamassu.com',
//     'account_birthday': '2016-08-20T00:00:00.000Z',
//     'account_address': ' المنصور'
//   };
//   final box = GetStorage();
//   Map? userData = box.read('_userData');
//
//   socketURL = socketURLSchool;
//   Get.put(TokenProvider()).addToken(userData);
//   runApp(GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       translations: TranslationsItems(),
//       defaultTransition: Transition.fade,
//       fallbackLocale: const Locale('ar', 'IQ'),
//       locale: const Locale('ar', 'IQ'),
//       theme: ThemeData(
//         fontFamily: 'Almarai',
//         scaffoldBackgroundColor: MyColor.white2,
//         primarySwatch: MyColor().pinkMaterial,
//         tabBarTheme: const TabBarTheme(
//           labelStyle: TextStyle(fontFamily: 'Almarai'),
//           unselectedLabelStyle: TextStyle(fontFamily: 'Almarai'),
//         ),
//       ),
//       builder: EasyLoading.init(
//         builder: (context, child) {
//           return MediaQuery(
//             data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
//             child: child!,
//           );
//         },
//       ),
//       home: Builder(builder: (context) {
//         return Storybook(
//           initialStory: 'Screen/s',
//           stories: [ Story(
//             name: 'Screen/s',
//
//             builder:(c) => HomePageStudent(
//               userData: user,
//             ),
//           )],
//         );
//       })));
// }
