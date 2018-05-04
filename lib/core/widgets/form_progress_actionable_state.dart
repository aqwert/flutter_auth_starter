import 'dart:async';

import 'package:flutter/material.dart';

import '../dialogs/show_error_dialog.dart';
import '../common/actionable.dart';

import 'progress_actionable_state.dart';

abstract class FormProgressActionableState<T extends StatefulWidget>
    extends ProgressActionableState<T> {
  final formKey = new GlobalKey<FormState>();

  Future<Null> validateAndSubmit(FutureContextCallback action) async {
    if (!showProgress) {
      final form = formKey.currentState;

      if (form?.validate() ?? true) {
        form?.save();

        await super.performAction(action);
      } else {
        await showErrorDialog(context, 'Please correct any errors first.');
      }
    }
  }
}
