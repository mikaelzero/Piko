import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LineBorderText extends StatefulWidget {
  final Widget child;
  final Size size;
  final bool autoAnim;
  final dynamic tag;

  const LineBorderText({Key key, this.child, this.size = Size.zero, this.autoAnim = true, this.tag = ""}) : super(key: key);

  @override
  _LineBorderTextState createState() => _LineBorderTextState();
}

class _LineBorderTextState extends State<LineBorderText> with TickerProviderStateMixin<LineBorderText> {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: Duration(milliseconds: 700), vsync: this);
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.value = 0;
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
    if (widget.autoAnim) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(LineBorderText oldWidget) {
    super.didUpdateWidget(oldWidget);
    dynamic oldTag = oldWidget.tag;
    dynamic tag = widget.tag;
    bool equals = tag == oldTag;
    if (!equals && widget.autoAnim && !_animationController.isAnimating) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget child) {
        double progress = _animationController.value;
        return CustomPaint(
          foregroundPainter: _BorderLinePainter(progress),
          child: RepaintBoundary(child: widget.child),
          size: widget.size,
        );
      },
    );
  }
}

class _BorderLinePainter extends CustomPainter {
  final double _progress;

  _BorderLinePainter(this._progress);

  @override
  void paint(Canvas canvas, Size size) {
    double padding = 5;
    Paint paint = Paint();
    paint.color = Colors.blue;
    paint.isAntiAlias = true;
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.square;
    paint.strokeWidth = 2;

    double percent = _progress;
    double percent2 = sqrt(3.38 - (percent - 1.7) * (percent - 1.7)) - 0.7;

    double width = size.width + padding;
    double height = size.height + padding;

    Offset pA = Offset(-padding, -padding);
    Offset pB = Offset(width, -padding);
    Offset pC = Offset(width, height);
    Offset pD = Offset(-padding, height);

    Offset p1 = Offset(width * percent2, pB.dy);
    canvas.drawLine(p1, pB, paint);

    Offset p2 = Offset(pB.dx, height * percent);
    canvas.drawLine(pB, p2, paint);

    Offset p3 = Offset(width, height * percent2);
    canvas.drawLine(p3, pC, paint);

    Offset p4 = Offset(width * (1 - percent), height);
    canvas.drawLine(pC, p4, paint);

    Offset p5 = Offset(width * (1 - percent2), height);
    canvas.drawLine(p5, pD, paint);

    Offset p6 = Offset(-padding, height * (1 - percent));
    canvas.drawLine(pD, p6, paint);

    Offset p7 = Offset(-padding, height * (1 - percent2));
    canvas.drawLine(p7, pA, paint);

    Offset p8 = Offset(width * percent, -padding);
    canvas.drawLine(pA, p8, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate is _BorderLinePainter) {
      double oldProgress = oldDelegate._progress;
      if (oldProgress == _progress) {
        return false;
      }
    }
    return true;
  }
}
