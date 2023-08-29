import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../../api_connection/student/chat/api_chat_student_list.dart';
import '../../../../provider/auth_provider.dart';
import '../../../../provider/student/chat/chat_all_list_items.dart';
import '../../../../provider/student/chat/chat_message.dart';
import '../../../../provider/student/chat/chat_socket.dart';
import '../../../../static_files/my_chat_static_files.dart';
import '../../../../static_files/my_color.dart';
import '../../../../static_files/my_loading.dart';
import '../../../../static_files/my_times.dart';
import 'chat_main/chat_page.dart';

class ChatTeacherList extends StatefulWidget {
  const ChatTeacherList({Key? key}) : super(key: key);

  @override
  State<ChatTeacherList> createState() => _ChatTeacherListState();
}

class _ChatTeacherListState extends State<ChatTeacherList> {
  final MainDataGetProvider _mainDataGetProvider = Get.put(MainDataGetProvider());
  final ScrollController _scrollController = ScrollController();
  final List _classes = Get.put(MainDataGetProvider()).mainData['account']['account_division'];

  int page = 0;
  _getTeacherList() {
    if (page != 0) {
      EasyLoading.show(status: "جار جلب البيانات");
    }
    String _classesId = Get.put(MainDataGetProvider()).mainData['account']['account_division_current']['_id'];

    Map _data = {"class_school": _classesId, "study_year": _mainDataGetProvider.mainData['setting'][0]['setting_year'], "page": page};
    ChatTeacherListAPI().getStudentList(_data).then((res) {
      EasyLoading.dismiss();
      if (!res['error']) {
        if (page == 0) {
          Get.put(ChatTeacherListProvider()).clear();
          Get.put(ChatTeacherListProvider()).changeContentUrl(res["content_url"]);
          Get.put(ChatTeacherListProvider()).changeLoading(false);
        }
        Get.put(ChatTeacherListProvider()).addStudent(res["results"]);
      } else {
        EasyLoading.showError(res['message'].toString());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _getTeacherList();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        page++;
        _getTeacherList();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatTeacherListProvider>(builder: (val) {
      return val.student.isEmpty && val.isLoading
          ? Center(
              child: loadingChat(),
            )
          : ListView.builder(
              itemBuilder: (BuildContext context, int index) => _student(val.student[index], val.contentUrl),
              controller: _scrollController,
              //separatorBuilder: (BuildContext context, int index)=>const Divider(),
              itemCount: val.student.length);
    });
  }

  _student(Map _data, String _contentUrl) {
    return ListTile(
      title: Text(
        _data['account_name'].toString(),
        style: const TextStyle(fontSize: 14),
      ),
      subtitle: _data['chats']['data'].length == 0
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                  decoration: _data['chats']['data'][0]['chat_message_is_deleted']
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1.0,
                            color: Colors.grey.shade300,
                          ),
                        )
                      : null,
                  child: Text(
                      _data['chats']['data'][0]['chat_message_is_deleted'] ? "تم مسح الرسالة" : _data['chats']['data'][0]['chat_message'] ?? "تم ارسال ملف",
                      style: TextStyle(fontSize: 12, fontWeight: _data['chats']['data'][0]['chat_message_isRead'] ? FontWeight.normal : FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
      leading: profileImg(_contentUrl, _data['account_img']),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_data['chats']['data'].isNotEmpty) _timeText(_data['chats']['data'][0]['created_at']),
          if (_data['chats']['countUnRead'] > 0) _messageUnRead(_data['chats']['countUnRead']),
        ],
      ),
      onTap: () async {
        Get.put(ChatMessageStudentProvider()).clear();
        Get.put(ChatMessageStudentProvider()).addListChat(_data['chats']['data']);
        await Get.to(() => ChatPage(userInfo: _data, contentUrl: _contentUrl));
        Get.put(ChatSocketStudentProvider()).socket.emit('readMessage', _data['_id']);
        Get.put(ChatMessageStudentProvider()).isShow(false);
        page = 0;
        _getTeacherList();
      },
      onLongPress: () {
        Get.bottomSheet(_bottomSheet(_data));
      },
    );
  }
}

Text _timeText(int _time) {
  return Text(
    toTimeOnly(_time, 12),
    style: const TextStyle(fontSize: 10),
  );
}

Widget _messageUnRead(int _count) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: MyColor.green,
    ),
    padding: const EdgeInsets.fromLTRB(7, 3, 7, 3),
    child: _count > 99
        ? const Text(
            "99+",
            style: TextStyle(fontSize: 10, color: MyColor.white0),
          )
        : Text(
            _count.toString(),
            style: const TextStyle(fontSize: 10, color: MyColor.white0),
          ),
  );
}

Widget _bottomSheet(Map _data) {
  return Container(
    decoration: const BoxDecoration(color: MyColor.white1, borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
    child: Column(
      children: [
        ListTile(
          title: Text(
            _data['account_name'].toString(),
            style: const TextStyle(fontSize: 14),
          ),
          subtitle: Text(_data['account_division_current']['class_name'].toString() + ' - ' + _data['account_division_current']['leader'].toString(),
              style: const TextStyle(
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ),
        const Divider(),
      ],
    ),
  );
}
