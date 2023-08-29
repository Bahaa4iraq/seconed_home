import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../provider/auth_provider.dart';
import '../../../provider/student/provider_notification.dart';
import '../../../static_files/my_color.dart';
import '../../../static_files/my_loading.dart';
import '../../../static_files/my_times.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final ScrollController _scrollController = ScrollController();
  final MainDataGetProvider _mainDataProvider = Get.put(MainDataGetProvider());

  int page = 0;
  String type = "message";
  initFunction(String division, String year, String type, int page) {
    // NotificationApi()
    //     .notificationShow(division, year, type, page)
    //     .then((res) => {notificationProvider.changeLoading(), notificationProvider.insertData(res)});
  }
  @override
  void dispose() {
    // notificationProvider.remove();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {

    initFunction(_mainDataProvider.mainData['account']['account_division_current']['_id'].toString(), _mainDataProvider.mainData['setting_year'].toString(), type, page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        page++;
        initFunction(
            _mainDataProvider.mainData['divisions'][0]['class_school_id'].toString(), _mainDataProvider.mainData['setting_year'].toString(), type, page);
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
          "الرسائل",
          style: TextStyle(color: MyColor.pink),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: GetBuilder<NotificationProvider>(
          builder: (val) => val.isLoading
              ? loading()
              : val.data.isEmpty
                  ? EmptyWidget(
            image: null,
            packageImage: PackageImage.Image_1,
            title: 'لاتوجد بيانات',
            subTitle: 'لم يتم اضافة اي بيانات',
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
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      controller: _scrollController,
                      itemCount: val.data.length,
                      itemBuilder: (BuildContext context, int indexes) {
                        print(val.data[indexes]['created_at']);
                        print("+++++++++++++++++++");
                        return Container(
                          margin: const EdgeInsets.only(right: 10, left: 10, top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: MyColor.pink),
                          ),
                          child: ListTile(
                            title: Text(
                              val.data[indexes]["notifications_title"].toString(),
                              style: const TextStyle(color: MyColor.pink, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // val.data[indexes]["notifications_description"] == null
                                //     ? null
                                //     : Text(val.data[indexes]["notifications_description"].toString()),
                                Text(toDateAndTime(val.data[indexes]['created_at'],24)),
                                //_time(val.data[indexes]['created_at']),
                              ],
                            ),
                            onTap: () {
                              // Get.to(() => ShowMessage(
                              //       data: val.data[indexes],
                              //     ));
                            },
                          ),
                        );
                      })),
    );
  }

  Widget _time(String time) {
    final dateTime = DateTime.parse(time);
    final formatClock = DateFormat('hh:mm a');
    final formatDate = DateFormat('yyyy-MM-dd');
    final clockString = formatClock.format(dateTime);
    final dateString = formatDate.format(dateTime);
    return Text(dateString.toString() + " " + clockString.toString());
  }
}
