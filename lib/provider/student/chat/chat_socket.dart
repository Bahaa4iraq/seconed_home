import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../static_files/my_url.dart';
import '../../auth_provider.dart';
import 'chat_message.dart';

class ChatSocketStudentProvider extends GetxController {
  late IO.Socket socket;
  void changeSocket(Map? dataProvider) {
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    socket = IO.io('${socketURL}chat', IO.OptionBuilder().setTransports(['websocket']).setAuth(_headers).build());
    socket.on('message', (_data) {
      final Map? dataProvider = Get.put(TokenProvider()).userData;
      bool isSender = _data['chat_from'] == dataProvider!['_id'];

      if (_data["chat_message_type"] == "text") {
        if (isSender) {
          Get.put(ChatMessageStudentProvider()).changeMessageSenderStatus(_data);
        } else {
          Get.put(ChatMessageStudentProvider()).addSingleChat(_data);
        }
      } else {
        Get.put(ChatMessageStudentProvider()).addSingleChat(_data);
      }
    });
    socket.on('groupMessage', (_data) {
      _data["isRead"] = false;
      final Map? dataProvider = Get.put(TokenProvider()).userData;
      bool isSender = _data['group_message_from']['_id'] == dataProvider!['_id'];
      if (_data["group_message_type"] == "text") {
        if (isSender) {
          Get.put(ChatMessageGroupStudentProvider()).changeMessageSenderStatus(_data);
        } else {
          Get.put(ChatMessageGroupStudentProvider()).addSingleChat(_data);
        }
      } else {
        Get.put(ChatMessageGroupStudentProvider()).addSingleChat(_data);
      }
    });
    socket.on('responseRemoveMessage', (_data) {
      if (_data['chat_message_is_deleted']) {
        Get.put(ChatMessageStudentProvider()).deleteMessageById(_data['_id']);
      }
    });
    socket.on('groupResponseRemoveMessage', (_data) {
      if (_data['group_message_is_deleted']) {
        Get.put(ChatMessageGroupStudentProvider()).deleteMessageById(_data['_id']);
      }
    });
    socket.on('getTyping', (data) {
      Get.put(ChatMessageStudentProvider()).chatTyping(data);
    });
    socket.on('online', (data) {
      Get.put(ChatMessageStudentProvider()).userOnlineCheck(data);
    });
    update();
  }
}
