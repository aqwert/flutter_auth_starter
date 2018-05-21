import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_auth_base/flutter_auth_base.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../../widgets/progress_actionable_state.dart';
import '../../../../app_model.dart';
import '../../../../widgets/modalAppBar.dart';
import '../../../../dialogs/show_ok_cancel_dialog.dart';

import '../../signin_accounts/signin_picker_dialog.dart';

class CloseAccount extends StatefulWidget {
  @override
  createState() => new CloseAccountState();
}

class CloseAccountState extends ProgressActionableState<CloseAccount> {
  @override
  void initState() {
    super.initState();
  }

  Future _closeAccount(AuthService authService) async {
    var user = await authService.currentUser();

    try {
      await authService.closeAccount({});
    } on AuthRequiredException {
      var signInProviders = _getSignInProviders(authService, user);
      handleAuthenticationRequired(signInProviders);
    }
  }

  List<AuthProvider> _getSignInProviders(
      AuthService authService, AuthUser user) {
    List<AuthProvider> signInProviders = [];
    for (var acc in user.providerAccounts) {
      var authProvider = authService.authProviders.firstWhere(
          (p) => p.providerName == acc.providerName,
          orElse: () => null);
      if (authProvider != null) {
        signInProviders.add(authProvider);
      }
    }

    return signInProviders;
  }

  void handleAuthenticationRequired(List<AuthProvider> signInProviders) {
    showOkCancelDialog(() {
      Navigator.pop(context);

      showSigninPickerDialog(context, signInProviders);
    }, () {
      Navigator.pop(context);
    },
        context: context,
        caption: "Authentication Required",
        message:
            "You need to re-authenticate to be able to remove this account");
  }

  Widget _progressIndicator() {
    return super.showProgress
        ? Padding(
            padding: EdgeInsets.all(16.0),
            child: PlatformCircularProgressIndicator())
        : Container();
  }

  void _confirmAndActionClosingAccount(AuthService authService) {
    super.performAction((_) async => await showOkCancelDialog(() {
          Navigator.pop(context);
          _closeAccount(authService);
        }, () => Navigator.pop(context),
            caption: 'Confirm',
            message:
                'Are you sure you want to permanently close your account and delete all data you created? You may be prompted to reauthenticate.',
            context: context));
  }

  Widget _build(AuthService authService) {
    return SingleChildScrollView(
        child: Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
            'Closing your account will permanently delete any data you created. This cannot be undone'),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: Text(
          'Do you wish to continue?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: PlatformButton(
            child: Text('Yes, close my account'),
            onPressed: super.showProgress
                ? null
                : () => _confirmAndActionClosingAccount(authService)),
      ),
      _progressIndicator(),
    ]));
  }

  // Form _asForm(Widget widget) {
  //   return Form(autovalidate: true, key: super.formKey, child: widget);
  // }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      rebuildOnChange: false,
      builder: (_, child, model) => PlatformScaffold(
            appBar: ModalAppBar(
              title: Text('Close Account'),
              hideAccept: true,
              closeAction: () => Navigator.maybePop(context),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Material(
                color: isMaterial ? null : Theme.of(context).cardColor,
                child: _build(model.authService),
              ),
            ),
          ),
    );
  }
}
