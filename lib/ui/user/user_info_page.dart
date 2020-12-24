import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pixiv/generated/l10n.dart';
import 'package:pixiv/model/user_detail.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class UserInfoPage extends StatefulWidget {
  final String tabName;
  final UserDetail userDetail;

  const UserInfoPage(this.tabName, this.userDetail, {Key key}) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Builder(
        builder: (context) => CustomScrollView(
              key: PageStorageKey<String>(widget.tabName),
              slivers: <Widget>[
                SliverOverlapInjector(handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
                SliverPadding(
                    padding: EdgeInsets.all(16.0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(
                              widget.userDetail.user.name + "@" + widget.userDetail.user.account,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 16),
                          Visibility(
                              visible: widget.userDetail.profile.webpage != null,
                              child: GestureDetector(
                                  onTap: () async {
                                    final url = widget.userDetail.profile.webpage;
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {}
                                  },
                                  child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                                    SvgPicture.asset("assets/images/ic_webpage.svg", color: Color(0xFF209CEB), width: 25, height: 25),
                                    SizedBox(width: 8),
                                    Text(widget.userDetail.profile.webpage.toString(), style: TextStyle(color: Color(0xFF209CEB))),
                                  ]))),
                          Visibility(
                              visible: widget.userDetail.profile.twitter_url != null,
                              child: GestureDetector(
                                  onTap: () async {
                                    final url = widget.userDetail.profile.twitter_url;
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {}
                                  },
                                  child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                                    SvgPicture.asset("assets/images/ic_twitter.svg", width: 25, height: 25),
                                    SizedBox(width: 8),
                                    Text(widget.userDetail.profile.twitter_account.toString(), style: TextStyle(color: Color(0xFF209CEB))),
                                  ]))),
                          SizedBox(height: 16),
                          Container(
                              alignment: Alignment.center,
                              child: SelectableLinkify(
                                  onOpen: (link) async {
                                    if (await canLaunch(link.url)) {
                                      await launch(link.url);
                                    } else {
                                      Share.share(link.url);
                                    }
                                  },
                                  text: widget.userDetail.user.comment,
                                  textAlign: TextAlign.center)),
                          SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Visibility(
                                  visible: widget.userDetail.profile.gender.isNotEmpty,
                                  child: Text(widget.userDetail.profile.gender == 'female' ? S.of(context).female : S.of(context).male)),
                              Visibility(visible: widget.userDetail.profile.region.isNotEmpty, child: Text(" " + widget.userDetail.profile.region)),
                              Visibility(
                                  visible: widget.userDetail.profile.birth_year != 0,
                                  child: Text(" " + (DateTime.now().year - widget.userDetail.profile.birth_year).toString())),
                              Visibility(
                                  visible: widget.userDetail.profile.birth.isNotEmpty, child: Text(" " + widget.userDetail.profile.birth.toString()))
                            ],
                          ),
                          SizedBox(height: 8),
                          _buildWorkSpace()
                        ],
                      ),
                    ))
              ],
            ));
  }

  Widget _buildWorkSpace() {
    return Column(
      children: [
        _buildSingleWorkSpace(S.of(context).workspace_pc, widget.userDetail.workspace.pc),
        _buildSingleWorkSpace(S.of(context).workspace_monitor, widget.userDetail.workspace.monitor),
        _buildSingleWorkSpace(S.of(context).workspace_tool, widget.userDetail.workspace.tool),
        _buildSingleWorkSpace(S.of(context).workspace_scanner, widget.userDetail.workspace.scanner),
        _buildSingleWorkSpace(S.of(context).workspace_tablet, widget.userDetail.workspace.tablet),
        _buildSingleWorkSpace(S.of(context).workspace_printer, widget.userDetail.workspace.printer),
        _buildSingleWorkSpace(S.of(context).workspace_mouse, widget.userDetail.workspace.mouse),
        _buildSingleWorkSpace(S.of(context).workspace_music, widget.userDetail.workspace.music),
        _buildSingleWorkSpace(S.of(context).workspace_desk, widget.userDetail.workspace.desk),
        _buildSingleWorkSpace(S.of(context).workspace_chair, widget.userDetail.workspace.chair),
        _buildSingleWorkSpace(S.of(context).workspace_comment, widget.userDetail.workspace.comment),
      ],
    );
  }

  Widget _buildSingleWorkSpace(String desc, String data) {
    return Visibility(
        visible: data.isNotEmpty && data != null,
        child: Padding(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  flex: 7,
                  child: Text(
                    desc,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  )),
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Expanded(flex: 12, child: SelectableText(data))
            ],
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
