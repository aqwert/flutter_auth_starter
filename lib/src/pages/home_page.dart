import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;

import '../../core/app_model.dart';
import '../../core/pages/drawer_page.dart';
import '../../core/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Widget _buildBody(AppModel model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: Column(
          children: <Widget>[
            Text('Home page'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PlatformButton(
                child: Text('Sign Out'),
                onPressed: () async => await model.authService.signOut(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PlatformButton(
                child: Text('Switch Platform'),
                onPressed: () {
                  setState(() {
                    if (isCupertino) {
                      changeToMaterialPlatform();
                    } else if (isMaterial) {
                      changeToCupertinoPlatform();
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      rebuildOnChange: false,
      builder: (_, child, model) {
        return PlatformScaffold(
          android: (_) => MaterialScaffoldData(
                drawer: new Drawer(
                  child: new DrawerPage(),
                ),
              ),
          appBar: PlatformAppBar(
            title: Text(
              'Flutter Auth Starter',
            ),
            ios: (_) => CupertinoNavigationBarData(
                  leading: PlatformIconButton(
                    iosIcon: Icon(CupertinoIcons.info),
                    onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Material(
                                  child: ProfilePage(),
                                ),
                          ),
                        ),
                  ),
                ),
          ),
          body: Material(
            color: isMaterial ? null : Theme.of(context).cardColor,
            child: _buildBody(model),
          ),
        );
      },
    );
  }
}
