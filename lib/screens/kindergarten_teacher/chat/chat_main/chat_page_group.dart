import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:images_picker/images_picker.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../api_connection/teacher/chat/api_add_files_chat.dart';
import '../../../../api_connection/teacher/chat/api_chat_group_list.dart';
import '../../../../provider/auth_provider.dart';
import '../../../../provider/provider_audio_player.dart';
import '../../../../provider/teacher/chat/chat_all_list_items.dart';
import '../../../../provider/teacher/chat/chat_message.dart';
import '../../../../provider/teacher/chat/chat_socket.dart';
import '../../../../static_files/my_group_static_files.dart';
import '../../../../static_files/my_color.dart';
import '../../../../static_files/my_times.dart';
import 'package:uuid/uuid.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';

class ChatPageGroup extends StatefulWidget {
  final Map userInfo;
  final String contentUrl;
  const ChatPageGroup({Key? key, required this.userInfo, required this.contentUrl}) : super(key: key);

  @override
  State<ChatPageGroup> createState() => _ChatPageGroupState();
}

class _ChatPageGroupState extends State<ChatPageGroup> {
  final ScrollController _scrollController = ScrollController();
  final ChatMessageBottomBarProvider _chatMessageBottomBarProvider = Get.put(ChatMessageBottomBarProvider());
  final player = AudioPlayer();

  int page = 0;
  _getChatOfStudent() {
    EasyLoading.show(status: "جار جلب البيانات");
    ChatGroupListAPI().getChatOfGroup(widget.userInfo['_id'],page).then((res) {
      EasyLoading.dismiss();
      if (!res['error']) {
        Get.put(ChatMessageGroupProvider()).addListChat(res["results"]);
      } else {
        EasyLoading.showError(res['message'].toString());
      }
    });
  }

  final AudioPlayerProvider _audioPlayerProvider = Get.put(AudioPlayerProvider());
  _checkUserOnline() {
    String uId = widget.userInfo['_id'];
    Map _data = {"chat_to": uId};
    Get.put(ChatSocketProvider()).socket.emit('checkOnline', _data);
  }

  @override
  void initState() {
    _checkUserOnline();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        page++;
        _getChatOfStudent();
      }

