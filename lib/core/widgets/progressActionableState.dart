import 'dart:async';

import 'package:flutter/material.dart';

import 'progressableState.dart';
import '../common/actionable.dart';
import '../common/appException.dart';
import '../dialogs/showError_dialog.dart';

abstract class ProgressActionableState<T extends StatefulWidget>
    extends ProgressableState<T> with Actionable {
  Future performAction(FutureContextCallback action) async {
    setProgress(true);
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      await action(context);
    } on AppException catch (error) {
      await showErrorDialog(context, error.message ?? 'Unknown error occured',
          showSigninSuggestion: error.signinSuggested);
    } catch (error) {
      await showErrorDialog(context, 'Unknown error occured');
    } finally {
      await new Future.delayed(const Duration(milliseconds: 500), () {
        setProgress(false);
      });
    }
  }
}
