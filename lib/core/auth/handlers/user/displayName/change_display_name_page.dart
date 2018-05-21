import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_auth_base/flutter_auth_base.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'change_display_name_view_model.dart';
import '../../../../widgets/form_progress_actionable_state.dart';
import '../../../../app_model.dart';
import '../../../../widgets/modalAppBar.dart';

class ChangeDisplayName extends StatefulWidget {
  ChangeDisplayName({this.displayName});

  final String displayName;
  //final AuthService authService;

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

  Future _setDisplayName(AuthService authService) async {
    _viewModel.validateAll();
    await authService.setUserDisplayName(_viewModel.displayName);

    Navigator.pop(context);
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
            padding: EdgeInsets.all(16.0),
            child: PlatformCircularProgressIndicator())
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
    return ScopedModelDescendant<AppModel>(
      rebuildOnChange: false,
      builder: (_, child, model) => PlatformScaffold(
            appBar: ModalAppBar(
              title: Text('Change Display Name'),
              acceptAction: super.showProgress
                  ? null
                  : () => super.validateAndSubmit(
                        (_) async => await _setDisplayName(model.authService),
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
