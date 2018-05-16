import 'dart:async';

import 'package:flutter/material.dart';

import 'progressable_state.dart';
import '../common/actionable.dart';
import '../common/app_exception.dart';
import '../dialogs/show_error_dialog.dart';

abstract class ProgressActionableState<T extends StatefulWidget>
    extends ProgressableState<T> implements Actionable {
  Future performAction(FutureContextCallback action) async {
    setProgress(true);
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      await action(context);
    } on AppException catch (error) {
      setProgress(false);

      await showErrorDialog(context, error.message ?? 'Unknown error occured');
    } catch (error) {
      setProgress(false);

      await showErrorDialog(context, 'Unknown error occured');
    } finally {
      await new Future.delayed(const Duration(milliseconds: 500), () {
        setProgress(false);
      });
    }
  }
}
