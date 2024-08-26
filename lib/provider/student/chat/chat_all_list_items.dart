import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../../../api_connection/student/chat/api_chat_student_list.dart';

class ChatTeacherListProvider extends GetxController {
  RxList student = [].obs;
  String contentUrl = '';
  List data = [];

  void getStudent(page, classesId, studyYear, searchKeyword) {
    Logger().i(searchKeyword);
    Map data = {
      "class_school": classesId,
      "study_year": studyYear,
      "page": page,
      "search": searchKeyword == '' ? null : searchKeyword,
    };

    ChatTeacherListAPI().getStudentList(data).then((res) {
      EasyLoading.dismiss();
      if (!res['error']) {
        Logger()
            .i((res['results'] as List<dynamic>).map((e) => e['account_name']));

        if (page == 0) {
          clear();
          changeContentUrl(res["content_url"]);
          changeLoading(false);
          student.value = res['results'];
        } else {
          List temp = student;
          temp.addAll(res['results']);
          student.value = temp;
        }
        update();
      } else {
        EasyLoading.showError(res['message'].toString());
      }
    });
  }

  void changeContentUrl(String contentUrl) {
    contentUrl = contentUrl;
  }

  bool isLoading = true;
  void changeLoading(bool isLoading) {
    isLoading = isLoading;
  }

  void clear() {
    student.value = [];
    update();
    data.clear();
  }
}

class ChatGroupStudentListProvider extends GetxController {
  List student = [];
  String contentUrl = '';
  void addStudent(List data) {
    student.addAll(data);
    update();
  }

  void changeContentUrl(String contentUrl) {
    contentUrl = contentUrl;
  }

  bool isLoading = true;
  void changeLoading(bool isLoading) {
    isLoading = isLoading;
  }

  void clear() {
    student.clear();
  }

  void changeReadingCount(String id) {
    student.where((element) => element['_id'] == id);
    final singleChat = student.firstWhere((item) => item['_id'] == id);
    singleChat['chats']['countUnRead'] = 0;
    update();
  }

  void addSingleChat(Map data, String id) {
    final singleChat = student.firstWhere((item) => item['_id'] == id);
    singleChat['chats']['data'] = [data];
    update();
  }
  //_data['chats']['data']
}
