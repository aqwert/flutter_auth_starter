import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class TabletAwareLayoutBuilder extends StatelessWidget {
  TabletAwareLayoutBuilder(
      {Key key, @required this.mobileView, @required this.tabletView})
      : assert(mobileView != null),
        assert(tabletView != null),
        super(key: key);

  final WidgetBuilder mobileView;
  final WidgetBuilder tabletView;

  final double tabletThreshold = 660.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final bool useMobileLayout = constraints.maxWidth < tabletThreshold;

      if (useMobileLayout) {
        return mobileView(context);
      } else {
        return tabletView(context);
      }
    });
  }
}
