import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ScreenAwarePadding extends StatelessWidget {
  ScreenAwarePadding({Key key, @required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    var left = 0.0;
    var bottom = 0.0;
    var right = 0.0;
    var top = 0.0;

    if (size.height > 600 && size.height <= 750) {
      top = 16.0;
      bottom = 16.0;
    }
    if (size.height > 750 && size.height <= 900) {
      top = 32.0;
      bottom = 64.0;
    }
    if (size.height > 900 && size.height <= 1200) {
      top = 64.0;
      bottom = 128.0;
    }
    if (size.height > 1200) {
      top = 256.0;
      bottom = 256.0;
    }

    if (size.width > 350 && size.width <= 400) {
      left = 16.0;
      right = 16.0;
    }
    if (size.width > 400 && size.width <= 600) {
      left = 32.0;
      right = 32.0;
    }
    if (size.width > 600 && size.width <= 800) {
      left = 64.0;
      right = 64.0;
    }
    if (size.width > 800 && size.width <= 1000) {
      left = 128.0;
      right = 128.0;
    }
    if (size.width > 1000 && size.width <= 1200) {
      left = 256.0;
      right = 256.0;
    }
    if (size.width > 1200) {
      left = 384.0;
      right = 384.0;
    }

    var pad =
        EdgeInsets.only(left: left, bottom: bottom, right: right, top: top);

    return Padding(padding: pad, child: child);
  }
}
