import 'package:get/get.dart';

class NotificationDriverProvider extends GetxController {
  List data = [];
  bool? isRead;
  bool isLoading = true;
  String contentUrl = "";
  void insertData(_data) {
    data.addAll(_data);
    update();
  }

  void changeRead(_isRead) {
    isRead = _isRead;
    //update();
  }

  void editReadMap(String _id) {
    int _indexItem = data.indexWhere((element) => element['_id'] == _id);
    if(!data[_indexItem]['isRead']){
      data[_indexItem]['isRead'] = true;
      update();
    }
  }


  void remove() {
    data.clear();
    isLoading = true;
  }

  void changeLoading(bool _isLoading) {
    isLoading = _isLoading;
  }

  void changeContentUrl(String _contentUrl) {
    contentUrl = _contentUrl;
  }
}
