// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, no_leading_underscores_for_local_identifiers, unused_element, deprecated_member_use

import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:secondhome2/screens/kindergarten_teacher/profile.dart';

import '../../api_connection/student/api_dashboard_data.dart';
import '../../api_connection/teacher/api_notification.dart';
import '../../provider/auth_provider.dart';
import '../../provider/student/student_provider.dart';
import '../../provider/teacher/provider_notification.dart';
import '../../static_files/my_color.dart';
import '../student/dashboard_student/live_education/live_education.dart';
import 'chat/chat_main/chat_main.dart';
import 'live_education/live_education.dart';
import 'pages/degree/degree_choice.dart';
import 'pages/exam_schedule.dart';
import 'pages/notifications/notification_all.dart';
import 'pages/show_latest_news.dart';
import 'pages/teacher_attend.dart';
import 'pages/teacher_salary/teacher_salary.dart';
import 'pages/teacher_weekly_schedule.dart';

class TeacherDashboard extends StatefulWidget {
  final Map userData;
  const TeacherDashboard({Key? key, required this.userData}) : super(key: key);
  @override
  _TeacherDashboardState createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> with AutomaticKeepAliveClientMixin {
  final Map? dataProvider = Get.put(TokenProvider()).userData;
  final LatestNewsProvider latestNewsProvider = Get.put(LatestNewsProvider());
  List accountDivisionList = [];

  @override
  bool get wantKeepAlive => true;


  _getTeacherInfo() async {
    Map _data = {
      "study_year": Get.put(MainDataGetProvider()).mainData['setting'][0]['setting_year'],
      "page": 0,
      "class_school": accountDivisionList,
      "type": null,
    };
    await NotificationsAPI().getNotifications(_data);
  }

  @override
  void initState() {
    for (Map accountDivision in Get.put(MainDataGetProvider()).mainData['account']
    ['account_division']) {
      accountDivisionList.add(accountDivision['_id']);
    }
    _getTeacherInfo();
    DashboardDataAPI().latestNews();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final double data =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window)
            .size
            .shortestSide;
    return Scaffold(
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: GetBuilder<MainDataGetProvider>(
                builder: (_) => ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        children: [
                          GetBuilder<MainDataGetProvider>(
                              builder: (_mainDataProvider) {
                                return Container(
                                  width: 60,
                                  height: 60,
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                      shape: BoxShape.rectangle),
                                  child: _mainDataProvider.mainData.isEmpty
                                      ? Container()
                                      : ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(30.0)),
                                      child: CachedNetworkImage(
                                        imageUrl: _mainDataProvider.contentUrl +
                                            _mainDataProvider.mainData["account"]
                                            ['school']['school_logo'],
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                      )),
                                );
                              }),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.userData['account_name'].toString(),
                            style: const TextStyle(
                                color: MyColor.turquoise,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          GetBuilder<TeacherNotificationProvider>(builder: (_countNumber) {
                            FlutterAppBadger.updateBadgeCount(
                                _countNumber.countUnread);
                            return GestureDetector(
                              onTap: () {
                                Get.to(() => NotificationTeacherAll(
                                  userData: widget.userData,
                                ));
                              },
                              child: Container(
                                  child: _countNumber.countUnread == 0
                                      ? const Icon(
                                    LineIcons.bell,
                                    color: MyColor.red,
                                    size: 40,
                                  )
                                      : Stack(
                                    children: <Widget>[
                                      const Icon(
                                        Icons.notifications,
                                        color: MyColor.red,
                                        size: 40,
                                      ),
                                      Positioned(
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(1),
                                          decoration: BoxDecoration(
                                            color: MyColor.turquoise,
                                            borderRadius:
                                            BorderRadius.circular(6),
                                          ),
                                          constraints: const BoxConstraints(
                                            minWidth: 12,
                                            minHeight: 12,
                                          ),
                                          child: Text(
                                            _countNumber.countUnread.toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 8,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            );
                          })
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    GetBuilder<LatestNewsProvider>(
                        builder: (_data) => _data.newsData.isEmpty
                            ? Container()
                            : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: Get.height / 5,
                              child: Swiper(
                                itemBuilder: (BuildContext context, int index) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: InkWell(
                                        onTap: () {
                                          Get.to(() => ShowLatestNews(
                                            data: _data.newsData[index],
                                            //tag: _data.newsData[index]['latest_news_img'],
                                          ));
                                        },
                                        child:
                                        Container(
                                          width: Get.width,
                                          decoration: BoxDecoration(
                                              color: MyColor.turquoise2,
                                              borderRadius: BorderRadius.circular(100)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                            child: Row(
                                              children: [
                                                _data.newsData[index]['latest_news_title'] == null
                                                    ? Container()
                                                    : Expanded(
                                                  child: Center(
                                                    child: SizedBox(
                                                        width: 120,
                                                        child: Text(
                                                          _data.newsData[index]['latest_news_title'],
                                                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: MyColor.white0),
                                                          textAlign: TextAlign.center,
                                                        )),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                  child: Image.asset("assets/img/ايكونه تطبيق 1.png"),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                    ),
                                  );
                                },
                                loop: false,
                                itemCount: _data.newsData.length,
                                viewportFraction: 1,
                                scale: 0.9,
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(thickness: 2,color: MyColor.turquoise),
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      physics: const BouncingScrollPhysics(),
                      childAspectRatio: 1.1,
                      padding: const EdgeInsets.only(top: 15),
                      mainAxisSpacing: 16.0,
                      crossAxisSpacing: 10.0,
                      children: [
                        ///Announcement()
                        _gridContainer(
                            "المحادثة",
                            "assets/img/dashboard/d-notification.png",
                            const ChatMain()),

                        ///Salary()
                        _gridContainer(
                            "الراتب",
                            "assets/img/dashboard/salary.png",
                            const TeacherSalary()),

                        ///TeacherAttend(userData: widget.userData)
                        _gridContainer(
                            "الحضور",
                            "assets/img/dashboard/Attendees.png",
                            TeacherAttend(userData: widget.userData)),

                        ///ShowNotification()
                        _gridContainer(
                            "الاشعارات",
                            "assets/img/dashboard/s-notification.png",
                            NotificationTeacherAll(
                              userData: widget.userData,
                            )),

                        ///ExamTable()
                        _gridContainer(
                            "جدول الامتحانات",
                            "assets/img/dashboard/s-table.png",
                            const TeacherExamSchedule()), //s-notification
                        ///ELearning()
                        _gridContainer(
                            "التعليم الالكتروني",
                            "assets/img/dashboard/live.png",
                            NotificationTeacherLiveEducation(userData: widget.userData,)
                        ),

                        ///DegreeList(()
                        _gridContainer(
                            "الدرجات",
                            "assets/img/dashboard/marks2.png",
                            const DegreeChoice()),

                        ///StudyTable()
                        _gridContainer(
                            "الجدول الاسبوعي",
                            "assets/img/dashboard/s-tables.png",
                            const TeacherWeeklySchedule()),

                        ///HomeWork()
                        _gridContainer(
                            "حساب الاستاذ",
                            "assets/img/graduated.png",
                            TeacherProfile(
                              userData: widget.userData,
                            )),
                      ],
                    ),
                    const SizedBox(height: 30)
                  ],
                )),
          ),
        ));
  }

  Widget _gridContainer(_t, _img, Widget _nav) {
    return GestureDetector(
      onTap: () {
        Get.to(() => _nav);
      },
      child: Container(
        decoration: BoxDecoration(
          color: MyColor.turquoise,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 9,
              child: Padding(
                padding: const EdgeInsets.only(right: 25, left: 25, top: 20),
                child: Image.asset(
                  _img,
                  height: 40,
                  color: MyColor.white0,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                child: AutoSizeText(
                  _t,
                  maxLines: 1,
                  minFontSize: 12,
                  maxFontSize: 25,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: MyColor.white0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttons(_t, Widget? _nav, _icon) {
    return SizedBox(
      width: Get.width / 2.5,
      child: MaterialButton(
          color: MyColor.red,
          textColor: MyColor.turquoise,
          elevation: 0,
          onPressed: () {
            if (_nav != null) {
              Get.to(() => _nav);
            }
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          child: Row(
            children: [
              AutoSizeText(
                _t,
                maxFontSize: 14,
                minFontSize: 11,
                maxLines: 1,
              ),
              const Spacer(),
              Icon(
                _icon,
                color: MyColor.turquoise,
              )
            ],
          )),
    );
  }

  // Widget _header(Map _data, String _contentUrl) {
  //   return Container(
  //     padding: const EdgeInsets.all(20),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               const AutoSizeText(
  //                 "الاستاذ",
  //                 maxLines: 1,
  //                 minFontSize: 15,
  //                 maxFontSize: 20,
  //                 overflow: TextOverflow.ellipsis,
  //                 style: TextStyle(
  //                     fontSize: 20,
  //                     fontWeight: FontWeight.bold,
  //                     color: MyColor.black),
  //               ),
  //               AutoSizeText(
  //                 widget.userData['account_name'].toString(),
  //                 maxLines: 1,
  //                 minFontSize: 15,
  //                 maxFontSize: 20,
  //                 overflow: TextOverflow.ellipsis,
  //                 style: const TextStyle(
  //                     fontSize: 20,
  //                     fontWeight: FontWeight.bold,
  //                     color: MyColor.turquoise),
  //               ),
  //             ],
  //           ),
  //         ),
  //         const SizedBox(
  //           width: 20,
  //         ),
  //         Column(
  //           children: [
  //             _data.isEmpty
  //                 ? Container(
  //                     width: Get.width / 4,
  //                     height: Get.width / 4,
  //                     decoration: BoxDecoration(
  //                         border:
  //                             Border.all(width: 1.5, color: MyColor.grayDark),
  //                         borderRadius:
  //                             const BorderRadius.all(Radius.circular(10.0)),
  //                         shape: BoxShape.rectangle),
  //                     child: ClipRRect(
  //                       borderRadius:
  //                           const BorderRadius.all(Radius.circular(10.0)),
  //                       child: Image.asset("assets/img/graduated.png"),
  //                     ),
  //                   )
  //                 : _data['account']['account_img'] == null
  //                     ? Container(
  //                         width: Get.width / 4,
  //                         height: Get.width / 4,
  //                         decoration: BoxDecoration(
  //                             border: Border.all(
  //                                 width: 1.5, color: MyColor.grayDark),
  //                             borderRadius:
  //                                 const BorderRadius.all(Radius.circular(10.0)),
  //                             shape: BoxShape.rectangle),
  //                         child: ClipRRect(
  //                           borderRadius:
  //                               const BorderRadius.all(Radius.circular(10.0)),
  //                           child: Image.asset("assets/img/graduated.png"),
  //                         ),
  //                       )
  //                     : Container(
  //                         width: Get.width / 4,
  //                         height: Get.width / 4,
  //                         decoration: BoxDecoration(
  //                             border: Border.all(
  //                                 width: 1.5, color: MyColor.grayDark),
  //                             borderRadius:
  //                                 const BorderRadius.all(Radius.circular(10.0)),
  //                             shape: BoxShape.rectangle),
  //                         child: ClipRRect(
  //                           borderRadius:
  //                               const BorderRadius.all(Radius.circular(10.0)),
  //                           child: CachedNetworkImage(
  //                             imageUrl:
  //                                 _contentUrl + _data['account']['account_img'],
  //                             fit: BoxFit.cover,
  //                             placeholder: (context, url) => const Row(
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               crossAxisAlignment: CrossAxisAlignment.center,
  //                               mainAxisSize: MainAxisSize.min,
  //                               children: [
  //                                 CircularProgressIndicator(),
  //                               ],
  //                             ),
  //                             errorWidget: (context, url, error) =>
  //                                 const Icon(Icons.error),
  //                           ),
  //                         ),
  //                       ),
  //             TextButton(
  //               onPressed: () {
  //                 pickImage();
  //               },
  //               child: const AutoSizeText(
  //                 "تغيير الصورة",
  //                 maxLines: 1,
  //                 minFontSize: 15,
  //                 maxFontSize: 20,
  //                 overflow: TextOverflow.ellipsis,
  //                 style: TextStyle(color: MyColor.turquoise, fontSize: 18),
  //               ),
  //             )
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
