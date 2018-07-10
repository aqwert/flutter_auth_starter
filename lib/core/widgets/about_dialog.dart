import 'dart:io';

import 'package:flutter/material.dart' hide showLicensePage, LicensePage;
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:meta/meta.dart';

import '../pages/license_page.dart';

/// NOTE: this is taken from flutter/lib/src/material/about.dart
/// So it can support both Cupertino and Material design

/// An about box. This is a dialog box with the application's icon, name,
/// version number, and copyright, plus a button to show licenses for software
/// used by the application.
///
/// To show an [AboutDialog], use [showAboutDialog].
///
/// If the application has a [Drawer], the [AboutListTile] widget can make the
/// process of showing an about dialog simpler.
///
/// The [AboutDialog] shown by [showAboutDialog] includes a button that calls
/// [showLicensePage].
///
/// The licenses shown on the [LicensePage] are those returned by the
/// [LicenseRegistry] API, which can be used to add more licenses to the list.
class AboutDialog extends StatelessWidget {
  /// Creates an about box.
  ///
  /// The arguments are all optional. The application name, if omitted, will be
  /// derived from the nearest [Title] widget. The version, icon, and legalese
  /// values default to the empty string.
  const AboutDialog({
    Key key,
    this.applicationName,
    this.applicationVersion,
    this.applicationIcon,
    this.applicationLegalese,
    this.children,
  }) : super(key: key);

  /// The name of the application.
  ///
  /// Defaults to the value of [Title.title], if a [Title] widget can be found.
  /// Otherwise, defaults to [Platform.resolvedExecutable].
  final String applicationName;

  /// The version of this build of the application.
  ///
  /// This string is shown under the application name.
  ///
  /// Defaults to the empty string.
  final String applicationVersion;

  /// The icon to show next to the application name.
  ///
  /// By default no icon is shown.
  ///
  /// Typically this will be an [ImageIcon] widget. It should honor the
  /// [IconTheme]'s [IconThemeData.size].
  final Widget applicationIcon;

  /// A string to show in small print.
  ///
  /// Typically this is a copyright notice.
  ///
  /// Defaults to the empty string.
  final String applicationLegalese;

  /// Widgets to add to the dialog box after the name, version, and legalese.
  ///
  /// This could include a link to a Web site, some descriptive text, credits,
  /// or other information to show in the about box.
  ///
  /// Defaults to nothing.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final String name = applicationName ?? _defaultApplicationName(context);
    final String version =
        applicationVersion ?? _defaultApplicationVersion(context);
    final Widget icon = applicationIcon ?? _defaultApplicationIcon(context);
    List<Widget> body = <Widget>[];
    if (icon != null)
      body.add(
          new IconTheme(data: const IconThemeData(size: 48.0), child: icon));
    body.add(new Expanded(
        child: new Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: new ListBody(children: <Widget>[
              new Text(name, style: Theme.of(context).textTheme.headline),
              new Text(version, style: Theme.of(context).textTheme.body1),
              new Container(height: 18.0),
              new Text(applicationLegalese ?? '',
                  style: Theme.of(context).textTheme.caption)
            ]))));
    body = <Widget>[
      new Row(crossAxisAlignment: CrossAxisAlignment.start, children: body),
    ];
    if (children != null) body.addAll(children);
    return new PlatformAlertDialog(
        content: new SingleChildScrollView(
          child: new ListBody(children: body),
        ),
        actions: <Widget>[
          new PlatformDialogAction(
              child: new PlatformText('View Licenses'),
              onPressed: () {
                showLicensePage(
                    context: context,
                    applicationName: applicationName,
                    applicationVersion: applicationVersion,
                    applicationIcon: applicationIcon,
                    applicationLegalese: applicationLegalese);
              }),
          new PlatformDialogAction(
              child: new PlatformText('Close'),
              onPressed: () {
                Navigator.pop(context);
              }),
        ]);
  }
}

String _defaultApplicationName(BuildContext context) {
  final Title ancestorTitle = context.ancestorWidgetOfExactType(Title);
  return ancestorTitle?.title ??
      Platform.resolvedExecutable.split(Platform.pathSeparator).last;
}

String _defaultApplicationVersion(BuildContext context) {
  // TODO(ianh): Get this from the embedder somehow.
  return '';
}

Widget _defaultApplicationIcon(BuildContext context) {
  // TODO(ianh): Get this from the embedder somehow.
  return null;
}

void showLicensePage(
    {@required BuildContext context,
    String applicationName,
    String applicationVersion,
    Widget applicationIcon,
    String applicationLegalese}) {
  Navigator.pop(context);
  Navigator.push(
      context,
      new MaterialPageRoute<void>(
          builder: (BuildContext context) => new LicensePage(
              applicationName: applicationName,
              applicationVersion: applicationVersion,
              applicationLegalese: applicationLegalese)));
}
