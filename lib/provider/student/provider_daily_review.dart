import 'package:get/get.dart';

class ReviewDailyDateProvider extends GetxController {
  List data = [];
  void insertData(dataR) {
    data = dataR;
    update();
  }

  bool isLoading = true;
  void changeLoading(bool isLoadingR) {
    isLoading = isLoadingR;
  }
}
