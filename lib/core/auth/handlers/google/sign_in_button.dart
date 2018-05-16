import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_auth_base/flutter_auth_base.dart';

import 'package:meta/meta.dart';

import 'icon.dart';
import '../../../common/actionable.dart';

Future signInAction(AuthProvider provider, Actionable actionable) async {
  await actionable.performAction((BuildContext context) async {
    await provider.signIn({});
  });
}

class SignInButton extends StatelessWidget {
  SignInButton({@required this.provider, @required this.actionable});

  final AuthProvider provider;
  final Actionable actionable;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.red,
      padding: EdgeInsets.all(8.0),
      onPressed: () async => await signInAction(provider, actionable),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            providerIcon,
            color: Colors.white,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child:
                Text('Google Sign in', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}
