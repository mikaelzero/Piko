import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class SelectableHtml extends StatefulWidget {
  final String data;

  const SelectableHtml({Key key, @required this.data}) : super(key: key);

  @override
  _SelectableHtmlState createState() => _SelectableHtmlState();
}

class _SelectableHtmlState extends State<SelectableHtml> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {},
      child: HtmlWidget(
        widget.data ?? '~',
        customStylesBuilder: (e) {
          if (e.attributes.containsKey('href')) {
            return {'color': '#${Theme.of(context).accentColor.value.toRadixString(16).substring(2, 8)}'};
          }
          return null;
        },
        onTapUrl: (String url) async {
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            Share.share(url);
          }
        },
      ),
    );
  }
}
