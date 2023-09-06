// ignore_for_file: unused_import, library_private_types_in_public_api, no_leading_underscores_for_local_identifiers, avoid_print

import 'package:auto_animated/auto_animated.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:logger/logger.dart';
import 'package:secondhome2/screens/student/dashboard_student/daily_exams.dart';
import 'package:secondhome2/screens/student/dashboard_student/show/show_latest_news.dart';
import 'package:secondhome2/screens/student/dashboard_student/show/show_news_notification.dart';
import 'package:secondhome2/screens/student/dashboard_student/student_salary/student_salary_details.dart';
import 'package:secondhome2/screens/student/dashboard_student/test_home_work.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../api_connection/student/api_notification.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/student/provider_notification.dart';
import '../../../static_files/my_color.dart';
import '../../../static_files/my_loading.dart';
import '../../../static_files/my_times.dart';
import 'homeworks.dart';
import 'show/show_message.dart';
import 'student_attend.dart';
import 'student_salary/student_salary.dart';

class NotificationAll extends StatefulWidget {
  final Map userData;
  const NotificationAll({Key? key, required this.userData}) : super(key: key);

  @override
  _NotificationAllState createState() => _NotificationAllState();
}

class _NotificationAllState extends State<NotificationAll> {
  final ScrollController _scrollController = ScrollController();
  final MainDataGetProvider _mainDataGetProvider =
      Get.put(MainDataGetProvider());
  final NotificationProvider _notificationProvider =
      Get.put(NotificationProvider());
  int page = 0;
  String? type;
  dynamic typeList = [
    "رسالة",
    "ملخص",
    "واجب بيتي",
    "امتحان يومي",
    "هل تعلم",
    "اقساط",
    "الميلاد"
  ];
  initFunction() {
    Map _data = {
      "study_year": _mainDataGetProvider.mainData['setting'][0]['setting_year'],
      "page": page,
      "class_school": _mainDataGetProvider.mainData['account']
          ['account_division_current']['_id'],
      "type": type == "هل تعلم" ? "تقرير" : type,
      "isRead": _notificationProvider.isRead
    };
    NotificationsAPI().getNotifications(_data);
  }

