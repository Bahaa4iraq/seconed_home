import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:line_icons/line_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path/path.dart' as p;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../api_connection/student/api_notification.dart';
import '../../../../static_files/my_appbar.dart';
import '../../../../static_files/my_color.dart';
import '../../../../static_files/my_image_grid.dart';
import '../../../../static_files/my_pdf_viewr.dart';
import '../../../../static_files/my_random.dart';
import '../../../../static_files/my_times.dart';

class ShowMessage extends StatefulWidget {
  final Map data;
  final String contentUrl;
  final String notificationsType;
  final VoidCallback? onUpdate;
  const ShowMessage({Key? key, required this.data, required this.contentUrl, required this.notificationsType, this.onUpdate}) : super(key: key);

  @override
  _ShowMessageState createState() => _ShowMessageState();
}

class _ShowMessageState extends State<ShowMessage> {
  //["رسالة","تبليغ","واجب بيتي","ملخص","تقرير"]
  void _launchURL(_url) async => await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

  @override
  void initState() {
    if (!widget.data['isRead']) {
      widget.onUpdate?.call();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(widget.data['notifications_title'].toString(),MyColor.pink),
      body: ListView(
        children: [
          Padding(padding: const EdgeInsets.all(10), child: imageGrid(widget.contentUrl, widget.data['notifications_imgs'],MyColor.pink)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(toDateAndTime(widget.data['created_at'], 12)),
          ),
          if(widget.data['notifications_sender'] !=null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text("المرسل: "),
                  Text(widget.data['notifications_sender']['account_name'].toString()),
                ],
              ),
            ),
          if (widget.notificationsType == "واجب بيتي")
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: MaterialButton(
                onPressed: () => showMaterialModalBottomSheet(
                  context: context,
                  expand: true,
                  builder: (context) => AddAnswer(data: widget.data),
                ),
                child: const Text(
                  "اضافة اجابة",
                  style: TextStyle(color: MyColor.pink),
                ),
                color: MyColor.pink,
              ),
            ),
          if (widget.data['notifications_link'] != "" && widget.data['notifications_link'] != null)
            InkWell(
              onTap: () => _launchURL(widget.data['notifications_link']),
              child: Container(
                margin: const EdgeInsets.only(right: 20, left: 20,top:20),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(color: MyColor.pink.withOpacity(.17), borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    widget.data['notifications_link'].toString(),
                    style: const TextStyle(fontSize: 18, color: MyColor.pink),
                  ),
                ),
              ),
            ),
          if (widget.data['notifications_pdf'] != "" && widget.data['notifications_pdf'] != null)
            InkWell(
              onTap: () => Get.to(() => PdfViewer(url: widget.contentUrl + widget.data['notifications_pdf'])),
              child: Container(
                margin: const EdgeInsets.only(right: 20, left: 20, top: 10),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(color: MyColor.pink.withOpacity(.9), borderRadius: BorderRadius.circular(10)),
                child: const Center(
                  child: Text(
                    "عرض ملف ال PDF",
                    style: TextStyle(fontSize: 18, color: MyColor.pink),
                  ),
                ),
              ),
            ),
          if (widget.data['notifications_description'] != null)
            Container(
              margin: const EdgeInsets.all(20),
              child: Text(
                widget.data['notifications_description'].toString(),
                style: const TextStyle(fontSize: 18, color: MyColor.pink),
              ),
            )
        ],
      ),
    );
  }
}

class AddAnswer extends StatefulWidget {
  final Map data;
  const AddAnswer({Key? key, required this.data}) : super(key: key);

  @override
  _AddAnswerState createState() => _AddAnswerState();
}

class _AddAnswerState extends State<AddAnswer> {
  final TextEditingController _answerText = TextEditingController();
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  final List<XFile> _pic = [];

  Future<XFile?> compressAndGetFile(XFile file, String targetPath) async {
    String getRand = RandomGen().getRandomString(5);
    var result = await FlutterImageCompress.compressAndGetFile(file.path, "$targetPath/img_$getRand.jpg", quality: 40);
    return result;
  }

