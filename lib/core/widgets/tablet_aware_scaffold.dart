import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'tablet_aware_layout_builder.dart';

class TabletAwareScaffold extends StatelessWidget {
  TabletAwareScaffold(
      {Key key,
      @required this.mobileView,
      @required this.tabletView,
      this.backgroundColor = Colors.white})
      : assert(mobileView != null),
        assert(tabletView != null),
        super(key: key);

  final WidgetBuilder mobileView;
  final WidgetBuilder tabletView;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: TabletAwareLayoutBuilder(
            mobileView: mobileView, tabletView: tabletView));
  }
}
