import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:vector_math/vector_math_64.dart';

class OffsetUtil {
  static Offset globalToLocal(RenderObject object, Offset point, {RenderObject ancestor}) {
    final Matrix4 transform = object.getTransformTo(ancestor);
    final double det = transform.invert();
    if (det == 0.0) return Offset.zero;
    final Vector3 n = Vector3(0.0, 0.0, 1.0);
    final Vector3 i = transform.perspectiveTransform(Vector3(0.0, 0.0, 0.0));
    final Vector3 d = transform.perspectiveTransform(Vector3(0.0, 0.0, 1.0)) - i;
    final Vector3 s = transform.perspectiveTransform(Vector3(point.dx, point.dy, 0.0));
    final Vector3 p = s - d * (n.dot(s) / n.dot(d));
    return Offset(p.x, p.y);
  }
}
