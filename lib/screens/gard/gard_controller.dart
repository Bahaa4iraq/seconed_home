import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:secondhome2/api_connection/auth_connection.dart';
import 'package:secondhome2/provider/auth_provider.dart';
import 'package:secondhome2/screens/gard/static_model.dart';
import 'package:secondhome2/screens/gard/student_model.dart';
import 'package:secondhome2/static_files/my_url.dart';

class GardController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool error = false.obs;
  TextEditingController search = TextEditingController();
  StaticModel? staticModel;
  RxList<StudentGardModel> studentList = <StudentGardModel>[].obs;
  RxList<StudentGardModel> filterdStudentList = <StudentGardModel>[].obs;
  final Map? dataProvider = Get.put(TokenProvider()).userData;

  searchStudent(String value) {
    filterdStudentList.clear();
    if (value.isEmpty) {
      filterdStudentList.addAll(studentList);
    } else {
      for (var item in studentList) {
        if (item.accountName!.contains(value)) {
          filterdStudentList.add(item);
        }
      }
    }
  }

  Future getStudentNames(String token) async {
    try {
      isLoading.value = true;
      Map<String, String> headers = {"Authorization": token};

      var response = await http.get(
          Uri.parse('$mainApi/guard/absence_registry/students?limit=1000'),
          headers: headers);
      if (response.statusCode == 200) {
        studentList.clear();
        filterdStudentList.clear();
        var data = jsonDecode(response.body);
        for (var item in data['results']['data']) {
          studentList.add(StudentGardModel.fromJson(item));
        }
        filterdStudentList.addAll(studentList);
        isLoading.value = false;
      } else if (response.statusCode == 401) {
        print('401');
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

  Future editStudentStatus(String studentId, String type, String token) async {
    try {
      isLoading.value = true;
      Map data = {'student_id': studentId, 'type': type};
      Map<String, String> headers = {"Authorization": token};
      var response = await http.post(
          Uri.parse('$mainApi/guard/absence_registry'),
          headers: headers,
          body: data);
      if (response.statusCode == 200) {
        getStudentNames(token);
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

  Future getStudentReport(String token) async {
    try {
      isLoading.value = true;
      Map<String, String> headers = {"Authorization": token};

      var response = await http.get(
          Uri.parse('$mainApi/guard/absence_registry/statics'),
          headers: headers);
      if (response.statusCode == 200) {
        studentList.clear();
        filterdStudentList.clear();
        var data = jsonDecode(response.body);
        staticModel = StaticModel.fromJson(data['results']);
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
}
