import 'dart:async';

import 'package:flutter_auth_base/flutter_auth_base.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter/material.dart';

import 'signin_picker.dart';

Future<Null> showSigninPickerDialog(
    BuildContext context, List<AuthProvider> authProviders) async {
  return showDialog<Null>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return PlatformAlertDialog(
        title: Text('Pick Sign-in Account'),
        content: SignInPicker(authProviders: authProviders),
        actions: <Widget>[
          PlatformDialogAction(
            child: PlatformText('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
    },
  );
}
