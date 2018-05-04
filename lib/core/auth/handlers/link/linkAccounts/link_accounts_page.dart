import 'package:flutter/material.dart';
import 'package:flutter_auth_base/flutter_auth_base.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../../app_model.dart';

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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Accounts'),
        ),
        backgroundColor: Colors.white,
        body: ScopedModelDescendant<AppModel>(builder: (_, child, model) {
          return Text('todo');
        }));
  }
}
