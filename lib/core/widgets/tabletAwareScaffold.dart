import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'tabletAwareLayoutBuilder.dart';

class TabletAwareScaffold extends StatelessWidget {
  TabletAwareScaffold(
      {@required this.mobileView,
      @required this.tabletView,
      this.backgroundColor = Colors.white});

  final Widget mobileView;
  final Widget tabletView;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: TabletAwareLayoutBuilder(
            mobileView: mobileView, tabletView: tabletView));
  }
}
