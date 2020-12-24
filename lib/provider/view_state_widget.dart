import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:pixiv/config/resource_mananger.dart';
import 'package:pixiv/generated/l10n.dart';
import 'package:pixiv/utils/assets_util.dart';

import 'view_state.dart';

/// 加载中
class ViewStateBusyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}

/// 基础Widget
class ViewStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final Widget image;
  final Widget buttonText;
  final String buttonTextData;
  final VoidCallback onPressed;

  ViewStateWidget({Key key, this.image, this.title, this.message, this.buttonText, @required this.onPressed, this.buttonTextData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var titleStyle = Theme.of(context).textTheme.subhead.copyWith(color: Colors.grey);
    var messageStyle = titleStyle.copyWith(color: titleStyle.color.withOpacity(0.7), fontSize: 14);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        image ?? Icon(IconFonts.pageError, size: 50, color: Colors.grey[500]),
        Visibility(
            visible: title != null && title.isNotEmpty,
            child: Text(
              title ?? S.of(context).viewStateMessageError,
              style: titleStyle,
            )),
        Visibility(visible: message != null && message.isNotEmpty, child: Text(message ?? '', style: messageStyle)),
        SizedBox(height: 8),
        Visibility(
            visible: buttonTextData != null && buttonTextData.isNotEmpty,
            child: ViewStateButton(
              child: buttonText,
              textData: buttonTextData,
              onPressed: onPressed,
            )),
      ],
    );
  }
}

/// ErrorWidget
class ViewStateErrorWidget extends StatelessWidget {
  final ViewStateError error;
  final String title;
  final String message;
  final Widget image;
  final Widget buttonText;
  final String buttonTextData;
  final VoidCallback onPressed;

  const ViewStateErrorWidget({
    Key key,
    @required this.error,
    this.image,
    this.title,
    this.message,
    this.buttonText,
    this.buttonTextData,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var defaultTitle;
    switch (error.errorType) {
      case ViewStateErrorType.networkTimeOutError:
        defaultTitle = S.of(context).viewStateMessageNetworkError;
        break;
      case ViewStateErrorType.defaultError:
        defaultTitle = S.of(context).viewStateMessageError;
        break;
    }

    return ViewStateWidget(
      onPressed: this.onPressed,
      title: defaultTitle,
      image: image ?? Lottie.asset(lottie_error),
      buttonText: buttonText,
      buttonTextData: S.of(context).viewStateButtonRetry,
    );
  }
}

/// 页面无数据
class ViewStateEmptyWidget extends StatelessWidget {
  final String message;
  final Widget image;
  final Widget buttonText;
  final String buttonTextData;
  final VoidCallback onPressed;

  const ViewStateEmptyWidget({Key key, this.image, this.message, this.buttonText, this.buttonTextData, @required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewStateWidget(
      onPressed: this.onPressed,
      image: image ?? Lottie.asset(lottie_empty),
      buttonText: buttonText,
      buttonTextData: buttonTextData ?? S.of(context).viewStateButtonRefresh,
    );
  }
}

class ViewStateButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final String textData;

  const ViewStateButton({@required this.onPressed, this.child, this.textData}) : assert(child == null || textData == null);

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      child: child ??
          Text(
            textData ?? S.of(context).viewStateButtonRetry,
            style: TextStyle(wordSpacing: 5),
          ),
      textColor: Colors.grey,
      splashColor: Theme.of(context).splashColor,
      onPressed: onPressed,
      highlightedBorderColor: Theme.of(context).splashColor,
    );
  }
}
