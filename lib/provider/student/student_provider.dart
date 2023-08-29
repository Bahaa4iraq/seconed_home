import 'package:get/get.dart';


class LatestNewsProvider extends GetxController {
  List newsData = [];
  void addData(List _newsData) {
    newsData = _newsData;
    update();
  }
  String contentUrl ="";
  void changeContentUrl(String _contentUrl) {
    contentUrl = _contentUrl;
  }
}
