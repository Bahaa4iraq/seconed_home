import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:secondhome2/api_connection/auth_connection.dart';
import 'package:secondhome2/provider/auth_provider.dart';
import 'package:secondhome2/screens/gard/student_model.dart';
import 'package:secondhome2/static_files/my_url.dart';

class GardController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool error = false.obs;
  RxList<StudentGardModel> studentList = <StudentGardModel>[].obs;
  final Map? dataProvider = Get.put(TokenProvider()).userData;

  Future getStudentNames() async {
    try {
      isLoading.value = true;
      Map<String, String> headers = {"Authorization": dataProvider?['token']};

      var response = await http.get(
          Uri.parse('$mainApi/guard/absence_registry/students'),
          headers: headers);
      if (response.statusCode == 200) {
        studentList.clear();
        var data = jsonDecode(response.body);
        for (var item in data['results']['data']) {
          studentList.add(StudentGardModel.fromJson(item));
        }
        isLoading.value = false;
      } else if (response.statusCode == 401) {
        Auth().redirect();
      } else {
        isLoading.value = false;
        error.value = true;
      }
    } catch (e) {
      isLoading.value = false;
      error.value = true;
      print(e);
    }
  }

  Future editStudentStatus(String studentId, String type) async {
    try {
      isLoading.value = true;
      Map data = {'student_id': studentId, 'type': type};
      Map<String, String> headers = {"Authorization": dataProvider?['token']};
      var response = await http.post(
          Uri.parse('$mainApi/guard/absence_registry'),
          headers: headers,
          body: data);
      if (response.statusCode == 200) {
        getStudentNames();
      } else if (response.statusCode == 401) {
        Auth().redirect();
      } else {
        isLoading.value = false;
        error.value = true;
      }
    } catch (e) {
      isLoading.value = false;
      error.value = true;
      print(e);
    }
  }
}
