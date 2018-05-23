import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_auth_base/flutter_auth_base.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../../common/dialog.dart';
import '../../../../widgets/form_progress_actionable_state.dart';
import '../../../../widgets/tablet_aware_layout_builder.dart';
import '../../../../app_info.dart';
import '../../../../app_model.dart';

import '../../../../widgets/throttled_text_editing_controller.dart';
import '../../../../widgets/email_image_circle_avatar.dart';

import '../../user/termsAcceptance/terms_accept_modal.dart';

import 'sign_up_view_model.dart';

class SignUpPassword extends StatefulWidget {
  @override
  createState() => new SignUpPasswordState();
}

class SignUpPasswordState extends FormProgressActionableState<SignUpPassword> {
  @override
  void initState() {
    super.initState();

    _viewModel = new ViewModel();

    _emailController = ThrottledTextEditingController(
        throttleDurationMilliseconds: 1500,
        onUpdate: (value) => avatarKey.currentState?.performUpdate(value));
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
    try {
      await provider?.create(
          {'email': _viewModel.email, 'password': _viewModel.password});
    } on UserAcceptanceRequiredException {
      bool accepted = await _handleAcceptanceRequired();

      if (accepted)
        await provider?.create(
            {'email': _viewModel.email, 'password': _viewModel.password},
            termsAccepted: true);
    }
  }

  Future<bool> _handleAcceptanceRequired() async {
    var accepted = await openDialog<bool>(
      context: context,
      builder: (_) => TermsAcceptModal(),
    );
    return accepted;
  }

  Widget _signUpButton(AuthService authService) {
    final ThemeData themeData = Theme.of(context);
    final bool isDark = Brightness.dark == themeData.primaryColorBrightness;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32.0),
      child: PlatformButton(
        android: (_) => MaterialRaisedButtonData(
            textColor: isDark ? Colors.white : Colors.black87,
            color: Theme.of(context).primaryColor),
        ios: (_) => CupertinoButtonData(color: Theme.of(context).primaryColor),
        child: Text('Sign Up'),
        onPressed: super.showProgress
            ? null
            : () => super.validateAndSubmit(
                  (_) async => await _signUpWithEmailPassword(authService),
                ),
      ),
    );
  }

  Widget _progressIndicator() {
    return super.showProgress
        ? Padding(
            padding: EdgeInsets.all(16.0),
            child: PlatformCircularProgressIndicator())
        : Container();
  }

  Widget _buildMobileForm(AppInfo appInfo, AuthService authService) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
          ],
        ),
      ),
    );
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
            ),
          ),
        ),
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
            ),
          ),
        ),
      ],
    );
  }

  Form _asForm(Widget widget) {
    return Form(autovalidate: true, key: super.formKey, child: widget);
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text('Create New Account'),
      ),
      backgroundColor: Colors.white,
      body: Material(
        color: isMaterial ? null : Theme.of(context).cardColor,
        child: ScopedModelDescendant<AppModel>(
          builder: (_, child, model) => TabletAwareLayoutBuilder(
                mobileView: (_) => _asForm(
                      _buildMobileForm(model.appInfo, model.authService),
                    ),
                tabletView: (_) => _asForm(
                      _buildTabletForm(model.appInfo, model.authService),
                    ),
              ),
        ),
      ),
    );
  }
}
