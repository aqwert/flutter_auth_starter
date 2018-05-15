import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_auth_base/flutter_auth_base.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../../widgets/form_progress_actionable_state.dart';
import '../../../../app_model.dart';
import 'change_email_view_model.dart';
import '../icon.dart';
import '../../../../widgets/modalAppBar.dart';

class ChangeEmail extends StatefulWidget {
  //ChangeEmail(this.authService);

  //final AuthService authService;

  @override
  createState() => new ChangeEmailState();
}

class ChangeEmailState extends FormProgressActionableState<ChangeEmail> {
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

    await provider?.changePrimaryIdentifier(
        {'email': _viewModel.email, 'password': _viewModel.password});

    Navigator.pop(context);
  }

  Widget _emailField() {
    return ListTile(
      leading: Icon(
        providerIcon,
      ),
      title: TextFormField(
          enabled: !super.showProgress,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          decoration: InputDecoration(labelText: 'New Email'),
          validator: _viewModel.validateEmail,
          onSaved: (val) => _viewModel.email = val),
    );
  }

  Widget _passwordField() {
    return ListTile(
      leading: Icon(
        Icons.lock,
      ),
      title: TextFormField(
          enabled: !super.showProgress,
          autocorrect: false,
          obscureText: true,
          decoration: InputDecoration(labelText: 'Current Password'),
          validator: _viewModel.validatePassword,
          onSaved: (val) => _viewModel.password = val),
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
            'Please enter you current password to change your primary email address'),
      ),
      _passwordField(),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Divider(),
      ),
      _emailField(),
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
              title: Text('Change Email'),
              acceptAction: super.showProgress
                  ? null
                  : () => super.validateAndSubmit(
                        (_) async => await _changeEmail(model.authService),
                      ),
              closeAction:
                  super.showProgress ? null : () => Navigator.maybePop(context),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Material(
                color: isMaterial ? null : Theme.of(context).cardColor,
                child: _asForm(
                  _build(),
                ),
              ),
            ),
          ),
    );
  }
}
