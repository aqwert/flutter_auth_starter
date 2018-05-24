import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_auth_base/flutter_auth_base.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../../widgets/modalAppBar.dart';
import '../../../../widgets/form_progress_actionable_state.dart';
import '../../../../app_model.dart';

import 'forgot_password_view_model.dart';

class ForgotPassword extends StatefulWidget {
  @override
  createState() => new ForgotPasswordState();
}

class ForgotPasswordState extends FormProgressActionableState<ForgotPassword> {
  @override
  void initState() {
    super.initState();

    _viewModel = new ViewModel();
  }

  ViewModel _viewModel;
  bool _showSendMessage = false;

  AuthProvider _getPasswordProvider(AuthService authService) {
    return authService.authProviders.firstWhere(
        (prov) => prov.providerName == 'password',
        orElse: () => null);
  }

  Future _sendPasswordReset(AuthService authService) async {
    var provider = _getPasswordProvider(authService);

    if (provider != null) {
      await provider.sendPasswordReset({'email': _viewModel.email});
      setState(() {
        _showSendMessage = true;
      });
    }
  }

  Widget _emailField() {
    return TextFormField(
      enabled: !super.showProgress,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      decoration: InputDecoration(labelText: 'Email'),
      validator: _viewModel.validateEmail,
      onSaved: (val) => _viewModel.email = val,
    );
  }

  Widget _forgotButton(AuthService authService) {
    return Padding(
      padding: EdgeInsets.all(32.0),
      child: PlatformButton(
          child: Text('Send Email'),
          onPressed: super.showProgress
              ? null
              : () => super.validateAndSubmit(
                  (_) async => await _sendPasswordReset(authService))),
    );
  }

  Widget _progressIndicator() {
    return super.showProgress
        ? Padding(
            padding: EdgeInsets.all(16.0),
            child: PlatformCircularProgressIndicator())
        : Container();
  }

  Widget _buildForm(AuthService authService) {
    return SingleChildScrollView(
        child: new Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Please enter your email address and we will send you a reset password email.',
          ),
        ),
        _emailField(),
        _forgotButton(authService),
        _showSendMessage
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'An email has been sent to this address. Please open the email and follow the instructions to reset your password',
                  textAlign: TextAlign.center,
                ),
              )
            : Container(),
        _progressIndicator()
      ]),
    ));
  }

  Form _asForm(Widget widget) {
    return Form(autovalidate: true, key: super.formKey, child: widget);
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: ModalAppBar(
        title: Text('Reset Password'),
        hideAccept: true,
        closeAction:
            super.showProgress ? null : () => Navigator.maybePop(context),
      ),
      body: Material(
        color: isMaterial ? null : Theme.of(context).cardColor,
        child: ScopedModelDescendant<AppModel>(
          rebuildOnChange: false,
          builder: (_, child, model) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _asForm(_buildForm(model.authService)),
              ),
        ),
      ),
    );
  }
}
