import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pixiv/generated/l10n.dart';
import 'package:pixiv/utils/exts.dart';

class PhotoViewGalleryScreenPage extends StatefulWidget {
  List images = [];
  int index = 0;
  String heroTag;
  PageController controller;

  PhotoViewGalleryScreenPage({Key key, @required this.images, this.index, this.controller, this.heroTag}) : super(key: key) {
    controller = PageController(initialPage: index);
  }

  @override
  _PhotoViewGalleryScreenState createState() => _PhotoViewGalleryScreenState();
}

class _PhotoViewGalleryScreenState extends State<PhotoViewGalleryScreenPage> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0,
            child: Container(
              child: ExtendedImageGesturePageView.builder(
                controller: PageController(
                  initialPage: currentIndex,
                ),
                itemCount: widget.images.length,
                onPageChanged: (num) {
                  setState(() {
                    currentIndex = num;
                  });
                },
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onLongPress: () {
                      showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16.0))),
                          builder: (_) {
                            return SafeArea(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    title: Text(S.of(context).save),
                                    onTap: () {
                                      saveNetworkImageToPhoto(widget.images[currentIndex]);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    child: ExtendedImage.network(
                      widget.images[index],
                      headers: {"referer": "https://app-api.pixiv.net/", "User-Agent": "PixivIOSApp/5.8.0", "Host": ImageHost},
                      fit: BoxFit.contain,
                      mode: ExtendedImageMode.gesture,
                      initGestureConfigHandler: (ExtendedImageState state) {
                        return GestureConfig(
                          inPageView: true,
                          initialScale: 1.0,
                          maxScale: 5.0,
                          animationMaxScale: 6.0,
                          initialAlignment: InitialAlignment.center,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 15,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text("${currentIndex + 1}/${widget.images.length}", style: TextStyle(fontSize: 16)),
            ),
          ),
          Positioned(
            right: 10,
            top: MediaQuery.of(context).padding.top,
            child: IconButton(
              icon: Icon(
                Icons.close,
                size: 30,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> saveNetworkImageToPhoto(String url, {bool useCache: false}) async {
    var appDocDir = await getExternalStorageDirectory();
    String savePath = appDocDir.path + "/piko/" + DateTime.now().millisecondsSinceEpoch.toString() + ".jpg";
    await Dio().download(url, savePath,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {"referer": "https://app-api.pixiv.net/", "User-Agent": "PixivIOSApp/5.8.0", "Host": ImageHost},
        ));
    final result = await ImageGallerySaver.saveFile(savePath);
    BotToast.showText(text: (result != null && result != "") ? S.of(context).save_success : S.of(context).save_failed);
    return result != null && result != "";
  }
}
