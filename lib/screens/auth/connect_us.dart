import 'package:cached_network_image/cached_network_image.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:secondhome2/static_files/my_appbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import '../../api_connection/student/api_general_data.dart';
import '../../provider/student/provider_genral_data.dart';
import '../../static_files/my_color.dart';
import '../../static_files/my_loading.dart';

class ConnectUs extends StatefulWidget {
  final Color color;
  const ConnectUs({super.key, required this.color});
  @override
  _ConnectUsState createState() => _ConnectUsState();
}

class _ConnectUsState extends State<ConnectUs> {
  @override
  void initState() {
    GeneralData().getContact();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: myAppBar("اتصل بنا", widget.color),
      body: GetBuilder<ContactProvider>(builder: (val) {
        return val.isLoading
            ? loading()
            : val.contact!.isEmpty
                ? EmptyWidget(
                    image: null,
                    packageImage: PackageImage.Image_1,
                    title: 'لاتوجد بيانات',
                    subTitle: 'لم يتم اضافة اي بيانات',
                    titleTextStyle: const TextStyle(
                      fontSize: 22,
                      color: Color(0xff9da9c7),
                      fontWeight: FontWeight.w500,
                    ),
                    subtitleTextStyle: const TextStyle(
                      fontSize: 14,
                      color: Color(0xffabb8d6),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.only(right: 20, left: 20),
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        if (val.contact!['school_img'] != null)
                          Container(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),

                                ///image cache
                                child: CachedNetworkImage(
                                  imageUrl: val.contentUrl +
                                      val.contact!['school_img'],
                                  placeholder: (context, url) => const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(),
                                    ],
                                  ),
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                )

                                //Image.network(val.contact!['school_img']),
                                ),
                          ),
                        if (val.contact!['school_website'] != null)
                          // Container(
                          //   decoration: BoxDecoration(
                          //       color: MyColor.c0.withOpacity(0.2),
                          //       borderRadius: BorderRadius.circular(10)
                          //   ),
                          //   child: TextButton(
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: [
                          //         Text(connectUsData['school_website'],style: TextStyle(fontSize: 16,color: MyColor.c0),),
                          //       ],
                          //     ),
                          //     style: ButtonStyle(backgroundColor: MyColor.c0.withOpacity(0.2),),
                          //     onPressed: () async {
                          //       var _tel = "https:${connectUsData['school_website']}";
                          //       await canLaunch(_tel) ? await launch(_tel) : throw 'Could not launch $_tel';
                          //     },
                          //   ),
                          // ),
                          TextButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                widget.color.withOpacity(0.2),
                              ),
                              overlayColor: WidgetStateProperty.all(
                                widget.color.withOpacity(0.2),
                              ),
                            ),
                            onPressed: () async {
                              var schoolWebsite =
                                  val.contact!['school_website'];
                              await canLaunch(schoolWebsite)
                                  ? await launch(schoolWebsite)
                                  : throw 'Could not launch $schoolWebsite';
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  val.contact!['school_website'],
                                  style: TextStyle(
                                      fontSize: 16, color: widget.color),
                                ),
                              ],
                            ),
                          ),
                        if (val.contact!['school_description'] != null)
                          Text(
                            val.contact!['school_description'],
                            style: const TextStyle(
                                color: MyColor.grayDark, fontSize: 14),
                            textAlign: TextAlign.justify,
                          ),
                        Container(
                          padding: const EdgeInsets.only(
                              top: 20, bottom: 20, right: 20, left: 20),
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 3,
                            children: [
                              if (val.contact!['school_phone'] != null)
                                Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: widget.color),
                                      child: IconButton(
                                        icon: const Icon(
                                          LineIcons.phone,
                                          color: MyColor.white0,
                                        ),
                                        onPressed: () async {
                                          var tel =
                                              "tel:${val.contact!['school_phone']}";
                                          await canLaunch(tel)
                                              ? await launch(tel)
                                              : throw 'Could not launch $tel';
                                        },
                                      ),
                                    ),
                                    Text(
                                      "الهاتف",
                                      style: TextStyle(
                                          fontSize: 14, color: widget.color),
                                    )
                                  ],
                                ),
                              if (val.contact!['school_telegram'] != null)
                                Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: widget.color),
                                      child: IconButton(
                                        icon: const Icon(
                                          LineIcons.telegram,
                                          color: MyColor.white0,
                                        ),
                                        onPressed: () async {
                                          var tel =
                                              val.contact!['school_telegram'];
                                          await canLaunch(tel)
                                              ? await launch(tel)
                                              : throw 'Could not launch $tel';
                                        },
                                      ),
                                    ),
                                    Text(
                                      "تلكرام",
                                      style: TextStyle(
                                          fontSize: 14, color: widget.color),
                                    )
                                  ],
                                ),
                              if (val.contact!['school_facebook'] != null)
                                Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: widget.color),
                                      child: IconButton(
                                        icon: const Icon(
                                          LineIcons.facebookF,
                                          color: MyColor.white0,
                                        ),
                                        onPressed: () async {
                                          var tel =
                                              val.contact!['school_facebook'];
                                          await canLaunch(tel)
                                              ? await launch(tel)
                                              : throw 'Could not launch $tel';
                                        },
                                      ),
                                    ),
                                    Text(
                                      "فيسبوك",
                                      style: TextStyle(
                                          fontSize: 14, color: widget.color),
                                    )
                                  ],
                                ),
                              if (val.contact!['school_whatsapp'] != null)
                                Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: widget.color),
                                      child: IconButton(
                                        icon: const Icon(
                                          LineIcons.whatSApp,
                                          color: MyColor.white0,
                                        ),
                                        onPressed: () async {
                                          final link = WhatsAppUnilink(
                                            phoneNumber:
                                                '${val.contact!['school_whatsapp']}',
                                            text: "",
                                          );
                                          await launch('$link');
                                        },
                                      ),
                                    ),
                                    Text(
                                      "واتساب",
                                      style: TextStyle(
                                          fontSize: 14, color: widget.color),
                                    )
                                  ],
                                ),
                              if (val.contact!['school_website'] != null)
                                Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: widget.color),
                                      child: IconButton(
                                        icon: const Icon(
                                          LineIcons.globe,
                                          color: MyColor.white0,
                                        ),
                                        onPressed: () async {
                                          var tel =
                                              val.contact!['school_website'];
                                          await canLaunch(tel)
                                              ? await launch(tel)
                                              : throw 'Could not launch $tel';
                                        },
                                      ),
                                    ),
                                    Text(
                                      "الموقع الالكتروني",
                                      style: TextStyle(
                                          fontSize: 14, color: widget.color),
                                    )
                                  ],
                                ),
                              if (val.contact!['google_map'] != null)
                                Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: widget.color),
                                      child: IconButton(
                                        icon: const Icon(
                                          LineIcons.mapMarked,
                                          color: MyColor.white0,
                                        ),
                                        onPressed: () async {
                                          var tel = val.contact!['google_map'];
                                          await canLaunch(tel)
                                              ? await launch(tel)
                                              : throw 'Could not launch $tel';
                                        },
                                      ),
                                    ),
                                    Text(
                                      "الموقع على الخريطة",
                                      style: TextStyle(
                                          fontSize: 14, color: widget.color),
                                    )
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
      }),
    );
  }
}
