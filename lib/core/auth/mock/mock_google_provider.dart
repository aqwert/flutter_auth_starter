import 'package:flutter_auth_base/flutter_auth_base.dart';
import 'dart:async';

import 'mock_user.dart';
import 'mock_user_account.dart';

class MockGoogleProvider extends AuthProvider with LinkableProvider {
  MockGoogleProvider(this.service);

  AuthService service;

  @override
  String get providerName => 'google';

  @override
  String get providerDisplayName => "Google";

  @override
  Future<AuthUser> linkAccount(Map<String, String> args) async {
    var currentUser = service.authUserChanged.value;

    await new Future.delayed(const Duration(milliseconds: 1000), () => {});

    var providers =
        new List<AuthUserAccount>.from(currentUser.providerAccounts);
    providers.add(new MockUserGoogleAccount());

    service.authUserChanged.value = new MockUser()
      ..email = currentUser.email
      ..displayName = currentUser.displayName
      ..photoUrl = currentUser.photoUrl
      ..isEmailVerified = true
      ..providerAccounts = providers;
    return service.authUserChanged.value;
  }

  @override
  Future<AuthUser> signIn(Map<String, String> args) async {
    await new Future.delayed(const Duration(milliseconds: 2000), () => {});

    print('******** Google sign in ********');
    var google = new MockUserGoogleAccount();
    var providers = new List<AuthUserAccount>()..add(google);

    return service.authUserChanged.value = new MockUser()
      ..email = google.email
      ..displayName = google.displayName
      ..photoUrl = google.photoUrl
      ..isEmailVerified = true
      ..providerAccounts = providers;
  }

  @override
  Future<AuthUser> changePassword(Map<String, String> args) async {
    throw new UnsupportedError('Cannot change Google password ');
  }

  @override
  Future<AuthUser> changePrimaryIdentifier(Map<String, String> args) async {
    throw new UnsupportedError('Cannot change Google email ');
  }

  @override
  Future<AuthUser> create(Map<String, String> args) async {
    throw new UnsupportedError('Cannot create Google password ');
  }

  @override
  Future<AuthUser> sendPasswordReset(Map<String, String> args) async {
    throw new UnsupportedError('Cannot reset Google password ');
  }

  @override
  Future<AuthUser> sendVerification(Map<String, String> args) async {
    throw new UnsupportedError('Cannot send Google verification email ');
  }
}
