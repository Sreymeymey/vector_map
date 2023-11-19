import 'dart:ui';

import 'package:vector_map/map/src/drawable/drawable.dart';

/// Defines a path to be painted on the map.
abstract class DrawablePath extends Drawable {
  DrawablePath(Path path, int pointsCount)
      : this._path = path,
        this._pointsCount = pointsCount;

  final Path _path;
  final int _pointsCount;

  @override
  void drawOn(Canvas canvas, Paint paint, double scale) {
    canvas.drawPath(_path, paint);
  }

  @override
  Rect getBounds() {
    return _path.getBounds();
  }

  @override
  bool contains(Offset offset) {
    return _path.contains(offset);
  }

  @override
  int get pointsCount => _pointsCount;

  @override
  bool get visible => true;
}
