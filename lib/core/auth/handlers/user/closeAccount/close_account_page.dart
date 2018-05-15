import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_auth_base/flutter_auth_base.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'close_account_view_model.dart';
import '../../../../widgets/form_progress_actionable_state.dart';
import '../../../../app_model.dart';
import '../../../../widgets/modalAppBar.dart';

class CloseAccount extends StatefulWidget {
  //CloseAccount(this.authService);

  //final AuthService authService;

  @override
  createState() => new CloseAccountState();
}

class CloseAccountState extends FormProgressActionableState<CloseAccount> {
  @override
  void initState() {
    super.initState();

    _viewModel = new ViewModel();
  }

  ViewModel _viewModel;

  Future _closeAccount(AuthService authService) async {
    _viewModel.validateAll();

    var user = await authService.currentUser();
    await authService
        .closeAccount({'email': user.email, 'password': _viewModel.password});
  }

  Widget _passwordField() {
    return TextFormField(
        enabled: !super.showProgress,
        autocorrect: false,
        obscureText: true,
        decoration: InputDecoration(labelText: 'Password'),
        validator: _viewModel.validatePassword,
        onSaved: (val) => _viewModel.password = val);
  }

  Widget _progressIndicator() {
    return super.showProgress
        ? Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.black45)),
          )
        : Container();
  }

  Widget _build(AuthService authService) {
    return SingleChildScrollView(
        child: Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('Please enter you current password to delete your account'),
      ),
      _passwordField(),
      Padding(
        padding: const EdgeInsets.all(32.0),
        child: RaisedButton(
            child: Text('Close Account'),
            onPressed: super.showProgress
                ? null
                : () => super.validateAndSubmit(
                    (_) async => await _closeAccount(authService))),
      ),
      _progressIndicator(),
    ]));
  }

  Form _asForm(Widget widget) {
    return Form(autovalidate: true, key: super.formKey, child: widget);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      rebuildOnChange: false,
      builder: (_, child, model) => PlatformScaffold(
            appBar: ModalAppBar(
              title: Text('Delete Account'),
              hideAccept: true,
              closeAction: () => Navigator.maybePop(context),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Material(
                color: isMaterial ? null : Theme.of(context).cardColor,
                child: _asForm(
                  _build(model.authService),
                ),
              ),
            ),
          ),
    );
  }
}
