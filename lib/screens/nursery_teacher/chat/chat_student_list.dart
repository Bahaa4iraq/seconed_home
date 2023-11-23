import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../api_connection/teacher/chat/api_chat_student_list.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/teacher/chat/chat_all_list_items.dart';
import '../../../provider/teacher/chat/chat_message.dart';
import '../../../provider/teacher/chat/chat_socket.dart';
import '../../../static_files/debouncer.dart';
import '../../../static_files/my_chat_static_files.dart';
import '../../../static_files/my_color.dart';
import '../../../static_files/my_loading.dart';
import '../../../static_files/my_times.dart';
import 'chat_main/chat_page.dart';

class ChatStudentList extends StatefulWidget {
  const ChatStudentList({Key? key}) : super(key: key);

  @override
  State<ChatStudentList> createState() => _ChatStudentListState();
}

class _ChatStudentListState extends State<ChatStudentList> {
  final MainDataGetProvider _mainDataGetProvider =
      Get.put(MainDataGetProvider());
  final ScrollController _scrollController = ScrollController();
  final List _classes =
      Get.put(MainDataGetProvider()).mainData['account']['account_division'];
  final TextEditingController searchController = TextEditingController();
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 600));
  final ChatStudentListProvider chatStudentProvider = Get.find();

  int page = 0;
  List _classesId = [];
  late var _studyYear;

  search(){
    page = 0;
    EasyLoading.show(status: "جار جلب البيانات");
    chatStudentProvider.getStudent(page, _classesId, _studyYear, searchController.text);
  }
  _getStudentList() {
    _studyYear= _mainDataGetProvider.mainData['setting'][0]['setting_year'];
    if (page != 0) {
      EasyLoading.show(status: "جار جلب البيانات");
    }
    chatStudentProvider.getStudent(page, _classesId, _studyYear, searchController.text);

  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    for (Map _data in _classes) {
      _classesId.add(_data['_id'].toString());
    }
    _getStudentList();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        page++;
        _getStudentList();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatStudentListProvider>(builder: (val) {
      return val.student.value.isEmpty && val.isLoading
          ? Center(
              child: loadingChat(),
            )
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 0, right: 20, left: 20),
                  child: TextFormField(
                    controller: searchController,
                    style: const TextStyle(
                      color: MyColor.black,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 24),
                      errorStyle: const TextStyle(color: MyColor.grayDark),
                      fillColor: const Color(0xFFFAFAFA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      suffixIcon: const Icon(Icons.search),
                      filled: true,
                      hintText: 'ابحث',
                    ),
                    onChanged: (keyword) {
                      _debouncer(() {
                        search();
                      });
                    },
                    onTapOutside: (e) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) =>
                          _student(val.student[index], val.contentUrl),
                      controller: _scrollController,
                      padding: const EdgeInsets.only(top:10),
                      //separatorBuilder: (BuildContext context, int index)=>const Divider(),
                      itemCount: val.student.length),
                ),
              ],
            );
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
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                    decoration: _data['chats']['data'][0]
                            ['chat_message_is_deleted']
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1.0,
                              color: Colors.grey.shade300,
                            ),
                          )
                        : null,
                    child: Text(
                        _data['chats']['data'][0]['chat_message_is_deleted']
                            ? "تم مسح الرسالة"
                            : _data['chats']['data'][0]['chat_message'] ??
                                "تم ارسال ملف",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: _data['chats']['data'][0]
                                    ['chat_message_isRead']
                                ? FontWeight.normal
                                : FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
              ],
            ),
      leading: profileImg(_contentUrl, _data['account_img']),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_data['chats']['data'].isNotEmpty)
            _timeText(_data['chats']['data'][0]['created_at']),
          if (_data['chats']['countUnRead'] > 0)
            _messageUnRead(_data['chats']['countUnRead']),
        ],
      ),
      onTap: () async {
        searchController.clear();
        Get.put(ChatMessageProvider()).clear();
        Get.put(ChatMessageProvider()).addListChat(_data['chats']['data']);
        await Get.to(() => ChatPage(userInfo: _data, contentUrl: _contentUrl));
        Get.put(ChatSocketProvider()).socket.emit('readMessage', _data['_id']);
        Get.put(ChatMessageProvider()).isShow(false);
        page = 0;
        _getStudentList();
      },
      onLongPress: () {
        Get.bottomSheet(_bottomSheet(_data));
      },
    );
  }
}

Text _timeText(int _time) {
  return Text(
    getChatDate(_time, 12),
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
    decoration: const BoxDecoration(
        color: MyColor.white1,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10), topLeft: Radius.circular(10))),
    child: Column(
      children: [
        ListTile(
          title: Text(
            _data['account_name'].toString(),
            style: const TextStyle(fontSize: 14),
          ),
          subtitle: Text(
              _data['account_division_current']['class_name'].toString() +
                  ' - ' +
                  _data['account_division_current']['leader'].toString(),
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
