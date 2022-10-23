library nflex;

import 'package:flutter/widgets.dart';

class NFlex extends StatelessWidget {
  const NFlex({
    super.key,
    required this.children,
    required this.direction,
    this.padding = EdgeInsets.zero,
  });

  final Axis direction;

  final EdgeInsetsGeometry padding;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
