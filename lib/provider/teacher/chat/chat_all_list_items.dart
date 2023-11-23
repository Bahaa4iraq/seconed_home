import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../api_connection/teacher/chat/api_chat_student_list.dart';

class ChatStudentListProvider extends GetxController {
  final student = <dynamic>[].obs;
  List data = [];
  String contentUrl = '';
  void getStudent(page,classesId,studyYear,searchKeyword){

    Map _data = {
      "class_school": classesId,
      "study_year": studyYear,
      "page": page,
      "search": searchKeyword == '' ? null : searchKeyword,
    };

    ChatStudentListAPI().getStudentList(_data).then((res) {
      EasyLoading.dismiss();
      if (!res['error']) {
        if (page == 0) {
          clear();
          changeContentUrl(res["content_url"]);
          changeLoading(false);
          student.value = res['results'];
        }else{
          List temp = student.value;
          temp.addAll(res['results']);
          student.value = temp;
        }
        update();
      } else {
        EasyLoading.showError(res['message'].toString());
      }
    });
  }


  void changeContentUrl(String _contentUrl) {
    contentUrl = _contentUrl;
  }
  bool isLoading = true;
  void changeLoading(bool _isLoading){
    isLoading = _isLoading;
  }
  void clear(){
    student.value =[];
    update();
    data.clear();
  }

}

class ChatGroupListProvider extends GetxController {
  List student = [];
  String contentUrl = '';
  void addStudent(List _data){
    student.addAll(_data);
    update();
  }

  void changeContentUrl(String _contentUrl) {
    contentUrl = _contentUrl;
  }
  bool isLoading = true;
  void changeLoading(bool _isLoading){
    isLoading = _isLoading;
  }
  void clear(){
    student.clear();
  }
  void changeReadingCount(String _id){
    student.where((element) => element['_id'] == _id);
    final singleChat = student.firstWhere((item) => item['_id'] == _id);
    singleChat['chats']['countUnRead'] = 0;
    update();
  }

  void addSingleChat(Map _data,String _id) {
    final singleChat = student.firstWhere((item) => item['_id'] == _id);
    singleChat['chats']['data'] = [_data];
    update();
  }
  //_data['chats']['data']
}