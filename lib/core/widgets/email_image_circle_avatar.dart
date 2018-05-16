import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_auth_base/flutter_auth_base.dart';
import 'package:meta/meta.dart';

class EmailImageCircleAvatar extends StatefulWidget {
  EmailImageCircleAvatar(
      {Key key,
      @required this.defaultImage,
      @required this.imageProvider,
      this.backgroundColor = Colors.transparent,
      this.email,
      this.checkIfImageExists = false,
      this.radius = 48.0,
      this.imageSize = 200})
      : super(key: key);

  final AssetImage defaultImage;
  final PhotoUrlProvider imageProvider;
  final int imageSize;
  final double radius;
  final String email;
  final Color backgroundColor;
  final bool checkIfImageExists;

  @override
  createState() => new EmailImageCircleAvatarState();
}

class EmailImageCircleAvatarState extends State<EmailImageCircleAvatar> {
  @override
  void initState() {
    super.initState();

    if (_builder == null) {
      _builder = FutureBuilder(
          future: performUpdate(_email ?? widget.email),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            return _buildImage();
          });
    }
  }

  FutureBuilder<String> _builder;
  String _gravatarImageUrl;
  String _email;

  Future<String> performUpdate(String email) async {
    var url = await widget.imageProvider?.emailToPhotoUrl(email,
        size: widget.imageSize, checkIfImageExists: widget.checkIfImageExists);

    if (url != null && url.isValid) {
      setState(() {
        _email = email;
        _gravatarImageUrl = url.url;
      });
    } else {
      setState(() {
        _email = email;
        _gravatarImageUrl = null;
      });
    }
    return "done";
  }

  NetworkImage _image;
  NetworkImage networkImage() {
    if (_image == null) {
      _image = new NetworkImage(_gravatarImageUrl);
    } else {
      if (_image.url != _gravatarImageUrl) {
        _image = new NetworkImage(_gravatarImageUrl);
      }
    }

    return _image;
  }

  Widget _buildImage() {
    return CircleAvatar(
      backgroundColor: widget.backgroundColor,
      backgroundImage:
          _gravatarImageUrl == null ? widget.defaultImage : networkImage(),
      radius: widget.radius,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_gravatarImageUrl != null) {
      return _buildImage();
    } else {
      return _builder;
    }
  }
}
