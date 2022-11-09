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

class NFlexParentData extends ContainerBoxParentData<RenderBox> {}

class RenderNFlex extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, NFlexParentData> {
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
    if (child.parentData is! NFlexParentData) {
      child.parentData = NFlexParentData();
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
    RenderBox? child = firstChild;

    List<Size> sizes = [];

    final BoxConstraints innerConstraints;

    if (crossAxisAlignment == CrossAxisAlignment.stretch) {
      switch (_direction) {
        case Axis.horizontal:
          innerConstraints =
              BoxConstraints.tightFor(height: contentSize.height);
          break;
        case Axis.vertical:
          innerConstraints = BoxConstraints.tightFor(width: contentSize.width);
          break;
      }
    } else {
      switch (_direction) {
        case Axis.horizontal:
          innerConstraints = BoxConstraints(maxHeight: contentSize.height);
          break;
        case Axis.vertical:
          innerConstraints = BoxConstraints(maxWidth: contentSize.width);
          break;
      }
    }

    visitChildren(
      (child) => sizes.add(
        ChildLayoutHelper.layoutChild(child as RenderBox, innerConstraints),
      ),
    );

    double allocatedSize = sizes.fold(
        0, (previousValue, element) => previousValue + element.width);

    final double actualSizeDelta =
        size.width - padding.horizontal - allocatedSize;
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

    double usedSpace = padding.left + leadingSpace; // use EdgeInsets

    int index = 0;
    visitChildren((child) {
      NFlexParentData pd = child.parentData as NFlexParentData;
      Size size = sizes[index];
      switch (_crossAxisAlignment) {
        case CrossAxisAlignment.center:
        case CrossAxisAlignment.stretch:
          pd.offset = Offset(usedSpace,
              padding.top + ((contentSize.height - size.height) / 2));
          break;
        case CrossAxisAlignment.start:
          pd.offset = Offset(usedSpace, padding.top);
          break;
        case CrossAxisAlignment.end:
          pd.offset = Offset(
              usedSpace, this.size.height - padding.bottom - size.height);
          break;
        default:
          break;
      }
      usedSpace += sizes[index].width + betweenSpace;
      index++;
    });
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox? child = firstChild;
    while (child != null) {
      final NFlexParentData childParentData =
          child.parentData! as NFlexParentData;
      context.paintChild(child, childParentData.offset + offset);
      child = childParentData.nextSibling;
    }
  }
}
