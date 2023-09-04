
import 'package:flutter/material.dart';
import 'package:secondhome2/static_files/my_appbar.dart';
import 'package:secondhome2/static_files/my_image_grid.dart';
import 'package:secondhome2/static_files/my_times.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../static_files/my_color.dart';

class ShowNewsNotification extends StatefulWidget {
  final Map data;
  final String contentUrl;
  final String notificationsType;
  final VoidCallback?  onUpdate;
  const ShowNewsNotification(
      {Key? key,
      required this.data,
      required this.contentUrl,
      required this.notificationsType, this.onUpdate})
      : super(key: key);

  @override
  _ShowNewsNotificationState createState() => _ShowNewsNotificationState();
}

class _ShowNewsNotificationState extends State<ShowNewsNotification> {


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
  void initState() {
    if (!widget.data['isRead']) {
      widget.onUpdate?.call();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar('News',MyColor.turquoise),
      body: ListView(
        children: [

          Padding(
              padding: const EdgeInsets.all(10),
              child: imageGrid(
                  widget.contentUrl, widget.data['notifications_imgs'],MyColor.turquoise)),
          Text(toDateAndTime(widget.data['created_at'], 12)),
          Padding(
            padding: const EdgeInsets.only(right: 8, left: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text("المرسل: "),
                Text(widget.data['notifications_sender']['account_name']
                    .toString()),
              ],
            ),
          ),

          if (widget.data['notifications_link'] != "" &&
              widget.data['notifications_link'] != null)
            InkWell(
              onTap: () => _launchSocial(widget.data['notifications_link'],'www.google.com'),
             // onTap: () => _launchURL(widget.data['notifications_link']),
              child: Container(
                margin: const EdgeInsets.only(right: 20, left: 20),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: MyColor.turquoise.withOpacity(.17),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    widget.data['notifications_link'].toString(),
                    style:
                        const TextStyle(fontSize: 18, color: MyColor.turquoise),
                  ),
                ),
              ),
            ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Text(
              widget.data['notifications_title'].toString(),
              style: const TextStyle(fontSize: 18, color: MyColor.black,fontWeight: FontWeight.w600),
            ),
          ),
          if (widget.data['notifications_description'] != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.data['notifications_description'].toString(),
                style: const TextStyle(fontSize: 18, color: MyColor.grayDark),
              ),
            )
        ],
      ),
    );
  }
}
