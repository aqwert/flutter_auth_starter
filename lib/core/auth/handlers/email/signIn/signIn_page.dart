import 'package:flutter/material.dart';
import 'package:flutter_auth_base/flutter_auth_base.dart';
import 'package:meta/meta.dart';

class SignInPassword extends StatefulWidget {
  static String routeName = '/signInPassword';

  SignInPassword({@required this.authService});
  final AuthService authService;
  @override
  createState() => new SignInPasswordState();
}

class SignInPasswordState extends State<SignInPassword> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text('Sign in page'),
    ));
  }
}
