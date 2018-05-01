import 'dart:async';

import 'package:async_loader/async_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_base/flutter_auth_base.dart';
import 'package:scoped_model/scoped_model.dart';

import '../widgets/tabletAwareScaffold.dart';
import '../widgets/screenLogo.dart';

import '../app_model.dart';
import '../app_info.dart';

enum LoginState {
  LoginSuccessful,
  LoginRequired,
}

class Splash extends StatefulWidget {
  Splash({this.signInButtonBuilders, this.signUpButtonBuilders});

  final Map<String, WidgetBuilder> signInButtonBuilders;
  final Map<String, WidgetBuilder> signUpButtonBuilders;

  @override
  State<StatefulWidget> createState() => SplashState();
}

class SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    _loader = _buildLoader();
  }

  final GlobalKey<AsyncLoaderState> _loaderKey = GlobalKey<AsyncLoaderState>();

  Widget _loader;

  Future<LoginState> _initAppState(AppModel model) async {
    //Delibrate delay so we dont get flickering.
    await Future.delayed(Duration(milliseconds: 500), () {});
    await model.refreshAuthUser();
    if (model.token != null) {
      return LoginState.LoginSuccessful;
    } else {
      return LoginState.LoginRequired;
    }
  }

  void _navigateToHome() {
    new Future.delayed(
        const Duration(seconds: 0),
        () => Navigator
            .of(context)
            .pushNamedAndRemoveUntil('/home', (item) => false));
  }

  Widget _handleCompleted(AuthService authService, LoginState state) {
    if (state == LoginState.LoginRequired) {
      return _buttons(authService);
    } else if (state == LoginState.LoginSuccessful) {
      _navigateToHome();
    }
    return Container();
  }

  Widget _handleError(AuthService authService, Object error) {
    return _buttons(authService, errorMessage: error.toString());
  }

  Widget _handleSnapshot(AppModel model, BuildContext context,
      AsyncSnapshot<LoginState> snapshot) {
    if (snapshot.hasData) {
      return _handleCompleted(model.authService, snapshot.data);
    } else if (snapshot.hasError) {
      return _handleError(model.authService, snapshot.error);
    } else {
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.black45)),
        ),
      );
    }
  }

  Widget _loginLoader;

  Widget _buildLoader() {
    return ScopedModelDescendant<AppModel>(builder: (_, child, model) {
      if (_loginLoader == null) {
        _loginLoader = FutureBuilder<LoginState>(
            key: _loaderKey,
            future: _initAppState(model),
            builder: (_, AsyncSnapshot<LoginState> snapshot) =>
                _handleSnapshot(model, _, snapshot));
      }
      return _loginLoader;
    });
  }

  Widget _buttons(AuthService authService, {String errorMessage}) {
    List<Widget> widgets = new List<Widget>();
    widget.signInButtonBuilders?.forEach((providerName, builder) {
      var widget = builder(context);
      if (widget != null) {
        widgets.add(Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0), child: widget));
      }
    });

    widgets.add(Padding(padding: EdgeInsets.only(top: 16.0)));

    widget.signUpButtonBuilders?.forEach((providerName, builder) {
      var widget = builder(context);
      if (widget != null) {
        widgets.add(Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0), child: widget));
      }
    });

    return Column(children: widgets);
  }

  Widget _buildMobileView(
      AppInfo appInfo, Widget loader, Color splashForegroundColor) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ScreenLogo(imagePath: appInfo.appIconPath),
        Text(appInfo.appName,
            style: TextStyle(
                color: splashForegroundColor,
                fontSize: 18.0,
                fontWeight: FontWeight.bold)),
        Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: loader,
          )
        ])
      ],
    ));
  }

  Widget _buildTabletView(AppInfo appInfo, Widget loader,
      Color splashBackgroundColor, Color splashForegroundColor) {
    return Row(
      children: <Widget>[
        Expanded(
            flex: 1,
            child: Material(
                color: splashBackgroundColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ScreenLogo(imagePath: appInfo.appIconPath),
                    Text(appInfo.appName,
                        style: TextStyle(
                            color: splashForegroundColor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold)),
                  ],
                ))),
        Expanded(
            flex: 1,
            child: SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 36.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: loader,
                  )
                ],
              ),
            ))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(builder: (_, child, model) {
      //var theme = Theme.of(context);
      Color bgColor = Colors.white;
      Color fgColor = Colors.black87;

      return TabletAwareScaffold(
          mobileView: _buildMobileView(model.appInfo, _loader, fgColor),
          tabletView:
              _buildTabletView(model.appInfo, _loader, bgColor, fgColor),
          backgroundColor: bgColor);
    });
  }
}
