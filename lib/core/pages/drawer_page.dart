import 'dart:async';

import 'package:async_loader/async_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_base/flutter_auth_base.dart';
import 'package:scoped_model/scoped_model.dart';

import '../app_info.dart';
import '../app_model.dart';
import 'profile_base_state.dart';

import '../dialogs/app_info_dialog.dart' as app;

class DrawerPage extends StatefulWidget {
  DrawerPage({this.licenceAdditionalWidgets});

  final List<Widget> licenceAdditionalWidgets;

  @override
  createState() => new DrawerPageState();
}

class DrawerPageState extends ProfileBaseState<DrawerPage> {
  @override
  Widget aboutItem(AppInfo appInfo) {
    return super.listItem(
      'About',
      () => app.showAppInfoDialog(
          appIconPath: appInfo.appIconPath,
          appName: appInfo.appName,
          appVersion: appInfo.appVersion,
          applicationLegalese: appInfo.applicationLegalese,
          context: context,
          addtionalWidgets: widget.licenceAdditionalWidgets),
    );
  }

  Widget _profileHeader(
      AppInfo appInfo, AuthService authService, AuthUser userInfo) {
    var theme = Theme.of(context);
    return UserAccountsDrawerHeader(
      onDetailsPressed: () => setState(() {
            _showInfo = !_showInfo;
          }),
      accountName: Text(userInfo.displayName),
      accountEmail: Text(userInfo.email),
      currentAccountPicture:
          super.userPhotoImage(appInfo, authService, userInfo),
      decoration: BoxDecoration(color: theme.accentColor),
    );
  }

  bool _showInfo = false;

  Widget _authView(
      AppInfo appInfo, AuthService authService, AuthUser userInfo) {
    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        _profileHeader(appInfo, authService, userInfo),
        _showInfo
            ? super.userList(appInfo, authService, userInfo)
            : super.standardList(appInfo, authService, userInfo),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(builder: (context, child, model) {
      if (model.user == null || !model.user.isValid) {
        return super.notAuthView(model.authService);
      } else {
        return _authView(model.appInfo, model.authService, model.user);
      }
    });
  }
}
