import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../widgets/screen_aware_padding.dart';

Future<T> openDialog<T>(
    {@required BuildContext context, @required WidgetBuilder builder}) {
  var size = MediaQuery.of(context).size;

  bool isMobile = size.width < 660 || size.height < 660;

  if (isMobile) {
    //mobile view we use PageRoute
    return Navigator.push(
        context, MaterialPageRoute(fullscreenDialog: true, builder: builder));
  } else {
    //tablet we use showDialog with Screen padding
    return showDialog(
        context: context,
        builder: (ctx) => ScreenAwarePadding(child: builder(ctx)),
        barrierDismissible: false);
  }
}
