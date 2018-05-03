import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../core/app_model.dart';
import '../../core/pages/drawer_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(builder: (_, child, model) {
      return Scaffold(
          appBar: AppBar(title: Text('Flutter Auth Starter')),
          drawer: new Drawer(
            child: new DrawerPage(),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Center(
              child: Column(children: <Widget>[
                Text('Home page'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                      child: Text('Sign Out'),
                      onPressed: () async => await model.authService.signOut()),
                )
              ]),
            ),
          ));
    });
  }
}
