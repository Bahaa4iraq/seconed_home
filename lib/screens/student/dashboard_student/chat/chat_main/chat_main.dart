import 'package:flutter/material.dart';

import '../../../../../static_files/my_color.dart';
import '../chat_student_list.dart';

class ChatMain extends StatefulWidget {
  const ChatMain({super.key});

  @override
  State<ChatMain> createState() => _ChatMainState();
}

class _ChatMainState extends State<ChatMain> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                const SliverAppBar(
                  backgroundColor: MyColor.pink,
                  foregroundColor: MyColor.white0,
                  title: Text('CHAT'),
                  centerTitle: true,
                  pinned: true,
                  floating: true,
                  bottom: TabBar(
                    indicatorColor: MyColor.white0,
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    indicatorWeight: 3,
                    tabs: [
                      Tab(
                        text: "الاساتذة",
                      ),
                      // Tab(
                      //   text: "الصفوف",
                      // ),
                      // Tab(
                      //   text: "المجموعات",
                      // ),
                    ],
                  ),
                ),
              ];
            },
            body: const TabBarView(
              children: [
                ChatTeacherList(),
                //ChatClassGroupList(),
                // ChatGroupList(),
              ],
            )),
      ),
    );
  }
}
