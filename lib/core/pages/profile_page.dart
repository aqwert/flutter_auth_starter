import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_auth_base/flutter_auth_base.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:scoped_model/scoped_model.dart';

import '../app_info.dart';
import '../app_model.dart';

import 'profile_base_state.dart';
import '../widgets/header_button.dart';
import '../widgets/tablet_aware_layout_builder.dart';

import '../dialogs/app_info_dialog.dart' as app;

class ProfilePage extends StatefulWidget {
  ProfilePage({this.licenceAdditionalWidgets});

  final List<Widget> licenceAdditionalWidgets;

  @override
  State<StatefulWidget> createState() => ProfilePageState();
}

class ProfilePageState extends ProfileBaseState<ProfilePage> {
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
      AppInfo appInfo, AuthService authService, AuthUser user) {
    return Container(
      color: Color(0xffeeeeee),
      child: Center(
        child: Column(
          children: <Widget>[
            super.userPhotoImage(appInfo, authService, user),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Text(
                user.displayName,
                style: Theme
                    .of(context)
                    .primaryTextTheme
                    .body1
                    .copyWith(color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(user.email,
                  style: Theme
                      .of(context)
                      .primaryTextTheme
                      .body2
                      .copyWith(color: Colors.black54)),
            ),
            //Divider(),
          ],
        ),
      ),
    );
  }

  Widget _authTabletView(
      AppInfo appInfo, AuthService authService, AuthUser userInfo) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            color: Color(0xffeeeeee),
            //elevation: 4.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _profileHeader(appInfo, authService, userInfo),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              _showInfo
                  ? super.userList(appInfo, authService, userInfo)
                  : super.standardList(appInfo, authService, userInfo),
            ],
          ),
        ),
      ],
    );
  }

  Widget _authMobileView(
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

  bool _showInfo = false;
  void _toggleList() {
    setState(() {
      _showInfo = !_showInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: new Text("Profile"),
        trailingActions: <Widget>[
          HeaderButton(
            text: _showInfo ? 'Info' : 'Account',
            onPressed: () => _toggleList(),
          ),
        ],
      ),
      body: ScopedModelDescendant<AppModel>(
        builder: (context, child, model) {
          if (model.user == null || !model.user.isValid) {
            return super.notAuthView(model.authService);
          } else {
            return TabletAwareLayoutBuilder(
              mobileView: (_) =>
                  _authMobileView(model.appInfo, model.authService, model.user),
              tabletView: (_) =>
                  _authTabletView(model.appInfo, model.authService, model.user),
            );
          }
        },
      ),
    );
  }
}
