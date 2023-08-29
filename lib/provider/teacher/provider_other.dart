import 'package:get/get.dart';

class OtherProvider extends GetxController {
  List studentList = [];

  void addToList(_userList) {
    studentList = _userList;
    update();
  }
}