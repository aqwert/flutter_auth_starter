import 'package:flutter/material.dart';
import 'package:flutter_auth_base/flutter_auth_base.dart';
import 'package:meta/meta.dart';

class SignUpPassword extends StatefulWidget {
  static String routeName = '/signUpPassword';

  SignUpPassword({@required this.authService});
  final AuthService authService;
  @override
  createState() => new SignUpPasswordState();
}

class SignUpPasswordState extends State<SignUpPassword> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text('Sign up page'),
    ));
  }
}
