import 'package:flutter/material.dart';
import 'signIn/sign_in_page.dart';
import 'icon.dart';

void signIn(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (_) => SignInPassword()));
}

class SignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return RaisedButton(
      color: theme.primaryColor,
      padding: EdgeInsets.all(8.0),
      onPressed: () => signIn(context),
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
