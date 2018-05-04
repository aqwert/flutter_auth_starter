import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_auth_base/flutter_auth_base.dart';

import '../../../../widgets/form_progress_actionable_state.dart';

import 'change_password_view_model.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword(this.authService);

  final AuthService authService;

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

  Future _changeEmail() async {
    var provider = _getPasswordProvider(widget.authService);

    await provider?.changePassword({
      'currentPassword': _viewModel.currentPassword,
      'newPassword': _viewModel.newPassword
    });

    Navigator.of(context).pop(true);
  }

  Widget _header() {
    return AppBar(
        leading: CloseButton(),
        title: Text('Change Password'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.done),
              onPressed: super.showProgress
                  ? null
                  : () => super
                      .validateAndSubmit((_) async => await _changeEmail())),
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
          obscureText: true,
          decoration: InputDecoration(labelText: 'Re-type New Password'),
          validator: _viewModel.validatePassword,
          onSaved: (val) => _viewModel.newPasswordConfirm = val),
    );
  }

  Widget _progressIndicator() {
    return super.showProgress
        ? Padding(
            padding: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.black45)),
            ),
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
    return Scaffold(
        appBar: _header(),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _asForm(_build())));
  }
}
