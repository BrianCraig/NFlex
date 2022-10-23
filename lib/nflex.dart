library nflex;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class NFlex extends MultiChildRenderObjectWidget {
  NFlex({
    super.key,
    super.children,
    required this.direction,
    this.padding = EdgeInsets.zero,
  });

  final Axis direction;

  final EdgeInsets padding;

  @override
  RenderNFlex createRenderObject(BuildContext context) {
    return RenderNFlex(
      direction: direction,
      padding: padding,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderNFlex renderObject) {
    renderObject
      ..direction = direction
      ..padding = padding;
  }
}

class NFlexParentData extends ContainerBoxParentData<RenderBox> {}

class RenderNFlex extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, NFlexParentData> {
  RenderNFlex({
    List<RenderBox>? children,
    Axis direction = Axis.horizontal,
    EdgeInsets padding = EdgeInsets.zero,
  })  : _direction = direction,
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

    visitChildren(
      (child) => sizes.add(
        ChildLayoutHelper.layoutChild(child as RenderBox, constraints.loosen()),
      ),
    );

    //double totalSpace = sizes.fold(0, (previousValue, element) => previousValue + element.width);

    double usedSpace = padding.left; // use EdgeInsets

    int index = 0;
    visitChildren((child) {
      (child.parentData as NFlexParentData).offset = Offset(usedSpace, padding.top + ((contentSize.height - sizes[index].height) / 2));
      usedSpace += sizes[index].width;
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
