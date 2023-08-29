// ignore_for_file: unused_import, library_prefixes, library_private_types_in_public_api, no_leading_underscores_for_local_identifiers, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:secondhome2/screens/auth/connect_us.dart';
import 'package:secondhome2/screens/kindergarten_teacher/pages/intimation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../api_connection/auth_connection.dart';
import '../../provider/auth_provider.dart';
import '../../provider/teacher/chat/chat_socket.dart';
import '../../provider/teacher/provider_teacher_dashboard.dart';
import '../../static_files/my_color.dart';
import '../../static_files/my_loading.dart';
import '../../static_files/my_url.dart';
import 'profile.dart';
import 'teacher_dashboard.dart';

class HomePageKindergartenTeacher extends StatefulWidget {
  final Map userData;
  const HomePageKindergartenTeacher({Key? key, required this.userData}) : super(key: key);
  @override
  _HomePageKindergartenTeacherState createState() => _HomePageKindergartenTeacherState();
}

class _HomePageKindergartenTeacherState extends State<HomePageKindergartenTeacher>
    with AutomaticKeepAliveClientMixin {
   final TeacherDashboardProvider teacherDashboardProvider =
  Get.put(TeacherDashboardProvider());
  final Map? dataProvider = Get.put(TokenProvider()).userData;

  void _onItemTapped(int index) {
    teacherDashboardProvider.changeIndex(index);
  }

  void initWidgetList() {
    List<Widget> _widget = <Widget>[
      TeacherDashboard(userData: widget.userData),
      const ConnectUs(color: MyColor.turquoise),
       NotificationTeacherIntimation(userData: widget.userData),
       TeacherProfile(userData: widget.userData),
    ];
    teacherDashboardProvider.initWidget(_widget);
  }

  initUserData() async {

    await Auth().getStudentInfo();
    Get.put(ChatSocketProvider()).changeSocket(dataProvider);
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
      body: GetBuilder<TeacherDashboardProvider>(builder: (val) {
        return Container(
          child: val.widgetOptions == null
              ? loading()
              : val.widgetOptions![val.selectedIndex],
        );
      }),
      bottomNavigationBar: GetBuilder<TeacherDashboardProvider>(builder: (val) {
        return BottomNavigationBar(
          unselectedItemColor: MyColor.turquoise.withOpacity(0.6),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CommunityMaterialIcons.home_outline),
              label: "الرئيسية",
            ),
            BottomNavigationBarItem(
              icon: Icon(CommunityMaterialIcons.contacts_outline),
              label: "اتصل بنا",
            ),
            BottomNavigationBarItem(
              icon: Icon(CommunityMaterialIcons.file_outline),
              label: "تبليغات",
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
