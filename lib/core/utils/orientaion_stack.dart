import 'package:app_lecocon_ssbe/core/utils/size_extension.dart';
import 'package:flutter/material.dart';

class OrientedStack extends StatelessWidget {
  final SizeOrientation orientation;
  final List<Widget> children;

  const OrientedStack({
    super.key,
    required this.orientation,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    if ((orientation == SizeOrientation.paysage)) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      );
    } else {
      return Column(
        verticalDirection: VerticalDirection.up,
        mainAxisAlignment: MainAxisAlignment.end,
        children: children,
      );
    }
  }
}