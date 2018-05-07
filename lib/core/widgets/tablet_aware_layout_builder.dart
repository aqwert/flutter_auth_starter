import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class TabletAwareLayoutBuilder extends StatelessWidget {
  TabletAwareLayoutBuilder(
      {Key key, @required this.mobileView, this.tabletView})
      : super(key: key);

  final Widget mobileView;
  final Widget tabletView;

  final double tabletThreshold = 660.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final bool useMobileLayout = constraints.maxWidth < tabletThreshold;

      if (useMobileLayout) {
        return mobileView;
      } else {
        return tabletView;
      }
    });
  }
}
