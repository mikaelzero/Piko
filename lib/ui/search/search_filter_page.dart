import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pixiv/generated/l10n.dart';
import 'package:pixiv/model/search_filter.dart';
import 'package:pixiv/model/theme_model.dart';
import 'package:pixiv/utils/date_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pixiv/widget/date_range_picker.dart' as DateRagePicker;

class SearchFilterPage extends StatefulWidget {
  const SearchFilterPage({Key key}) : super(key: key);

  @override
  _SearchFilterPageState createState() => _SearchFilterPageState();
}

class _SearchFilterPageState extends State<SearchFilterPage> {
  List<int> starNum = [
    0,
    100,
    250,
    500,
    1000,
    5000,
    10000,
    20000,
    30000,
    50000,
  ];

  SearchFilterBean filterBean;
  int currentSort = -1;
  int currentSearchTarget = -1;
  double starValue = 0.0;
  DateTime startTime, endTime;

  final sortArr = ["date_desc", "date_asc", "popular_desc"];
  final search_target = ["exact_match_for_tags", "partial_match_for_tags", "title_and_caption"];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    getFilter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              height: 8,
              width: 60,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  width: 35,
                  height: 35,
                  child: Icon(Icons.close,color: ThemeModel().userDarkMode ? Colors.black54 : Colors.white70),
                ),
              ),
              Expanded(
                  child: Center(
                child: Text(
                  S.of(context).search_filter,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              )),
              GestureDetector(
                onTap: reset,
                child: Text(S.of(context).search_reset, style: TextStyle(color: Colors.grey)),
              ),
              SizedBox(width: 20),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: 20),
              Container(
                decoration: currentSort == 0 ? _getChooseBoxDecoration() : _getNormalBoxDecoration(),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      currentSort = 0;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                    child: Text(S.of(context).search_filter_date_desc, style: TextStyle(color: currentSort == 0 ? Colors.white : Colors.black54)),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Container(
                decoration: currentSort == 1 ? _getChooseBoxDecoration() : _getNormalBoxDecoration(),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      currentSort = 1;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                    child: Text(S.of(context).search_filter_date_asc, style: TextStyle(color: currentSort == 1 ? Colors.white : Colors.black54)),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Container(
                decoration: currentSort == 2 ? _getChooseBoxDecoration() : _getNormalBoxDecoration(),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      currentSort = 2;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                    child: Text(S.of(context).search_filter_popular_desc, style: TextStyle(color: currentSort == 2 ? Colors.white : Colors.black54)),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(S.of(context).search_filter_date),
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: handleShowDatePicker,
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: Colors.grey[200], width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                          startTime == null
                              ? S.of(context).search_filter_choose_date
                              : DateUtil.getFormat(startTime, "yyyy MM dd") + "-" + DateUtil.getFormat(endTime, "yyyy MM dd"),
                          style: TextStyle(color: Colors.grey)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 16, top: 8, bottom: 8),
                      child: SvgPicture.asset(
                        "assets/images/ic_date.svg",
                        color: Colors.grey,
                        width: 25,
                        height: 25,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(S.of(context).search_filter_collections_num),
                Text((starNum[starValue.toInt()]).toString()),
              ],
            ),
          ),
          SliderTheme(
            data: SliderThemeData(
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10, elevation: 10),
            ),
            child: Slider(
              activeColor: Theme.of(context).accentColor,
              inactiveColor: Colors.grey[300],
              onChanged: (double value) {
                int v = value.toInt();
                setState(() {
                  starValue = v.toDouble();
                });
              },
              value: starValue,
              max: 9.0,
            ),
          ),
          SizedBox(height: 20),
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 30),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(width: 20),
                Container(
                  decoration: currentSearchTarget == 0 ? _getChooseBoxDecoration() : _getNormalBoxDecoration(),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentSearchTarget = 0;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                      child: Text(S.of(context).search_filter_exact_match_for_tag,
                          style: TextStyle(color: currentSearchTarget == 0 ? Colors.white : Colors.black54)),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Container(
                  decoration: currentSearchTarget == 1 ? _getChooseBoxDecoration() : _getNormalBoxDecoration(),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentSearchTarget = 1;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                      child: Text(S.of(context).search_filter_partial_match_for_tag,
                          style: TextStyle(color: currentSearchTarget == 1 ? Colors.white : Colors.black54)),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Container(
                  decoration: currentSearchTarget == 2 ? _getChooseBoxDecoration() : _getNormalBoxDecoration(),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentSearchTarget = 2;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                      child: Text(S.of(context).search_filter_title_and_caption,
                          style: TextStyle(color: currentSearchTarget == 2 ? Colors.white : Colors.black54)),
                    ),
                  ),
                ),
                SizedBox(width: 20),
              ],
            ),
          ),
          GestureDetector(
            onTap: applyFilter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Container(
                  decoration: _getChooseBoxDecoration(),
                  child:  Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: Text(S.of(context).search_filter_apply, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  void applyFilter() {
    filterBean = SearchFilterBean();
    if (currentSort != -1) {
      filterBean.sort = sortArr[currentSort];
    }
    if (currentSearchTarget != -1) {
      filterBean.search_target = search_target[currentSearchTarget];
    }
    if (startTime != null) {
      filterBean.start_date = startTime;
    }
    if (endTime != null) {
      filterBean.end_date = endTime;
    }
    if (starValue != 0.0) {
      filterBean.bookmark_num = starNum[starValue.toInt()];
    }
    Navigator.pop(context, filterBean);
  }

  void reset() {
    setState(() {
      currentSort = -1;
      currentSearchTarget = -1;
      starValue = 0.0;
      startTime = null;
      endTime = null;
    });
  }

  void handleShowDatePicker() async {
    final List<DateTime> picked = await DateRagePicker.showDatePicker(
        context: context,
        initialFirstDate: startTime ?? DateTime.now().subtract(Duration(days: 7)),
        initialLastDate: endTime ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null && picked.length == 2) {
      setState(() {
        startTime = picked[0];
        endTime = picked[1];
      });
    }
  }

  BoxDecoration _getChooseBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      boxShadow: [
        BoxShadow(color: ThemeModel().userDarkMode ? Colors.black54 : Colors.blue[200], offset: Offset(5.0, 5.0), blurRadius: 10.0, spreadRadius: 2.0),
        BoxShadow(color: Theme.of(context).accentColor)
      ],
    );
  }

  BoxDecoration _getNormalBoxDecoration() {
    return BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );
  }

  Future<void> getFilter() async {
    String key = "search_filter_key";
    final prefs = await SharedPreferences.getInstance();
    SearchFilterBean bean = prefs.get(key);
    filterBean = bean;
  }

  void saveFilter(SearchFilterBean currentBean) async {
    String key = "search_filter_key";
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(currentBean));
  }
}
