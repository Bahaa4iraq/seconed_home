// ignore_for_file: unused_import, library_private_types_in_public_api, no_leading_underscores_for_local_identifiers, deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
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
  void _launchURL(_url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  void _launchSocial(String url, String fallbackUrl) async {
    try {
      bool launched =
      await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {

      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.turquoise,
        title: Text(
          widget.data['latest_news_title'].toString(),
          style: const TextStyle(color: MyColor.white0),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        children: [
          singleImageShowAndSave(Get.put(LatestNewsProvider()).contentUrl,
              widget.data['latest_news_img'].toString(),MyColor.turquoise),
          const Divider(),
          if (widget.data['latest_news_link'] != null &&
              widget.data['latest_news_link'] != "")
            InkWell(
             // onTap: () => _launchURL(widget.data['latest_news_link']),
              onTap: () => _launchSocial(widget.data['latest_news_link'],'www.google.com'),
              child: Container(
                margin: const EdgeInsets.only(right: 20, left: 20),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: MyColor.turquoise.withOpacity(.17),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    widget.data['latest_news_link'].toString(),
                    style:
                        const TextStyle(fontSize: 18, color: MyColor.turquoise),
                  ),
                ),
              ),
            ),
          if (widget.data['latest_news_description'] != null)
            Container(
              margin: const EdgeInsets.all(20),
              child: Text(
                widget.data['latest_news_description'].toString(),
                style: const TextStyle(fontSize: 18, color: MyColor.grayDark),
              ),
            ),
        ],
      ),
    );
  }
}
