import 'package:community_material_icon/community_material_icon.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:secondhome2/screens/nursery/attende.dart';
import 'package:secondhome2/screens/nursery/review/review_date.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../api_connection/auth_connection.dart';
import '../../provider/auth_provider.dart';
import '../../provider/student/chat/chat_socket.dart';
import '../../provider/student/provider_maps.dart';
import '../../provider/student/provider_student_dashboard.dart';
import '../../provider/student/student_provider.dart';
import '../../static_files/my_color.dart';
import '../../static_files/my_loading.dart';
import '../../static_files/my_url.dart';
import 'dashboard_nursery/dashboard.dart';
import 'dashboard_nursery/nursery_salary/nursery_salary.dart';
import 'profile/nursery_profile.dart';

class HomePageNursery extends StatefulWidget {
  final Map userData;
  const HomePageNursery({super.key, required this.userData});
  @override
  HomePageNurseryState createState() => HomePageNurseryState();
}

class HomePageNurseryState extends State<HomePageNursery>
    with AutomaticKeepAliveClientMixin {
  followTopics() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? schoolId = prefs.getString('school_id');
    await messaging.subscribeToTopic('school_$schoolId');
  }

  final LatestNewsProvider latestNewsProvider = Get.put(LatestNewsProvider());
  final StudentDashboardProvider nurseryDashboardProvider =
      Get.put(StudentDashboardProvider());
  late IO.Socket socket;
  final Map? dataProvider = Get.put(TokenProvider()).userData;
  final SocketDataProvider _socketDataProvider = Get.put(SocketDataProvider());
  initSocketDriver() {
    Map<String, String> headers = {"Authorization": dataProvider!['token']};
    socket = IO.io(
        '${socketURL}driver',
        IO.OptionBuilder()
            .disableAutoConnect()
            .setTransports(['websocket'])
            .setAuth(headers)
            .build());
    _socketDataProvider.changeSocket(socket);
  }

  void _onItemTapped(int index) {
    nurseryDashboardProvider.changeIndex(index);
  }

  void initWidgetList() {
    List<Widget> widgetList = <Widget>[
      Dashboard(userData: widget.userData),
      const ReviewDate(),
      const Attende(color: MyColor.pink),
      const StudentSalary(),
      StudentProfile(userData: widget.userData),
    ];
    nurseryDashboardProvider.initWidget(widgetList);
  }

  initUserData() async {
    await Auth().getStudentInfo();
    Get.put(ChatSocketStudentProvider()).changeSocket(dataProvider);
    //initSocketDriver();
    initWidgetList();
  }

  @override
  void initState() {
    initUserData();
    followTopics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GetBuilder<StudentDashboardProvider>(builder: (val) {
        return Container(
          child: val.widgetOptions == null
              ? loading()
              : val.widgetOptions![val.selectedIndex],
        );
      }),
      bottomNavigationBar: GetBuilder<StudentDashboardProvider>(builder: (val) {
        return BottomNavigationBar(
          unselectedItemColor: MyColor.pink.withOpacity(0.6),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CommunityMaterialIcons.home_outline),
              label: "الرئيسية",
            ),
            BottomNavigationBarItem(
              icon: Icon(CommunityMaterialIcons.diamond_outline),
              label: "تقييم الطالب",
            ),
            BottomNavigationBarItem(
              icon: Icon(CommunityMaterialIcons.location_enter),
              label: "دخول وخروج",
            ),
            BottomNavigationBarItem(
              icon: Icon(CommunityMaterialIcons.file_outline),
              label: "الاقساط",
            ),
            BottomNavigationBarItem(
              icon: Icon(LineIcons.user),
              label: "الحساب",
            ),
          ],
          currentIndex: val.selectedIndex,
          selectedItemColor: MyColor.pink,
          showUnselectedLabels: true,
          onTap: _onItemTapped,
        );
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
