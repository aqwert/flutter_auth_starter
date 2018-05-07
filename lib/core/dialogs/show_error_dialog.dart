import 'dart:async';

import 'package:flutter/material.dart';

Future<Null> showErrorDialog(BuildContext context, String message,
    {bool showSigninSuggestion = false}) async {
  return showDialog<Null>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Oops'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message ?? 'An unknown error occured'),
              // (showSigninSuggestion != null && showSigninSuggestion)
              //     ? _signInButton(context)
              //     :  Container()
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
