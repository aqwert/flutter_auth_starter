import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_auth_base/flutter_auth_base.dart';

import 'change_display_name_view_model.dart';
import '../../../../widgets/form_progress_actionable_state.dart';

class ChangeDisplayName extends StatefulWidget {
  ChangeDisplayName(this.authService, this.displayName);

  final String displayName;
  final AuthService authService;

  @override
  createState() => new ChangeDisplayNameState();
}

class ChangeDisplayNameState
    extends FormProgressActionableState<ChangeDisplayName> {
  @override
  void initState() {
    super.initState();

    _viewModel = new ViewModel(displayName: widget.displayName);
  }

  ViewModel _viewModel;

  Future _setDisplayName() async {
    _viewModel.validateAll();
    await widget.authService.setUserDisplayName(_viewModel.displayName);

    Navigator.of(context).pop(true);
  }

  Widget _header() {
    return AppBar(
        leading: CloseButton(),
        title: Text('Change Display Name'),
        actions: <Widget>[
          IconButton(
              icon: new Icon(Icons.done),
              onPressed: super.showProgress
                  ? null
                  : () => super
                      .validateAndSubmit((_) async => await _setDisplayName())),
        ]);
  }

  Widget _displayNameField() {
    return ListTile(
      leading: Icon(
        Icons.person,
      ),
      title: TextFormField(
          initialValue: _viewModel.displayName,
          decoration: new InputDecoration(labelText: 'Display Name'),
          validator: _viewModel.validateDisplayName,
          onSaved: (val) => _viewModel.displayName = val),
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
      _displayNameField(),
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
        body: Padding(padding: EdgeInsets.all(16.0), child: _asForm(_build())));
  }
}
