// ignore_for_file: prefer_const_constructors, unused_import, prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:secondhome2/screens/student/dashboard_student/subjects.dart';
import 'package:secondhome2/screens/student/dashboard_student/weekly_schedule.dart';
import 'package:secondhome2/screens/student/review/daily_review_date.dart';
import 'package:secondhome2/screens/student/widgets/item_main_menu.dart';

import '../../../api_connection/student/api_dashboard_data.dart';
import '../../../api_connection/student/api_notification.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/student/provider_notification.dart';
import '../../../provider/student/student_provider.dart';
import '../../../static_files/my_color.dart';
import '../../../static_files/my_loading.dart';
import 'chat/chat_main/chat_main.dart';
import 'exam_degree.dart';
import 'exam_schedule.dart';
import 'notification_all.dart';
import 'show/show_latest_news.dart';
import 'student_attend.dart';
import 'student_salary/student_salary.dart';
import '../review/review_date.dart';

class Dashboard extends StatefulWidget {
  final Map userData;
  const Dashboard({Key? key, required this.userData}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with AutomaticKeepAliveClientMixin {
  bool isVisible = false;
  @override
  bool get wantKeepAlive => true;

  _getStudentInfo() async {
    Map _data = {
      "study_year": Get.put(MainDataGetProvider()).mainData['setting'][0]
          ['setting_year'],
      "page": 0,
      "class_school": Get.put(MainDataGetProvider()).mainData['account']
          ['account_division_current']['_id'],
      "type": null,
    };
    await NotificationsAPI().getNotifications(_data);
  }

  @override
  void initState() {
    _getStudentInfo();
    DashboardDataAPI().latestNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final double data =
        // ignore: deprecated_member_use
        MediaQueryData.fromView(WidgetsBinding.instance.window)
            .size
            .shortestSide;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: ListView(
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.userData['account_name'].toString(),
                          style: const TextStyle(
                              color: MyColor.turquoise,
                              fontWeight: FontWeight.bold),
                        ),
                        GetBuilder<MainDataGetProvider>(
                            builder: (_mainDataProvider) =>
                                _mainDataProvider.mainData.isEmpty
                                    ? const Text("")
                                    : Text(
                                        _mainDataProvider.mainData['account']
                                                    ['account_division_current']
                                                    ['class_name']
                                                .toString() +
                                            " - " +
                                            _mainDataProvider
                                                .mainData['account']
                                                    ['account_division_current']
                                                    ['leader']
                                                .toString(),
                                        style: const TextStyle(
                                            color: MyColor.grayDark,
                                            fontWeight: FontWeight.bold),
                                      )),
                      ],
                    ),
                    const Spacer(),
                    GetBuilder<NotificationProvider>(builder: (_countNumber) {
                      FlutterAppBadger.updateBadgeCount(
                          _countNumber.countUnread);
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => NotificationAll(
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 16),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isVisible = !isVisible;
                      });
                    },
                    child: Icon(
                      Icons.menu,
                      color: Color(0xFFf4482d),
                      size: 40,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: isVisible,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: GetBuilder<MainDataGetProvider>(
                        builder: (val) {
                          return val.mainData.isEmpty
                              ? loading()
                              : AnimationLimiter(
                                  child: Container(
                                    width: Get.width,
                                    color: MyColor.turquoise2,
                                    child: GridView.count(
                                      shrinkWrap: true,
                                      crossAxisCount: 1,
                                      physics: const BouncingScrollPhysics(),
                                      childAspectRatio: 4,
                                      mainAxisSpacing: 10.0,
                                      crossAxisSpacing: 10.0,
                                      children: [
                                        SizedBox(
                                          height: 90,
                                          child: ItemMainMenu(
                                            img: "assets/img/study_table.png",
                                            nav: WeeklySchedule(),
                                            features: val.mainData['account']['school']['school_features']['features_schedule_weekly'],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 90,
                                          child: ItemMainMenu(
                                            img: "assets/img/dgrees.png",
                                            nav: ExamDegree(),
                                            features: val.mainData['account']
                                                        ['school']
                                                    ['school_features']
                                                ['features_degrees'],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 90,
                                          child: ItemMainMenu(
                                            img: "assets/img/table_exam.png",
                                            nav: ExamSchedule(),
                                            features: val.mainData['account']
                                                        ['school']
                                                    ['school_features']
                                                ['features_exams'],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 90,
                                          child: ItemMainMenu(
                                            img: "assets/img/atends.png",
                                            nav: StudentAttend(
                                                userData: widget.userData),
                                            features: val.mainData['account']
                                                        ['school']
                                                    ['school_features']
                                                ['features_absence'],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 90,
                                          child: ItemMainMenu(
                                            img: "assets/img/fees.png",
                                            nav: StudentSalary(),
                                            features: val.mainData['account']
                                                        ['school']
                                                    ['school_features']
                                                ['features_accountant'],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              GetBuilder<MainDataGetProvider>(
                builder: (val) {
                  return val.mainData.isEmpty
                      ? loading()
                      : AnimationLimiter(
                          child: GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 1,
                            physics: const BouncingScrollPhysics(),
                            childAspectRatio: 2,
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 10.0,
                            children: [
                              ItemMainMenu(
                                  img: "assets/img/my_day.png",
                                  nav: DailyReviewDate(),
                                  features: val.mainData['account']['school']
                                          ['school_features']
                                      ['features_notifications']),
                              ItemMainMenu(
                                  img: "assets/img/notifications.png",
                                  nav: NotificationAll(
                                    userData: widget.userData,
                                  ),
                                  features: val.mainData['account']['school']
                                          ['school_features']
                                      ['features_notifications']),
                              ItemMainMenu(
                                img: "assets/img/direct.png",
                                nav: const ChatMain(),
                                features: val.mainData['account']['school']
                                    ['school_features']['features_chat'],
                              ),
                              // ItemMainMenu(
                              //   img: "assets/img/dashboard/book.png",
                              //   nav: const SubjectsList(),
                              //   features: true,
                              // )
                            ],
                          ),
                        );
                },
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _container(String _t1, String _t2, String _img, Widget _nav, _width) {
    return GestureDetector(
      onTap: () {
        Get.to(() => _nav);
      },
      child: Container(
        height: 90,
        width: _width / 2.2,
        decoration: BoxDecoration(
          color: MyColor.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                padding: const EdgeInsets.all(4.0),
                child: FittedBox(
                  alignment: Alignment.centerRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _t1,
                        maxLines: 1,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: MyColor.white0),
                      ),
                      Text(
                        _t2,
                        maxLines: 1,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: MyColor.white0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                _img,
                //height: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
