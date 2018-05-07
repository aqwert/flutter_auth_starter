import 'package:flutter/material.dart';
import 'signUp/sign_up_page.dart';

void signUp(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpPassword()));
}

class SignUpButton extends StatelessWidget {
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
          padding: EdgeInsets.symmetric(horizontal: 32.0),
          textColor: theme.primaryColor,
          onPressed: () => signUp(context),
          child: Text("Sign Up"))
    ]);
  }
}
