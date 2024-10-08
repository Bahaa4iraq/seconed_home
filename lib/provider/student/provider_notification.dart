import 'package:get/get.dart';

class NotificationProvider extends GetxController {
  List data = [];
  int countRead = 0;
  bool? isRead;
  int countUnread = 0;
  int countAll = 0;
  bool isLoading = true;
  String contentUrl = "";
  void insertData(dataR) {
    data.addAll(dataR);
    update();
  }

  void changeRead(isReadR) {
    isRead = isReadR;
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

  void changeCount(int countAllR, int countReadR, int countUnreadR) {
    countAll = countAllR;
    countRead = countReadR;
    countUnread = countUnreadR;
    update();
  }

  void remove() {
    data.clear();
    isLoading = true;
  }

  void changeLoading(bool isLoadingR) {
    isLoading = isLoadingR;
    update();
  }

  void changeContentUrl(String contentUrlR) {
    contentUrl = contentUrlR;
  }
}

class NotificationProviderE extends GetxController {
  List data = [];
  int countRead = 0;
  bool? isRead;
  int countUnread = 0;
  int countAll = 0;
  bool isLoading = true;
  String contentUrl = "";
  void insertData(dataR) {
    data.clear();
    data.addAll(dataR);
    update();
  }

  void changeRead(isReadR) {
    isRead = isReadR;
    //update();
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

  void changeCount(int countAllR, int countReadR, int countUnreadR) {
    countAll = countAllR;
    countRead = countReadR;
    countUnread = countUnreadR;
    update();
  }

  void remove() {
    data.clear();
    isLoading = true;
  }

  void changeLoading(bool isLoadingR) {
    isLoading = isLoadingR;
  }

  void changeContentUrl(String contentUrlR) {
    contentUrl = contentUrlR;
  }
}

class NotificationProviderHomeWork extends GetxController {
  List data = [];
  int countRead = 0;
  bool? isRead;
  int countUnread = 0;
  int countAll = 0;
  bool isLoading = true;
  String contentUrl = "";
  void insertData(data) {
    data.clear();
    data.addAll(data);
    update();
  }

  void changeRead(isReadR) {
    isRead = isReadR;
    //update();
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

  void changeCount(int countAllX, int countReadX, int countUnreadX) {
    countAll = countAllX;
    countRead = countReadX;
    countUnread = countUnreadX;
    update();
  }

  void remove() {
    data.clear();
    isLoading = true;
  }

  void changeLoading(bool isLoadingx) {
    isLoading = isLoadingx;
  }

  void changeContentUrl(String contentUrlx) {
    contentUrl = contentUrlx;
  }
}

class MonthlyMessageNotificationProvider extends GetxController {
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
    //update();
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
  }

  void changeContentUrl(String contentUrlx) {
    contentUrl = contentUrlx;
  }
}

class ClothesNotificationProvider extends GetxController {
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
    //update();
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
  }

  void changeContentUrl(String contentUrlx) {
    contentUrl = contentUrlx;
  }
}

class FoodNotificationProvider extends GetxController {
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
    //update();
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
  }

  void changeContentUrl(String contentUrlx) {
    contentUrl = contentUrlx;
  }
}

class SleepNotificationProvider extends GetxController {
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
    //update();
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
  }

  void changeContentUrl(String contentUrlx) {
    contentUrl = contentUrlx;
  }
}

class NappyNotificationProvider extends GetxController {
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
    //update();
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
  }

  void changeContentUrl(String contentUrlx) {
    contentUrl = contentUrlx;
  }
}

class TrainingNotificationProvider extends GetxController {
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
    //update();
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
  }

  void changeContentUrl(String contentUrlx) {
    contentUrl = contentUrlx;
  }
}
