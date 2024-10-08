//const String mainApi = "https://api.lm-uat.com/api/mobile/";
// const String socketURL = "https://api.lm-uat.com/";

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:secondhome2/provider/auth_provider.dart';

const String socketURLKindergarten = "https://api.lm-kids.com/";

String kinderURL = "https://api.lm-kids.com/api/mobile/";

String mainApi = kinderURL;
String socketURL = socketURLKindergarten;

followTopics() async {
  String id =
      Get.put(MainDataGetProvider()).mainData['account']['school']['_id'];
  String type = '';
  GetStorage box = GetStorage();
  type = box.read('type');

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.subscribeToTopic('school_$id');
  if (type == 'student') {
    await messaging.subscribeToTopic('all_students_$id');
    await messaging.unsubscribeFromTopic('all_teachers_$id');
    await messaging.unsubscribeFromTopic('all_drivers_$id');
    await messaging.unsubscribeFromTopic('all_receptions_$id');
  } else if (type == 'teacher') {
    await messaging.subscribeToTopic('all_teachers_$id');
    await messaging.unsubscribeFromTopic('all_students_$id');
    await messaging.unsubscribeFromTopic('all_drivers_$id');
    await messaging.unsubscribeFromTopic('all_receptions_$id');
  } else if (type == 'driver') {
    await messaging.subscribeToTopic('all_drivers_$id');
    await messaging.unsubscribeFromTopic('all_students_$id');
    await messaging.unsubscribeFromTopic('all_teachers_$id');
    await messaging.unsubscribeFromTopic('all_receptions_$id');
  } else if (type == 'reception') {
    await messaging.subscribeToTopic('all_receptions_$id');
    await messaging.unsubscribeFromTopic('all_students_$id');
    await messaging.unsubscribeFromTopic('all_teachers_$id');
    await messaging.unsubscribeFromTopic('all_drivers_$id');
  }
}
