import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../static_files/my_color.dart';

class ShowDocument extends StatelessWidget {
  final Map data;
  final String url;
  const ShowDocument({Key? key, required this.data, required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.turquoise,
        title: const Text(
          "المستمسكات",
          style: TextStyle(color: MyColor.white0),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (data['certificate_national_id'] != null)
              Container(
                  padding: const EdgeInsets.only(right: 40, left: 40, top: 40),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("هوية المخول"),
                      ),
                      _imgShow(url + data['certificate_national_id']),
                      const Divider()
                    ],
                  )),
          ],
        ),
      ),
    );
  }

  Widget _imgShow(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}
