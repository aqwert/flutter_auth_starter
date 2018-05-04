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
import '../../../../widgets/screen_aware_padding.dart';

import '../signUp/sign_up_page.dart';
import '../forgotPassword/forgot_password_page.dart';

import 'sign_in_view_model.dart';

class SignInPassword extends StatefulWidget {
  static String routeName = '/signInPassword';

  SignInPassword({@required this.authService});
  final AuthService authService;
  @override
  createState() => new SignInPasswordState();
}

class SignInPasswordState extends FormProgressActionableState<SignInPassword> {
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

  void _signUp() {
    Navigator.of(context).pushNamed(SignUpPassword.routeName);
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

  Future _signInWithEmailPassword(AuthService authService) async {
    _viewModel.validateAll();

    var provider = _getPasswordProvider(authService);
    await provider?.signIn(new Map<String, String>()
      ..['email'] = _viewModel.email
      ..['password'] = _viewModel.password);
  }

  Widget _signInButton(AuthService authService) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32.0),
      child: RaisedButton(
          child: Text('Sign In'),
          onPressed: super.showProgress
              ? null
              : () => super.validateAndSubmit(
                  (_) async => await _signInWithEmailPassword(authService))),
    );
  }

  Widget _forgotPasswordButton(AuthService authService) {
    return authService.options.canSendForgotEmail
        ? Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 32.0, right: 32.0),
            child: FlatButton(
                child: Text('Forgot password'),
                onPressed: super.showProgress
                    ? null
                    : () {
                        return showDialog(
                            context: context,
                            builder: (_) => new ScreenAwarePadding(
                                child: new ForgotPassword(widget.authService)),
                            barrierDismissible: false);
                      }))
        : Container();
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
              _emailField(),
              _passwordField(),
              _signInButton(authService),
              _forgotPasswordButton(authService),
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
                  _emailField(),
                  _passwordField(),
                  _signInButton(authService),
                  _forgotPasswordButton(authService),
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
          title: Text('Login'),
          actions: <Widget>[
            FlatButton(
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                      color: Theme.of(context).primaryTextTheme.title.color),
                ),
                onPressed: () => _signUp()),
          ],
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
