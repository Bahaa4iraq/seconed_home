import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:get_storage/get_storage.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:secondhome2/screens/auth/accounts_screen.dart';
import 'package:secondhome2/screens/kindergarten_teacher/teacher_kindergarten_home.dart';
import 'package:secondhome2/screens/nursery_teacher/teacher_nursery_home.dart';

import '../../api_connection/auth_connection.dart';
import '../../provider/auth_provider.dart';
import '../../static_files/my_color.dart';
import '../nursery/nursery_home.dart';
import '../student/home_page_student.dart';

// import 'connectUs.dart';
// import 'requestCer.dart';
// import 'requestJop.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TokenProvider get tokenProvider => Get.put(TokenProvider());

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  bool isSwitched = false;

  final RoundedLoadingButtonController _btnController =
  RoundedLoadingButtonController();
  final _formCheck = GlobalKey<FormState>();
  // TextEditingController email = TextEditingController(text: 'lilian@secondhome.com'); // وردي
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  // TextEditingController email = TextEditingController();
  // TextEditingController pass = TextEditingController();
  var storage = GetStorage();
  Map? authData;

  shaConvert(_pass) {
    var bytes = utf8.encode(_pass);
    Digest sha512Result = sha512.convert(bytes);
    return sha512Result.toString();
  }

  _login() async {
    final box = GetStorage();
    Map _data = {
      "account_email": email.text,
      "account_password": shaConvert(pass.text),
      "auth_ip": authData!['query'].toString(),
      "auth_city":
      authData!['country'].toString() + authData!['city'].toString(),
      "auth_lon": authData!['lon'].toString(),
      "auth_lat": authData!['lat'].toString(),
      "auth_phone_details": await getDeviceInfo(),
      "auth_phone_id": await getPhoneId(),
      "auth_firebase": await FirebaseMessaging.instance.getToken()
    };

    if (_formCheck.currentState!.validate() && authData != null) {
      Auth().login(_data).then((res) async {
        if (!res['error']) {
          _btnController.success();
          await box.write('_userData', res['results']);
          Get.put(TokenProvider()).addToken(res['results']);
          if (res['results']["account_type"] == "student") {
            tokenProvider.addAccountToDatabase(res['results']);

            if (res['results']["is_kindergarten"]) {
              Get.offAll(() => HomePageStudent(userData: res['results']));
            }else{
              Get.offAll(() => HomePageNursery(userData: res['results']));
            }


          } else if (res['results']["account_type"] == "teacher") {
            tokenProvider.addAccountToDatabase(res['results']);

            if (res['results']["is_kindergarten"]) {
              Get.offAll(() => HomePageKindergartenTeacher(userData: res['results']));
            }else{
              Get.offAll(() => HomePageNurseryTeacher(userData: res['results']));
            }
          } else if (res['results']["account_type"] == "assistance") {
            // Timer(const Duration(seconds: 1), () {
            //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            //     return driver.HomePage(userData: res['results']);
            //   }));
            // });
          } else if (res['results']["account_type"] == "manager") {
            // Timer(const Duration(seconds: 1), () {
            //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            //     return manager.HomePage(userData: res['results']);
            //   }));
            // });
          } else {
            _btnController.error();
            EasyLoading.showError(res['message'].toString());
            Timer(const Duration(seconds: 2), () {
              _btnController.reset();
            });
          }
        } else {
          _btnController.error();
          EasyLoading.showError(res['message'].toString());
          Timer(const Duration(seconds: 2), () {
            _btnController.reset();
          });
        }
      });
    } else if (authData == null) {
      getIp();
      EasyLoading.showError("يوجد خطأ, الرجاء المحاولة مرة اخرى");
      _btnController.reset();
    } else {
      _btnController.reset();
    }
  }

  ///teacher@g.com
  getDeviceInfo() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return "${androidInfo.manufacturer}, ${androidInfo.brand}, ${androidInfo.model}, ${androidInfo.board}";
    } else if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return "${iosDeviceInfo.utsname.machine}, ${iosDeviceInfo.utsname.sysname}, ${iosDeviceInfo.model}";
    } else {
      return "NoData";
    }
  }

  getPhoneId() async {
    String? deviceId = await PlatformDeviceId.getDeviceId;
    return deviceId;
  }

  getIp() async {
    await GetStorage.init();
    Auth().getIp().then((res) {
      if (res['status'] == "success") {
        authData = res;
      }
    });
  }

  @override
  void initState() {
    getIp();
    super.initState();
  }

  bool _obscurePassword = true;

  changeObscurePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  late Future<int> indexUrl;
  @override
  Widget build(BuildContext context) {
    double width = Get.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        top: false,
        child: SingleChildScrollView(
          child: SizedBox(
            height: Get.height,
            child: Column(
              children: [

                Padding(
                  padding:  EdgeInsets.only(top: Get.height* .05),
                  child: Image.asset(
                    "assets/img/main.png",
                    height: Get.height * 0.3,

                  ),
                ),

                Form(
                  key: _formCheck,
                  child: Column(
                    children: [
                      // Text(storage.read("isNursery").toString()),
                      const Icon(
                        LineIcons.userAlt,
                        size: 40,
                        color: MyColor.turquoise,
                      ),
                      const Text(
                        "البريد الالكتروني",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: MyColor.turquoise),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, right: 20, left: 20),
                        child: TextFormField(
                          controller: email,
                          style: const TextStyle(
                            color: MyColor.black,
                          ),
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18.0, horizontal: 18),
                              //hintText: "الايميل",
                              errorStyle: const TextStyle(color: MyColor.grayDark),
                              fillColor: Colors.transparent,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(55.0),
                                borderSide: const BorderSide(
                                  color: MyColor.turquoise,
                                  width: 10,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100.0),
                                borderSide: const BorderSide(
                                    color: MyColor.turquoise, width: 3),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100.0),
                                borderSide: const BorderSide(
                                    color: MyColor.turquoise, width: 3),
                              ),
                              //prefixIcon: const Icon(LineIcons.user),
                              filled: true
                            //fillColor: Colors.green
                          ),
                          validator: (value) {
                            var result =
                            value!.length < 3 ? "املئ البيانات" : null;
                            return result;
                          },
                        ),
                      ),
                      const Icon(
                        LineIcons.lock,
                        size: 40,
                        color: MyColor.turquoise,
                      ),
                      const Text(
                        "كلمة السر",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: MyColor.turquoise),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, right: 20, left: 20),
                        child: TextFormField(
                          controller: pass,
                          style: const TextStyle(
                            color: MyColor.black,
                          ),
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18.0, horizontal: 18),
                              errorStyle: const TextStyle(color: MyColor.grayDark),
                              fillColor: Colors.transparent,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(55.0),
                                borderSide: const BorderSide(
                                  color: MyColor.turquoise,
                                  width: 10,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100.0),
                                borderSide: const BorderSide(
                                    color: MyColor.turquoise, width: 3),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100.0),
                                borderSide: const BorderSide(
                                    color: MyColor.turquoise, width: 3),
                              ),
                              //prefixIcon: const Icon(LineIcons.user),
                              filled: true
                            //fillColor: Colors.green
                          ),
                          obscureText: _obscurePassword,
                          validator: (value) {
                            var result =
                            value!.length < 4 ? "املئ البيانات" : null;
                            return result;
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: width / 2,
                    child: RoundedLoadingButton(
                      height: 56,
                      color: MyColor.turquoise,
                      valueColor: MyColor.white0,
                      successColor: MyColor.turquoise,
                      controller: _btnController,
                      onPressed: _login,
                      borderRadius: 50,
                      child: const Text(
                        "تسجيل الدخول",
                        style: TextStyle(
                            color: MyColor.white0,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Get.height * 0.06),
                _buttons("حساباتي",  AccountsScreen(),'assets/img/dashboard/group.svg',),

                // Container(
                //   padding:
                //       const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                //   child: Container(
                //     child: GestureDetector(
                //       onTap: () {
                //         print("forget password");
                //       },
                //       child: const Align(
                //         alignment: Alignment.centerLeft,
                //         child: Text(
                //           "نسيت كلمة المرور؟",
                //           style: TextStyle(
                //               color: MyColor.turquoise,
                //               fontSize: 20,
                //               fontWeight: FontWeight.bold),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buttons(_t, Widget _nav,String icon) {
    return SizedBox(
      height: 50 ,
      child: MaterialButton(
          color: MyColor.turquoise,
          elevation: 8,
          onPressed: () {
            Get.to(() => _nav);
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText(
                _t,
                maxFontSize: 15,
                minFontSize: 12,
                maxLines: 1,
                style: const TextStyle(color: MyColor.white0,fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10,),

              SvgPicture.asset(icon,height: 20,color: Colors.white,),
            ],
          )),
    );
  }

  txtFormField(TextEditingController _controller, String _hint) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 350),
      padding: const EdgeInsets.only(top: 15),
      // child: TextFormField(
      //   maxLines: 1,
      //   controller: _controller,
      //   cursorRadius: Radius.circular(16.0),
      //   //cursorWidth: 2.0,
      //   // inputFormatters: <TextInputFormatter>[
      //   //   FilteringTextInputFormatter.digitsOnly,
      //   // ],
      //   style: TextStyle(fontSize: 16),
      //   obscureText: _hint == "الرقم السري" ? true : false,
      //   autofocus: false,
      //   decoration: InputDecoration(
      //       labelText: _hint,
      //       contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10),
      //       fillColor: MyColor.c3,
      //       border: OutlineInputBorder(
      //         borderRadius: BorderRadius.circular(15.0),
      //         borderSide: BorderSide(
      //           color: MyColor.c3,
      //         ),
      //       ),
      //       enabledBorder: OutlineInputBorder(
      //         borderRadius: BorderRadius.circular(15.0),
      //         borderSide: BorderSide(
      //           color: MyColor.c3,
      //         ),
      //       ),
      //       focusedBorder: OutlineInputBorder(
      //         borderRadius: BorderRadius.circular(15.0),
      //         borderSide: BorderSide(
      //           color: MyColor.c3,
      //         ),
      //       ),
      //       errorBorder: OutlineInputBorder(
      //         borderRadius: BorderRadius.circular(15.0),
      //         borderSide: BorderSide(
      //           color: MyColor.c5,
      //         ),
      //       ),
      //       prefixIcon: _hint == "الرقم السري" ? Icon(LineIcons.lock) : Icon(LineIcons.user),
      //       filled: true
      //     //fillColor: Colors.green
      //   ),
      // ),
    );
  }

// ignore: non_constant_identifier_names
// void _LoginCheck() async {
//   Map _data = {
//     "username": user.text,
//     "password": pass.text
//   };
//   Auth().login(_data).then((response) {
//     if(response['error']==false) {
//       if(_saveData){
//         final box = GetStorage();
//         box.write('_token', response['accessToken']);
//         box.write('_userData', response['results']);
//       }
//       _btnController.success();
//       Timer(Duration(seconds: 1), () {
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
//           return Dashboard(token: response['accessToken'],userData: response['results']);
//         }));
//       });
//     }else{
//       _btnController.error();
//       Timer(Duration(seconds: 2), () {
//         _btnController.reset();
//       });
//     }
//   });
//   _btnController.reset();
//   // Timer(Duration(seconds: 3), () {
//   //   _btnController.success();
//   // });
// }
}