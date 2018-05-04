import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_auth_base/flutter_auth_base.dart';
import 'package:meta/meta.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../../widgets/form_progress_actionable_state.dart';
import '../../../../widgets/tablet_aware_layout_builder.dart';
import '../../../../app_info.dart';
import '../../../../app_model.dart';

import '../../../../widgets/throttled_text_editing_controller.dart';
import '../../../../widgets/email_image_circle_avatar.dart';

import 'sign_up_view_model.dart';

class SignUpPassword extends StatefulWidget {
  static String routeName = '/signUpPassword';

  SignUpPassword({@required this.authService});
  final AuthService authService;
  @override
  createState() => new SignUpPasswordState();
}

class SignUpPasswordState extends FormProgressActionableState<SignUpPassword> {
  @override
  void initState() {
    super.initState();

    _viewModel = new ViewModel();

    _emailController = ThrottledTextEditingController(
        onUpdate: (value) => avatarKey.currentState.performUpdate(value));
  }

  ViewModel _viewModel;
  TextEditingController _emailController;

  final avatarKey = GlobalKey<EmailImageCircleAvatarState>();

  AuthProvider _getPasswordProvider(AuthService authService) {
    return authService.authProviders.firstWhere(
        (prov) => prov.providerName == 'password',
        orElse: () => null);
  }

  Widget _logoGravatar(AppInfo appInfo, AuthService authService) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: EmailImageCircleAvatar(
          checkIfImageExists: true,
          key: avatarKey,
          imageSize: 150,
          backgroundColor: Colors.white70,
          defaultImage: AssetImage(appInfo.appIconPath),
          imageProvider: authService.preAuthPhotoProvider),
    );
  }

  Widget _displayNameField() {
    return TextFormField(
      enabled: !super.showProgress,
      keyboardType: TextInputType.text,
      autocorrect: false,
      decoration: InputDecoration(labelText: 'Display Name (optional)'),
      validator: _viewModel.validateDisplayName,
      onSaved: (val) => _viewModel.displayName = val,
    );
  }

  Widget _emailField() {
    return TextFormField(
      enabled: !super.showProgress,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      controller: _emailController,
      decoration: InputDecoration(labelText: 'Email'),
      validator: _viewModel.validateEmail,
      onSaved: (val) => _viewModel.email = val,
    );
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

  Widget _passwordConfirmField() {
    return TextFormField(
        enabled: !super.showProgress,
        autocorrect: false,
        obscureText: true,
        decoration: InputDecoration(labelText: 'Re-type Password'),
        validator: _viewModel.validatePassword,
        onSaved: (val) => _viewModel.passwordConfirm = val);
  }

  Future _signUpWithEmailPassword(AuthService authService) async {
    _viewModel.validateAll();

    var provider = _getPasswordProvider(authService);
    await provider?.create(new Map<String, String>()
      ..['email'] = _viewModel.email
      ..['password'] = _viewModel.password);
  }

  Widget _signUpButton(AuthService authService) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32.0),
      child: RaisedButton(
          child: Text('Sign Up'),
          onPressed: super.showProgress
              ? null
              : () => super.validateAndSubmit(
                  (_) async => await _signUpWithEmailPassword(authService))),
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

  Widget _buildMobileForm(AppInfo appInfo, AuthService authService) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _logoGravatar(appInfo, authService),
                ],
              ),
              _displayNameField(),
              _emailField(),
              _passwordField(),
              _passwordConfirmField(),
              _signUpButton(authService),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[_progressIndicator()],
              ),
            ])));
  }

  Widget _buildTabletForm(AppInfo appInfo, AuthService authService) {
    return Row(
      children: <Widget>[
        Expanded(
            flex: 1,
            child: Container(
                color: Colors.white,
                //elevation: 4.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _logoGravatar(appInfo, authService),
                    _progressIndicator()
                  ],
                ))),
        Expanded(
            flex: 1,
            child: SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 36.0),
              child: Column(
                children: <Widget>[
                  _displayNameField(),
                  _emailField(),
                  _passwordField(),
                  _passwordConfirmField(),
                  _signUpButton(authService),
                ],
              ),
            ))),
      ],
    );
  }

  Form _asForm(Widget widget) {
    return Form(autovalidate: true, key: super.formKey, child: widget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Create New Account'),
        ),
        backgroundColor: Colors.white,
        body: ScopedModelDescendant<AppModel>(builder: (_, child, model) {
          return TabletAwareLayoutBuilder(
              mobileView:
                  _asForm(_buildMobileForm(model.appInfo, model.authService)),
              tabletView:
                  _asForm(_buildTabletForm(model.appInfo, model.authService)));
        }));
  }
}
