// ignore_for_file: unused_import, library_prefixes, library_private_types_in_public_api, no_leading_underscores_for_local_identifiers, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:secondhome2/screens/auth/connect_us.dart';
import 'package:secondhome2/screens/student/review/daily_review_date.dart';
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
import 'dashboard_student/daily_exams.dart';
import 'dashboard_student/dashboard.dart';
import 'profile/student_profile.dart';
import 'review/review_date.dart';

class HomePageStudentOld extends StatefulWidget {
  const HomePageStudentOld({super.key, required this.userData});
  final Map userData;

  @override
  _HomePageStudentOldState createState() => _HomePageStudentOldState();
}

class _HomePageStudentOldState extends State<HomePageStudentOld>
    with AutomaticKeepAliveClientMixin {
  final LatestNewsProvider latestNewsProvider = Get.put(LatestNewsProvider());
  final StudentDashboardProvider studentDashboardProvider =
      Get.put(StudentDashboardProvider());
  late IO.Socket socket;
  final Map? dataProvider = Get.put(TokenProvider()).userData;
  final SocketDataProvider _socketDataProvider = Get.put(SocketDataProvider());
  initSocketDriver() {
    Map<String, String> _headers = {"Authorization": dataProvider!['token']};
    socket = IO.io(
        socketURL + 'driver',
        IO.OptionBuilder()
            .disableAutoConnect()
            .setTransports(['websocket'])
            .setAuth(_headers)
            .build());
    _socketDataProvider.changeSocket(socket);
  }

  void _onItemTapped(int index) {
    studentDashboardProvider.changeIndex(index);
  }

  void initWidgetList() {
    List<Widget> _widget = <Widget>[
      Dashboard(userData: widget.userData),
      const ReviewDate(),
      const DailyExams(),
      StudentProfile(userData: widget.userData),
    ];
    studentDashboardProvider.initWidget(_widget);
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
          unselectedItemColor: MyColor.turquoise.withOpacity(0.6),
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
              icon: Icon(CommunityMaterialIcons.file_outline),
              label: "الامتحانات",
            ),
            BottomNavigationBarItem(
              icon: Icon(LineIcons.user),
              label: "الحساب",
            ),
          ],
          currentIndex: val.selectedIndex,
          selectedItemColor: MyColor.turquoise,
          showUnselectedLabels: true,
          onTap: _onItemTapped,
        );
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
