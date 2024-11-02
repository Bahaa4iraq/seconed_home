import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:dio/dio.dart';
import 'my_color.dart';

Widget imageGrid(String contentUrl, List imgs, Color color) {
  if (imgs.length == 1) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Get.to(() => ImageShowList(
                contentUrl: contentUrl,
                imgs: imgs,
                initialIndex: 0,
                color: color,
              ));
        },
        child: Hero(
          tag: imgs[0],
          child: CachedNetworkImage(
            imageUrl: contentUrl + imgs[0],
            placeholder: (context, url) => const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            ),
            fit: BoxFit.contain,
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  } else if (imgs.length == 2) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => ImageShowList(
                  contentUrl: contentUrl,
                  imgs: imgs,
                  initialIndex: 0,
                  color: color,
                ));
          },
          child: Hero(
            tag: imgs[0],
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: contentUrl + imgs[0],
                placeholder: (context, url) => const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),
                fit: BoxFit.contain,
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => ImageShowList(
                  contentUrl: contentUrl,
                  imgs: imgs,
                  initialIndex: 1,
                  color: color,
                ));
          },
          child: Hero(
            tag: imgs[1],
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: contentUrl + imgs[1],
                placeholder: (context, url) => const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),
                fit: BoxFit.contain,
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        )
      ],
    );
  } else if (imgs.length == 3 || imgs.length == 4) {
    return Container(
      decoration: BoxDecoration(
          color: MyColor.white4, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(8),
      child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: imgs.length,
          itemBuilder: (BuildContext ctx, index) {
            return GestureDetector(
              onTap: () {
                Get.to(() => ImageShowList(
                      contentUrl: contentUrl,
                      imgs: imgs,
                      initialIndex: index,
                      color: color,
                    ));
              },
              child: Hero(
                tag: imgs[index],
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: contentUrl + imgs[index],
                    placeholder: (context, url) => const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    ),
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            );
          }),
    );
  } else if (imgs.length >= 5) {
    return Container(
      decoration: BoxDecoration(
          color: MyColor.white4, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(8),
      child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: 4,
          itemBuilder: (BuildContext ctx, index) {
            if (index == 3) {
              return GestureDetector(
                onTap: () {
                  Get.to(() => ImageShowList(
                        contentUrl: contentUrl,
                        imgs: imgs,
                        initialIndex: index,
                        color: color,
                      ));
                },
                child: Hero(
                  tag: imgs[index],
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CachedNetworkImage(
                            imageUrl: contentUrl + imgs[index],
                            placeholder: (context, url) => const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                              ],
                            ),
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        Container(
                          color: MyColor.grayDark.withOpacity(.8),
                          child: Center(
                            child: Text(
                              "${imgs.length - 3}+",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 30),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
            return GestureDetector(
              onTap: () {
                Get.to(() => ImageShowList(
                      contentUrl: contentUrl,
                      imgs: imgs,
                      initialIndex: index,
                      color: color,
                    ));
              },
              child: Hero(
                tag: imgs[index],
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: contentUrl + imgs[index],
                    placeholder: (context, url) => const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    ),
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            );
          }),
    );
  } else {
    return const Text("");
  }
}

Widget imageGridChat(String contentUrl, List imgs, Color color) {
  if (imgs.length == 1) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Get.to(() => ImageShowList(
                contentUrl: contentUrl,
                imgs: imgs,
                initialIndex: 0,
                color: color,
              ));
        },
        child: Hero(
          tag: imgs[0],
          child: CachedNetworkImage(
            imageUrl: contentUrl + imgs[0],
            placeholder: (context, url) => const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            ),
            fit: BoxFit.contain,
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  } else if (imgs.length == 2) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => ImageShowList(
                  contentUrl: contentUrl,
                  imgs: imgs,
                  initialIndex: 0,
                  color: color,
                ));
          },
          child: Hero(
            tag: imgs[0],
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: contentUrl + imgs[0],
                placeholder: (context, url) => const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),
                fit: BoxFit.contain,
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => ImageShowList(
                  contentUrl: contentUrl,
                  imgs: imgs,
                  initialIndex: 1,
                  color: color,
                ));
          },
          child: Hero(
            tag: imgs[1],
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: contentUrl + imgs[1],
                placeholder: (context, url) => const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),
                fit: BoxFit.contain,
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        )
      ],
    );
  } else if (imgs.length == 3 || imgs.length == 4) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(8),
      child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: imgs.length,
          itemBuilder: (BuildContext ctx, index) {
            return GestureDetector(
              onTap: () {
                Get.to(() => ImageShowList(
                      contentUrl: contentUrl,
                      imgs: imgs,
                      initialIndex: index,
                      color: color,
                    ));
              },
              child: Hero(
                tag: imgs[index],
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: contentUrl + imgs[index],
                    placeholder: (context, url) => const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    ),
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            );
          }),
    );
  } else if (imgs.length >= 5) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(8),
      child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: 4,
          itemBuilder: (BuildContext ctx, index) {
            if (index == 3) {
              return GestureDetector(
                onTap: () {
                  Get.to(() => ImageShowList(
                        contentUrl: contentUrl,
                        imgs: imgs,
                        initialIndex: index,
                        color: color,
                      ));
                },
                child: Hero(
                  tag: imgs[index],
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CachedNetworkImage(
                            imageUrl: contentUrl + imgs[index],
                            placeholder: (context, url) => const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                              ],
                            ),
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        Container(
                          color: MyColor.grayDark.withOpacity(.8),
                          child: Center(
                            child: Text(
                              "${imgs.length - 3}+",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 30),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
            return GestureDetector(
              onTap: () {
                Get.to(() => ImageShowList(
                      contentUrl: contentUrl,
                      imgs: imgs,
                      initialIndex: index,
                      color: color,
                    ));
              },
              child: Hero(
                tag: imgs[index],
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: contentUrl + imgs[index],
                    placeholder: (context, url) => const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    ),
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            );
          }),
    );
  } else {
    return const Text("");
  }
}