      if (_scrollController.position.pixels >= 200) {
        Get.put(ChatMessageGroupProvider()).isShow(true);
      } else {
        Get.put(ChatMessageGroupProvider()).isShow(false);
      }
    });
    //
    Get.put(ChatSocketProvider()).socket.emit('groupJoin', widget.userInfo['_id']);
    super.initState();
  }

  @override
  void dispose() {
    // notificationProvider.remove();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: profileImg(widget.contentUrl, widget.userInfo['account_img']),
            ),
            const SizedBox(
              width: 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.userInfo['group_name'],
                  style: const TextStyle(fontSize: 15),
                ),
                GetBuilder<ChatMessageGroupProvider>(builder: (val) {
                  return Row(
                    children: [
                      _onlineIconCheck(val.online, widget.userInfo['_id']),
                      const SizedBox(
                        width: 3,
                      ),
                      val.typing['chat_to'] == widget.userInfo['_id']
                          ? const Text(
                              "جار الكتابة...",
                              style: TextStyle(fontSize: 10),
                            )
                          : _onlineWidgetCheck(val.online, widget.userInfo['_id']),
                    ],
                  );
                })
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GetBuilder<ChatMessageGroupProvider>(builder: (val) {
              return Scaffold(
                body: ListView.builder(
                    // separatorBuilder: (BuildContext context, int index) {
                    //   return DateChip(
                    //       date: toDateAndTimeDateTime(val.chat[index]['created_at']-100000,24)
                    //   );
                    // },
                    //
                    itemCount: val.chat.length,
                    controller: _scrollController,
                    reverse: true,
                    itemBuilder: (BuildContext context, int index) => chatMessageBubbles(val.chat[index], index,player)),
                floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
                floatingActionButton: val.showFloating
                    ? FloatingActionButton(
                        onPressed: () {
                          _scrollController.animateTo(0, duration: const Duration(milliseconds: 400), curve: Curves.bounceIn);
                        },
                        child: const Icon(Icons.arrow_downward_rounded),
                        mini: true,
                        backgroundColor: MyColor.red,
                      )
                    : null,
              );
            }),
          ),
          _bottomContainer()
        ],
      ),
    );
  }

  static const double iconSize = 20;

  _bottomContainer() {
    return GetBuilder<ChatMessageBottomBarProvider>(builder: (val) {
      return Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        // decoration: BoxDecoration(
        //
        // ),
        child: val.isRecording
            ? Row(
                children: [
                  IconButton(
                      onPressed: () => _sendSound(),
                      icon: const Icon(
                        Icons.send_rounded,
                        color: MyColor.red,
                      )),
                  Expanded(
                    child: Row(
                      children: [
                        Text(secondToTime(val.current?.duration!.inSeconds.seconds.inSeconds.toInt() ?? 0)),
                        const Spacer(),
                        IconButton(
                            onPressed: val.recordSoundStop,
                            icon: const Icon(
                              Icons.cancel,
                              color: MyColor.red,
                            )),
                        // Expanded(
                        //   child: Column(
                        //     children: [
                        //       RectangleWaveform(
                        //         maxDuration: const Duration(seconds: 60),
                        //         elapsedDuration: Duration(seconds: (60 - (val.current?.duration!.inSeconds ?? 0))),
                        //         samples: val.samples,
                        //         height: 100,
                        //         absolute: true,
                        //         borderWidth: 0.5,
                        //         inactiveBorderColor: Color(0xFFEBEBEB),
                        //         width: MediaQuery.of(context).size.width,
                        //         inactiveColor: Colors.white,
                        //         activeBorderColor: Color(0xFFEBEBEB),
                        //         activeGradient: LinearGradient(
                        //           begin: Alignment.bottomCenter,
                        //           end: Alignment.topCenter,
                        //           colors: [
                        //             Color(0xFFff3701),
                        //             Color(0xFFff6d00),
                        //           ],
                        //           stops: [
                        //             0,
                        //             0.3,
                        //           ],
                        //         ),
                        //       ),
                        //       SizedBox(
                        //         height: 2,
                        //       ),
                        //       RectangleWaveform(
                        //         maxDuration: Duration(seconds: 60),
                        //         elapsedDuration: Duration(seconds: (60 - (val.current?.duration!.inSeconds ?? 0))),
                        //         samples: val.samples,
                        //         height: 50,
                        //         width: MediaQuery.of(context).size.width,
                        //         absolute: true,
                        //         invert: true,
                        //         borderWidth: 0.5,
                        //         inactiveBorderColor: Color(0xFFEBEBEB),
                        //         activeBorderColor: Color(0xFFEBEBEB),
                        //         activeColor: Color(0xFFffbf99),
                        //         inactiveColor: Color(0xFFffbf99),
                        //       ),
                        //     ],
                        //   ),
                        // )
                      ],
                    ),
                  )
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: val.message.text.trim().isNotEmpty ? _sendTextMessage : val.recordSoundStart,
                      icon: val.message.text.trim().isNotEmpty
                          ? const Icon(
                              Icons.send,
                              color: MyColor.red,
                            )
                          : const Icon(
                              Icons.mic,
                              color: MyColor.red,
                            )

                      // const Icon(
                      //         Icons.mic,
                      //         color: MyColor.red,
                      //       )
                      ),
                  Expanded(
                    child: TextFormField(
                      controller: val.message,
                      style: const TextStyle(
                        color: MyColor.black,
                      ),
                      minLines: 1,
                      maxLines: 3,
                      onChanged: (_text) {
                        Map _data = {
                          "chat_to": widget.userInfo['_id'],
                        };
                        val.changeTextMessage(_data);
                      },
                      onTap: val.changeOpen,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12),
                          hintText: "اكتب هنا",
                          errorStyle: const TextStyle(color: MyColor.grayDark),
                          fillColor: MyColor.grayDark.withOpacity(0.05),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          //prefixIcon: const Icon(LineIcons.user),
                          filled: true
                          //fillColor: Colors.green
                          ),
                    ),
                  ),
                  val.isOpenOtherItems
                      ? IconButton(
                          onPressed: val.changeOpen,
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: MyColor.red,
                            size: iconSize,
                          ))
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: val.changeOpen,
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: MyColor.red,
                                  size: iconSize,
                                )),
                            IconButton(
                                onPressed: _pickPDF,
                                icon: const Icon(
                                  Icons.picture_as_pdf,
                                  color: MyColor.red,
                                  size: iconSize,
                                )),
                            IconButton(
                                onPressed: _pickCamera,
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: MyColor.red,
                                  size: iconSize,
                                )),
                            IconButton(
                                onPressed: _pickImage,
                                icon: const Icon(
                                  Icons.image,
                                  color: MyColor.red,
                                  size: iconSize,
                                )),
                          ],
                        ),
                ],
              ),
      );
    });
  }

  _sendTextMessage() {
    final Map? dataProvider = Get.put(TokenProvider()).userData;
    Map _message = {
      "group_message_type": "text",
      "group_message_uuid": const Uuid().v1(),
      "group_message": _chatMessageBottomBarProvider.message.text,
      'group_message_is_deleted': false,
      'isRead': false,
      "group_message_from": {
        "_id": dataProvider!['_id'],
        "account_name": dataProvider['account_name'],
        //"account_img": dataProvider['account_name'],
        "account_mobile": dataProvider['account_mobile']
      },
      //"chat_from": dataProvider!['_id'],
      //"group_replay": null,
      "created_at": DateTime.now().millisecond,
      "group_message_url": null,
      "chat_delivered": false,
    };

    Map _data = {"message": _message, "groupId": widget.userInfo['_id']};

    Get.put(ChatMessageGroupProvider()).addSingleChat(_message);
    Get.put(ChatGroupListProvider()).addSingleChat(_message, widget.userInfo['_id']);
    Get.put(ChatSocketProvider()).socket.emit('groupMessage', _data);
    _chatMessageBottomBarProvider.message.clear();
  }

  Future _pickImage() async {
    List<Media>? res = await ImagesPicker.pick(count: 10, pickType: PickType.all, gif: true, quality: 0.4, maxSize: 150);
    List<dio.MultipartFile> _localPic = [];
    for (int i = 0; i < res!.length; i++) {
      _localPic.add(dio.MultipartFile.fromFileSync(res[i].path, filename: 'pic$i.jpg', contentType: MediaType('image', 'jpg')));
    }

    final Map? dataProvider = Get.put(TokenProvider()).userData;
    dio.FormData _data = dio.FormData.fromMap({
      "group_message_type": "image",
      "group_message_uuid": const Uuid().v1(),
      "group_message": null,
      'group_message_is_deleted': false,
      'isRead': false,
      "group_message_from": {
        "_id": dataProvider!['_id'],
        "account_name": dataProvider['account_name'],
        //"account_img": dataProvider['account_name'],
        "account_mobile": dataProvider['account_mobile']
      },
      "group_message_imgs": _localPic,
      "group_message_group_id": widget.userInfo['_id'],
      "group_chat_replay": null,
      "created_at": DateTime.now().millisecond,
      "group_message_url": null,
      "chat_delivered": false,
    });

    AddChatFilesAPI().addImagesGroup(_data);
  }

  Future _pickCamera() async {
    List<Media>? res = await ImagesPicker.openCamera(pickType: PickType.image, maxTime: 180, quality: 0.4, maxSize: 150);
    List<dio.MultipartFile> _localPic = [];
    for (int i = 0; i < res!.length; i++) {
      _localPic.add(dio.MultipartFile.fromFileSync(res[i].path, filename: 'pic$i.jpg', contentType: MediaType('image', 'jpg')));
    }

    final Map? dataProvider = Get.put(TokenProvider()).userData;
    dio.FormData _data = dio.FormData.fromMap({
      "group_message_type": "image",
      "group_message_uuid": const Uuid().v1(),
      "group_message": null,
      'group_message_is_deleted': false,
      'isRead': false,
      "group_message_from": {
        "_id": dataProvider!['_id'],
        "account_name": dataProvider['account_name'],
        //"account_img": dataProvider['account_name'],
        "account_mobile": dataProvider['account_mobile']
      },
      "group_message_imgs": _localPic,
      "group_message_group_id": widget.userInfo['_id'],
      "group_chat_replay": null,
      "created_at": DateTime.now().millisecond,
      "group_message_url": null,
      "chat_delivered": false,
    });

    AddChatFilesAPI().addImagesGroup(_data);
  }

  Future _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
    );

    final Map? dataProvider = Get.put(TokenProvider()).userData;
    dio.FormData _data = dio.FormData.fromMap({
      "group_message_type": "pdf",
      "group_message_uuid": const Uuid().v1(),
      "group_message": null,
      'group_message_is_deleted': false,
      'isRead': false,
      "group_message_from": {
        "_id": dataProvider!['_id'],
        "account_name": dataProvider['account_name'],
        //"account_img": dataProvider['account_name'],
        "account_mobile": dataProvider['account_mobile']
      },
      "group_message_imgs": null,
      "group_message_group_id": widget.userInfo['_id'],
      "group_chat_replay": null,
      "created_at": DateTime.now().millisecond,
      "group_message_url": dio.MultipartFile.fromFileSync(result!.files.first.path!, filename: 'pdfFile.pdf', contentType: MediaType('application', 'pdf')),
      "chat_delivered": false,
    });

    AddChatFilesAPI().addImagesGroup(_data);
  }

  Future _sendSound() async {
    String recordPath = await _chatMessageBottomBarProvider.recordSoundStop();

    final Map? dataProvider = Get.put(TokenProvider()).userData;
    dio.FormData _data = dio.FormData.fromMap({
      "group_message_type": "audio",
      "group_message_uuid": const Uuid().v1(),
      "group_message": null,
      'group_message_is_deleted': false,
      'isRead': false,
      "group_message_from": {
        "_id": dataProvider!['_id'],
        "account_name": dataProvider['account_name'],
        //"account_img": dataProvider['account_name'],
        "account_mobile": dataProvider['account_mobile']
      },
      "group_message_imgs": null,
      "group_message_group_id": widget.userInfo['_id'],
      "group_chat_replay": null,
      "created_at": DateTime.now().millisecond,
      "group_message_url": dio.MultipartFile.fromFileSync(recordPath, filename: 'audio.m4a', contentType: MediaType('audio', 'aac')),
      "chat_delivered": false,
    });

    AddChatFilesAPI().addImagesGroup(_data);
  }
}

