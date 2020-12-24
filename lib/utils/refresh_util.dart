import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:pixiv/utils/assets_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PixivRefreshHeader extends RefreshIndicator {
  PixivRefreshHeader() : super(height: 80.0, refreshStyle: RefreshStyle.Behind);

  @override
  State<StatefulWidget> createState() {
    return PixivRefreshHeaderState();
  }
}

class PixivRefreshHeaderState extends RefreshIndicatorState<PixivRefreshHeader> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    _controller.repeat(period: Duration(seconds: 1));
    super.initState();
  }

  @override
  void onModeChange(RefreshStatus mode) {
    super.onModeChange(mode);
  }

  @override
  void resetValue() {
    super.resetValue();
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus mode) {
    return Center(
      child: Lottie.asset(refresh_header_lottie, controller: _controller, height: 80),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class PixivRefreshFooter extends StatefulWidget {
  PixivRefreshFooter() : super();

  @override
  State<StatefulWidget> createState() {
    return _PixivRefreshFooterState();
  }
}

class _PixivRefreshFooterState extends State<PixivRefreshFooter> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    _controller.repeat(period: Duration(seconds: 1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      height: 80,
      builder: (context, mode) {
        if (mode == LoadStatus.noMore) {
          return Center();
        } else {
          return Center(
            child: Lottie.asset(refresh_footer_lottie, controller: _controller, height: 80),
          );
        }
      },
      loadStyle: LoadStyle.ShowWhenLoading,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
