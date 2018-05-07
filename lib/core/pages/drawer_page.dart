import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_auth_base/flutter_auth_base.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../auth/handlers/link/linkAccounts/link_accounts_page.dart';
import '../auth/handlers/email/change/change_email_page.dart';
import '../auth/handlers/email/change/change_password_page.dart';
import '../auth/handlers/user/displayName/change_display_name_page.dart';
import '../auth/handlers/user/closeAccount/close_account_page.dart';
import '../dialogs/show_error_dialog.dart';
import '../dialogs/show_ok_cancel_dialog.dart';
import '../widgets/screen_aware_padding.dart';
import '../widgets/email_image_circle_avatar.dart';
import '../app_info.dart';
import '../app_model.dart';
import '../common/dialog.dart';

import 'license_page.dart' as app;

class DrawerPage extends StatefulWidget {
  DrawerPage({this.licenceAdditionalWidgets});

  final List<Widget> licenceAdditionalWidgets;

  @override
  createState() => new DrawerPageState();
}

class DrawerPageState extends State<DrawerPage> {
  @override
  void initState() {
    super.initState();
  }

  bool _showNormalList = true;

  AuthProvider _getPasswordProvider(AuthService authService) {
    return authService.authProviders.firstWhere(
        (prov) => prov.providerName == 'password',
        orElse: () => null);
  }

  Future _sendVerificationEmail(
      AuthService authService, AuthUser userInfo) async {
    var passwordProvider = _getPasswordProvider(authService);

    if (passwordProvider == null) {
      return await showErrorDialog(
          context, 'Email/Password provider is not configured');
    } else {
      try {
        await passwordProvider.sendVerification({'email': userInfo.email});
        //TODO snackbar stating it has been sent
      } catch (error) {
        //TODO display message
      }
    }
  }

  Future _sendVerifyEmail(AuthService authService, AuthUser userInfo) async {
    return await showOkCancelDialog(() async {
      Navigator.pop(context);
      await _sendVerificationEmail(authService, userInfo);
    }, () => Navigator.pop(context),
        context: context,
        caption: 'Send Verification Email',
        message:
            'Would you like to send a verification email to ${userInfo.email}');
  }

  void _pop() {
    Navigator.pop(context);
  }

  Future _logout(AuthService authService) {
    return showOkCancelDialog(
        () async => await authService.signOut(), () => _pop(),
        caption: 'Confirm',
        message: 'Are you sure you want to logout?',
        context: context);
  }

  Future _changeDisplayName(AuthUser userInfo) {
    return openDialog(
        context: context,
        builder: (_) => ChangeDisplayName(displayName: userInfo.displayName));
  }

  Future _changeEmail() {
    return openDialog(context: context, builder: (_) => ChangeEmail());
  }

  Future _changePassword() {
    return openDialog(context: context, builder: (_) => ChangePassword());
  }

  Future _closeAccount() {
    return openDialog(context: context, builder: (_) => CloseAccount());
  }

  Future _linkAccounts() {
    Navigator.pop(context);

    return Navigator.push(
        context, MaterialPageRoute(builder: (_) => LinkAccounts()));
  }

  void _about(AppInfo appInfo) {
    app.showLicensePage(
        appIconPath: appInfo.appIconPath,
        appName: appInfo.appName,
        appVersion: appInfo.appVersion,
        applicationLegalese: appInfo.applicationLegalese,
        context: context,
        addtionalWidgets: widget.licenceAdditionalWidgets);
  }

  //TODO bring in package
  Future _launchURL(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (error) {
      await showErrorDialog(context, 'Could not open link');
    }
  }

  Widget _userPhotoImage(
      AppInfo appInfo, AuthService authService, AuthUser user) {
    return EmailImageCircleAvatar(
      defaultImage: AssetImage(appInfo.avatarDefaultAppIconPath),
      imageSize: 100,
      radius: 32.0,
      email: user.email,
      imageProvider: authService.postAuthPhotoProvider,
    );
  }

