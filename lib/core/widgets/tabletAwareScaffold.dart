import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class TabletAwareScaffold extends StatelessWidget {
  TabletAwareScaffold(
      {@required this.mobileView,
      @required this.tabletView,
      this.backgroundColor = Colors.white});

  final Widget mobileView;
  final Widget tabletView;
  final Color backgroundColor;

  final double tabletThreshold = 660.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: LayoutBuilder(builder: (context, constraints) {
          final bool useMobileLayout = constraints.maxWidth < tabletThreshold;

          if (useMobileLayout) {
            return mobileView;
          } else {
            return tabletView;
          }
        }));
  }
}
