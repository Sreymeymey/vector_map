import 'package:flutter/material.dart';
import 'package:vector_map/map/src/data/map_data_source.dart';
import 'package:vector_map/map/src/data/map_feature.dart';
import 'package:vector_map/map/src/drawable/circle_marker.dart';
import 'package:vector_map/map/src/drawable/marker.dart';
import 'package:vector_map/map/src/theme/map_highlight_theme.dart';

/// The [VectorMap] theme.
class MapTheme {
  static const Color defaultColor = Color(0xFFE0E0E0);
  static const Color defaultContourColor = Color(0xFF9E9E9E);

  static Color getThemeOrDefaultColor(
      MapDataSource dataSource, MapFeature feature, MapTheme theme) {
    Color? color = theme.getColor(dataSource, feature);
    if (color != null) {
      return color;
    }
    return MapTheme.defaultColor;
  }

  /// Gets the feature color.
  static Color getFeatureColor(MapDataSource dataSource, MapFeature feature,
      MapTheme theme, MapHighlightTheme? highlightTheme) {
    Color? color = highlightTheme?.color;
    if (color == null) {
      color = theme.getColor(dataSource, feature);
    }
    if (color != null) {
      return color;
    }
    return MapTheme.defaultColor;
  }

  /// Gets the feature contour color.
  static Color? getContourColor(
      MapTheme theme, MapHighlightTheme? highlightTheme) {
    Color? color = highlightTheme?.contourColor;
    if (color == null) {
      color = theme.contourColor;
    }
    return color;
  }

  /// Builds a [VectorMap]
  MapTheme(
      {Color? color,
      this.contourColor,
      this.labelVisibility,
      this.labelStyleBuilder,
      MarkerBuilder? markerBuilder})
      : this._color = color,
        this.markerBuilder =
            markerBuilder != null ? markerBuilder : CircleMakerBuilder.fixed();

  final Color? _color;
  final Color? contourColor;
  final LabelVisibility? labelVisibility;
  final LabelStyleBuilder? labelStyleBuilder;
  final MarkerBuilder markerBuilder;

  /// Indicates whether the theme has any value set.
  bool hasValue() {
    return _color != null || contourColor != null || labelVisibility != null;
  }

  /// Gets the feature color.
  Color? getColor(MapDataSource dataSource, MapFeature feature) {
    return _color;
  }
}

/// Defines the visibility of a [MapFeature]
typedef LabelVisibility = bool Function(MapFeature feature);

/// The label style builder.
typedef LabelStyleBuilder = TextStyle Function(
    MapFeature feature, Color featureColor, Color labelColor);
