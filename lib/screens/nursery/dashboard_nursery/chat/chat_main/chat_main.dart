import 'package:flutter/material.dart';

import '../../../../../static_files/my_color.dart';
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
                  backgroundColor: MyColor.pink,
                  foregroundColor: MyColor.white0,
                  title: Text('CHAT'),
                  pinned: true,
                  floating: true,
                ),
              ];
            },
            body:const ChatTeacherList(),),
      ),
    );
  }
}
