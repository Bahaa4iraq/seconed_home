import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import 'chat_socket.dart';
import 'package:record/record.dart';

class ChatMessageStudentProvider extends GetxController {
  List chat = [];
  Map typing = {};
  Map online = {};
  bool showFloating = false;
  String? currentChatReciver;
  String? currentChatSender;
  void isShow(bool _bool){
    if(showFloating != _bool){
      showFloating = _bool;
      update();
    }
  }
  String contentUrl = '';
  void addListChat(List _data) {
    chat.addAll(_data);
    update();
  }

  void addSingleChat(Map _data) {
    if(_data['chat_from'] == currentChatReciver||_data['chat_from'] == currentChatSender){
      chat.insert(0,_data);
      update();
    }
  }

  void changeMessageSenderStatus(Map _data) {
    //chat.where((element) => element['chat_uuid']);
    final singleChat = chat.firstWhere((item) => item['chat_uuid'] == _data['chat_uuid']);
    singleChat['_id'] = _data['_id'];
    singleChat['created_at'] = _data['created_at'];
    singleChat['chat_message_imgs'] = _data['chat_message_imgs'];
    singleChat['chat_delivered'] = null;
    update();
  }

  void deleteMessageById(String id){
    final singleChat = chat.firstWhere((item) => item['_id'] == id);
    singleChat['chat_message_is_deleted'] = true;
    update();
  }

  void chatTyping(Map _data){
    typing = _data;
    if(typing.isNotEmpty){
      Timer(const Duration(seconds: 1), () {
        typing.clear();
        update();
      });
    }
    print(_data);
    update();
  }

  void userOnlineCheck(Map _data){
    online = _data;
    update();
  }


  bool isLoading = true;
  void changeLoading(bool _isLoading) {
    isLoading = _isLoading;
  }

  void clear() {
    chat.clear();
  }
}

class ChatMessageGroupStudentProvider extends GetxController {
  List chat = [];
  Map typing = {};
  Map online = {};
  bool showFloating = false;
  String? currentChatSender;
  String? currentGroupId;
  void isShow(bool _bool){
    if(showFloating != _bool){
      showFloating = _bool;
      update();
    }
  }
  String contentUrl = '';
  void addListChat(List _data) {
    chat.addAll(_data);
    update();
  }

  void addSingleChat(Map _data) {
    if(_data["group_message_group_id"]==currentGroupId ||_data["group_message_from"]["_id"]==currentChatSender) {
      chat.insert(0, _data);
      update();
    }
  }

  void changeMessageSenderStatus(Map _data) {
    //chat.where((element) => element['chat_uuid']);
    final singleChat = chat.firstWhere((item) => item['chat_uuid'] == _data['chat_uuid']);
    singleChat['_id'] = _data['_id'];
    singleChat['created_at'] = _data['created_at'];
    singleChat['chat_message_imgs'] = _data['chat_message_imgs'];
    singleChat['chat_delivered'] = null;
    update();
  }

  void deleteMessageById(String id){
    final singleChat = chat.firstWhere((item) => item['_id'] == id);
    singleChat['group_message_is_deleted'] = true;
    update();
  }

  void chatTyping(Map _data){
    typing = _data;
    if(typing.isNotEmpty){
      Timer(const Duration(seconds: 1), () {
        typing.clear();
        update();
      });
    }
    print(_data);
    update();
  }

  void userOnlineCheck(Map _data){
    online = _data;
    update();
  }


  bool isLoading = true;
  void changeLoading(bool _isLoading) {
    isLoading = _isLoading;
  }

  void clear() {
    chat.clear();
  }
}

class ChatMessageBottomBarStudentProvider extends GetxController{
  TextEditingController message = TextEditingController();
  bool isOpenOtherItems =false;
  bool isRecording = false;

  Record record = Record();
  Amplitude? amplitude;
  Timer? timer;
  Timer? ampTimer;
  double recordDuration = 0;
  void changeTextMessage(Map _data){
    Get.put(ChatSocketStudentProvider()).socket.emit('typing', _data);
    update();
  }
  void clearTextMessage(){
    message.clear();
    update();
  }
  void changeOpen(){
    isOpenOtherItems = !isOpenOtherItems;
    update();
  }
  String customPath = '/flutter_audio_recorder_';


  void recordSoundStart() async {
    bool hasPermission = await record.hasPermission();
    if (hasPermission) {
      final appDocDirectory = await getApplicationDocumentsDirectory();

      final filePath = '${appDocDirectory.path}/myFile.m4a';

      await record.start(
        path: filePath,
        encoder: AudioEncoder.aacLc, // by default
        bitRate: 128000, // by default
        samplingRate: 44100, // by default
      );

      isRecording = await record.isRecording();
      recordDuration = 0;
      _startTimer();
      update();
    }
  }


  void _startTimer() {
    timer?.cancel();
    ampTimer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      recordDuration++;
      update();
    });

    ampTimer = Timer.periodic(const Duration(milliseconds: 200), (Timer t) async {
          amplitude = await record.getAmplitude();
          print(amplitude!.current);
          print(recordDuration);
          update();
        });
  }
  Future<String?> recordSoundStop() async {
    final path = await record.stop();
    timer?.cancel();
    ampTimer?.cancel();
    isRecording = await record.isRecording();
    update();
    return path;
  }
}