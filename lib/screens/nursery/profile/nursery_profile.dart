import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:line_icons/line_icons.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;
import 'package:secondhome2/provider/accounts_provider.dart';
import 'package:secondhome2/provider/student/provider_student_dashboard.dart';
import 'package:secondhome2/screens/auth/accounts_screen.dart';
import 'package:secondhome2/screens/auth/connect_us.dart';
import 'package:secondhome2/screens/auth/login_page.dart';
import 'package:secondhome2/screens/nursery/nursery_home.dart';
import 'package:secondhome2/screens/student/home_page_student.dart';

import '../../../api_connection/auth_connection.dart';
import '../../../api_connection/student/api_profile.dart';
import '../../../provider/auth_provider.dart';
import '../../../static_files/my_color.dart';
import '../../../static_files/my_loading.dart';
import '../../../static_files/my_package_info.dart';
import '../../../static_files/my_random.dart';
import '../../../static_files/my_times.dart';
import 'attach_documents.dart';

class StudentProfile extends StatefulWidget {
  final Map userData;

  const StudentProfile({Key? key, required this.userData}) : super(key: key);

  @override
  _StudentProfileState createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _zoomName = TextEditingController();
  final _formCheck = GlobalKey<FormState>();
  final AccountProvider accountProvider = Get.put(AccountProvider());

  TokenProvider get tokenProvider => Get.put(TokenProvider());

  onOtherAccountFound(Map<String, dynamic> account) async {
    await accountProvider.onClickAccount(account);
    tokenProvider.addToken(account);
    Get.delete<StudentDashboardProvider>();
    if (account["is_kindergarten"]) {
      Get.offAll(() => HomePageStudent(userData: account));
    } else {
      Get.offAll(() => HomePageNursery(userData: account));
    }
  }

  @override
  bool get wantKeepAlive => true;