  pickImage1() async {
    EasyLoading.show(status: "جار التحميل...");
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.image);
    //70568
    if (result != null) {
      if (result.files.length > 10) {
        EasyLoading.dismiss();
        EasyLoading.showError("لايمكن رفع اكثر من عشر صور");
      } else {
        List<XFile> files = result.paths.map((path) => XFile(path!)).toList();
        _pic.clear();
        for (var file in files) {
          await compressAndGetFile(file, p.dirname(file.path)).then((value) => {
                _pic.add(value!),
              });
        }
        setState(() {});
        EasyLoading.dismiss();
      }
    } else {
      EasyLoading.dismiss();
    }
  }

  _send() {
    if (_pic.isNotEmpty || _answerText.text.isNotEmpty) {
      List<dio.MultipartFile> _localPic = [];
      for (int i = 0; i < _pic.length; i++) {
        _localPic.add(dio.MultipartFile.fromFileSync(_pic[i].path, filename: 'pic$i.jpg', contentType: MediaType('image', 'jpg')));
      }
      var _data = dio.FormData.fromMap({
        "notification_id": widget.data["_id"],
        "text": _answerText.text,
        "photos": _localPic,
      });
      NotificationsAPI().homeworkAnswer(_data).then((res) {
        if (res['error'] == false) {
          _btnController.success();
        } else {
          _btnController.error();
        }
      });
    } else {
      EasyLoading.showError("يجب ادراج الاجابة");
    }
    _btnController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: Text("الاجابة على الواجب")),
            ),
            const Divider(),
            Center(
              child: Container(
                constraints: const BoxConstraints(minWidth: 200, maxWidth: 350),
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: TextFormField(
                  controller: _answerText,
                  style: const TextStyle(
                    color: MyColor.grayDark,
                  ),
                  keyboardType: TextInputType.text,
                  maxLines: 3,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                      //contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                      contentPadding: const EdgeInsets.all(12.0),
                      hintText: "اكتب الاجابة هنا",
                      isDense: true,
                      errorStyle: const TextStyle(color: MyColor.red),
                      fillColor: MyColor.white1,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                          color: MyColor.white1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: MyColor.white1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                          color: MyColor.white1,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                          color: MyColor.red,
                        ),
                      ),
                      filled: true
                      //fillColor: Colors.green
                      ),
                ),
              ),
            ),
            const Divider(),
            _pic.isNotEmpty
                ? Container(
                    padding: const EdgeInsets.only(right: 20, left: 20, top: 40),
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 150,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                for (XFile img in _pic) _imageListView(img),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _pic.clear();
                                });
                              },
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.red,
                              )),
                        ),
                      ],
                    ))
                : _buttons("ادراج صورة", pickImage1, LineIcons.image, true),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: RoundedLoadingButton(
                color: MyColor.pink,
                child: const Text("ارسال", style: TextStyle(color: MyColor.white0, fontSize: 20, fontWeight: FontWeight.bold)),
                valueColor: MyColor.pink,
                successColor: MyColor.pink,
                controller: _btnController,
                onPressed: _send,
                borderRadius: 10,
              ),
            ),
            const SizedBox(
              height: 25,
            )
          ],
        ),
      ),
    );
  }

  _buttons(_t, _nav, _icon, _enable) {
    return Container(
      decoration: BoxDecoration(
        color: MyColor.pink,
        borderRadius: BorderRadius.circular(5.0),
      ),
      margin: const EdgeInsets.only(right: 20, left: 20, top: 20),
      child: ListTile(
        onTap: _nav,
        enabled: _enable,
        title: Text(
          _t,
          maxLines: 1,
          style: const TextStyle(color: MyColor.pink, fontSize: 15),
        ),
        trailing: Icon(
          _icon,
          color: MyColor.pink,
        ),
      ),
    );
  }

  _imageListView(XFile _img) {
    return Container(
      height: 150,
      width: Get.width / 4,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        border: Border.all(width: 2.0, color: MyColor.white3),
        borderRadius: const BorderRadius.all(Radius.circular(11)),
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          //show  XFile image
          child: Image.file(
            File(_img.path),
            fit: BoxFit.cover,
          )),
    );
  }
}
