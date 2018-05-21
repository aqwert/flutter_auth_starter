import 'dart:async';

import 'package:flutter/material.dart';
import 'signIn/sign_in_page.dart';
import 'icon.dart';

import '../../../common/future_action_callback.dart';

Future signIn(BuildContext context) {
  return Navigator.push(
      context, MaterialPageRoute(builder: (_) => SignInPassword()));
}

class SignInButton extends StatelessWidget {
  SignInButton({this.action = signIn});

  final FutureActionCallback<BuildContext> action;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return RaisedButton(
      color: theme.primaryColor,
      padding: EdgeInsets.all(8.0),
      onPressed: () => action(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            providerIcon,
            color: Colors.white,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Email Sign in', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}
