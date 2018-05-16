import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:flutter/material.dart' show Icons;
import 'package:meta/meta.dart';

class ModalAppBar extends PlatformAppBar {
  ModalAppBar({
    Key key,
    @required Widget title,
    @required VoidCallback closeAction,
    bool hideAccept: false,
    String acceptText: 'Save',
    VoidCallback acceptAction,
    Color backgroundColor,
    PlatformBuilder<MaterialAppBarData> android,
    PlatformBuilder<CupertinoNavigationBarData> ios,
  }) : super(
            key: key,
            title: title,
            backgroundColor: backgroundColor,
            leading: _closeButton(closeAction),
            trailingActions:
                hideAccept ? [] : [_acceptButton(acceptText, acceptAction)],
            android: android,
            ios: ios);

  static Widget _acceptButton(String acceptText, VoidCallback acceptAction) {
    return PlatformWidget(
      android: (_) => PlatformIconButton(
            androidIcon: Icon(Icons.done),
            onPressed: acceptAction,
          ),
      ios: (_) => PlatformButton(
            child: Text(
              acceptText,
            ),
            onPressed: acceptAction,
          ),
    );
  }

  static Widget _closeButton(VoidCallback closeAction) {
    return PlatformWidget(
      android: (_) => PlatformIconButton(
            androidIcon: Icon(Icons.close),
            onPressed: closeAction,
          ),
      ios: (_) => PlatformButton(
            child: Text(
              'Cancel',
            ),
            onPressed: closeAction,
          ),
    );
  }
}
