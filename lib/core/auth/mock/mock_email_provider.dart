import 'dart:async';
import 'package:flutter_auth_base/flutter_auth_base.dart';

import 'mock_user.dart';
import 'mock_user_account.dart';

class MockEmailProvider extends AuthProvider implements LinkableProvider {
  MockEmailProvider(this.service);

  AuthService service;

  @override
  String get providerName => 'password';

  @override
  String get providerDisplayName => "Email with Password";

  @override
  Future<AuthUser> create(Map<String, String> args) async {
    var user = new MockUser()
      ..email = args['email']
      ..displayName = 'Mocked';

    await new Future.delayed(const Duration(milliseconds: 1000), () => {});

    service.authUserChanged.value = user;
    return user;
  }

  @override
  Future<AuthUser> signIn(Map<String, String> args) async {
    var user = new MockUser()
      ..email = args['email']
      ..displayName = 'Mocked';

    await new Future.delayed(const Duration(milliseconds: 1000), () => {});

    service.authUserChanged.value = user;
    return user;
  }

  @override
  Future<AuthUser> sendPasswordReset(Map<String, String> args) async {
    await new Future.delayed(const Duration(milliseconds: 1000), () => {});

    return service.authUserChanged.value;
  }

  @override
  Future<AuthUser> changePassword(Map<String, String> args) async {
    await new Future.delayed(const Duration(milliseconds: 1000), () => {});

    return service.authUserChanged.value;
  }

  @override
  Future<AuthUser> changePrimaryIdentifier(Map<String, String> args) async {
    var currentUser = service.authUserChanged.value;

    await new Future.delayed(const Duration(milliseconds: 1000), () => {});

    return service.authUserChanged.value = new MockUser()
      ..email = args['email']
      ..displayName = currentUser.displayName
      ..photoUrl = currentUser.photoUrl
      ..isEmailVerified =
          false //pretend that changing email also requires validation
      ..providerAccounts =
          new List<AuthUserAccount>.from(currentUser.providerAccounts);
  }

  @override
  Future<AuthUser> sendVerification(Map<String, String> args) async {
    var currentUser = service.authUserChanged.value;

    await new Future.delayed(const Duration(milliseconds: 1000), () => {});

    return service.authUserChanged.value = new MockUser()
      ..email = currentUser.email
      ..displayName = currentUser.displayName
      ..photoUrl = currentUser.photoUrl
      ..isEmailVerified = true
      ..providerAccounts =
          new List<AuthUserAccount>.from(currentUser.providerAccounts);
  }

  @override
  Future<AuthUser> linkAccount(Map<String, String> args) async {
    var currentUser = service.authUserChanged.value;

    await new Future.delayed(const Duration(milliseconds: 1000), () => {});

    var providers =
        new List<AuthUserAccount>.from(currentUser.providerAccounts);
    providers.add(new MockUserPasswordAccount());

    service.authUserChanged.value = new MockUser()
      ..email = currentUser.email
      ..displayName = currentUser.displayName
      ..photoUrl = currentUser.photoUrl
      ..isEmailVerified = true
      ..providerAccounts = providers;
    return service.authUserChanged.value;
  }
}
