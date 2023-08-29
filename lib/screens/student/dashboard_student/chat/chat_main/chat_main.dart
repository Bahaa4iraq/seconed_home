import 'package:flutter/material.dart';
import 'package:secondhome2/static_files/my_color.dart';

import '../chat_group_list_student.dart';
import '../chat_student_list.dart';

class ChatMain extends StatefulWidget {
  const ChatMain({Key? key}) : super(key: key);

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
                  backgroundColor: MyColor.turquoise,
                  foregroundColor: MyColor.white0,
                  title: Text('CHAT'),
                  pinned: true,
                  floating: true,
                  bottom: TabBar(
                    indicatorColor: MyColor.white0,
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
                ChatGroupList(),
              ],
            )),
      ),
    );
  }
}
