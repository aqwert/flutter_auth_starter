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
    final ThemeData theme = Theme.of(context);
    final bool isDark = Brightness.dark == theme.primaryColorBrightness;
    var color = isDark ? Colors.white : Colors.black87;

    return RaisedButton(
      color: theme.primaryColor,
      padding: EdgeInsets.all(8.0),
      onPressed: () => action(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            width: 70.0,
            child: Icon(
              providerIcon,
              color: color,
            ),
          ),
          Expanded(
            child: new Center(
                child: Text('Email Sign in', style: TextStyle(color: color))),
          ),
          Container(
            width: 70.0,
          ),
        ],
      ),
    );
  }
}