Widget _onlineWidgetCheck(Map _online, String _id) {
  if (_online.isNotEmpty) {
    if (_online['isOnline'] && _online['id'] == _id) {
      return const Text(
        "نشط",
        style: TextStyle(fontSize: 10),
      );
    } else {
      return Text(
        lastSeenTime(_online['date']),
        //"اخر ضهور $data ",
        style: const TextStyle(fontSize: 10),
      );
    }
  } else {
    return Container();
  }
}

Widget _onlineIconCheck(Map _online, String _id) {
  if (_online.isNotEmpty) {
    if (_online['isOnline'] && _online['id'] == _id) {
      return const Icon(
        Icons.circle,
        size: 10,
        color: Colors.green,
      );
    } else {
      return Container();
    }
  } else {
    return Container();
  }
}

// _d(){
//   return Column(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       RectangleWaveform(
//         maxDuration: maxDuration,
//         elapsedDuration: elapsedDuration,
//         samples: samples,
//         height: 100,
//         absolute: true,
//         borderWidth: 0.5,
//         inactiveBorderColor: borderColor,
//         width: MediaQuery.of(context).size.width,
//         inactiveColor: Colors.white,
//         activeBorderColor: borderColor,
//         activeGradient: LinearGradient(
//           begin: Alignment.bottomCenter,
//           end: Alignment.topCenter,
//           colors: [
//             Color(0xFFff3701),
//             Color(0xFFff6d00),
//           ],
//           stops: [
//             0,
//             0.3,
//           ],
//         ),
//       ),
//       const SizedBox(
//         height: 2,
//       ),
//       RectangleWaveform(
//         maxDuration: maxDuration,
//         elapsedDuration: elapsedDuration,
//         samples: samples,
//         height: 50,
//         width: MediaQuery.of(context).size.width,
//         absolute: true,
//         invert: true,
//         borderWidth: 0.5,
//         inactiveBorderColor: borderColor,
//         activeBorderColor: borderColor,
//         activeColor: minoractiveColor,
//         inactiveColor: minorinactiveColor,
//       ),
//       // sizedBox,
//       Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ElevatedButton(
//             onPressed: () {
//               audioPlayer.fixedPlayer!.pause();
//             },
//             child: const Icon(
//               Icons.pause,
//             ),
//           ),
//           sizedBox,
//           ElevatedButton(
//             onPressed: () {
//               audioPlayer.fixedPlayer!.resume();
//             },
//             child: const Icon(Icons.play_arrow),
//           ),
//           sizedBox,
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 audioPlayer.fixedPlayer!
//                     .seek(const Duration(milliseconds: 0));
//               });
//             },
//             child: const Icon(Icons.replay_outlined),
//           ),
//         ],
//       )
//     ],
//   );
// }
