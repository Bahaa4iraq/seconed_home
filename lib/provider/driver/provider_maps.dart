import 'package:get/get.dart';

class MapDataProvider extends GetxController{
  Map newsData = {};
  bool isLocationServiceEnabled = false;
  bool permission =false;
  void addData(Map _newsData) {
    newsData = _newsData;
    update();
  }
  void serviceLocation(bool _isLocationServiceEnabled){
    isLocationServiceEnabled = _isLocationServiceEnabled;
    update();
  }
  void permissionLocation(bool _isPermissionEnabled){
    permission = _isPermissionEnabled;
    update();
  }
}

