import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_auth_base/flutter_auth_base.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../../widgets/form_progress_actionable_state.dart';
import '../../../../app_model.dart';
import 'change_password_view_model.dart';

class ChangePassword extends StatefulWidget {
  //ChangePassword(this.authService);

  //final AuthService authService;

  @override
  createState() => new ChangePasswordState();
}

class ChangePasswordState extends FormProgressActionableState<ChangePassword> {
  @override
  void initState() {
    super.initState();

    _viewModel = new ViewModel();
  }

  ViewModel _viewModel;

  AuthProvider _getPasswordProvider(AuthService authService) {
    return authService.authProviders.firstWhere(
        (prov) => prov.providerName == 'password',
        orElse: () => null);
  }

  Future _changeEmail(AuthService authService) async {
    var provider = _getPasswordProvider(authService);

    await provider?.changePassword({
      'currentPassword': _viewModel.currentPassword,
      'newPassword': _viewModel.newPassword
    });

    Navigator.pop(context);
  }

  Widget _header(AuthService authService) {
    return AppBar(
        leading: CloseButton(),
        title: Text('Change Password'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.done),
              onPressed: super.showProgress
                  ? null
                  : () => super.validateAndSubmit(
                      (_) async => await _changeEmail(authService))),
        ]);
  }

  Widget _currentPasswordField() {
    return ListTile(
      leading: Icon(
        Icons.lock,
      ),
      title: TextFormField(
          obscureText: true,
          decoration: InputDecoration(labelText: 'Current Password'),
          validator: _viewModel.validatePassword,
          onSaved: (val) => _viewModel.currentPassword = val),
    );
  }

  Widget _newPasswordField() {
    return ListTile(
      leading: Icon(
        Icons.lock,
      ),
      title: TextFormField(
          enabled: !super.showProgress,
          autocorrect: false,
          obscureText: true,
          decoration: InputDecoration(labelText: 'New Password'),
          validator: _viewModel.validatePassword,
          onSaved: (val) => _viewModel.newPassword = val),
    );
  }

  Widget _newPasswordConfirmField() {
    return ListTile(
      leading: Icon(
        Icons.lock,
      ),
      title: TextFormField(
          enabled: !super.showProgress,
          autocorrect: false,
          obscureText: true,
          decoration: InputDecoration(labelText: 'Re-type New Password'),
          validator: _viewModel.validatePassword,
          onSaved: (val) => _viewModel.newPasswordConfirm = val),
    );
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

  Widget _build() {
    return SingleChildScrollView(
        child: Column(children: <Widget>[
      Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
            'Please enter you current password to be able change to a new password'),
      ),
      _currentPasswordField(),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Divider(),
      ),
      _newPasswordField(),
      _newPasswordConfirmField(),
      _progressIndicator(),
    ]));
  }

  Form _asForm(Widget widget) {
    return Form(autovalidate: true, key: super.formKey, child: widget);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
        builder: (_, child, model) => Scaffold(
            appBar: _header(model.authService),
            body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _asForm(_build()))));
  }
}
