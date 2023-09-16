import 'package:auto_animated/auto_animated.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:secondhome2/screens/nursery/review/daily_review_date.dart';
import 'package:secondhome2/screens/nursery/review/review_date.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../api_connection/student/api_notification.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/student/provider_notification.dart';
import '../../../static_files/my_color.dart';
import '../../../static_files/my_loading.dart';
import '../../../static_files/my_times.dart';
import 'food_schedule.dart';
import 'nursery_attend.dart';
import 'nursery_salary/nursery_salary.dart';
import 'show/show_message.dart';
import 'weekly_schedule.dart';

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
  List typeList = [
    "رسالة",
    "ملابس",
    "غذاء",
    "دروس",
    "اقساط",
    "تدريب",
    "غفوة",
    "العناية بالطفل",
    "الميلاد"
  ];

  initFunction() {
    Map _data = {
      "study_year": _mainDataGetProvider.mainData['setting'][0]['setting_year'],
      "page": page,
      "class_school": _mainDataGetProvider.mainData['account']
          ['account_division_current']['_id'],
      "type": type,
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
        backgroundColor: MyColor.pink,
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
            return IconButton(
              onPressed: () {
                if (val.isRead == null) {
                  val.changeRead(true);
                } else if (val.isRead == true) {
                  val.changeRead(false);
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
                          _button(typeList[i])
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
                            : LiveList.options(
                                options: options,
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                controller: _scrollController,
                                itemCount: val.data.length,
                                itemBuilder: animationItemBuilder(
                                  (indexes) {
                                    return TimelineTile(
                                      alignment: TimelineAlign.manual,
                                      lineXY: .2,
                                      isFirst: indexes == 0,
                                      indicatorStyle: IndicatorStyle(
                                        color: val.data[indexes]["isRead"]
                                            ? MyColor.pink.withOpacity(.2)
                                            : MyColor.red,
                                        indicator: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: val.data[indexes]["isRead"]
                                                  ? MyColor.pink.withOpacity(.2)
                                                  : MyColor.red,
                                            ),
                                            child: Icon(
                                              _icon(val.data[indexes]
                                                  ["notifications_type"]),
                                              size: 15,
                                              color: MyColor.white0,
                                            )),
                                      ),
                                      afterLineStyle: LineStyle(
                                        color: MyColor.grayDark.withOpacity(.2),
                                      ),
                                      beforeLineStyle: LineStyle(
                                        color: MyColor.grayDark.withOpacity(.2),
                                      ),
                                      startChild: _dateTimeLine(
                                          val.data[indexes]["created_at"]),
                                      endChild: Container(
                                        margin: const EdgeInsets.only(
                                            right: 10, left: 10, top: 10),
                                        padding: const EdgeInsets.only(
                                            bottom: 16),

                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: val.data[indexes]["isRead"]
                                                  ? MyColor.pink.withOpacity(.2)
                                                  : MyColor.red),
                                        ),
                                        child: ListTile(
                                          title: Text(
                                            val.data[indexes]
                                                    ["notifications_title"]
                                                .toString(),
                                            style: const TextStyle(
                                                color: MyColor.pink,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: val.data[indexes][
                                                      "notifications_description"] !=
                                                  null
                                              ? Text(val.data[indexes][
                                                      "notifications_description"]
                                                  .toString())
                                              : null,

                                          onTap: () {
                                            _navPage(val.data[indexes],
                                                val.contentUrl);
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

  _navPage(Map data, String contentUrl) {
    List pageNotifications = [
      "رسالة",
      "ملابس",
      "غذاء",
      "دروس",
      "اشعار" /*, "تبليغ"*/,
      "تدريب",
      "واجب بيتي",
      "غفوة",
      "اقساط",
      "هل تعلم",
      "الحفاض",
    ];
    print(data['notifications_title']);
    if (data['notifications_title'] == "الجدول الاسبوعي") {
      setState(() {
        NotificationsAPI().updateReadNotifications(data['_id']);
      });
      Get.to(() => const WeeklySchedule());
    } else if (data['notifications_title'] == "جدول الطعام الاسبوعي") {
      setState(() {
        NotificationsAPI().updateReadNotifications(data['_id']);
      });
      Get.to(() => const FoodSchedule());
    } else if (data['notifications_title'] == "تم اضافة تقييم جديد") {
      setState(() {
        NotificationsAPI().updateReadNotifications(data['_id']);
      });
      Get.to(() => const ReviewDate());
    }else if (data['notifications_title'] == "تم اضافة تقييم يومي جديد") {
      setState(() {
        NotificationsAPI().updateReadNotifications(data['_id']);
      });
      Get.to(() => const DailyReviewDate());
    }
    else if (data['notifications_title'] == "تم اضافة حضور / غياب / اجازة") {
      setState(() {
        NotificationsAPI().updateReadNotifications(data['_id']);
      });
      Get.to(() =>  StudentAttend(userData: widget.userData));
    }

    else if (pageNotifications.contains(data['notifications_type'])) {
      Get.to(() => ShowMessage(
        data: data,
        contentUrl: contentUrl,
        notificationsType: data['notifications_type'],
        onUpdate: () {
          NotificationsAPI().updateReadNotifications(data['_id']);
        },
      ));
    } else if (data['notifications_type'] == "الحضور") {
      setState(() {
        NotificationsAPI().updateReadNotifications(data['_id']);
      });
      Get.to(() => StudentAttend(
        userData: widget.userData,
      ));
    } else if (data['notifications_type'] == "الميلاد") {
      setState(() {
        NotificationsAPI().updateReadNotifications(data['_id']);
      });
    }
  }

  _button(String? _type) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: MaterialButton(
        onPressed: () {
          page = 0;
          type = _type == 'العناية بالطفل' ? 'الحفاض': _type;
          Get.put(NotificationProvider()).remove();
          EasyLoading.show(status: "جار جلب البيانات");
          initFunction();
        },
        color: _type == type ? MyColor.pink : MyColor.white0,
        textColor: _type == type ? MyColor.white0 : MyColor.pink,
        child: Text(_type ?? "الكل"),
      ),
    );
  }


  IconData _icon(_type) {
    if (_type == "رسالة") {
      return Iconsax.message;
    } else if (_type == "ملابس") {
      return Iconsax.book;
    } else if (_type == "دروس") {
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
              color: MyColor.pink.withOpacity(.2),
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















