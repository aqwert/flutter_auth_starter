import 'package:flutter_auth_base/flutter_auth_base.dart';

import 'mock_userAccount.dart';

class MockUser extends AuthUser {
  @override
  String displayName = "Mocked";

  @override
  String email;

  @override
  bool isEmailVerified = false;

  @override
  bool get isValid => email != null;

  @override
  String get uid => 'mockedid';

  @override
  String photoUrl;

  @override
  List<AuthUserAccount> providerAccounts = new List<AuthUserAccount>()
    ..add(new MockUserPasswordAccount());
}
