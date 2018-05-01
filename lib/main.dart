import 'package:flutter/material.dart';
import 'package:flutter_auth_base/flutter_auth_base.dart';
import 'package:scoped_model/scoped_model.dart';
import 'core/app_model.dart';
import 'core/app_info.dart';
import 'core/pages/splash_page.dart';
import 'theme.dart';
import 'routes.dart' as routing;
import 'mockAuthService.dart' as auth;
import 'core/auth/handlers/email/signInButton.dart' as email;
import 'core/auth/handlers/email/signUpButton.dart' as email;
import 'core/auth/handlers/google/signInButton.dart' as google;
import 'core/common/widgetProviderBuilder.dart';

final GlobalKey<NavigatorState> _navKey = new GlobalKey<NavigatorState>();

void main() {
  //TODO fill these out for your app
  var appInfo = new AppInfo(
      appName: 'Flutter Auth Starter',
      appVersion: "0.0.1",
      appIconPath: "assets/icons/appIcon.jpg",
      avatarDefaultAppIconPath: "assets/icons/transparent.png",
      applicationLegalese: '',
      privacyPolicyUrl: "http://yourPrivacyPolicyUrl",
      termsOfServiceUrl: "http://yourTermsOfServiceUrl");

  var authService = auth.createMockedAuthService();

  //Each provider may want to handle signin and sign up differently
  // which may be navigation to another page, popup, or no UI at all
  var signInButtons = new Map<String, WidgetBuilder>();
  addForProvider(signInButtons, authService.authProviders, "password",
      (BuildContext context, AuthProvider prov) => new email.SignInButton());
  addForProvider(
      signInButtons,
      authService.authProviders,
      "google",
      (BuildContext context, AuthProvider prov) =>
          new google.SignInButton(provider: prov));

  var signUpButtons = new Map<String, WidgetBuilder>();
  addForProvider(signUpButtons, authService.authProviders, "password",
      (BuildContext context, AuthProvider prov) => new email.SignUpButton());

  var app = ScopedModel<AppModel>(
      model: AppModel(appInfo: appInfo, authService: authService),
      child: MaterialApp(
          title: appInfo.appName,
          navigatorKey: _navKey,
          debugShowCheckedModeBanner: false,
          theme: theme(),
          home: Splash(
              signInButtonBuilders: signInButtons,
              signUpButtonBuilders: signUpButtons),
          routes: routing.buildRoutes(authService),
          onGenerateRoute: routing.buildGenerator()));

  runApp(app);
}

void addForProvider(
    Map<String, WidgetBuilder> buttons,
    List<AuthProvider> providers,
    String providerName,
    WidgetProviderBuilder builder) {
  for (var prov in providers) {
    if (prov.providerName == providerName) {
      var localProvider = prov;
      buttons[providerName] =
          (BuildContext context) => builder(context, localProvider);
    }
  }
}
