import 'package:get/get.dart';

class TeacherNotificationProvider extends GetxController {
  List data = [];
  int countRead = 0;
  bool? isRead;
  int countUnread = 0;
  int countAll = 0;
  bool isLoading = true;
  String contentUrl = "";
  void insertData(datax) {
    data.addAll(datax);
    update();
  }

  void changeRead(isReadx) {
    isRead = isReadx;
    update();
  }

  void editReadMap(String id) {
    int indexItem = data.indexWhere((element) => element['_id'] == id);
    if (!data[indexItem]['isRead']) {
      countRead++;
      countUnread--;
      data[indexItem]['isRead'] = true;
      update();
    }
  }

  void deleteNotification(String id) {
    data.removeWhere((element) => element['_id'] == id);
    update();
  }

  void changeCount(int countAllx, int countReadx, int countUnreadx) {
    countAll = countAllx;
    countRead = countReadx;
    countUnread = countUnreadx;
    update();
  }

  void remove() {
    data.clear();
    isLoading = true;
  }

  void changeLoading(bool isLoadingx) {
    isLoading = isLoadingx;
    update();
  }

  void changeContentUrl(String contentUrlx) {
    contentUrl = contentUrlx;
  }
}

class TeacherHomeworkAnswersProvider extends GetxController {
  List data = [];

  bool isLoading = true;
  String contentUrl = "";
  void insertData(datax) {
    data.addAll(datax);
    update();
  }

  void deleteNotification(String id) {
    data.removeWhere((element) => element['_id'] == id);
    update();
  }

  void remove() {
    data.clear();
    isLoading = true;
  }

  void changeLoading(bool isLoadingx) {
    isLoading = isLoadingx;
    update();
  }

  void changeContentUrl(String contentUrlx) {
    contentUrl = contentUrlx;
  }
}

class SelectSwitchProvider extends GetxController {
  int? radioValue = -1;

  void change(int? value) {
    radioValue = value;
    update();
  }
}

class NotificationProviderIntimation extends GetxController {
  List data = [];
  int countRead = 0;
  bool? isRead;
  int countUnread = 0;
  int countAll = 0;
  bool isLoading = true;
  String contentUrl = "";
  void insertData(datax) {
    data.clear();
    data.addAll(datax);
    update();
  }

  void changeRead(isReadx) {
    isRead = isReadx;
    update();
  }

  void editReadMap(String id) {
    int indexItem = data.indexWhere((element) => element['_id'] == id);
    if (!data[indexItem]['isRead']) {
      countRead++;
      countUnread--;
      data[indexItem]['isRead'] = true;
      update();
    }
  }

  void changeCount(int countAllx, int countReadx, int countUnreadx) {
    countAll = countAllx;
    countRead = countReadx;
    countUnread = countUnreadx;
    update();
  }

  void remove() {
    data.clear();
    isLoading = true;
  }

  void changeLoading(bool isLoadingx) {
    isLoading = isLoadingx;
    update();
  }

  void changeContentUrl(String contentUrlx) {
    contentUrl = contentUrlx;
  }
}
