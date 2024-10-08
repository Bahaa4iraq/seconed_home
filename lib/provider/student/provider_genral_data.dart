import 'package:get/get.dart';


class SchoolsProvider extends GetxController {
  List? schools;
  bool isLoading = true;
  void addData(List list) {
    schools = list;
    update();
  }

  void changeLoading(bool isLoading) {
    isLoading = isLoading;
  }
}

class GovernorateProvider extends GetxController {
  List? governorate;
  bool isLoading = true;
  void addData(List list) {
    governorate = list;
    update();
  }

  void changeLoading(bool isLoading) {
    isLoading = isLoading;
  }
}

class ContactProvider extends GetxController {
  Map? contact;
  bool isLoading = true;
  String contentUrl = "";
  void addData(Map map) {
    contact = map;
    update();
  }

  void changeLoading(bool isLoading) {
    isLoading = isLoading;
  }

  void changeContentUrl(String contentUrl) {
    contentUrl = contentUrl;
  }
}

/// old data [-----start----]
class SubjectProvider extends GetxController {
  Map? subject;
  String contentUrl = "";
  void addToSubject(Map map) {
    subject = map;
    update();
  }

  void changeContentUrl(String contentUrl) {
    contentUrl = contentUrl;
  }

  void insertData(body) {}
}

class TeachersProvider extends GetxController {
  List? teachers;
  String contentUrl = "";
  void addToTeachers(List list) {
    teachers = list;
    update();
  }

  void changeContentUrl(String contentUrl) {
    contentUrl = contentUrl;
  }
}


/// old data [-----end----]
