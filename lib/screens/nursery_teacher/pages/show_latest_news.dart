// ignore_for_file: library_private_types_in_public_api, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:secondhome2/static_files/my_times.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../provider/student/student_provider.dart';
import '../../../static_files/my_color.dart';
import '../../../static_files/my_image_grid.dart';

class ShowLatestNews extends StatefulWidget {
  final Map data;
  const ShowLatestNews({super.key, required this.data});

  @override
  _ShowLatestNewsState createState() => _ShowLatestNewsState();
}

class _ShowLatestNewsState extends State<ShowLatestNews> {
  void _launchURL(_url) async => await canLaunchUrl(Uri.parse(_url))
      ? await launchUrl(Uri.parse(_url))
      : throw 'Could not launch $_url';

  void _launchSocial(String url, String fallbackUrl) async {
    try {
      bool launched = await canLaunchUrl(Uri.parse(url));
      if (!launched) {
        await launchUrl(Uri.parse(url));
      }
    } catch (e) {
      Logger().i("error");
      await launchUrl(Uri.parse(fallbackUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.pink,
        title: const Text(
          'اخر الاخبار',
          style: TextStyle(
              color: MyColor.white0, fontSize: 20, fontWeight: FontWeight.bold),
        ),
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
              onTap: () => _launchSocial(
                  widget.data['latest_news_link'], 'www.google.com'),
              // onTap: () => _launchURL(widget.data['latest_news_link']),
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
