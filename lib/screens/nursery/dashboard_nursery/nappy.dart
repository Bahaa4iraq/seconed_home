import 'package:auto_animated/auto_animated.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:secondhome2/screens/nursery/dashboard_nursery/show/show_message.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../api_connection/student/api_notification.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/student/provider_notification.dart';
import '../../../static_files/my_appbar.dart';
import '../../../static_files/my_color.dart';
import '../../../static_files/my_loading.dart';
import '../../../static_files/my_times.dart';
import 'notification_all.dart';

class Nappy extends StatefulWidget {
  const Nappy({super.key});

  @override
  State<Nappy> createState() => _NappyState();
}

class _NappyState extends State<Nappy> {
  final MainDataGetProvider _mainDataGetProvider =
      Get.put(MainDataGetProvider());
  final ScrollController _scrollController = ScrollController();

  _getData() {
    Map data = {
      "study_year": _mainDataGetProvider.mainData['setting'][0]['setting_year'],
      "page": 0,
      "class_school": _mainDataGetProvider.mainData['account']
          ['account_division_current']['_id'],
      "type": 'الحفاض',
      "isRead": null
    };
    NotificationsAPI().getNotificationsNappy(data);
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

  final formatter = NumberFormat.decimalPattern();
  DateTime now = DateTime.now();
  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar("العناية بالطفل", MyColor.pink),
      body: GetBuilder<NappyNotificationProvider>(
          builder: (val) => val.isLoading
              ? loading()
              : val.data.isEmpty
                  ? EmptyWidget(
                      image: null,
                      packageImage: PackageImage.Image_1,
                      title: 'لاتوجد بيانات',
                      subTitle: 'لم يتم اضافة البيانات',
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
                                  child: const Icon(
                                    Icons.edit,
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
                            startChild:
                                _dateTimeLine(val.data[indexes]["created_at"]),
                            endChild: Container(
                              margin: const EdgeInsets.only(
                                  right: 10, left: 10, top: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: val.data[indexes]["isRead"]
                                        ? MyColor.pink.withOpacity(.2)
                                        : MyColor.red),
                              ),
                              child: ListTile(
                                title: Text(
                                  val.data[indexes]["notifications_title"]
                                      .toString(),
                                  style: const TextStyle(
                                      color: MyColor.pink,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: val.data[indexes]
                                            ["notifications_description"] !=
                                        null
                                    ? Text(val.data[indexes]
                                            ["notifications_description"]
                                        .toString())
                                    : null,
                                onTap: () {
                                  Get.to(
                                    () => ShowMessage(
                                      data: val.data[indexes],
                                      contentUrl: val.contentUrl,
                                      notificationsType: val.data[indexes]
                                          ['notifications_type'],
                                      onUpdate: () {
                                        NotificationsAPI().updateReadNappy(
                                            val.data[indexes]['_id']);
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    )),
    );
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
