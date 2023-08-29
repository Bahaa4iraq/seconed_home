import 'dart:async';
import 'package:another_audio_recorder/another_audio_recorder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';

import 'chat_socket.dart';
// import 'package:record/record.dart';

class ChatMessageStudentProvider extends GetxController {
  List chat = [];
  Map typing = {};
  Map online = {};
  bool showFloating = false;
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
    chat.insert(0,_data);
    update();
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
    chat.insert(0,_data);
    update();
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

  AnotherAudioRecorder? recorder;
  Recording? current;
  RecordingStatus currentStatus = RecordingStatus.Unset;
  // late List<double> samples;
  // late int totalSamples;
  // Amplitude? amplitude;
  // Timer? timer;
  // Timer? ampTimer;
  // double recordDuration = 0;
  // final record = Record();
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

  init() async {
    bool hasPermission = await AnotherAudioRecorder.hasPermissions ;
    if(hasPermission){
      String customPath = '/flutter_audio_recorder_';
      io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
      if (io.Platform.isIOS) {
        appDocDirectory = await getApplicationDocumentsDirectory();
      } else {
        appDocDirectory = (await getExternalStorageDirectory())!;
      }

      // can add extension like ".mp4" ".wav" ".m4a" ".aac"
      customPath = appDocDirectory.path + customPath + DateTime.now().millisecondsSinceEpoch.toString();
      recorder = AnotherAudioRecorder(customPath, audioFormat: AudioFormat.AAC);
      await recorder!.initialized;
      var _current = await recorder!.current(channel: 0);
      // should be "Initialized", if all working fine
      current = _current;
      currentStatus = _current!.status!;
    }else {
      Get.snackbar("تصريح", "الرجاء الموافقة على استخدام الميكروفون");
    }
  }

  recordSoundStart() async {
    try {
      await init();
      await recorder!.start();
      var recording = await recorder!.current(channel: 0);
      current = recording;
      isRecording = true;
      const tick = Duration(milliseconds: 50);
      Timer.periodic(tick, (Timer t) async {
        if (currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var _current = await recorder!.current(channel: 0);
        // print(current.status);
        current = _current;
        currentStatus = current!.status!;
        print(current!.metering!.averagePower);
        print(current!.metering!.peakPower);
        update();
      });
    } catch (e) {
    }
  }

  recordSoundStop() async {
    var result = await recorder!.stop();
    print("Stop recording: ${result!.path}");
    print("Stop recording: ${result.duration}");
    // File file = widget.localFileSystem.file(result.path);
    // print("File length: ${await file.length()}");
    current = result;
    currentStatus = current!.status!;
    isRecording = false;
    update();
    return result.path;
  }
  // void recordSoundStart() async {
  //   bool hasPermission = await record.hasPermission();
  //   if(hasPermission){
  //     await record.start(
  //       //path: 'myFile.m4a', // required
  //       encoder: AudioEncoder.AAC, // by default
  //       bitRate: 128000, // by default
  //       samplingRate: 44100, // by default
  //     );
  //     isRecording = await record.isRecording();
  //     recordDuration = 0;
  //     _startTimer();
  //     update();
  //   }
  // }
  //
  // void _startTimer() {
  //   timer?.cancel();
  //   ampTimer?.cancel();
  //
  //   timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
  //     recordDuration++;
  //     update();
  //   });
  //
  //   ampTimer = Timer.periodic(const Duration(milliseconds: 200), (Timer t) async {
  //         amplitude = await record.getAmplitude();
  //         print(amplitude!.current);
  //         print(recordDuration);
  //         update();
  //       });
  // }
  // void recordSoundStop() async {
  //   final path = await record.stop();
  //   print(path);
  //   timer?.cancel();
  //   ampTimer?.cancel();
  //   isRecording = await record.isRecording();
  //   update();
  // }
}