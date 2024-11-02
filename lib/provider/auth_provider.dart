import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:secondhome2/local_database/sql_database.dart';

// class Auth extends GetxController{
//
// }
class TokenProvider extends GetxController {
  Map? userData;
  void addToken(userDataR) {
    userData = userDataR;
    update();
  }

  void removeToken() {
    userData = null;
  }

  addAccountToDatabase(Map<String, dynamic> account) async {
    await SqlDatabase.db.insertAccountAsMap(account);
  }
}

class MainDataGetProvider extends GetxController {
  Map mainData = {};
  addData(Map userDataR) async {
    mainData = userDataR;

    update();
  }

  void changeType(String comingType) {
    GetStorage box = GetStorage();
    box.write('type', comingType);
  }

  String contentUrl = "";
  void changeContentUrl(String contentUrlR) {
    contentUrl = contentUrlR;
  }
}

class AreasProvider extends GetxController {
  List areas = [];
  void addData(List data) {
    areas = data;
    update();
  }
}
