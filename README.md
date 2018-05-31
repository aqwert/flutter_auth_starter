# flutter_auth_starter

This auth starter project for flutter simplifies the addition of signing in and up of the user with the application. You could add full (albiet mocked) authentication flow within your flutter app within minutes.

This is an opinionated view of authentication within a flutter app. Specific use cases may not be covered or different to what is expected.

**[Screenshots](./SCREENSHOTS.md)**

## Features

* Pages
    * Splash page
    * Sign in with email and password
    * Sign up with email and password
    * Forgotten Password
    * Social Auth sign in (Google)
    * Terms to accept Privay Policy and Terms of Service
    * Drawer and Profile page with following
        * Displaying a message for Email not being verified
        * Terms of Service
        * About (displays app version, name and link to look at package licences)
        * Change of user display name
        * Change of user email address
        * Change of uer password
        * Connecting mulitple accounts (i.e. link google sign in with your email and password)
        * Closing the account
        * Logout
        
* Functionality
    * Incorporated platform aware widgets from [flutter_platform_widgets](https://github.com/aqwert/flutter_platform_widgets)
        * Display either a material design or cupertino design based on the platform target. 
        * Available the Drawer in Material (for android) and a Profile Page (slidein for iOS)
    * Pluggable authentication provider model (uses [flutter_auth_base](https://github.com/aqwert/flutter_auth_base))
        * Built-in Mock provider 
        * External provider for Firebase Auth: [flutter_auth_firebase](https://github.com/aqwert/flutter_auth_firebase) integration 
    * Gravatar image provider to display the gravatar image of the user when signing in/up and for display on the Drawer and Profile page
    * Basic form validation for email, password, name inputs
    * Tablet aware screens. See section at the bottom on how this is done.
        * Landscape vs Portrait
            * If the screen width is greater then 660 px then the splash, signin and sign up pages will change to a 2 column layout.
        * Modal Dialogs
            * For pages such as `ForgotPassword` the page will either be a full sized modal dialog for smaller screens, or a dialog with margin having a semi transpaetrnt border rendering the page underneath it.

## Known Issues or Outstanding work

- [ ] Currently only material light theme is supported. 
- [ ] Incorporate Twitter, Github social auth
- [ ] Anonymous (Guest mode) sign in
- [ ] Sign in with Email link
- [ ] Extending Drawer and Profile list.
- [ ] Ability to change avatar image
- [ ] Biometric login (Fingerprint / Retina)

## Get Started

There are a number of ways to get started.

 > In my opinion it may be better to first fork into your own repository as a "copy", then use the pubspec reference method into your real project. This will give you the control of merging any changes back into your fork but also treating the package as a module into the application.

### Fork

Simply fork the entire repository.
* Pros: 
    * Quick 
    * Will be able to customise any of the code
    * And check the changes back in for you own purposes
    * Could more easily merge changes back into your fork
* Cons: 
    * Linked back to this project which may be undesirable.
    * Will pull in more than you require.
    * Will need to change the name of the project.
    * You will have the source code in your project which may add unnecessary noise
        * Unless you use the pubspec method mentioned below
    
### Copy the code

If you clone or fork the code first, then you could simply copy the `core` folder into your project

* Pros:
    * You take what you need.
    * Can customise the code.
    * You can place the code anywhere.
    * Any changes to this repo won't get into your project automatically
* Cons:
    * Any updates from this repo will be a manual task.
    * You will have the source code in your project which may add unnecessary noise
    
### Link via pubspec.yaml

To treat this like any other package you can reference the git repository directly

```yml
  flutter_auth_starter: 
    git:
      url: https://github.com/aqwert/flutter_auth_starter.git
````

* Pros:
    * Not pulling in the code into your project
    * Quickest way to get started.
    
* Cons: 
    * Cannot modify any of the code from within your project. You get what you get
    * Any updates from this repo may be undesirable, or may break your application 

## Dependencies

Once your own custom project is created, at a minimum the following should be included in the `pubspec.yaml` file:

```yml
<snip>
dependencies:
  <snip>

  scoped_model: "^0.2.0"
  async_loader: "^0.1.1"
  font_awesome_flutter: 6.0.0
  url_launcher: "^3.0.0"

  flutter_auth_base: "^0.1.5"
  flutter_platform_widgets: "^0.2.0"
  flutter_auth_starter: 
    git:
      url: https://github.com/aqwert/flutter_auth_starter.git

<snip>
```

 > Note that the versions may be higher than listed.
 > See 'Getting Started' above if the package  `flutter_auth_starter` is to be included this way.

## Setup

An example of the setup can be found inside [main.dart](https://github.com/aqwert/flutter_auth_starter/blob/master/lib/main.dart)

This has the following:

### Configure AppInfo

AppInfo is just a bunch of information relating to what the app is:

```dart
var appInfo = new AppInfo(
      appName: 'Flutter Auth Starter',
      appVersion: "0.0.1",
      appIconPath: "assets/icons/appIcon.jpg",
      avatarDefaultAppIconPath: "assets/icons/profileIcon.png",
      applicationLegalese: '',
      privacyPolicyUrl: "http://yourPrivacyPolicyUrl",
      termsOfServiceUrl: "http://yourTermsOfServiceUrl");
```

**appName**

Used mainly for the About and Licence page to display the application name. This could be different to the app name set as the app title within the `MaterialApp`.

**appVersion**

Version displayed on the About and Licence page.

**appIconPath**

The path to the default application icon that your application should set. (Be sure to set the path to the file in the assets section of the pubspec.yaml file).

**avatarDefaultAppIconPath**

The icon used when there is no icon/profile image for the user when viewing the Drawer or Profile page. If using the [GravatarProvider](https://github.com/aqwert/flutter_auth_starter/blob/master/lib/core/imageProviders/gravatar_provider.dart) you would probably never see  this default image since the gravatar provider has a fallback image.

**applicationLegalese**

Optional legal text displayed on the About page. 

**privacyPolicyUrl**

The external url that links to your application's privacy policy. Accessed from the Terms of Use page and the Drawer / Profile page.

**termsOfServiceUrl**

The external url that links to your applications terms of service. Accessed from the Terms of Use page and the Drawer / Profile page.

### Configure the AuthService

 > Note there is a [Firebase](https://github.com/aqwert/flutter_auth_firebase) implementation which can be used.

Out of the box this starter has mocked instances to get started.

`var authService = auth.createMockedAuthService();`

Where createMockedAuthService can be defined as

```dart
import 'package:flutter_auth_base/flutter_auth_base.dart';
import 'core/auth/mock/mock_service.dart';

import 'core/imageProviders/combined_image_provider.dart';
import 'core/imageProviders/gravatar_provider.dart';
import 'core/imageProviders/user_photo_url_provider.dart';

AuthService createMockedAuthService() {
  var authService = new MockService();
  authService.preAuthPhotoProvider = new GravatarProvider();
  authService.postAuthPhotoProvider = new CombinedPhotoProvider()
    ..add(new AuthUserImageProvider(service: authService))
    ..add(new GravatarProvider(missingImageType: ImageType.MysteryMan));

  return authService;
}
```
This sets the mock service with email and google signin providers (mocked of course) and uses The `AuthUserImageProvider` which will attempt to download the photoUrl returned for the user. `GravatarProvider` will check http://gravatar.com/ with the entered email address to pull down an image, or use the `MysteryMan` if one does not exist.


### Configure the ScopedModel\<AppModel>

This starter uses [ScopedModel](https://pub.dartlang.org/packages/scoped_model) for holding the state of the user authentication, plus providing access to the authentication service. The use of `ScopedModel` should not interfere with the use of any other state management packages (such as [Flutter Redux](https://pub.dartlang.org/packages/flutter_redux)) or [Inhertited Widgets](https://docs.flutter.io/flutter/widgets/InheritedWidget-class.html).

The `ScopedModel` wraps the main application widget `MaterialApp` so that it can be accessed by the routed pages.

```dart
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
```

**AppModel**

This is the main application model that holds authentication information such as the state of the currect user, notify of any changes to the user whether they login or logout and access to the main authentication service

**home**

This should always be `Splash` (core/pages/splash_page.dart) as it handles the routing of the user to either signin/up if there is no authenticated user, or to the home page (defined in the routes) if the user is authenticated.

**routes**

At a bare minimum the only route that needs to defined is the home page (the first page navigated to after signin). All other routing within the starter pages are routed directly using `MaterialPageRoute`. It maybe possible to swap to using [fluro](https://pub.dartlang.org/packages/fluro) as the routing manager (not tested).

Example: [routes.dart](https://github.com/aqwert/flutter_auth_starter/blob/master/lib/routes.dart).

```dart
Map<String, WidgetBuilder> buildRoutes(AuthService authService) {
  var routes = new Map<String, WidgetBuilder>();

  routes['/home'] = (BuildContext context) => new HomePage();

  return routes;
}
```

 > Remember to set the HomePage to your own specific home page.
 
 ### Configure the Authentication Listener
 
 In order to route to the `Splash` page when the user logs out or to route to the `HomePage` when the user is succesasfully authenticated, a listener needs to be placed on the `AppModel`.
 
 ```dart
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
 ```
 
 ## Configure the App
 
 Simply: `runApp(app);` at the end
 
# Screen Aware sizing

This starter project also has helper functions to render to a mobile or tablet layout.

## Mobile or Tablet layout

For mobile, it is desireable in portrait mode to render a single column. When the device has a certain width (either when viewing in Portrait mode or on a tablet) it should show a 2 column layout.

**Example**

Looking at the [Splash page ](https://github.com/aqwert/flutter_auth_starter/blob/master/lib/core/pages/splash_page.dart) the layout will change from a single column to a double column

```dart
 @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (_, child, model) {
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
```

The `TabletAwareScaffold` will render the mobileView if the screen width is under 660, otherwise it will render the tabletView. Of course it is up to the implmentation of these `WidgetBuilders` to return the appropriate view (i.e. 1 column vs 2 column layout).

## Modal Dialogs.

Instead of using the `showDialog` directly there is a [utility wrapper](https://github.com/aqwert/flutter_auth_starter/blob/master/lib/core/common/dialog.dart) that will either:

* Push a MaterialPageRoute with fullScreenDialog set to true, or
* Use showDialog to 'popup' a dialog with a margin

**Example**

Looking at the [Sign in page](https://github.com/aqwert/flutter_auth_starter/blob/master/lib/core/auth/handlers/email/signIn/sign_in_page.dart) it will [display a modal dialog](https://github.com/aqwert/flutter_auth_starter/blob/cf1dad801d9a7dfd8877497a462927a972525866/lib/core/auth/handlers/email/signIn/sign_in_page.dart#L144) for the forgotten passowrd page.

```dart
Widget _forgotPasswordButton(AuthService authService) {
    return authService.options.canSendForgotEmail
        ? Padding(
            padding: const EdgeInsets.only(
                bottom: 16.0, top: 16.0, left: 32.0, right: 32.0),
            child: PlatformButton(
                child: Text('Forgot password'),
                onPressed: super.showProgress
                    ? null
                    : () async => await openDialog(
                        context: context, builder: (_) => ForgotPassword())))
        : Container();
  }
```

Note the `await openDialog(...)` call.

# Issues and Feedback

Please [create](https://github.com/aqwert/flutter_auth_starter/issues/new) an issue to provide feedback or an issue.

![alt text](https://user-images.githubusercontent.com/4413519/40525703-d70be7f6-6035-11e8-9e9d-29c59b955fe7.PNG "Logo")


