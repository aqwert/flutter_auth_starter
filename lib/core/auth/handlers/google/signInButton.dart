import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_auth_base/flutter_auth_base.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meta/meta.dart';

class SignInButton extends StatelessWidget {
  SignInButton({@required this.provider});

  final AuthProvider provider;

  Future _signIn(BuildContext context) async {
    await provider.signIn(new Map<String, String>());

    Navigator.of(context).pushNamedAndRemoveUntil('/home', (item) => false);
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.red,
      padding: EdgeInsets.all(8.0),
      onPressed: () async => await _signIn(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            FontAwesomeIcons.google,
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
