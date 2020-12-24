import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pixiv/generated/l10n.dart';
import 'package:pixiv/provider/provider_widget.dart';
import 'package:pixiv/ui/detail/illust_page.dart';
import 'package:pixiv/ui/user/user_home_page.dart';
import 'package:pixiv/view_model/search_suggestions_model.dart';

class SearchSuggestionsPage extends StatefulWidget {
  final TextEditingController searchController;
  final callback;

  SearchSuggestionsPage( this.searchController, this.callback);

  @override
  SearchSuggestionsPageState createState() => SearchSuggestionsPageState();
}

class SearchSuggestionsPageState extends State<SearchSuggestionsPage> {
  SearchSuggestionsModel model;

  @override
  void initState() {
    super.initState();
    model = SearchSuggestionsModel();
    widget.searchController.addListener(() {
      model.fetch(widget.searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 170),
      child: ProviderWidget<SearchSuggestionsModel>(
          model: model,
          onModelReady: (model) => model.fetch(widget.searchController.text),
          builder: (context, model, child) {
            if (model.isBusy) {
              return Container(
                color: Theme.of(context).accentColor,
                child: Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Colors.white70,
                )),
              );
            }
            if (model.isEmpty) {
              return Container(
                color: Theme.of(context).accentColor,
                child: Center(child: Text(S.of(context).search_empty_desc, style: TextStyle(color: Colors.white60))),
              );
            }
            return Container(
              color: Theme.of(context).accentColor,
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverVisibility(
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        if (index == 0)
                          return ListTile(
                            title: Text(widget.searchController.text ?? '', style: TextStyle(color: Colors.white60)),
                            subtitle: Text(S.of(context).illust_id, style: TextStyle(color: Colors.white54)),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => IllustPage(
                                        id: int.tryParse(widget.searchController.text),
                                      )));
                            },
                          );
                        return ListTile(
                          title: Text(widget.searchController.text ?? '', style: TextStyle(color: Colors.white60)),
                          subtitle: Text(S.of(context).user_id, style: TextStyle(color: Colors.white54)),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) => UserHomePage(int.tryParse(widget.searchController.text))));
                          },
                        );
                      }, childCount: 2),
                    ),
                    visible: widget.searchController.text.length <= 5 && int.tryParse(widget.searchController.text) != null,
                  ),
                  if (model.autoWords != null && model.autoWords.tags.isNotEmpty)
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final tags = model.autoWords.tags;
                        return ListTile(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            widget.callback(tags[index].name);
                          },
                          title: Text(tags[index].name, style: TextStyle(color: Colors.white60)),
                          subtitle: Text(tags[index].translated_name ?? "", style: TextStyle(color: Colors.white54)),
                        );
                      }, childCount: model.autoWords.tags.length),
                    ),
                ],
              ),
            );
          }),
    );
  }
}