  pickImage() async {
    EasyLoading.show(status: "جار التحميل...");
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      XFile file = XFile(result.files.single.path!);
      compressAndGetFile(file, p.dirname(file.path)).then((value) {
        dio.FormData _data = dio.FormData.fromMap({
          "account_img": dio.MultipartFile.fromFileSync(value!.path,
              filename: 'pic.jpg', contentType: MediaType('image', 'jpg')),
          "account_img_old": Get.put(MainDataGetProvider()).mainData['account']
              ['account_img']
        });
        StudentProfileAPI().editImgProfile(_data).then((res) async {
          if (res['error'] == false) {
            await Auth().getStudentInfo();
            EasyLoading.showSuccess("تم تغيير الصورة بنجاح");
          } else {
            EasyLoading.showError("يوجد خطأ ما");
          }
        });
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      // User canceled the picker
    }
  }

  Future<XFile?> compressAndGetFile(XFile file, String targetPath) async {
    String getRand = RandomGen().getRandomString(5);
    var result = await FlutterImageCompress.compressAndGetFile(
        file.path, "$targetPath/img_$getRand.jpg",
        quality: 40);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColor.pink,
          title: const Text(
            "الملف الشخصي",
            style: TextStyle(color: MyColor.white0),
          ),
          iconTheme: const IconThemeData(
            color: MyColor.white0,
          ),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Get.defaultDialog(
                  title: "تسجيل خروج",
                  content: const Text(
                    "هل انت متأكد من عملية تسجيل الخروج؟",
                  ),
                  cancel: MaterialButton(
                    color: MyColor.pink,
                    onPressed: () => Get.back(),
                    child: const Text(
                      "الغاء",
                      style: TextStyle(color: MyColor.white0),
                    ),
                  ),
                  confirm: MaterialButton(
                    color: MyColor.pink,
                    onPressed: () {
                      Auth().loginOut().then((res) async{
                        if (res['error'] == false) {
                          await accountProvider
                              .deleteAccount(widget.userData['account_email']);
                          if (accountProvider.accounts.firstOrNull != null) {
                            onOtherAccountFound(
                                accountProvider.accounts.first.toMap());
                          } else {
                            Get.offAll(() => const LoginPage());
                            Get.delete<StudentDashboardProvider>();
                            FlutterAppBadger.removeBadge();
                            EasyLoading.showSuccess(res['message'].toString());
                          }
                        } else {
                          EasyLoading.showError(res['message'].toString());
                        }
                      });
                    },
                    child: const Text(
                      "تأكيد",
                      style: TextStyle(color: MyColor.white0),
                    ),
                  ),
                );
              },
            )
          ],
          leading: Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                shape: BoxShape.rectangle),
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                child: GetBuilder<MainDataGetProvider>(builder: (_) {
                  return _.mainData.isEmpty
                      ? Container()
                      : CachedNetworkImage(
                          imageUrl: _.contentUrl +
                              _.mainData['account']['school']['school_logo'],
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        );
                })),
          ),
        ),
        body: GetBuilder<MainDataGetProvider>(builder: (_) {
          return _.mainData.isEmpty
              ? loading()
              : ListView(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AutoSizeText(
                                  "الطالب",
                                  maxLines: 1,
                                  minFontSize: 15,
                                  maxFontSize: 20,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: MyColor.black),
                                ),
                                AutoSizeText(
                                  widget.userData['account_name'].toString(),
                                  maxLines: 1,
                                  minFontSize: 15,
                                  maxFontSize: 20,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: MyColor.pink),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: [
                              _.mainData.isEmpty
                                  ? Container(
                                      width: Get.width / 4,
                                      height: Get.width / 4,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1.5, color: MyColor.pink),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10.0)),
                                          shape: BoxShape.rectangle),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10.0)),
                                        child: Image.asset(
                                            "assets/img/graduated.png"),
                                      ),
                                    )
                                  : _.mainData['account']['account_img'] == null
                                      ? Container(
                                          width: Get.width / 4,
                                          height: Get.width / 4,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1.5,
                                                  color: MyColor.grayDark),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10.0)),
                                              shape: BoxShape.rectangle),
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10.0)),
                                            child: Image.asset(
                                                "assets/img/graduated.png"),
                                          ),
                                        )
                                      : Container(
                                          width: Get.width / 4,
                                          height: Get.width / 4,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1.5,
                                                  color: MyColor.red),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10.0)),
                                              shape: BoxShape.rectangle),
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10.0)),
                                            child: CachedNetworkImage(
                                              imageUrl: _.contentUrl +
                                                  _.mainData['account']
                                                      ['account_img'],
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  const CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                              TextButton(
                                onPressed: () {
                                  pickImage();
                                },
                                child: const AutoSizeText(
                                  "تعديل الصورة",
                                  maxLines: 1,
                                  minFontSize: 15,
                                  maxFontSize: 20,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: MyColor.pink, fontSize: 18),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (_.mainData['account']["account_division_current"]
                            ['class_name'] !=
                        null)
                      _text(
                          "الصف",
                          _.mainData['account']["account_division_current"]
                              ['class_name']),
                    _text(
                        "الشعبة",
                        _.mainData['account']["account_division_current"]
                            ['leader']),
                    if (widget.userData['account_birthday'] != null)
                      _text("الميلاد",
                          fromISOToDate(widget.userData['account_birthday'])),
                    if (widget.userData['account_mobile'] != null)
                      _text("الهاتف",
                          widget.userData['account_mobile'].toString()),
                    _text(
                        "الايميل", widget.userData['account_email'].toString()),
                    FutureBuilder<String>(
                      future: packageInfo(), // async work
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Text('Loading....');
                          default:
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return _text("الاصدار", '${snapshot.data}');
                            }
                        }
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ///AttachDocuments()
                        _buttons("المستمسكات", const AttachDocuments(),
                            LineIcons.upload, true),
                        _buttons(
                            "الحسابات",
                            AccountsScreen(
                              backgroundColor: MyColor.pink,
                              foregroundColor: MyColor.white0,
                            ),
                            LineIcons.fileInvoice,
                            true),

                        _buttons(
                            "اتصل بنا",
                            const ConnectUs(
                              color: MyColor.pink,
                            ),
                            LineIcons.phone,
                            true),

                        // ///Reports()
                        // _buttons("reports", Reports(), LineIcons.fileInvoice,true),
                      ],
                    ),
                    // Container(
                    //   padding: const EdgeInsets.only(right: 20, left: 20),
                    //   child: _buttonsSession("activeSession", ActiveSession()),
                    // )
                  ],
                );
        }));
  }

  _buttons(_t, Widget _nav, _icon, bool enable) {
    return SizedBox(
      width: Get.width / 2.5,
      child: MaterialButton(
          color: MyColor.pink,
          elevation: 0,
          onPressed: enable
              ? () {
                  Get.to(() => _nav);
                }
              : null,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          child: Row(
            children: [
              AutoSizeText(
                _t,
                maxFontSize: 14,
                minFontSize: 11,
                maxLines: 1,
                style: const TextStyle(color: MyColor.white0),
              ),
              const Spacer(),
              Icon(
                _icon,
                color: MyColor.white0,
              )
            ],
          )),
    );
  }

  _buttonsSession(_t, Widget _nav) {
    return SizedBox(
      width: Get.width / 2.5,
      child: MaterialButton(
        color: MyColor.pink,
        elevation: 0,
        onPressed: () {
          Get.to(() => _nav);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        child: AutoSizeText(
          _t,
          maxFontSize: 14,
          minFontSize: 11,
          maxLines: 1,
          style: const TextStyle(color: MyColor.white0),
        ),
      ),
    );
  }

  _text(String _first, String _second) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: RichText(
        text: TextSpan(
            text: _first,
            style: const TextStyle(color: Colors.black, fontSize: 17),
            children: <TextSpan>[
              TextSpan(
                text: " : ",
                style: const TextStyle(color: MyColor.pink, fontSize: 17),
              ),
              TextSpan(
                text: _second,
                style: const TextStyle(color: MyColor.pink, fontSize: 17),
              ),
            ]),
      ),
    );
  }
}
