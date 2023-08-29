import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:line_icons/line_icons.dart';
import 'package:path/path.dart' as p;
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../api_connection/student/api_profile.dart';
import '../../../static_files/my_color.dart';
import '../../../static_files/my_random.dart';
import 'show/show_documents.dart';

class AttachDocuments extends StatefulWidget {
  const AttachDocuments({Key? key}) : super(key: key);

  @override
  _AttachDocumentsState createState() => _AttachDocumentsState();
}

class _AttachDocumentsState extends State<AttachDocuments> {
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  XFile? _pic1;
  XFile? _pic2;
  XFile? _pic3;
  XFile? _pic4;
  XFile? _pic5;

  pickImage1() async {
    EasyLoading.show(status: "جار التحميل");
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      XFile file = XFile(result.files.single.path!);
      compressAndGetFile(file, p.dirname(file.path)).then((value) => {
            setState(() {
              _pic1 = value;
            }),
            EasyLoading.dismiss(),
          });
    } else {
      EasyLoading.dismiss();
      // User canceled the picker
    }
  }

  pickImage2() async {
    EasyLoading.show(status: "جار التحميل");
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      XFile file = XFile(result.files.single.path!);
      compressAndGetFile(file, p.dirname(file.path)).then((value) => {
            setState(() {
              _pic2 = value;
            }),
            EasyLoading.dismiss(),
          });
    } else {
      EasyLoading.dismiss();
    }
  }

  pickImage3() async {
    EasyLoading.show(status: "جار التحميل");
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      XFile file = XFile(result.files.single.path!);
      compressAndGetFile(file, p.dirname(file.path)).then((value) => {
            setState(() {
              _pic3 = value;
            }),
            EasyLoading.dismiss(),
          });
    } else {
      EasyLoading.dismiss();
    }
  }

  pickImage4() async {
    EasyLoading.show(status: "جار التحميل");
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      XFile file = XFile(result.files.single.path!);
      compressAndGetFile(file, p.dirname(file.path)).then((value) => {
            setState(() {
              _pic4 = value;
            }),
            EasyLoading.dismiss(),
          });
    } else {
      EasyLoading.dismiss();
    }
  }

  pickImage5() async {
    EasyLoading.show(status: "جار التحميل");
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      XFile file = XFile(result.files.single.path!);
      compressAndGetFile(file, p.dirname(file.path)).then((value) => {
            setState(() {
              _pic5 = value;
            }),
            EasyLoading.dismiss(),
          });
    } else {
      EasyLoading.dismiss();
    }
  }

  bool activeNav = false;
  Map _documents = {};
  String _contentUrl = "";
  Future<XFile?> compressAndGetFile(XFile file, String targetPath) async {
    String getRand = RandomGen().getRandomString(5);
    var result = await FlutterImageCompress.compressAndGetFile(file.path, "$targetPath/img_$getRand.jpg", quality: 20);
    return result;
  }

  _send() {
    dio.FormData _data = dio.FormData.fromMap({
      "certificate_national_id_old_file": _documents['certificate_national_id'],
      "certificate_national_old_old_file": _documents['certificate_national_old'],
      "certificate_passport_old_file": _documents['certificate_passport'],
      "certificate_nationality_old_file": _documents['certificate_nationality'],
      "certificate_address_old_file": _documents['certificate_address'],
      "certificate_national_id":
          _pic1 == null ? null : dio.MultipartFile.fromFileSync(_pic1!.path, filename: 'pic.jpg', contentType: MediaType('image', 'jpg')),
      "certificate_national_old":
          _pic2 == null ? null : dio.MultipartFile.fromFileSync(_pic2!.path, filename: 'pic.jpg', contentType: MediaType('image', 'jpg')),
      "certificate_passport": _pic3 == null ? null : dio.MultipartFile.fromFileSync(_pic3!.path, filename: 'pic.jpg', contentType: MediaType('image', 'jpg')),
      "certificate_nationality":
          _pic4 == null ? null : dio.MultipartFile.fromFileSync(_pic4!.path, filename: 'pic.jpg', contentType: MediaType('image', 'jpg')),
      "certificate_address": _pic5 == null ? null : dio.MultipartFile.fromFileSync(_pic5!.path, filename: 'pic.jpg', contentType: MediaType('image', 'jpg')),
    });
    if (_pic1 == null && _pic2 == null && _pic3 == null && _pic4 == null && _pic5 == null) {
      _btnController.error();
      EasyLoading.showError("الرجاء اختيار المستمسكات لرفعها");
      Timer(const Duration(seconds: 2), () {
        _btnController.reset();
      });
    } else {
      StudentProfileAPI().studentCertificateInsert(_data).then((res) {
        if (res['error'] == false) {
          _showDocuments();
          _btnController.success();
          EasyLoading.showSuccess(res['message'].toString());
        } else {
          _btnController.error();
          EasyLoading.showError(res['message'].toString());
          Timer(const Duration(seconds: 2), () {
            _btnController.reset();
          });
        }
      });
    }
  }

  _showDocuments() {
    StudentProfileAPI().studentCertificateGet().then((res) {
      if (!res['error']) {
        if (res['results']['certificate_national_id'] == null &&
            res['results']['certificate_national_old'] == null &&
            res['results']['certificate_passport'] == null &&
            res['results']['certificate_nationality'] == null &&
            res['results']['certificate_address'] == null) {
        } else {
          setState(() {
            activeNav = true;
            _documents = res['results'];
            _contentUrl = res['content_url'];
          });
        }
      }
    });
  }

  @override
  void initState() {
    _showDocuments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.pink,
        title: const Text(
          "المستمسكات",
          style: TextStyle(color: MyColor.white0),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => activeNav
                ? Get.to(() => ShowDocument(
                      data: _documents,
                      url: _contentUrl,
                    ))
                : Get.snackbar("انتبه", "لم يتم رفع اي مستمسكات للان",
                    backgroundColor: MyColor.grayDark, colorText: Colors.white),
            tooltip: "عرض المستمسكات",
            icon: const Icon(LineIcons.fileInvoice),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _pic1 != null
                ? Container(
                    padding:
                        const EdgeInsets.only(right: 40, left: 40, top: 40),
                    child: Stack(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(File(_pic1!.path))),
                        Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _pic1 = null;
                                });
                              },
                              icon: const Icon(
                                Icons.clear,
                                color: MyColor.pink,
                              )),
                        ),
                      ],
                    ))
                : _buttons("البطاقة الموحدة", pickImage1, LineIcons.plus, true),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: RoundedLoadingButton(
                color: MyColor.pink,
                child: const Text("ارسال",
                    style: TextStyle(
                        color: MyColor.white0,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                valueColor: MyColor.white0,
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
          style: const TextStyle(color: MyColor.white0, fontSize: 15),
        ),
        trailing: Icon(
          _icon,
          color: MyColor.white0,
        ),
      ),
    );
  }
}
