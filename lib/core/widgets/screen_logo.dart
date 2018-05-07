import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class ScreenLogo extends StatelessWidget {
  ScreenLogo({Key key, @required this.imagePath}) : super(key: key);

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    var icon = AssetImage(imagePath);

    var size = MediaQuery.of(context).size;

    return Image(
      image: icon,
      height: size.width > 700.0 && size.height > 500.0 ? 128.0 : 96.0,
      width: size.width > 700.0 && size.height > 500.0 ? 128.0 : 96.0,
    );
  }
}
