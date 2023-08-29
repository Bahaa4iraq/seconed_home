import 'package:get/get.dart';

class ChatStudentListProvider extends GetxController {
  List student = [];
  List data = [];
  String contentUrl = '';
  void addStudent(List _data){
    student.addAll(_data);
    data.addAll(_data);
    update();
  }

  filter(String keyword){
    if(keyword.isEmpty){
      student = data;
    }else{
      student = data.where((value){
        return value["account_name"].toString().toLowerCase().startsWith(keyword);
      }).toList();
    }
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