import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:pixiv/generated/l10n.dart';
import 'package:pixiv/model/comment_response.dart';
import 'package:pixiv/net/api_client.dart';
import 'package:pixiv/provider/provider_widget.dart';
import 'package:pixiv/provider/view_state_widget.dart';
import 'package:pixiv/utils/date_util.dart';
import 'package:pixiv/view_model/comment_model.dart';
import 'package:pixiv/widget/base_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CommentPage extends StatefulWidget {
  final int id;

  const CommentPage({Key key, this.id}) : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final _commentController = TextEditingController();
  FocusNode focusNode;
  int parentCommentId;
  String replayName;

  @override
  void dispose() {
    _commentController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    _commentController.addListener(() {
      setState(() {});
    });
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (!visible) {
          setState(() {
            replayName = null;
            parentCommentId = null;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<CommentModel>(
      model: CommentModel(widget.id),
      onModelReady: (model) => model.initData(),
      builder: (context, model, child) {
        if (model.isBusy) {
          return ViewStateBusyWidget();
        } else if (model.isError && model.list.isEmpty) {
          return ViewStateErrorWidget(error: model.viewStateError, onPressed: model.initData);
        } else if (model.isEmpty) {
          return ViewStateEmptyWidget(onPressed: model.initData);
        }
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                width: double.maxFinite,
                child: Stack(
                  children: [
                    Center(
                      child: Text(model.list.length.toString() + S.of(context).comment_title),
                    ),
                    Positioned(
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.close),
                        ))
                  ],
                ),
              ),
            ),
            Expanded(
                child: SmartRefresher(
              enablePullDown: false,
              enablePullUp: true,
              controller: model.refreshController,
              onRefresh: model.refresh,
              onLoading: model.loadMore,
              child: ListView.builder(
                itemBuilder: (c, i) => _getCommentItem(model.list[i]),
                itemCount: model.list.length,
              ),
            )),
            Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      maxLines: 5,
                      minLines: 1,
                      focusNode: focusNode,
                      style: TextStyle(fontSize: 16),
                      controller: _commentController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: S.of(context).replay + (replayName != null ? ("@" + replayName) : "")),
                      keyboardType: TextInputType.multiline,
                    )),
                    GestureDetector(
                        onTap: () {
                          commitComment(model);
                        },
                        child: SvgPicture.asset(
                          "assets/images/ic_comment_send.svg",
                          color: _commentController.text.isNotEmpty ? Colors.redAccent : Colors.grey[400],
                          width: 24,
                          height: 24,
                        ))
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _getCommentItem(Comment comment) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: [
          PixivCircleImage(comment.user.profileImageUrls.medium, width: 45, height: 45),
          SizedBox(width: 16),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(comment.user.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black45)),
              SizedBox(height: 8),
              Text(_getCommentDesc(comment), style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    DateUtil.getNormal(comment.date),
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      parentCommentId = comment.id;
                      setState(() {
                        replayName = comment.user.name;
                      });
                      FocusScope.of(context).requestFocus(focusNode);
                    },
                    child: Text(S.of(context).replay, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black45)),
                  )
                ],
              )
            ],
          )),
        ],
      ),
    );
  }

  String _getCommentDesc(Comment comment) {
    if (comment.parentComment.user != null) {
      return "@" + comment.parentComment.user.name.toString() + " " + comment.comment;
    } else {
      return comment.comment;
    }
  }

  void commitComment(CommentModel model) async {
    String txt = _commentController.text.trim();
    if (txt.isEmpty) {
      return;
    }
    _commentController.clear();
    parentCommentId = null;
    replayName = null;
    await apiClient.postIllustComment(widget.id, txt, parent_comment_id: parentCommentId);
    model.refresh();
  }
}
