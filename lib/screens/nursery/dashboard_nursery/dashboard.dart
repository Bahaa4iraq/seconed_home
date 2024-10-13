import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../api_connection/student/api_dashboard_data.dart';
import '../../../api_connection/student/api_notification.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/student/provider_notification.dart';
import '../../../provider/student/student_provider.dart';
import '../../../static_files/my_color.dart';
import '../../../static_files/my_loading.dart';
import '../review/daily_review_date.dart';
import 'chat/chat_main/chat_main.dart';
import 'chothes.dart';
import 'food.dart';
import 'nappy.dart';
import 'notification_all.dart';
import 'nursery_attend.dart';
import 'show/show_latest_news.dart';
import 'sleep.dart';
import 'training.dart';

class Dashboard extends StatefulWidget {
  final Map userData;
  const Dashboard({super.key, required this.userData});
  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  int latestNewsCurrentIndex = 0;

  _getStudentInfo() async {
    Map data = {
      "study_year": Get.put(MainDataGetProvider()).mainData['setting'][0]
          ['setting_year'],
      "page": 0,
      "class_school": Get.put(MainDataGetProvider()).mainData['account']
          ['account_division_current']['_id'],
      "type": null,
    };
    await NotificationsAPI().getNotifications(data);
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
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, right: 16, left: 16),
              child: Row(
                children: [
                  GetBuilder<MainDataGetProvider>(builder: (mainDataProvider) {
                    return GestureDetector(
                      child: Container(
                        width: 55,
                        height: 55,
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            shape: BoxShape.rectangle),
                        child: mainDataProvider.mainData.isEmpty
                            ? Container()
                            : ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0)),
                                child: CachedNetworkImage(
                                  imageUrl: mainDataProvider.contentUrl +
                                      mainDataProvider.mainData["account"]
                                          ['school']['school_logo'],
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                )),
                      ),
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
                            color: MyColor.pink,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      GetBuilder<MainDataGetProvider>(
                          builder: (mainDataProvider) =>
                              mainDataProvider.mainData.isEmpty
                                  ? const Text("")
                                  : Text(
                                      "${mainDataProvider.mainData['account']['account_division_current']['class_name']} - ${mainDataProvider.mainData['account']['account_division_current']['leader']}",
                                      style: const TextStyle(
                                          color: MyColor.grayDark,
                                          fontWeight: FontWeight.bold),
                                    )),
                    ],
                  ),
                  const Spacer(),
                  GetBuilder<NotificationProvider>(builder: (countNumber) {
                    FlutterAppBadger.updateBadgeCount(countNumber.countUnread);
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => NotificationAll(
                              userData: widget.userData,
                            ));
                      },
                      child: Container(
                          child: countNumber.countUnread == 0
                              ? const Icon(Icons.notifications,
                                  color: MyColor.pink, size: 40)
                              : Stack(
                                  children: <Widget>[
                                    const Icon(Icons.notifications,
                                        color: MyColor.pink, size: 40),
                                    Positioned(
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(1),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 12,
                                          minHeight: 12,
                                        ),
                                        child: Text(
                                          countNumber.countUnread.toString(),
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
            const SizedBox(height: 16),
            GetBuilder<LatestNewsProvider>(
                builder: (data) => data.newsData.isEmpty
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
                                return InkWell(
                                    onTap: () {
                                      Get.to(() => ShowLatestNews(
                                            data: data.newsData[index],
                                            //tag: _data.newsData[index]['latest_news_img'],
                                          ));
                                    },
                                    child: Stack(
                                      children: [
                                        Center(
                                            child: SvgPicture.asset(
                                                "assets/img/dashboard/k_background_news.svg",
                                                fit: BoxFit.fill)),
                                        data.newsData[index]
                                                    ['latest_news_title'] ==
                                                null
                                            ? Container()
                                            : Positioned(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2,
                                                right: 16,
                                                top: 0,
                                                bottom: 0,
                                                child: Center(
                                                  child: SizedBox(
                                                      width: 120,
                                                      child: Text(
                                                        data.newsData[index][
                                                            'latest_news_title'],
                                                        style: const TextStyle(
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                MyColor.white0),
                                                        textAlign:
                                                            TextAlign.center,
                                                      )),
                                                ),
                                              )
                                      ],
                                    ));
                              },
                              loop: false,
                              itemCount: data.newsData.length,
                              viewportFraction: 1,
                              scale: 0.9,
                            ),
                          )
                        ],
                      )),
            const SizedBox(height: 20),
            GetBuilder<MainDataGetProvider>(builder: (val) {
              return val.mainData.isEmpty
                  ? loading()
                  : AnimationLimiter(
                      child: GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        physics: const BouncingScrollPhysics(),
                        childAspectRatio: 0.9,
                        padding:
                            const EdgeInsets.only(top: 15, right: 24, left: 24),
                        mainAxisSpacing: 24.0,
                        crossAxisSpacing: 10.0,
                        children: [
                          _gridContainer(
                              "غفوة",
                              "assets/img/dashboard/k_sleep.svg",
                              const Sleep(),
                              val.mainData['account']['school']
                                      ['school_features']
                                  ['features_notifications']),
                          _gridContainer(
                              "العناية بالطفل",
                              "assets/img/dashboard/k_nappy.svg",
                              const Nappy(),
                              val.mainData['account']['school']
                                      ['school_features']
                                  ['features_notifications']),
                          _gridContainer(
                              "الحضور",
                              "assets/img/dashboard/k_attend.svg",
                              StudentAttend(
                                  userData: widget.userData), //ExamDegree(),
                              val.mainData['account']['school']
                                  ['school_features']['features_absence']),
                          _gridContainer(
                              "غذاء",
                              "assets/img/dashboard/k_food.svg",
                              const Food(),
                              val.mainData['account']['school']
                                      ['school_features']
                                  ['features_notifications']),
                          _gridContainer(
                              "تدريب",
                              "assets/img/dashboard/k_lessons.svg",
                              const Training(),
                              val.mainData['account']['school']
                                      ['school_features']
                                  ['features_notifications']),
                          _gridContainer(
                              "يومي",
                              "assets/img/dashboard/k_traning.svg",
                              const DailyReviewDate(),
                              val.mainData['account']['school']
                                  ['school_features']['features_review']),
                          _gridContainer(
                              "المحادثة",
                              "assets/img/dashboard/k_chat.svg",
                              const ChatMain(),
                              val.mainData['account']['school']
                                  ['school_features']['features_chat']),
                          _gridContainer(
                              'ملابس',
                              "assets/img/dashboard/k_clothes.svg",
                              const Clothes(),
                              val.mainData['account']['school']
                                      ['school_features']
                                  ['features_notifications']),
                          _gridContainer(
                              "اشعارات",
                              "assets/img/dashboard/k_notifications.svg",
                              NotificationAll(
                                userData: widget.userData,
                              ),
                              val.mainData['account']['school']
                                      ['school_features']
                                  ['features_notifications']),
                        ],
                      ),
                    );
            }),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  int index = 0;

  _gridContainer(t, img, Widget nav, bool features) {
    return AnimationConfiguration.staggeredGrid(
      position: index++,
      duration: const Duration(milliseconds: 375),
      columnCount: 9,
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: ScaleAnimation(
          child: GestureDetector(
            onTap: () {
              if (features) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => nav),
                );
                // Get.to(() => _nav);
              } else {
                // featureAttention();
              }
            },
            child: Center(
              child: SizedBox(
                width: Get.width * .35,
                child: Column(
                  children: [
                    Expanded(
                        child: AspectRatio(
                      aspectRatio: 1,
                      child: SvgPicture.asset(
                        img,
                      ),
                    )),
                    Container(
                      padding: const EdgeInsets.only(top: 16),
                      child: AutoSizeText(
                        t,
                        maxLines: 1,
                        minFontSize: 12,
                        maxFontSize: 22,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: MyColor.pink,
                            fontStyle: FontStyle.italic),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
