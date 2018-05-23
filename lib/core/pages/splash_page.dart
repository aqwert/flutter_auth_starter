import 'dart:async';

import 'package:async_loader/async_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_base/flutter_auth_base.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../common/dialog.dart';
import '../widgets/tablet_aware_scaffold.dart';
import '../widgets/screen_logo.dart';
import '../widgets/progress_actionable_state.dart';

import '../auth/handlers/email/sign_in_button.dart' as email;
import '../auth/handlers/email/sign_up_button.dart' as email;
import '../auth/handlers/google/sign_in_button.dart' as google;

import '../app_model.dart';
import '../app_info.dart';

import '../auth/handlers/user/termsAcceptance/terms_accept_modal.dart';

enum LoginState {
  LoginSuccessful,
  LoginRequired,
}

class Splash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashState();
}

class SplashState extends ProgressActionableState<Splash> {
  @override
  void initState() {
    super.initState();

    _loader = _buildLoader();
  }

  Widget _loader;
  Widget _loginLoader;

  final GlobalKey<AsyncLoaderState> _loaderKey = GlobalKey<AsyncLoaderState>();

  AuthProvider _getPasswordProvider(AuthService authService) {
    return authService.authProviders.firstWhere(
        (prov) => prov.providerName == 'password',
        orElse: () => null);
  }

  AuthProvider _getGoogleProvider(AuthService authService) {
    return authService.authProviders.firstWhere(
        (prov) => prov.providerName == 'google',
        orElse: () => null);
  }

  Future<LoginState> _initAppState(AppModel model) async {
    await model.refreshAuthUser();
    if (model.user != null && model.user.isValid) {
      return LoginState.LoginSuccessful;
    } else {
      return LoginState.LoginRequired;
    }
  }

  Widget _handleCompleted(
      AppInfo appInfo, AuthService authService, LoginState state) {
    if (state == LoginState.LoginRequired) {
      return _buttons(appInfo, authService);
    } else if (state == LoginState.LoginSuccessful) {
      //_navigateToHome();
    }
    return Container();
  }

  Widget _handleError(AppInfo appInfo, AuthService authService, Object error) {
    return _buttons(appInfo, authService, errorMessage: error.toString());
  }

  Widget _progressIndicator() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: PlatformCircularProgressIndicator(
        android: (_) => MaterialProgressIndicatorData(
              valueColor: AlwaysStoppedAnimation(Colors.black45),
            ),
      ),
    );
  }

  Widget _handleSnapshot(AppModel model, BuildContext context,
      AsyncSnapshot<LoginState> snapshot) {
    if (snapshot.hasData) {
      return _handleCompleted(model.appInfo, model.authService, snapshot.data);
    } else if (snapshot.hasError) {
      return _handleError(model.appInfo, model.authService, snapshot.error);
    } else {
      return _progressIndicator();
    }
  }

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

  Widget _buttons(AppInfo appInfo, AuthService authService,
      {String errorMessage}) {
    var passwordProvider = _getPasswordProvider(authService);
    var googleProvider = _getGoogleProvider(authService);

    List<Widget> widgets = new List<Widget>();
    if (passwordProvider != null) {
      widgets.add(Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: email.SignInButton()));
    }
    if (googleProvider != null) {
      widgets.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: google.SignInButton(action: (_) async {
            await performAction((BuildContext context) async {
              try {
                await googleProvider.signIn({}, termsAccepted: false);
              } on UserAcceptanceRequiredException catch (error) {
                bool accepted = await _handleAcceptanceRequired();

                if (accepted)
                  await googleProvider.signIn(error.data, termsAccepted: true);
              }
            });
          }),
        ),
      );
    }

    widgets.add(Padding(padding: EdgeInsets.only(top: 16.0)));
    if (passwordProvider != null) {
      widgets.add(Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: email.SignUpButton()));
    }

    return Column(children: widgets);
  }

  Future<bool> _handleAcceptanceRequired() async {
    var accepted = await openDialog<bool>(
      context: context,
      builder: (_) => TermsAcceptModal(),
    );
    return accepted;
  }

  Widget _withProgress(Widget child) {
    return super.showProgress ? _progressIndicator() : child;
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
            child: _withProgress(loader),
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
            child: Container(
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
                    child: _withProgress(loader),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (_, child, model) {
        //var theme = Theme.of(context);
        Color bgColor = Colors.white;
        Color fgColor = Colors.black87;

        return TabletAwareScaffold(
            mobileView: (_) =>
                _buildMobileView(model.appInfo, _loader, fgColor),
            tabletView: (_) =>
                _buildTabletView(model.appInfo, _loader, bgColor, fgColor),
            backgroundColor: bgColor);
      },
    );
  }
}
