import 'dart:async';

import 'package:flutter/material.dart';

import '../common/appException.dart';
import '../dialogs/showError_dialog.dart';

abstract class ProgressableState<T extends StatefulWidget> extends State<T> {
  bool showProgress = false;
  void setProgress(bool value) {
    if (mounted) {
      setState(() {
        //print('^^^^ Setting progress: ' + value.toString());
        showProgress = value;
      });
    }
  }

  Future<Null> doSubmit({options});

  Future performAction({options}) async {
    setProgress(true);
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      await doSubmit(options: options);

      //print('doSubmit completed');
    } on AppException catch (error) {
      await showErrorDialog(context, error.message ?? 'Unknown error occured',
          showSigninSuggestion: error.signinSuggested);
      //print('CLOZE ERROR');
    } catch (error) {
      await showErrorDialog(context, 'Unknown error occured');
    } finally {
      //print('PROGRESS CLOSE1');
      await new Future.delayed(const Duration(milliseconds: 500), () {
        //print('PROGRESS CLOSE2');
        setProgress(false);
      });
    }
  }
}
