import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../provider/student/student_provider.dart';
import '../../../../static_files/my_color.dart';
import '../../../../static_files/my_image_grid.dart';


class ShowLatestNews extends StatefulWidget {
  final Map data;
  const ShowLatestNews({Key? key, required this.data}) : super(key: key);

  @override
  _ShowLatestNewsState createState() => _ShowLatestNewsState();
}

class _ShowLatestNewsState extends State<ShowLatestNews> {
  void _launchURL(_url) async => await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.pink,
        title: Text(
          widget.data['latest_news_title'].toString(),
          style: const TextStyle(color: MyColor.white0),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        children: [
          singleImageShowAndSave(Get.put(LatestNewsProvider()).contentUrl,widget.data['latest_news_img'].toString(),MyColor.pink),

          const Divider(),
          if (widget.data['latest_news_link'] != null && widget.data['latest_news_link'] != "")
            InkWell(
              onTap: () => _launchURL(widget.data['latest_news_link']),
              child: Container(
                margin: const EdgeInsets.only(right: 20, left: 20),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(color: MyColor.pink.withOpacity(.17), borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    widget.data['latest_news_link'].toString(),
                    style: const TextStyle(fontSize: 18, color: MyColor.pink),
                  ),
                ),
              ),
            ),
          if (widget.data['latest_news_description'] != null)
            Container(
              margin: const EdgeInsets.all(20),
              child: Text(
                widget.data['latest_news_description'].toString(),
                style: const TextStyle(fontSize: 18, color: MyColor.pink),
              ),
            ),
        ],
      ),
    );
  }
}
