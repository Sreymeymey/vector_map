import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vector_map/map/src/addon/legend/legend.dart';
import 'package:vector_map/map/src/data/map_feature.dart';
import 'package:vector_map/map/src/data/map_layer.dart';
import 'package:vector_map/map/src/error.dart';
import 'package:vector_map/map/src/map_highlight.dart';
import 'package:vector_map/map/src/theme/map_gradient_theme.dart';
import 'package:vector_map/map/src/vector_map_api.dart';

/// Legend for [MapGradientTheme]
class GradientLegend extends Legend {
  /// Builds a [GradientLegend].
  ///
  /// The layer's theme must be a [MapGradientTheme].
  GradientLegend(
      {required MapLayer layer,
      EdgeInsetsGeometry? padding,
      EdgeInsetsGeometry? margin = const EdgeInsets.all(8),
      Decoration? decoration,
      this.barHeight = 100,
      double? fontSize,
      this.barWidth = 15,
      this.textGap = 8,
      this.barBorder})
      : this.fontSize = fontSize != null ? math.max(fontSize, 6) : 12,
        super(
            layer: layer,
            padding: padding,
            margin: margin,
            decoration: decoration) {
    if (layer.theme is MapGradientTheme == false) {
      throw VectorMapError('The layer theme must be a MapGradientTheme');
    }
  }

  final double textGap;
  final double barWidth;
  final double barHeight;
  final double fontSize;
  final BoxBorder? barBorder;

  @override
  Widget buildWidget(
      {required BuildContext context,
      required VectorMapApi mapApi,
      MapFeature? hover}) {
    return _GradientLegendWidget(legend: this, mapApi: mapApi);
  }

  double get _totalBarWidth {
    if (barBorder != null) {
      return barWidth + barBorder!.dimensions.horizontal;
    }
    return barWidth;
  }

  double get _totalBarHeight {
    if (barBorder != null) {
      return barHeight + barBorder!.dimensions.vertical;
    }
    return barHeight;
  }

  double get _barBorderHeight {
    if (barBorder != null) {
      return barBorder!.dimensions.vertical;
    }
    return 0;
  }
}

class _GradientLegendWidget extends StatefulWidget {
  const _GradientLegendWidget({required this.legend, required this.mapApi});

  final GradientLegend legend;
  final VectorMapApi mapApi;

  @override
  State<StatefulWidget> createState() => _GradientLegendState();
}

class _GradientLegendState extends State<_GradientLegendWidget> {
  _ValuePosition? valuePosition;

  @override
  Widget build(BuildContext context) {
    GradientLegend legend = widget.legend;

    MapGradientTheme gradientTheme = legend.layer.theme as MapGradientTheme;

    List<LayoutId> children = [];

    double? min = gradientTheme.min(legend.layer.dataSource);
    double? max = gradientTheme.max(legend.layer.dataSource);

    if (max != null && min != null) {
      children.add(LayoutId(
          id: _ChildId.bar,
          child: _GradientBar(
              layerId: widget.legend.layer.id,
              propertyKey: gradientTheme.key,
              min: min,
              max: max,
              colors: gradientTheme.colors,
              valuePositionUpdater: _updateValuePosition,
              border: widget.legend.barBorder,
              mapApi: widget.mapApi)));

      children.add(LayoutId(id: _ChildId.max, child: _text(max.toString())));

      children.add(LayoutId(id: _ChildId.min, child: _text(min.toString())));

      if (valuePosition != null) {
        children.add(LayoutId(
            id: _ChildId.value, child: _text(valuePosition!.formattedValue)));
      }
    }

    return Container(
        decoration: legend.decoration,
        margin: legend.margin,
        padding: legend.padding,
        child: _GradientLegendLayout(
            children: children,
            legend: widget.legend,
            valuePosition: valuePosition?.y));
  }

  Widget _text(String value) {
    return Container(
        child: Text(value.toString(),
            style: TextStyle(fontSize: widget.legend.fontSize),
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        padding: EdgeInsets.all(2),
        color: Colors.white.withOpacity(.7));
  }

  void _updateValuePosition(_ValuePosition? newValuePosition) {
    setState(() {
      valuePosition = newValuePosition;
    });
  }
}

typedef _ValuePositionUpdater = Function(_ValuePosition? position);

/// Holds the formatted value and location in gradient bar
class _ValuePosition {
  _ValuePosition(this.y, this.formattedValue);

