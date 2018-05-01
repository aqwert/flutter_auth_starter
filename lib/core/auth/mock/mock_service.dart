import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_auth_base/flutter_auth_base.dart';

import 'mock_user.dart';
import 'mock_email_provider.dart';
import 'mock_google_provider.dart';

class MockService extends AuthService {
  MockService() {
    var email = new MockEmailProvider(this);
    var google = new MockGoogleProvider(this);
    authProviders.add(email);
    authProviders.add(google);
    linkProviders.add(email);
    linkProviders.add(google);
  }

  @override
  AuthOptions options = new AuthOptions();

  final ValueNotifier<AuthUser> _authChangeNotifier =
      new ValueNotifier<AuthUser>(
          new MockUser()); //..email = 'mocked@mocked.com');

  @override
  ValueNotifier<AuthUser> get authUserChanged => _authChangeNotifier;

  @override
  List<AuthProvider> authProviders = new List<AuthProvider>();

  @override
  List<LinkableProvider> linkProviders = new List<LinkableProvider>();

  @override
  PhotoUrlProvider preAuthPhotoProvider;

  @override
  PhotoUrlProvider postAuthPhotoProvider;

  @override
  Future<AuthUser> currentUser() async {
    return _authChangeNotifier.value;
  }

  @override
  Future<String> currentUserToken() async {
    if (_authChangeNotifier.value.isValid) {
      return _authChangeNotifier.value.email;
    }
    return null;
  }

  @override
  Future<AuthUser> setUserDisplayName(String name) async {
    var user = _authChangeNotifier.value;
    var newUser = new MockUser()
      ..displayName = name
      ..email = user.email
      ..isEmailVerified = user.isEmailVerified
      ..photoUrl = user.photoUrl
      ..providerAccounts =
          new List<AuthUserAccount>.from(user.providerAccounts);

    return _authChangeNotifier.value = newUser;
  }

  @override
  Future<void> signOut() async {
    _authChangeNotifier.value = new MockUser()..email = null;
  }

  @override
  Future<void> closeAccount(Map<String, String> reauthenticationArgs) async {
    _authChangeNotifier.value = new MockUser()..email = null;
  }
}
