import 'package:flutter/material.dart';
import 'signIn/signIn_page.dart';

class SignInButton extends StatelessWidget {
  void _signIn(BuildContext context) {
    Navigator.of(context).pushNamed(SignInPassword.routeName);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return RaisedButton(
      color: theme.primaryColor,
      padding: EdgeInsets.all(8.0),
      onPressed: () => _signIn(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.email,
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