  final double y;
  final String formattedValue;
}

/// Gradient bar widget
class _GradientBar extends StatelessWidget {
  const _GradientBar(
      {required this.layerId,
      required this.propertyKey,
      required this.min,
      required this.max,
      required this.colors,
      required this.valuePositionUpdater,
      this.border,
      required this.mapApi});

  final int layerId;
  final String propertyKey;
  final double min;
  final double max;
  final List<Color> colors;
  final _ValuePositionUpdater valuePositionUpdater;
  final BoxBorder? border;
  final VectorMapApi mapApi;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      MouseRegion mouseRegion = MouseRegion(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: colors)),
          ),
          onHover: (event) => _highlightOn(
              context, constraints.maxHeight, event.localPosition.dy),
          onExit: (event) => _highlightOff(context));
      if (border != null) {
        return Container(
            child: mouseRegion, decoration: BoxDecoration(border: border));
      }
      return mouseRegion;
    });
  }

  void _highlightOn(BuildContext context, double maxHeight, double y) {
    double range = max - min;
    double value = min + (((maxHeight - y) * range) / maxHeight);
    MapGradientHighlight highlight = MapGradientHighlight(
        layerId: layerId,
        key: propertyKey,
        value: value,
        rangePerPixel: range / maxHeight,
        min: min,
        max: max);
    mapApi.setHighlight(highlight);
    valuePositionUpdater(_ValuePosition(y, highlight.formattedValue));
  }

  void _highlightOff(BuildContext context) {
    mapApi.clearHighlight();
    valuePositionUpdater(null);
  }
}

enum _ChildId { bar, max, min, value }

class _GradientLegendLayout extends MultiChildRenderObjectWidget {
  _GradientLegendLayout(
      {Key? key,
      required List<LayoutId> children,
      required this.legend,
      this.valuePosition})
      : super(
          key: key,
          children: children,
        );

  final GradientLegend legend;
  final double? valuePosition;

  @override
  _GradientLegendLayoutElement createElement() {
    return _GradientLegendLayoutElement(this);
  }

  @override
  _GradientLegendLayoutRenderBox createRenderObject(BuildContext context) {
    return _GradientLegendLayoutRenderBox(legend, valuePosition);
  }

  @override
  void updateRenderObject(
      BuildContext context, _GradientLegendLayoutRenderBox renderObject) {
    renderObject..legend = legend;
    renderObject..valuePosition = valuePosition;
  }
}

class _GradientLegendLayoutElement extends MultiChildRenderObjectElement {
  _GradientLegendLayoutElement(_GradientLegendLayout widget) : super(widget);

  @override
  void debugVisitOnstageChildren(ElementVisitor visitor) {
    children.forEach((child) {
      if (child.renderObject != null) {
        _GradientLegendLayoutParentData parentData =
            child.renderObject!.parentData as _GradientLegendLayoutParentData;
        if (parentData.visible) {
          visitor(child);
        }
      }
    });
  }
}

class _GradientLegendLayoutParentData extends MultiChildLayoutParentData {
  bool visible = false;
}

