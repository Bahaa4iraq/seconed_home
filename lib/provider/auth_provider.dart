import 'package:get/get.dart';

// class Auth extends GetxController{
//
// }
class TokenProvider extends GetxController {
  Map? userData;
  void addToken(userData) {
    this.userData = userData;
    update();
  }

  void removeToken() {
    userData = null;
  }
}

class MainDataGetProvider extends GetxController {
  Map mainData = {};
  void addData(Map userData) {
    mainData = userData;
    update();
  }

  String contentUrl = "";
  void changeContentUrl(String contentUrl) {
    this.contentUrl = contentUrl;
  }
}

class AreasProvider extends GetxController {
  List areas = [];
  void addData(List data) {
    areas = data;
    update();
  }
}