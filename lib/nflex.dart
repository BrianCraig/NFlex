library nflex;

import 'dart:math' show max;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class NFlex extends MultiChildRenderObjectWidget {
  NFlex({
    super.key,
    super.children,
    required this.direction,
    this.padding = EdgeInsets.zero,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  final Axis direction;

  final EdgeInsets padding;

  final MainAxisAlignment mainAxisAlignment;

  final CrossAxisAlignment crossAxisAlignment;

  @override
  RenderNFlex createRenderObject(BuildContext context) {
    return RenderNFlex(
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      padding: padding,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderNFlex renderObject) {
    renderObject
      ..direction = direction
      ..mainAxisAlignment = mainAxisAlignment
      ..crossAxisAlignment = crossAxisAlignment
      ..padding = padding;
  }
}

class NRow extends NFlex {
  NRow({
    super.key,
    super.mainAxisAlignment,
    super.crossAxisAlignment,
    super.padding,
    super.children,
  }) : super(
          direction: Axis.horizontal,
        );
}

class NColumn extends NFlex {
  NColumn({
    super.key,
    super.mainAxisAlignment,
    super.crossAxisAlignment,
    super.padding,
    super.children,
  }) : super(
          direction: Axis.vertical,
        );
}

class _NFlexParentData extends ContainerBoxParentData<RenderBox> {}

class _LayoutChildHelper {
  const _LayoutChildHelper(this.pd, this.size);

  final _NFlexParentData pd;
  final Size size;
}

extension on Axis {
  double _mainWidth(Size size) =>
      this == Axis.horizontal ? size.width : size.height;

  double _crossWidth(Size size) =>
      this == Axis.horizontal ? size.height : size.width;

  double _mainPadding(EdgeInsets padding) =>
      this == Axis.horizontal ? padding.horizontal : padding.vertical;

  double _mainStart(EdgeInsets padding) =>
      this == Axis.horizontal ? padding.left : padding.top;

  double _crossStart(EdgeInsets padding) =>
      this == Axis.horizontal ? padding.top : padding.left;

  Offset _offset(double main, double cross) => Offset(
      this == Axis.horizontal ? main : cross,
      this == Axis.horizontal ? cross : main);
}

class RenderNFlex extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, _NFlexParentData> {
  RenderNFlex({
    List<RenderBox>? children,
    Axis direction = Axis.horizontal,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    EdgeInsets padding = EdgeInsets.zero,
  })  : _direction = direction,
        _mainAxisAlignment = mainAxisAlignment,
        _crossAxisAlignment = crossAxisAlignment,
        _padding = padding;

  /// The direction to use as the main axis.
  Axis get direction => _direction;
  Axis _direction;
  set direction(Axis value) {
    if (_direction != value) {
      _direction = value;
      markNeedsLayout();
    }
  }

  /// The main axis alignment.
  MainAxisAlignment get mainAxisAlignment => _mainAxisAlignment;
  MainAxisAlignment _mainAxisAlignment;
  set mainAxisAlignment(MainAxisAlignment value) {
    if (_mainAxisAlignment != value) {
      _mainAxisAlignment = value;
      markNeedsLayout();
    }
  }

  /// The cross axis alignment.
  CrossAxisAlignment get crossAxisAlignment => _crossAxisAlignment;
  CrossAxisAlignment _crossAxisAlignment;
  set crossAxisAlignment(CrossAxisAlignment value) {
    if (_crossAxisAlignment != value) {
      _crossAxisAlignment = value;
      markNeedsLayout();
    }
  }

  /// The direction to use as the main axis.
  EdgeInsets get padding => _padding;
  EdgeInsets _padding;
  set padding(EdgeInsets value) {
    if (_padding != value) {
      _padding = value;
      markNeedsLayout();
    }
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _NFlexParentData) {
      child.parentData = _NFlexParentData();
    }
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return super.computeMinIntrinsicWidth(height);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return super.computeMaxIntrinsicWidth(height);
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return super.computeMinIntrinsicHeight(width);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return super.computeMaxIntrinsicHeight(width);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.biggest;
  }

  @override
  void performLayout() {
    size = constraints.biggest;
    Size contentSize = padding.deflateSize(size);

    List<_LayoutChildHelper> layoutChildrens = [];

    final BoxConstraints innerConstraints =
        crossAxisAlignment == CrossAxisAlignment.stretch
            ? (_direction == Axis.horizontal
                ? BoxConstraints.tightFor(height: contentSize.height)
                : BoxConstraints.tightFor(width: contentSize.width))
            : (_direction == Axis.horizontal
                ? BoxConstraints(maxHeight: contentSize.height)
                : BoxConstraints(maxWidth: contentSize.width));

    visitChildren(
      (child) => layoutChildrens.add(_LayoutChildHelper(
        child.parentData as _NFlexParentData,
        ChildLayoutHelper.layoutChild(child as RenderBox, innerConstraints),
      )),
    );

    double allocatedSize = layoutChildrens.fold(
        0,
        (previousValue, element) =>
            previousValue + _direction._mainWidth(element.size));

    final double actualSizeDelta = _direction._mainWidth(size) -
        _direction._mainPadding(padding) -
        allocatedSize;
    final double remainingSpace = max(0.0, actualSizeDelta);
    late final double leadingSpace;
    late final double betweenSpace;
    switch (_mainAxisAlignment) {
      case MainAxisAlignment.start:
        leadingSpace = 0.0;
        betweenSpace = 0.0; // gap here?
        break;
      case MainAxisAlignment.end:
        leadingSpace = remainingSpace;
        betweenSpace = 0.0; // gap here?
        break;
      case MainAxisAlignment.center:
        leadingSpace = remainingSpace / 2.0;
        betweenSpace = 0.0; // gap here?
        break;
      case MainAxisAlignment.spaceBetween:
        leadingSpace = 0.0;
        betweenSpace = childCount > 1 ? remainingSpace / (childCount - 1) : 0.0;
        break;
      case MainAxisAlignment.spaceAround:
        betweenSpace = childCount > 0 ? remainingSpace / childCount : 0.0;
        leadingSpace = betweenSpace / 2.0;
        break;
      case MainAxisAlignment.spaceEvenly:
        betweenSpace = childCount > 0 ? remainingSpace / (childCount + 1) : 0.0;
        leadingSpace = betweenSpace;
        break;
    }

    double usedSpace =
        _direction._mainStart(padding) + leadingSpace; // use EdgeInsets

    for (_LayoutChildHelper child in layoutChildrens) {
      switch (_crossAxisAlignment) {
        case CrossAxisAlignment.stretch:
          child.pd.offset =
              _direction._offset(usedSpace, _direction._crossStart(padding));
          break;
        case CrossAxisAlignment.center:
          child.pd.offset = _direction._offset(
            usedSpace,
            _direction._crossStart(padding) +
                ((_direction._crossWidth(contentSize) -
                        _direction._crossWidth(child.size)) /
                    2),
          );
          break;
        case CrossAxisAlignment.start:
          child.pd.offset =
              _direction._offset(usedSpace, _direction._crossStart(padding));
          break;
        case CrossAxisAlignment.end:
          child.pd.offset = _direction._offset(
            usedSpace,
            _direction._crossWidth(size) -
                _direction._crossStart(padding.flipped) -
                _direction._crossWidth(child.size),
          );
          break;
        default:
          break;
      }
      usedSpace += _direction._mainWidth(child.size) + betweenSpace;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox? child = firstChild;
    while (child != null) {
      final _NFlexParentData childParentData =
          child.parentData! as _NFlexParentData;
      context.paintChild(child, childParentData.offset + offset);
      child = childParentData.nextSibling;
    }
  }
}
