import 'package:flutter/material.dart';
import 'package:flutter_auth_base/flutter_auth_base.dart';

class LinkAccounts extends StatefulWidget {
  LinkAccounts({this.authService});

  static String routeName = '/linkAccounts';

  final AuthService authService;

  @override
  createState() => new LinkAccountsState();
}

class LinkAccountsState extends State<LinkAccounts> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      'TODO',
    ));
  }
}
