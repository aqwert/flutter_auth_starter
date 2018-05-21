import 'package:flutter/material.dart' hide AboutDialog;
import 'package:meta/meta.dart';

import '../widgets/about_dialog.dart';

void showAppInfoDialog(
    {@required BuildContext context,
    @required String appName,
    @required String appVersion,
    @required String appIconPath,
    String applicationLegalese,
    List<Widget> addtionalWidgets}) async {
  var icon = new AssetImage(appIconPath);

  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return new AboutDialog(
          applicationName: appName,
          applicationVersion: "version $appVersion",
          applicationIcon: new Image(
            image: icon,
            height: 64.0,
            width: 64.0,
          ),
          applicationLegalese: applicationLegalese,
          children: addtionalWidgets ?? []);
    },
  );
}