  final options = const LiveOptions(
    // Show each item through (default 250)
    showItemInterval: Duration(milliseconds: 100),

    // Animation duration (default 250)
    showItemDuration: Duration(milliseconds: 200),

    // Animations starts at 0.05 visible
    // item fraction in sight (default 0.025)
    visibleFraction: 0.025,

    // Repeat the animation of the appearance
    // when scrolling in the opposite direction (default false)
    // To get the effect as in a showcase for ListView, set true
    reAnimateOnVisibility: true,
  );
  @override
  void dispose() {
    _notificationProvider.remove();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    initFunction();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        EasyLoading.show(status: "جار جلب البيانات");
        page++;
        initFunction();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.turquoise,
        title: const Text(
          "الاشعارات",
          style: TextStyle(color: MyColor.white0),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: MyColor.white0,
        ),
        elevation: 0,
        actions: [
          GetBuilder<NotificationProvider>(builder: (val) {
            print("all data===============");
            print('isRead'+ '${val.isRead}');
            return IconButton(
              onPressed: () {
                if (val.isRead == null) {
                  val.changeRead(true);
                } else if (val.isRead == true) {
                  val.changeRead(false);
                } else {
                  val.changeRead(null);
                }
                page = 0;
                val.remove();
                EasyLoading.show(status: "جار جلب البيانات");
                initFunction();
              },
              icon: val.isRead == null
                  ? const Icon(CommunityMaterialIcons.eye_off_outline)
                  : val.isRead == true
                      ? const Icon(CommunityMaterialIcons.eye_check_outline)
                      : const Icon(CommunityMaterialIcons.eye_remove_outline),
            );
          })
        ],
      ),
      body: GetBuilder<NotificationProvider>(
          builder: (val) => Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _button(null),
                        for (int i = 0; i < typeList.length; i++)
                          _button(typeList[i]),
                      ],
                    ),
                  ),
                  Expanded(
                    child: val.isLoading
                        ? loading()
                        : val.data.isEmpty
                            ? EmptyWidget(
                                image: null,
                                packageImage: PackageImage.Image_1,
                                title: 'لاتوجد اشعارات',
                                subTitle: 'لم يتم اضافة اشعار خاص بك',
                                titleTextStyle: const TextStyle(
                                  fontSize: 22,
                                  color: Color(0xff9da9c7),
                                  fontWeight: FontWeight.w500,
                                ),
                                subtitleTextStyle: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xffabb8d6),
                                ),
                              )
                            //start summery

                            : isSummery == "ملخص"
                                ? Column(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                            color: MyColor.turquoise2,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15))),
                                        margin: const EdgeInsets.only(
                                            top: 20, left: 5, right: 5),
                                        padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 15,
                                            bottom: 15),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Link",
                                              style: TextStyle(
                                                  color: MyColor.white0),
                                            ),
                                            Text(
                                              "Notes",
                                              style: TextStyle(
                                                  color: MyColor.white0),
                                            ),
                                            Text(
                                              "Subject",
                                              style: TextStyle(
                                                  color: MyColor.white0),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: LiveList.options(
                                            itemBuilder: animationItemBuilder(
                                              (ind) {
                                                return InkWell(
                                                  onTap: () {
                                                    _navPage(val.data[ind],
                                                        val.contentUrl);
                                                  },
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 5,
                                                            right: 5,
                                                            bottom: 5,
                                                            top: 5),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10,
                                                        vertical: 15),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  20)),
                                                      color: MyColor.white0,
                                                      border: Border.all(
                                                          width: 1.5,
                                                          color: MyColor.green,
                                                          style: BorderStyle
                                                              .solid),
                                                    ),
                                                    width: 100,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Icon(
                                                          Icons.link_rounded,
                                                          color: Colors.grey,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            val.data[ind][
                                                                    "notifications_description"]
                                                                .toString(),
                                                            style: const TextStyle(
                                                                color: MyColor
                                                                    .grayDark),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 5),
                                                          decoration: const BoxDecoration(
                                                              border: Border(
                                                                  right: BorderSide(
                                                                      color: MyColor
                                                                          .green))),
                                                          child: Text(
                                                            val.data[ind][
                                                                    "notifications_title"]
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            itemCount: val.data.length,
                                            options: options),
                                      ),
                                    ],
                                  )
                                //نهاية الملخص
                                //end summery

                                : LiveList.options(
                                    options: options,
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    controller: _scrollController,
                                    itemCount: val.data.length,
                                    itemBuilder: animationItemBuilder(
                                      (indexes) {
                                        print(val.data[indexes]['notifications_type']);
                                        return TimelineTile(
                                          alignment: TimelineAlign.manual,
                                          lineXY: .2,
                                          isFirst: indexes == 0,
                                          indicatorStyle: IndicatorStyle(
                                            color: val.data[indexes]["isRead"]
                                                ? MyColor.turquoise
                                                : MyColor.red,
                                            indicator: Container(
                                                decoration:  BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: val.data[indexes]["isRead"]
                                                      ? MyColor.turquoise
                                                      : MyColor.red,                                                 ),
                                                child: Icon(
                                                  _icon(val.data[indexes]
                                                      ["notifications_type"]),
                                                  size: 15,
                                                  color: MyColor.white0,
                                                )),
                                          ),
                                          afterLineStyle: LineStyle(
                                            color: MyColor.grayDark
                                                .withOpacity(.2),
                                          ),
                                          beforeLineStyle: LineStyle(
                                            color: MyColor.grayDark
                                                .withOpacity(.2),
                                          ),
                                          startChild: _dateTimeLine(
                                              val.data[indexes]["created_at"]),
                                          endChild: Container(
                                            padding: const EdgeInsets.only(bottom: 10),
                                            margin: const EdgeInsets.only(right: 10, left: 10, top: 10),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: val.data[indexes]["isRead"]
                                                      ? MyColor.turquoise
                                                      : MyColor.red,                                                 ),
                                            ),
                                            child: ListTile(
                                              trailing: val.data[indexes]["isRead"] ? const Text("") : const Icon(Icons.mark_as_unread, color: MyColor.red),
                                              title: Text(val.data[indexes]["notifications_title"].toString(), style: const TextStyle(color: MyColor.turquoise, fontWeight: FontWeight.bold)),
                                              subtitle: val.data[indexes]["notifications_description"] != null ? Text('${val.data[indexes]["notifications_description"]}\n') : null,
                                              leading: _notificationsType(val.data[indexes]['notifications_type']),
                                              onTap: () {
                                                val.data[indexes]["isRead"] =
                                                    true;
                                                _navPage(val.data[indexes], val.contentUrl);
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                  ),
                ],
              )),
    );
  }

  _navPage(Map _data, String _contentUrl) {
    print("my id =====================");
    print(_data["_id"]);
    Logger().i(_data['notifications_type']);

    setState(() {
      Get.put(NotificationsAPI()).updateReadNotifications(_data["_id"]);
    });
    Get.put(NotificationsAPI()).updateReadNotifications(_data["_id"]);
    List _pageNotifications = [
      "رسالة",
      "واجب بيتي",
      "ملخص",
      "تقرير",
      "الميلاد",
      "دروس",
    ];
    if (_data['notifications_type'] == "اشعار") {
      Get.to(() => ShowNewsNotification(
        data: _data,
        contentUrl: _contentUrl,
        notificationsType: _data['notifications_type'],
      ));
      setState(() {
        Get.put(NotificationsAPI()).updateReadNotifications(_data["_id"]);
      });
    }else if (_data['notifications_type'] == "امتحان يومي") {
      Get.to(() => const DailyExams());
      setState(() {
        Get.put(NotificationsAPI()).updateReadNotifications(_data["_id"]);
      });
    } else if (_data['notifications_type'] == "الحضور") {
      setState(() {
        Get.put(NotificationsAPI()).updateReadNotifications(_data["_id"]);
      });
      Get.to(() => StudentAttend(
            userData: widget.userData,
          ));
    } else if (_data['notifications_type'] == "اقساط") {
      setState(() {
        Get.put(NotificationsAPI()).updateReadNotifications(_data["_id"]);
      });
      Get.to(() => const StudentSalary());
    } else if (_data['notifications_type'] == "الميلاد") {
      // Get.to(() => Installments())
    } else if (_pageNotifications.contains(_data['notifications_type'])) {
      print(_data['notifications_type']);
      Get.to(() => ShowMessage(
          data: _data,
          contentUrl: _contentUrl,
          notificationsType: _data['notifications_type'],
      onUpdate: (){
       NotificationsAPI().updateReadNotifications(_data['_id']);
      },));
    }

    // else if (_data['notifications_type'] == "البصمة") {
    //   // Get.to(() => Installments())
    // }
  }

  String isSummery = "";
  _button(String? _type) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: MaterialButton(
        onPressed: () {
          page = 0;

          type = _type;
          Get.put(NotificationProvider()).remove();
          EasyLoading.show(status: "جار جلب البيانات");
          initFunction();

          if (type == "ملخص") {
            isSummery = "ملخص";
          } else {
            isSummery = "";
          }
          print("my type================");
          if (type == "الحضور") {
            Get.to(() => StudentAttend(
                  userData: widget.userData,
                ));
          }
        },
        color: _type == type ? MyColor.turquoise : MyColor.white0,
        textColor: _type == type ? MyColor.white0 : MyColor.turquoise,
        child: Text(_type ?? "الكل"),
      ),
    );
  }

  _notificationsType(_type) {
    if (_type == "homework") {
      return const Text("واجب بيتي");
    } else if (_type == "message") {
      return const Text("رسالة");
    } else if (_type == "report") {
      return const Text("تقرير");
    } else if (_type == "installments") {
      return const Text("اقساط");
    } else if (_type == "vacations") {
      return const Text("اجازة");
    } else if (_type == "announcement") {
      return const Text("تبليغ");
    }
  }

  IconData _icon(_type) {
    if (_type == "رسالة") {
      return Iconsax.message;
    } else if (_type == "واجب بيتي") {
      return Iconsax.book;
    } else if (_type == "تقرير") {
      return Iconsax.presention_chart;
    } else if (_type == "اقساط") {
      return Iconsax.money_send;
    } else if (_type == "الحضور") {
      return Iconsax.frame;
    } else if (_type == "تبليغ") {
      return Iconsax.edit;
    } else if (_type == "ملخص") {
      return Iconsax.task;
    } else if (_type == "البصمة") {
      return Iconsax.finger_scan;
    } else if (_type == "الميلاد") {
      return Iconsax.cake;
    } else {
      return Iconsax.timer;
    }
  }

  Widget _dateTimeLine(int createdAt) {
    String currentYear = DateTime.now().year.toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          toDayOnly(createdAt),
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Container(
            padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
            decoration: BoxDecoration(
              color: MyColor.red.withOpacity(.2),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              toMonthOnlyAR(createdAt),
              style: const TextStyle(fontSize: 11),
            )),
        if (currentYear != toYearOnly(createdAt))
          Text(
            toYearOnly(createdAt),
            style: const TextStyle(fontSize: 11),
          ),
      ],
    );
  }
}

Widget Function(
  BuildContext context,
  int index,
  Animation<double> animation,
) animationItemBuilder(
  Widget Function(int index) child, {
  EdgeInsets padding = EdgeInsets.zero,
}) =>
    (
      BuildContext context,
      int index,
      Animation<double> animation,
    ) =>
        FadeTransition(
          opacity: Tween<double>(
            begin: 0,
            end: 1,
          ).animate(animation),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -0.1),
              end: Offset.zero,
            ).animate(animation),
            child: Padding(
              padding: padding,
              child: child(index),
            ),
          ),
        );
