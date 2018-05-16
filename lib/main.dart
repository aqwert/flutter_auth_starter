import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'core/app_model.dart';
import 'core/app_info.dart';
import 'core/pages/splash_page.dart';
import 'theme.dart';
import 'routes.dart' as routing;
import 'mock_auth_service.dart' as auth;

final GlobalKey<NavigatorState> _navKey = new GlobalKey<NavigatorState>();

void main() {
  //TODO fill these out for your app
  var appInfo = new AppInfo(
      appName: 'Flutter Auth Starter',
      appVersion: "0.0.1",
      appIconPath: "assets/icons/appIcon.jpg",
      avatarDefaultAppIconPath: "assets/icons/profileIcon.png",
      applicationLegalese: '',
      privacyPolicyUrl: "http://yourPrivacyPolicyUrl",
      termsOfServiceUrl: "http://yourTermsOfServiceUrl");

  var authService = auth.createMockedAuthService();

  var app = ScopedModel<AppModel>(
      model: AppModel(appInfo: appInfo, authService: authService),
      child: MaterialApp(
          title: appInfo.appName,
          navigatorKey: _navKey,
          debugShowCheckedModeBanner: false,
          theme: theme(),
          home: Splash(),
          routes: routing.buildRoutes(authService),
          onGenerateRoute: routing.buildGenerator()));

  //This is so that we can route to the splash screen when the user state changes and is signed out
  //If the user has changed and is signed in route to the home page
  authService.authUserChanged.addListener(() {
    app.model.refreshAuthUser().then((model) {
      if (model.hasChanged) {
        if (model.isValidUser) {
          _navKey.currentState.pushNamedAndRemoveUntil('/home', (_) => false);
        } else {
          _navKey.currentState.pushNamedAndRemoveUntil('/', (_) => false);
        }
      }
    });
  });

  runApp(app);
}
