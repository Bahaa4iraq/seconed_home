import 'package:cached_network_image/cached_network_image.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../api_connection/student/api_general_data.dart';
import '../../provider/student/provider_genral_data.dart';
import '../../static_files/my_color.dart';
import '../../static_files/my_loading.dart';
import '../../static_files/my_times.dart';
import 'show_ads.dart';

class Ads extends StatefulWidget {
  const Ads({Key? key}) : super(key: key);
  @override
  _AdsState createState() => _AdsState();
}

class _AdsState extends State<Ads> {
  final ScrollController _scrollController =  ScrollController();
  int page = 0;
  _showData() {
    GeneralData().getAds(page).then((res){
      if(EasyLoading.isShow){
        EasyLoading.dismiss();
      }
    });
  }

  @override
  void initState() {
    _showData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        page++;
        EasyLoading.show(status: "جار التحميل...");
        _showData();
      }
    });
    super.initState();
  }
  @override
  void dispose() {
    Get.put(AdsProvider()).changeLoading(true);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.pink,
        title: const Text(
          "الاعلانات",
          style: TextStyle(color: MyColor.pink),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: MyColor.pink,
        ),
        elevation: 0,
      ),
      body: GetBuilder<AdsProvider>(
        builder: (val) => val.isLoading
            ? loading()
            : val.ads!.isEmpty
            ? EmptyWidget(
          image: null,
          packageImage: PackageImage.Image_2,
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
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                controller: _scrollController,
                itemCount: val.ads!.length,
                itemBuilder: (BuildContext context, int indexes) {
                  return Container(
                    margin: const EdgeInsets.only(top: 10,right: 10,left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: MyColor.pink),
                    ),
                    child: ListTile(
                      title: Text(val.ads![indexes]['title'].toString(),style: const TextStyle(color: MyColor.pink,fontWeight: FontWeight.bold),),
                      subtitle: Text(toDateOnly(val.ads![indexes]['created_at']),style: const TextStyle(color: MyColor.black),),
                      onTap: (){
                        Get.to(()=>ShowAds(data:val.ads![indexes],tag:val.contentUrl + val.ads![indexes]['img'].toString()));
                      },
                      trailing: val.ads![indexes]['img'] == null
                          ? null
                          : SizedBox(
                              width: 60,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Hero(
                                  tag: val.contentUrl + val.ads![indexes]['img'],
                                  child: CachedNetworkImage(
                                    imageUrl: val.contentUrl + val.ads![indexes]['img'],
                                    placeholder: (context, url) => Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: const [
                                        CircularProgressIndicator(),
                                      ],
                                    ),
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}