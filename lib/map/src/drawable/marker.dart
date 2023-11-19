import 'dart:ui';

import 'package:vector_map/map/src/data/map_data_source.dart';
import 'package:vector_map/map/src/data/map_feature.dart';
import 'package:vector_map/map/src/drawable/drawable.dart';

/// [Marker] builder.
abstract class MarkerBuilder {
  MarkerBuilder();

  /// Builds a [Marker]
  Marker build(
      {required MapDataSource dataSource,
      required MapFeature feature,
      required Offset offset,
      required double scale});
}

/// Defines a marker to be painted on the map.
abstract class Marker extends Drawable {
  Marker({required this.offset});

  final Offset offset;

  @override
  void drawOn(Canvas canvas, Paint paint, double scale) {
    drawMarkerOn(canvas, paint, offset, scale);
  }

  @override
  int get pointsCount => 1;

  /// Draw this marker on [Canvas]
  void drawMarkerOn(Canvas canvas, Paint paint, Offset offset, double scale);
}
