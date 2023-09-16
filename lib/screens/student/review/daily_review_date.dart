import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondhome2/screens/student/review/show_daily_review.dart';

import '../../../api_connection/student/api_daily_review.dart';
import '../../../provider/student/provider_daily_review.dart';
import '../../../static_files/my_appbar.dart';
import '../../../static_files/my_color.dart';
import '../../../static_files/my_loading.dart';
class DailyReviewDate extends StatefulWidget {
  const DailyReviewDate({Key? key}) : super(key: key);

  @override
  _DailyReviewDateState createState() => _DailyReviewDateState();
}

class _DailyReviewDateState extends State<DailyReviewDate> {

  @override
  void initState() {
    DailyReviewAPI().getDailyReview();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar("يومي",MyColor.turquoise),
      body: GetBuilder<ReviewDailyDateProvider>(
          builder: (val) => val.isLoading
              ? loading()
              : val.data.isEmpty
              ? EmptyWidget(
                  image: null,
                  packageImage: PackageImage.Image_3,
                  title: 'لاتوجد بيانات',
                  subTitle: 'لم يتم اضافة اي تقييم',
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
                  itemCount: val.data.length,
                  itemBuilder: (BuildContext context, int indexes) {
                    return Container(
                      margin: const EdgeInsets.only(
                          right: 10, left: 10, top: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.reviews),
                        trailing: Text("Show Review"),
                        title: Text(
                          val.data[indexes]['review_date'],
                          style: const TextStyle(
                              color: MyColor.turquoise,
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Get.to(() => ShowDailyReview(
                              data: val.data[indexes],
                              indexItem:indexes
                          ));
                        },
                      ),
                    );

                  })),
    );
  }
}
