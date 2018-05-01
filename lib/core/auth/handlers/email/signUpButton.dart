import 'package:flutter/material.dart';
import 'signUp/signUp_page.dart';

class SignUpButton extends StatelessWidget {
  void _signUp(BuildContext context) {
    Navigator
        .of(context)
        .pushNamedAndRemoveUntil(SignUpPassword.routeName, (item) => false);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(children: <Widget>[
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text("Not registered?",
            style: TextStyle(color: theme.textTheme.body1.color)),
      ),
      OutlineButton(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          textColor: theme.primaryColor,
          onPressed: () => _signUp(context),
          child: Text("Sign Up"))
    ]);
  }
}
