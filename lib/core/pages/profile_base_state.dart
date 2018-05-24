import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_auth_base/flutter_auth_base.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_info.dart';
import '../auth/handlers/link/linkAccounts/link_accounts_page.dart';
import '../auth/handlers/email/change/change_email_page.dart';
import '../auth/handlers/email/change/change_password_page.dart';
import '../auth/handlers/user/displayName/change_display_name_page.dart';
import '../auth/handlers/user/closeAccount/close_account_page.dart';
import '../common/dialog.dart';
import '../dialogs/show_error_dialog.dart';
import '../dialogs/show_ok_cancel_dialog.dart';
import '../dialogs/show_info_dialog.dart';
import '../widgets/email_image_circle_avatar.dart';

abstract class ProfileBaseState<T extends StatefulWidget> extends State<T> {
  Widget aboutItem(AppInfo appInfo);

  Widget standardList(
      AppInfo appInfo, AuthService authService, AuthUser userInfo) {
    return Column(
      children: <Widget>[
        _emailNotVerifiedItem(appInfo, authService, userInfo),
        _termsOfServiceItem(appInfo),
        aboutItem(appInfo),
        const Divider(),
        _logoutItem(authService),
      ],
    );
  }

  Widget userList(AppInfo appInfo, AuthService authService, AuthUser userInfo) {
    return Column(
      children: <Widget>[
        _displayNameItem(authService, userInfo),
        _changeEmailItem(authService, userInfo),
        _changePasswordItem(authService, userInfo),
        _accountsItem(authService),
        _closeAccountItem(authService),
      ],
    );
  }

  Widget notAuthView(AuthService authService) {
    return Center(
        child: Column(children: <Widget>[
      Text('You are not authenticated. Please sign out and back in again'),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: PlatformButton(
            child: Text('Sign out'),
            onPressed: () async => await authService.signOut()),
      )
    ]));
  }

  Widget userPhotoImage(
      AppInfo appInfo, AuthService authService, AuthUser user) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: EmailImageCircleAvatar(
        defaultImage: AssetImage(appInfo.avatarDefaultAppIconPath),
        imageSize: 100,
        radius: 32.0,
        email: user.email,
        imageProvider: authService.postAuthPhotoProvider,
      ),
    );
  }

  Widget listItem(String title, VoidCallback onTap,
      {String subTitle, Color textColor, bool show: true}) {
    if (!show) {
      return Container();
    }

    var textTheme = Theme.of(context).textTheme;
    return ListTile(
      title: Text(
        title,
        style: textColor == null
            ? textTheme.body2
            : textTheme.body2.copyWith(color: textColor),
      ),
      subtitle: subTitle == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
              child: Text(subTitle),
            ),
      onTap: onTap,
    );
  }

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

  Future _acknowledgeEmailSend() async {
    return await showInfoDialog(() async => Navigator.pop(context),
        context: context,
        caption: 'Email Sent',
        message: 'Please check your email.');
  }

  Future _sendVerifyEmail(AuthService authService, AuthUser userInfo) async {
    return await showOkCancelDialog(() async {
      Navigator.pop(context);
      _sendVerificationEmail(authService, userInfo);
      _acknowledgeEmailSend();
    }, () => Navigator.pop(context),
        context: context,
        caption: 'Send Verification Email',
        message:
            'Would you like to send a verification email to ${userInfo.email}');
  }

  Widget _emailNotVerifiedItem(
      AppInfo appInfo, AuthService authService, AuthUser userInfo) {
    var theme = Theme.of(context);
    return Column(
      children: <Widget>[
        userInfo.isEmailVerified
            ? Container()
            : listItem('Email is not verified',
                () async => await _sendVerifyEmail(authService, userInfo),
                subTitle: 'Please tap to resend a verification email',
                textColor: theme.errorColor,
                show: authService.options.canVerifyAccount),
        !userInfo.isEmailVerified && authService.options.canVerifyAccount
            ? Divider()
            : Container()
      ],
    );
  }

  Widget _termsOfServiceItem(AppInfo appInfo) {
    return listItem(
      'Terms of Service',
      () => _launchURL(appInfo.termsOfServiceUrl),
    );
  }

  Widget _logoutItem(AuthService authService) {
    return listItem(
      'Logout',
      () async => await showOkCancelDialog(
          () async => await authService.signOut(), () => Navigator.pop(context),
          caption: 'Confirm',
          message: 'Are you sure you want to logout?',
          context: context),
    );
  }

  Widget _closeAccountItem(AuthService authService) {
    return listItem(
        'Close Account',
        () async => await openDialog(
              context: context,
              builder: (_) => CloseAccount(),
            ),
        subTitle: "Permanently delete account and associated data",
        textColor: Theme.of(context).errorColor,
        show: authService.options.canDeleteAccount);
  }

  Widget _accountsItem(AuthService authService) {
    return Column(
      children: <Widget>[
        listItem(
            'Accounts',
            () async => await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LinkAccounts(),
                  ),
                ),
            show: authService.options.canLinkAccounts),
        authService.options.canLinkAccounts ? Divider() : Container(),
      ],
    );
  }

  bool _canChangePassword(AuthService authService, AuthUser userInfo) {
    if (userInfo.providerAccounts.any((prov) => prov.canChangePassword)) {
      return authService.options.canChangePassword;
    }
    return false;
  }

  Widget _changePasswordItem(AuthService authService, AuthUser userInfo) {
    return listItem(
      'Change Password',
      () async =>
          await openDialog(context: context, builder: (_) => ChangePassword()),
      show: _canChangePassword(authService, userInfo),
    );
  }

  bool _canChangeEmail(AuthService authService, AuthUser userInfo) {
    if (userInfo.providerAccounts.any((prov) => prov.canChangeEmail)) {
      return authService.options.canChangeEmail;
    }
    return false;
  }

  Widget _changeEmailItem(AuthService authService, AuthUser userInfo) {
    return listItem(
      'Change Email Address',
      () async =>
          await openDialog(context: context, builder: (_) => ChangeEmail()),
      show: _canChangeEmail(authService, userInfo),
    );
  }

  bool _canChangeDisplayName(AuthService authService, AuthUser userInfo) {
    if (userInfo.providerAccounts.any((prov) => prov.canChangeDisplayName)) {
      return authService.options.canChangeDisplayName;
    }
    return false;
  }

  Widget _displayNameItem(AuthService authService, AuthUser userInfo) {
    return listItem(
      'Change / Set Display Name',
      () async => await openDialog(
          context: context,
          builder: (_) => ChangeDisplayName(displayName: userInfo.displayName)),
      show: _canChangeDisplayName(authService, userInfo),
    );
  }
}
