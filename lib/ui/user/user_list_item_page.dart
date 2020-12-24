import 'package:flutter/material.dart';
import 'package:pixiv/model/illust.dart';
import 'package:pixiv/model/user_preview.dart';
import 'package:pixiv/widget/base_image.dart';

class UserItemContainer extends StatefulWidget {
  final UserPreviews userPreviews;

  const UserItemContainer({Key key, @required this.userPreviews}) : super(key: key);

  @override
  _UserItemContainerState createState() => _UserItemContainerState();
}

class _UserItemContainerState extends State<UserItemContainer> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List<Illusts> imageList = widget.userPreviews.illusts.length > 3 ? widget.userPreviews.illusts.sublist(0, 3) : widget.userPreviews.illusts;
    return Padding(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.only(left: 70),
                    child: Text(widget.userPreviews.user.name),
                  ),
                  height: 50,
                ),
                GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 2.0,
                  ),
                  itemCount: imageList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return PixivImage(
                      imageList[index].imageUrls.squareMedium,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    );
                  },
                ),
              ],
            ),
            Positioned(
              top: 16,
              left: 8,
              child: Container(
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular((50)),
                  boxShadow: [
                    BoxShadow(color: Colors.grey[500], offset: Offset(5.0, 5.0), blurRadius: 10.0, spreadRadius: 1.0),
                    BoxShadow(color: Colors.white)
                  ],
                ),
                child: PixivCircleImage(
                  widget.userPreviews.user.profileImageUrls.medium,
                  width: 50,
                  height: 50,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
