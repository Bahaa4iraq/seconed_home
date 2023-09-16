import 'package:get/get.dart';
import 'package:secondhome2/local_database/sql_database.dart';

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

  addAccountToDatabase(Map<String,dynamic> account) async {
    await SqlDatabase.db.insertAccountAsMap(account);
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