  Widget _listItem(String title, VoidCallback onTap,
      {String subTitle, Color textColor, bool show: true}) {
    if (!show) {
      return Container();
    }

    var textTheme = Theme.of(context).textTheme;
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
            color: textColor == null ? textTheme.body2.color : textColor,
            fontWeight: textTheme.body2.fontWeight),
      ),
      subtitle: subTitle == null
          ? null
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(subTitle),
            ),
      onTap: onTap,
    );
  }

  Widget _normalListItems(
      AppInfo appInfo, AuthService authService, AuthUser userInfo) {
    return Column(
      children: <Widget>[
        _listItem(
            'Terms of Service', () => _launchURL(appInfo.termsOfServiceUrl)),
        _listItem('Privacy Policy', () => _launchURL(appInfo.privacyPolicyUrl)),
        _listItem('About', () => _about(appInfo)),
        const Divider(),
        _listItem('Logout', () async => await _logout(authService)),
      ],
    );
  }

  Widget _accountListItems(AuthService authService, AuthUser userInfo) {
    return new Column(
      children: <Widget>[
        _listItem('Change / Set Display Name',
            () async => await _changeDisplayName(userInfo),
            show: canChangeDisplayName(authService, userInfo)),
        _listItem('Change Email Address', () async => await _changeEmail(),
            show: canChangeEmail(authService, userInfo)),
        _listItem('Change Password', () async => await _changePassword(),
            show: canChangePassword(authService, userInfo)),
        canChangeEmail(authService, userInfo) ||
                canChangePassword(authService, userInfo)
            ? Divider()
            : Container(),
        _listItem('Accounts', () async => await _linkAccounts(),
            show: authService.options.canLinkAccounts),
        authService.options.canLinkAccounts ? Divider() : Container(),
        _listItem('Close Account', () async => await _closeAccount(),
            subTitle: "Permanately delete account and associated data",
            textColor: Theme.of(context).errorColor,
            show: authService.options.canDeleteAccount),
      ],
    );
  }

  bool canChangeDisplayName(AuthService authService, AuthUser userInfo) {
    if (userInfo.providerAccounts.any((prov) => prov.canChangeDisplayName)) {
      return authService.options.canChangeDisplayName;
    }
    return false;
  }

  bool canChangeEmail(AuthService authService, AuthUser userInfo) {
    if (userInfo.providerAccounts.any((prov) => prov.canChangeEmail)) {
      return authService.options.canChangeEmail;
    }
    return false;
  }

  bool canChangePassword(AuthService authService, AuthUser userInfo) {
    if (userInfo.providerAccounts.any((prov) => prov.canChangePassword)) {
      return authService.options.canChangePassword;
    }
    return false;
  }

  Widget _notAuthView(AuthService authService) {
    return Center(
        child: Column(children: <Widget>[
      Text('You are not authenticated. Please sign out and back in again'),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton(
            child: Text('Sign out'),
            onPressed: () async => await authService.signOut()),
      )
    ]));
  }

  Widget _authView(
      AppInfo appInfo, AuthService authService, AuthUser userInfo) {
    var theme = Theme.of(context);

    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          onDetailsPressed: () => setState(() {
                _showNormalList = !_showNormalList;
              }),
          accountName: Text(userInfo.displayName),
          accountEmail: Text(userInfo.email),
          currentAccountPicture:
              _userPhotoImage(appInfo, authService, userInfo),
          decoration: BoxDecoration(color: theme.accentColor),
        ),
        userInfo.isEmailVerified
            ? Container()
            : _listItem('Email is not verified',
                () async => await _sendVerifyEmail(authService, userInfo),
                subTitle: 'Please tap to resend a verification email',
                textColor: theme.errorColor,
                show: authService.options.canVerifyAccount),
        !userInfo.isEmailVerified && authService.options.canVerifyAccount
            ? Divider()
            : Container(),
        _showNormalList
            ? _normalListItems(appInfo, authService, userInfo)
            : _accountListItems(authService, userInfo),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(builder: (context, child, model) {
      if (model.user == null || !model.user.isValid) {
        return _notAuthView(model.authService);
      } else {
        return _authView(model.appInfo, model.authService, model.user);
      }
    });
  }
}
