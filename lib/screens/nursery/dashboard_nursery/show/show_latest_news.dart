import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondhome2/static_files/my_times.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../provider/student/student_provider.dart';
import '../../../../static_files/my_color.dart';
import '../../../../static_files/my_image_grid.dart';

class ShowLatestNews extends StatefulWidget {
  const ShowLatestNews({super.key, required this.data});
  final Map data;

  @override
  _ShowLatestNewsState createState() => _ShowLatestNewsState();
}

class _ShowLatestNewsState extends State<ShowLatestNews> {
  void _launchURL(url) async => await canLaunchUrl(Uri.parse(url))
      ? await launchUrl(Uri.parse(url))
      : throw 'Could not launch $url';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.pink,
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        children: [
          singleImageShowAndSave(Get.put(LatestNewsProvider()).contentUrl,
              widget.data['latest_news_img'].toString(), MyColor.pink),
          const Divider(),
          if (widget.data['latest_news_link'] != null &&
              widget.data['latest_news_link'] != "")
            InkWell(
              onTap: () => _launchURL(widget.data['latest_news_link']),
              child: Container(
                margin: const EdgeInsets.only(right: 20, left: 20),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: MyColor.pink.withOpacity(.17),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    widget.data['latest_news_link'].toString(),
                    style: const TextStyle(fontSize: 18, color: MyColor.pink),
                  ),
                ),
              ),
            ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              widget.data['latest_news_title'].toString(),
              style: const TextStyle(
                  fontSize: 18,
                  color: MyColor.black,
                  fontWeight: FontWeight.w600),
            ),
          ),
          if (widget.data['latest_news_description'] != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                widget.data['latest_news_description'].toString(),
                style: const TextStyle(fontSize: 18, color: MyColor.grayDark),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(toDateTime(widget.data['createdAt'])),
          ),
        ],
      ),
    );
  }
}
