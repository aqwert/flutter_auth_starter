import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_auth_base/flutter_auth_base.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../../widgets/form_progress_actionable_state.dart';
import 'link_account_view_model.dart';

import '../../../../widgets/modalAppBar.dart';

class LinkEmailAccount extends StatefulWidget {
  LinkEmailAccount(this.linkProvider, {this.onAuthRequired});

  final LinkableProvider linkProvider;
  final VoidCallback onAuthRequired;

  @override
  createState() => new LinkEmailAccountState();
}

class LinkEmailAccountState
    extends FormProgressActionableState<LinkEmailAccount> {
  @override
  void initState() {
    super.initState();

    _viewModel = new ViewModel();
  }

  ViewModel _viewModel;

  Future doLinkAccount() {
    _viewModel.validateAll();

    return widget.linkProvider.linkAccount(
        {'email': _viewModel.email, 'password': _viewModel.password});
  }

  Widget _linkButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32.0),
      child: PlatformButton(
        child: Text('Sign In'),
        onPressed: super.showProgress
            ? null
            : () => super.validateAndSubmit(
                  (_) async {
                    try {
                      await doLinkAccount();
                      Navigator.pop(context);
                    } on AuthRequiredException catch (error) {
                      if (widget.onAuthRequired != null) {
                        print('widget.onAuthRequired');
                        widget.onAuthRequired();
                      } else {
                        throw error;
                      }
                      return null;
                    }
                  },
                ),
      ),
    );
  }

  Widget _emailField() {
    return ListTile(
      leading: Icon(
        Icons.email,
      ),
      title: TextFormField(
          enabled: !super.showProgress,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          decoration: InputDecoration(labelText: 'Email'),
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
          decoration: InputDecoration(labelText: 'Password'),
          validator: _viewModel.validatePassword,
          onSaved: (val) => _viewModel.password = val),
    );
  }

  Widget _progressIndicator() {
    return super.showProgress
        ? Padding(
            padding: EdgeInsets.all(16.0),
            child: PlatformCircularProgressIndicator())
        : Container();
  }

  Widget _buildPage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
          child: Column(children: <Widget>[
        _emailField(),
        _passwordField(),
        _linkButton(),
        _progressIndicator(),
      ])),
    );
  }

  Form _asForm(Widget widget) {
    return Form(autovalidate: true, key: super.formKey, child: widget);
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: ModalAppBar(
        hideAccept: true,
        closeAction:
            super.showProgress ? null : () => Navigator.maybePop(context),
        title: Text('Link Email Account'),
      ),
      body: Material(
        color: isMaterial ? null : Theme.of(context).cardColor,
        child: _asForm(
          _buildPage(),
        ),
      ),
    );
  }
}
