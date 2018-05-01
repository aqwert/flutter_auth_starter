import 'dart:async';

import 'package:flutter/material.dart';

Future<Null> showErrorDialog(BuildContext context, String message,
    {bool showSigninSuggestion = false}) async {
  return showDialog<Null>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return new AlertDialog(
        title: new Text('Oops'),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new Text(message ?? 'An unknown error occured'),
              // (showSigninSuggestion != null && showSigninSuggestion)
              //     ? _signInButton(context)
              //     : new Container()
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
