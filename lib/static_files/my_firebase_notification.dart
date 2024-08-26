import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api_connection/student/api_dashboard_data.dart';
import '../provider/auth_provider.dart';
import '../screens/auth/login_page.dart';
import '../screens/nursery/dashboard_nursery/notification_all.dart' as nursery;
import '../screens/nursery/dashboard_nursery/chothes.dart' as nursery;
import '../screens/nursery/dashboard_nursery/nappy.dart' as nursery;
import '../screens/nursery/dashboard_nursery/food.dart' as nursery;
import '../screens/nursery/dashboard_nursery/training.dart' as nursery;
import '../screens/nursery/dashboard_nursery/sleep.dart' as nursery;
import '../screens/nursery/dashboard_nursery/nursery_salary/nursery_salary.dart'
    as nursery;
import '../screens/nursery/dashboard_nursery/weekly_schedule.dart' as nursery;
import '../screens/student/dashboard_student/notification_all.dart' as student;
import '../screens/student/dashboard_student/student_salary/student_salary.dart'
    as student;
import '../screens/student/dashboard_student/weekly_schedule.dart' as student;
import '../screens/kindergarten_teacher/pages/notifications/notification_all.dart'
    as teacherKindergartion;
import '../screens/kindergarten_teacher/pages/teacher_salary/teacher_salary.dart'
    as teacherKindergartion;
import '../screens/nursery_teacher/pages/teacher_salary/teacher_salary.dart'
    as teacherNursery;
import '../screens/nursery_teacher/pages/notifications/notification_all.dart'
    as teacherNursery;
import '../screens/kindergarten_teacher/pages/teacher_weekly_schedule.dart'
    as teacherKindergartion;
import '../screens/nursery_teacher/pages/teacher_weekly_schedule.dart'
    as teacherNursery;

class NotificationFirebase {
  initializeCloudMessage() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await messaging.subscribeToTopic('test');
    print('Subscribed to test topic');

    String? schoolId = prefs.getString('school_id');
    print(schoolId);
    try {
      await messaging.subscribeToTopic('school_$schoolId');
    } catch (e) {
      print(e);
    }
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    // NotificationSettings? settings;
    // if (Platform.isIOS) {
    //   settings = await messaging.requestPermission(
    //     alert: true,
    //     announcement: false,
    //     badge: true,
    //     carPlay: false,
    //     criticalAlert: false,
    //     provisional: false,
    //     sound: true,
    //   );
    // } else {
    //   settings = await messaging.requestPermission(
    //     alert: true,
    //     announcement: false,
    //     badge: true,
    //     carPlay: false,
    //     criticalAlert: false,
    //     provisional: false,
    //     sound: true,
    //   );
    // }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(message.notification!.body);
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }

      receivedMessages(message);
    });
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print('Got a message whilst in the foreground!');
    //   print('onMessage: ${message.data}');
    //
    //   if (message.notification != null) {
    //     print('Message also contained a notification: ${message.notification}');
    //   }
    //
    // });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      receivedMessages(message);
    });
  }
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  importance: Importance.max,
);

receivedMessages(RemoteMessage message) {
  final box = GetStorage();
  Map? userData = box.read('_userData');
  if (userData != null) {
    Get.put(TokenProvider()).addToken(userData);
  }

  Logger().i(message.messageType);
  Logger().i(message.category);
  Logger().i(message.notification?.title);
  if (userData == null) {
    return const LoginPage();
  } else if (userData["account_type"] == "student") {
    if (message.data['type'] == 'news') {
      DashboardDataAPI().latestNews(); //update news
    }
    if (userData["is_kindergarten"]) {
      _redirectToStudentScreens(message, userData);
    } else {
      _redirectToNurseryScreens(message, userData);
    }
  } else if (userData["account_type"] == "driver") {
  } else if (userData["account_type"] == "teacher") {
    if (userData["is_kindergarten"]) {
      if (message.data['type'] == 'schedule') {
        Get.to(() => const teacherKindergartion.TeacherWeeklySchedule());
      } else if (message.data['type'] == 'notification') {
        Get.to(() =>
            teacherKindergartion.NotificationTeacherAll(userData: userData));
      } else if (message.data['type'] == 'installments') {
        Get.to(() => const teacherKindergartion.TeacherSalary());
      }
    } else {
      if (message.data['type'] == 'schedule') {
        Get.to(() => const teacherNursery.TeacherWeeklySchedule());
      } else if (message.data['type'] == 'notification') {
        Get.to(() => teacherNursery.NotificationTeacherAll(userData: userData));
      } else if (message.data['type'] == 'installments') {
        Get.to(() => const teacherNursery.TeacherSalary());
      }
    }
  } else {
    return const LoginPage();
  }
}

_redirectToNurseryScreens(
    RemoteMessage message, Map<dynamic, dynamic> userData) {
  if (message.data['type'] == 'schedule') {
    Get.to(() => const nursery.WeeklySchedule());
  } else if (message.data['type'] == 'installments') {
    Get.to(() => const nursery.StudentSalary());
  } else if (message.data['type'] == 'news') {
  } else {
    switch (message.notification?.title) {
      case 'ملابس':
        {
          Get.to(() => const nursery.Clothes());
          break;
        }
      case 'الحفاض':
        {
          Get.to(() => const nursery.Nappy());
          break;
        }
      case 'تدريب':
        {
          Get.to(() => const nursery.Training());
          break;
        }
      case 'غذاء':
        {
          Get.to(() => const nursery.Food());
          break;
        }
      case 'غفوة':
        {
          Get.to(() => const nursery.Sleep());
          break;
        }
      default:
        {
          Get.to(() => nursery.NotificationAll(userData: userData));
          break;
        }
    }
  }
}

_redirectToStudentScreens(
    RemoteMessage message, Map<dynamic, dynamic> userData) {
  if (message.data['type'] == 'schedule') {
    Get.to(() => const student.WeeklySchedule());
  } else if (message.data['type'] == 'installments') {
    Get.to(() => const student.StudentSalary());
  } else if (message.data['type'] == 'notification') {
    Get.to(() => student.NotificationAll(userData: userData));
  }
}
