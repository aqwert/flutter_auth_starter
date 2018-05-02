import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class TabletAwareLayoutBuilder extends StatelessWidget {
  TabletAwareLayoutBuilder({@required this.mobileView, this.tabletView});

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
