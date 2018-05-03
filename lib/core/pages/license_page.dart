import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

void showLicensePage(
    {@required BuildContext context,
    @required String appName,
    @required String appVersion,
    @required String appIconPath,
    String applicationLegalese,
    List<Widget> addtionalWidgets}) async {
  var icon = new AssetImage(appIconPath);

  showAboutDialog(
      context: context,
      applicationName: appName,
      applicationVersion: "version $appVersion",
      applicationIcon: new Image(
        image: icon,
        height: 64.0,
        width: 64.0,
      ),
      applicationLegalese: applicationLegalese,
      children: addtionalWidgets ?? []);
}
