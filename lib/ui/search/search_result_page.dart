import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:pixiv/generated/l10n.dart';
import 'package:pixiv/model/search_filter.dart';
import 'package:pixiv/model/theme_model.dart';
import 'package:pixiv/provider/provider_widget.dart';
import 'package:pixiv/provider/view_state_widget.dart';
import 'package:pixiv/ui/detail/illust_page.dart';
import 'package:pixiv/ui/search/result_illust_list.dart';
import 'package:pixiv/ui/search/result_user_list.dart';
import 'package:pixiv/ui/search/search_filter_page.dart';
import 'package:pixiv/ui/search/search_suggestion_page.dart';
import 'package:pixiv/ui/user/user_home_page.dart';
import 'package:pixiv/view_model/search_history_model.dart';

class SearchResultPage extends StatefulWidget {
  /// 0为 插画  1 为用户
  final int searchType;
  final String searchString;

  SearchResultPage(this.searchType, {this.searchString});

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  final _searchController = TextEditingController();
  var searchKey = "";
  GlobalKey<ResultIllustListState> resultKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        setState(() {
          searchKey = "";
        });
      }
      setState(() {});
    });
    if (widget.searchString != null) {
      searchKey = widget.searchString;
      _searchController.text = searchKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            _buildContent(),
            _buildAppbar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAppbar(BuildContext context) {
    return Container(
      height: 170,
      decoration: (_searchController.text.isEmpty || searchKey.isNotEmpty) && _searchController.text == searchKey
          ? BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
              boxShadow: [
                BoxShadow(
                    color: ThemeModel().userDarkMode ? Colors.black54 : Colors.blue[200],
                    offset: Offset(5.0, 5.0),
                    blurRadius: 30.0,
                    spreadRadius: 2.0),
                BoxShadow(color: Theme.of(context).accentColor)
              ],
            )
          : BoxDecoration(color: Theme.of(context).accentColor),
      child: Padding(
        padding: EdgeInsets.only(top: 36),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_searchController.text.isNotEmpty) {
                        setState(() {
                          _searchController.text = "";
                          searchKey = "";
                        });
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  Visibility(
                      visible: widget.searchType == 0,
                      child: GestureDetector(
                        onTap: _openBottomSheet,
                        child: Icon(Icons.sort, color: Colors.white),
                      )),
                ],
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorDark,
                  borderRadius: BorderRadius.circular((30)),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 16),
                    Icon(Icons.search, color: Colors.white),
                    SizedBox(width: 16),
                    Expanded(child: _textField()),
                    SizedBox(width: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_searchController.text.isEmpty) {
      return _buildHistory();
    } else if (searchKey.isNotEmpty && searchKey == _searchController.text) {
      return widget.searchType == 0
          ? ResultIllustListPage(
              key: resultKey,
              word: searchKey,
            )
          : ResultUserListPage(word: searchKey);
    } else {
      return SearchSuggestionsPage(_searchController, (String word) {
        _searchController.text = word;
        setState(() {
          searchKey = word;
        });
        SearchHistoryModel.saveHistory(word);
      });
    }
  }

  Widget _textField() {
    return TextField(
      style: TextStyle(color: Colors.white),
      controller: _searchController,
      cursorColor: Colors.white70,
      decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintStyle: TextStyle(color: Colors.white70),
          hintText: S.of(context).search_hit),
      onChanged: (query) {
        if (query.startsWith('https://')) {
          Uri uri = Uri.parse(query);
          if (!uri.host.contains('pixiv')) {
            return;
          }
          final segment = uri.pathSegments;
          if (segment.length == 1 && query.contains("/member.php?id=")) {
            final id = uri.queryParameters['id'];
            Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (BuildContext context) => UserHomePage(int.parse(id))));
            _searchController.clear();
          }
          if (segment.length == 2) {
            if (segment[0] == 'artworks') {
              Navigator.of(context, rootNavigator: true)
                  .push(MaterialPageRoute(builder: (BuildContext context) => IllustPage(id: int.parse(segment[1]))));
              _searchController.clear();
            }
            if (segment[0] == 'users') {
              Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (BuildContext context) {
                return UserHomePage(int.parse(segment[1]));
              }));
              _searchController.clear();
            }
          }
        }
        var word = query.trim();
        if (word.isEmpty) return;
        bool isNum = int.tryParse(query) != null;
        if (isNum && word.length > 5) return;
      },
      onSubmitted: (s) {
        searchSubmit(s);
      },
    );
  }

  Widget _buildHistory() {
    return ProviderWidget<SearchHistoryModel>(
      model: SearchHistoryModel(),
      onModelReady: (model) => model.getHistory(),
      builder: (context, model, child) {
        if (model.isBusy) {
          return ViewStateBusyWidget();
        } else if (model.isEmpty) {
          return ViewStateEmptyWidget(onPressed: model.getHistory);
        }
        return Padding(
          padding: EdgeInsets.only(top: 200, left: 20, right: 20, bottom: 20),
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Tags(
                  runSpacing: 2,
                  alignment: WrapAlignment.start,
                  itemCount: model.historyList.isEmpty ? 0 : model.historyList.length,
                  itemBuilder: (int index) {
                    return GestureDetector(
                      onTap: () {
                        _searchController.text = model.historyList[index];
                        _searchController.selection =
                            TextSelection.fromPosition(TextPosition(affinity: TextAffinity.downstream, offset: model.historyList[index].length));
                        searchSubmit(model.historyList[index]);
                      },
                      child: Opacity(
                        opacity: 0.7,
                        child: Container(
                          decoration: new BoxDecoration(
                            color: Theme.of(context).accentColor,
                            borderRadius: new BorderRadius.circular((8.0)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                            child: Text(model.historyList[index], style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void searchSubmit(String s) {
    var word = s.trim();
    if (word.isEmpty) return;
    setState(() {
      searchKey = word;
    });
    SearchHistoryModel.saveHistory(word);
  }

  Future _openBottomSheet() async {
    SearchFilterBean result = await showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
        context: context,
        builder: (BuildContext context) {
          return SearchFilterPage();
        });
    if (widget.searchType == 0) {
      resultKey.currentState.setFilter(result);
    }
  }
}
