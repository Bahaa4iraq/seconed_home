import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_select/flutter_awesome_select.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../api_connection/student/api_general_data.dart';
import '../../static_files/my_color.dart';
import '../../static_files/my_random.dart';

class RequestJop extends StatefulWidget {
  const RequestJop({Key? key}) : super(key: key);
  @override
  _RequestJopState createState() => _RequestJopState();
}

class _RequestJopState extends State<RequestJop> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _specialty = TextEditingController();
  final TextEditingController _university = TextEditingController();

  final _formValidate = GlobalKey<FormState>();
  String _gov = '';
  final String _school = '';
  XFile? _pic;
  XFile? _cv;
  List<S2Choice<String>> governorates = [];
  List<S2Choice<String>> school = [];

  pickImage() async {
    EasyLoading.show(status: "جار التحميل...");
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      XFile file = XFile(result.files.single.path!);
      compressAndGetFile(file, p.dirname(file.path)).then((value) => {
            setState(() {
              _pic = value;
            }),
            EasyLoading.dismiss(),
          });
    } else {
      EasyLoading.dismiss();
      // User canceled the picker
    }
  }

  pickCV() async {
    EasyLoading.show(status: "جار التحميل...");
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      XFile file = XFile(result.files.single.path!);
      setState(() {
        _cv = file;
      });
      EasyLoading.dismiss();
      EasyLoading.showSuccess("تم تحميل السيرة الذاتية");
    } else {
      EasyLoading.dismiss();
    }
  }

  Future<XFile?> compressAndGetFile(XFile file, String targetPath) async {
    String getRand = RandomGen().getRandomString(5);
    var result = await FlutterImageCompress.compressAndGetFile(
        file.path, "$targetPath/img_$getRand.jpg",
        quality: 20);
    return result;
  }

  _send() async {
    if (_formValidate.currentState!.validate()) {
      if (_pic != null && _cv != null) {
        // FormData _data = FormData({
        //   "full_name": _name.text,
        //   "specialization": _specialty.text,
        //   "university": _university.text,
        //   "governorate": _gov,
        //   "requester_img": MultipartFile(_pic!.path, filename: 'pic.jpg', contentType: "image/jpg"),
        //   "requester_cv": MultipartFile(_cv!.path, filename: 'cv.pdf', contentType: "application/pdf"),
        //   "school": _school,
        // });
        var _data = dio.FormData.fromMap({
          "full_name": _name.text,
          "specialization": _specialty.text,
          "university": _university.text,
          "governorate": _gov,
          "requester_img": dio.MultipartFile.fromFileSync(_pic!.path,
              filename: 'pic.jpg', contentType: MediaType('image', 'jpg')),
          "requester_cv": dio.MultipartFile.fromFileSync(_cv!.path,
              filename: 'cv.pdf', contentType: MediaType('application', 'pdf')),
          "school": _school,
        });

        GeneralData().hireRequest(_data).then((res) {
          _btnController.reset();
          if (res['error'] == false) {
            _btnController.success();
          } else {
            _btnController.error();
          }
        });
      } else {
        EasyLoading.show(
            status: "الرجاء ارفع السيرة الذاتية والصورة", dismissOnTap: true);
        Timer(const Duration(seconds: 2), () {
          EasyLoading.dismiss();
        });
        _btnController.reset();
      }
    } else {
      _btnController.reset();
    }
  }

  @override
  void initState() {
    GeneralData().getGovernorate().then((res) {
      for (var _data in res) {
        governorates.add(S2Choice<String>(
            value: _data['governorate_name'].toString(),
            title: _data['governorate_name']));
      }
    });
    GeneralData().getSchools().then((res) {
      for (var _data in res) {
        school.add(S2Choice<String>(
            value: _data['_id'].toString(), title: _data['school_name']));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: MyColor.turquoise,
        title: const Text(
          "طلب تعيين",
          style: TextStyle(color: MyColor.red),
        ),
        iconTheme: const IconThemeData(
          color: MyColor.red,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: MyColor.white0,
        child: Form(
          key: _formValidate,
          child: Container(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: SingleChildScrollView(
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _formText(_name, "الاسم الكامل"),
                  _formText(_specialty, "الاختصاص"),
                  _formText(_university, "الجامعة او المعهد"),
                  // Container(
                  //   constraints: const BoxConstraints(minWidth: 200, maxWidth: 350, maxHeight: 73),
                  //   margin: const EdgeInsets.only(top: 0, bottom: 10, right: 0, left: 0),
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(10.0),
                  //     border: Border.all(
                  //       color: MyColor.red,
                  //     ),
                  //     color: MyColor.white1,
                  //   ),
                  //   child: SmartSelect<String>.single(
                  //     title: "المدرسة",
                  //     placeholder: "اختر المدرسة",
                  //     selectedValue: _school,
                  //     choiceItems: school,
                  //     onChange: (selected) {
                  //       setState(() => _school = selected.value!);
                  //     },
                  //   ),
                  // ),
                  Container(
                    constraints: const BoxConstraints(
                        minWidth: 200, maxWidth: 350, maxHeight: 73),
                    margin: const EdgeInsets.only(
                        top: 0, bottom: 0, right: 0, left: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: MyColor.red,
                      ),
                      color: MyColor.white1,
                    ),
                    child: SmartSelect<String>.single(
                      title: "المحافظة",
                      selectedValue: _gov,
                      choiceItems: governorates,
                      placeholder: "اختر المحافظة",
                      onChange: (selected) {
                        setState(() => _gov = selected.value);
                      },
                    ),
                  ),
                  if (_pic != null)
                    Container(
                        padding:
                            const EdgeInsets.only(right: 40, left: 40, top: 40),
                        child: Stack(
                          children: [
                            Image.file(File(_pic!.path)),
                            Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _pic = null;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Colors.red,
                                  )),
                            ),
                          ],
                        )),
                  Container(
                    constraints:
                        const BoxConstraints(minWidth: 200, maxWidth: 350),
                    padding:
                        const EdgeInsets.only(top: 10, right: 20, left: 20),
                    child: MaterialButton(
                        height: 45,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        color: MyColor.red,
                        onPressed: pickImage,
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "رفع صورة",
                              style: TextStyle(
                                  color: MyColor.turquoise,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ],
                        )),
                  ),
                  Container(
                    constraints:
                        const BoxConstraints(minWidth: 200, maxWidth: 350),
                    padding:
                        const EdgeInsets.only(top: 10, right: 20, left: 20),
                    child: MaterialButton(
                        height: 45,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        color: MyColor.red,
                        onPressed: pickCV,
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "رفع السيرة",
                              style: TextStyle(
                                  color: MyColor.turquoise,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ],
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: RoundedLoadingButton(
                      color: MyColor.red,
                      child: const Text("ارسال",
                          style: TextStyle(
                              color: MyColor.white0,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      valueColor: MyColor.turquoise,
                      successColor: MyColor.red,
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
          ),
        ),
      ),
    );
  }

  _formText(_control, _hintText) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(minWidth: 200, maxWidth: 350),
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 10,
        ),
        child: TextFormField(
          controller: _control,
          style: const TextStyle(
            color: MyColor.black,
          ),
          keyboardType: TextInputType.text,
          maxLines: null,
          textAlignVertical: TextAlignVertical.top,
          decoration: InputDecoration(
              //contentPadding: EdgeInsets.symmetric(vertical: 12.0),
              contentPadding: const EdgeInsets.all(12.0),
              hintText: _hintText,
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
          validator: (value) {
            var result = value!.length < 3 ? "املئ البيانات" : null;
            return result;
          },
        ),
      ),
    );
  }
}
