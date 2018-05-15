import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_auth_base/flutter_auth_base.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:scoped_model/scoped_model.dart';

import '../app_info.dart';
import '../app_model.dart';

import 'profile_base_state.dart';
import '../widgets/header_button.dart';

import 'license_page.dart' as app;

class ProfilePage extends StatefulWidget {
  ProfilePage({this.licenceAdditionalWidgets});

  final List<Widget> licenceAdditionalWidgets;

  @override
  State<StatefulWidget> createState() => ProfilePageState();
}

//could have inherited State class for common "stuff" between drawer and profile page

class ProfilePageState extends ProfileBaseState<ProfilePage> {
  @override
  Widget aboutItem(AppInfo appInfo) {
    return super.listItem(
      'About',
      () => app.showLicensePage(
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
    return Center(
      child: Column(
        children: <Widget>[
          super.userPhotoImage(appInfo, authService, user),
          Padding(
            padding: const EdgeInsets.all(4.0),
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
            padding: const EdgeInsets.all(4.0),
            child: Text(user.email,
                style: Theme
                    .of(context)
                    .primaryTextTheme
                    .body2
                    .copyWith(color: Colors.black54)),
          ),
          Divider(),
        ],
      ),
    );

    //  switcher for displaying profile info
  }

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

  bool _showInfo = false;
  void _toggleList() {
    setState(() {
      _showInfo = !_showInfo;
    });
  }

//TODO: tablet view also

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: new Text("Profile"),
        trailingActions: <Widget>[
          HeaderButton(
            text: _showInfo ? 'Back' : 'Account',
            onPressed: () => _toggleList(),
          ),
        ],
      ),
      body: ScopedModelDescendant<AppModel>(
        builder: (context, child, model) {
          if (model.user == null || !model.user.isValid) {
            return super.notAuthView(model.authService);
          } else {
            return _authView(model.appInfo, model.authService, model.user);
          }
        },
      ),
    );
  }
}