Widget singleImageShowAndSave(String contentUrl, String imgs, Color color) {
  return GestureDetector(
      onTap: () {
        Get.to(() => ImageShowSingle(
              contentUrl: contentUrl,
              imgs: imgs,
              color: color,
            ));
      },
      child: Hero(
        tag: imgs,
        child: CachedNetworkImage(
          imageUrl: contentUrl + imgs,
          placeholder: (context, url) => const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
            ],
          ),
          fit: BoxFit.contain,
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ));
}

class ImageShowList extends StatefulWidget {
  final String contentUrl;
  final List imgs;
  final int initialIndex;
  final Color color;

  const ImageShowList(
      {super.key,
      required this.contentUrl,
      required this.imgs,
      required this.initialIndex,
      required this.color});

  @override
  State<ImageShowList> createState() => _ImageShowListState();
}

class _ImageShowListState extends State<ImageShowList> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.color,
        actions: [
          IconButton(
              onPressed: () async {
                for (String img in widget.imgs) {
                  await _saveNetworkImage(widget.contentUrl + img);
                }
              },
              icon: const Icon(Icons.download))
        ],
      ),
      body: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: CachedNetworkImageProvider(
                widget.contentUrl + widget.imgs[index]),
            initialScale: PhotoViewComputedScale.contained * 0.8,
            heroAttributes: PhotoViewHeroAttributes(tag: widget.imgs[index]),
          );
        },
        itemCount: widget.imgs.length,
        loadingBuilder: (context, event) => Center(
          child: SizedBox(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              value: event == null
                  ? 0
                  : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
            ),
          ),
        ),
        backgroundDecoration: const BoxDecoration(
          color: Colors.black,
        ),
        pageController: PageController(initialPage: widget.initialIndex),
        onPageChanged: onPageChanged,
      ),
    );
  }

  void onPageChanged(int index) {
    // setState(() {
    //   currentIndex = index;
    // });
  }
}

class ImageShowSingle extends StatefulWidget {
  final String contentUrl;
  final String imgs;
  final Color color;
  const ImageShowSingle(
      {super.key,
      required this.contentUrl,
      required this.imgs,
      required this.color});

  @override
  State<ImageShowSingle> createState() => _ImageShowSingleState();
}

class _ImageShowSingleState extends State<ImageShowSingle> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: widget.color,
          actions: [
            IconButton(
                onPressed: () {
                  _saveNetworkImage(widget.contentUrl + widget.imgs);
                },
                icon: const Icon(Icons.download))
          ],
        ),
        body: PhotoView(
          imageProvider:
              CachedNetworkImageProvider(widget.contentUrl + widget.imgs),
          initialScale: PhotoViewComputedScale.contained * 0.8,
          heroAttributes: PhotoViewHeroAttributes(tag: widget.imgs),
          loadingBuilder: (context, event) => Center(
            child: SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                value: event == null
                    ? 0
                    : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
              ),
            ),
          ),
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
        ));
  }

  void onPageChanged(int index) {
    // setState(() {
    //   currentIndex = index;
    // });
  }
}

// _saveNetworkImage(String path) async {
//   GallerySaver.saveImage(path).then((bool? success) {
//     if (success!) {
//       Get.snackbar("نجاح", "تم حفظ الصورة بنجاح", backgroundColor: MyColor.green, colorText: MyColor.white0);
//     } else {
//       Get.snackbar("خطأ", "يوجد خطأ ما,الرجاء التاكد من الصلاحيات", backgroundColor: MyColor.red, colorText: MyColor.white0);
//     }
//   });
// }
_saveNetworkImage(String path) async {
  var response =
      await Dio().get(path, options: Options(responseType: ResponseType.bytes));
  final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(response.data),
      quality: 60,
      name: "hello");

  Get.snackbar("نجاح", "تم حفظ الصورة بنجاح",
      backgroundColor: MyColor.green, colorText: MyColor.white0);

  print(result);
}