class _GradientLegendLayoutRenderBox extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _GradientLegendLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox,
            _GradientLegendLayoutParentData> {
  _GradientLegendLayoutRenderBox(this.legend, this.valuePosition);

  GradientLegend legend;
  double? valuePosition;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _GradientLegendLayoutParentData) {
      child.parentData = _GradientLegendLayoutParentData();
    }
  }

  @override
  void performLayout() {
    RenderBox? minRenderBox;
    _GradientLegendLayoutParentData? minParentData;
    RenderBox? maxRenderBox;
    _GradientLegendLayoutParentData? maxParentData;
    RenderBox? valueRenderBox;
    _GradientLegendLayoutParentData? valueParentData;
    RenderBox? barRenderBox;
    _GradientLegendLayoutParentData? barParentData;

    visitChildren((child) {
      final _GradientLegendLayoutParentData parentData =
          child.gradientLegendLayoutParentData();
      parentData.visible = true;
      if (parentData.id == _ChildId.bar) {
        barRenderBox = child as RenderBox;
        barParentData = barRenderBox!.gradientLegendLayoutParentData();
      } else if (parentData.id == _ChildId.min) {
        minRenderBox = child as RenderBox;
        minParentData = minRenderBox!.gradientLegendLayoutParentData();
      } else if (parentData.id == _ChildId.max) {
        maxRenderBox = child as RenderBox;
        maxParentData = maxRenderBox!.gradientLegendLayoutParentData();
      } else if (parentData.id == _ChildId.value) {
        valueRenderBox = child as RenderBox;
        valueParentData = valueRenderBox!.gradientLegendLayoutParentData();
      }
    });

    double maxTextWidth = 0;
    double maxTextHeight = 0;
    double height = 0;
    if (valueRenderBox != null) {
      if (valuePosition != null) {
        _layoutTextChild(valueRenderBox!);
        maxTextHeight = math.max(maxTextHeight, valueRenderBox!.size.height);
        maxTextWidth = math.max(maxTextWidth, valueRenderBox!.size.width);
      } else {
        valueParentData!.visible = false;
      }
    }
    if (maxRenderBox != null) {
      _layoutTextChild(maxRenderBox!);
      maxTextHeight = math.max(maxTextHeight, maxRenderBox!.size.height);
      maxTextWidth = math.max(maxTextWidth, maxRenderBox!.size.width);
    }
    if (minRenderBox != null) {
      _layoutTextChild(minRenderBox!);
      maxTextHeight = math.max(maxTextHeight, minRenderBox!.size.height);
      maxTextWidth = math.max(maxTextWidth, minRenderBox!.size.width);
    }
    double barHeight = 0;
    if (barRenderBox != null) {
      barHeight = math.min(
          legend._totalBarHeight, constraints.maxHeight - maxTextHeight);
      barRenderBox!.layout(
          BoxConstraints.tightFor(
              width: legend._totalBarWidth, height: barHeight),
          parentUsesSize: true);
      height += barHeight;
    }

    // new size
    height += maxTextHeight;
    size = Size(maxTextWidth + legend._totalBarWidth + legend.textGap, height);

    if (barHeight - legend._barBorderHeight < 6) {
      barParentData?.visible = false;
      valueParentData?.visible = false;
      maxParentData?.visible = false;
      minParentData?.visible = false;
      return;
    }

    if (valueRenderBox != null && valuePosition != null) {
      valueParentData!.offset = Offset(
          size.width -
              valueRenderBox!.size.width -
              legend.textGap -
              legend._totalBarWidth,
          valuePosition! + legend._barBorderHeight / 2);
    }
    if (maxRenderBox != null) {
      if (valuePosition != null && valuePosition! < maxTextHeight) {
        maxParentData!.visible = false;
      } else {
        maxParentData!.offset = Offset(
            size.width -
                maxRenderBox!.size.width -
                legend.textGap -
                legend._totalBarWidth,
            legend._barBorderHeight / 2);
      }
    }

    if (minRenderBox != null) {
      if (valuePosition != null &&
          valuePosition! >
              barHeight - maxTextHeight - legend._barBorderHeight) {
        minParentData!.visible = false;
      } else {
        minParentData!.offset = Offset(
            size.width -
                minRenderBox!.size.width -
                legend.textGap -
                legend._totalBarWidth,
            size.height - maxTextHeight - legend._barBorderHeight / 2);
      }
    }
    if (barRenderBox != null) {
      barParentData!.offset =
          Offset(size.width - barRenderBox!.size.width, maxTextHeight / 2);
    }
  }

  void _layoutTextChild(RenderBox child) {
    child.layout(
        BoxConstraints.loose(Size(
            constraints.maxWidth - legend._totalBarWidth - legend.textGap,
            constraints.maxHeight)),
        parentUsesSize: true);
  }

  void visitVisibleChildren(RenderObjectVisitor visitor) {
    visitChildren((child) {
      if (child.gradientLegendLayoutParentData().visible) {
        visitor(child);
      }
    });
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    visitVisibleChildren(visitor);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    visitVisibleChildren((RenderObject child) {
      final _GradientLegendLayoutParentData childParentData =
          child.gradientLegendLayoutParentData();
      context.paintChild(child, childParentData.offset + offset);
    });
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    visitVisibleChildren((renderObject) {
      final RenderBox child = renderObject as RenderBox;
      final _GradientLegendLayoutParentData childParentData =
          child.gradientLegendLayoutParentData();
      result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - childParentData.offset);
          return child.hitTest(result, position: transformed);
        },
      );
    });

    return false;
  }
}

/// Utility extension to facilitate obtaining parent data.
extension __GradientLegendLayoutParentDataGetter on RenderObject {
  _GradientLegendLayoutParentData gradientLegendLayoutParentData() {
    return this.parentData as _GradientLegendLayoutParentData;
  }
}
