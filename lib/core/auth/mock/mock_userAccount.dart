import 'package:flutter_auth_base/flutter_auth_base.dart';

class MockUserPasswordAccount extends AuthUserAccount {
  @override
  String get displayName => 'Mocked Name';

  @override
  String get email => 'some@some.com';

  @override
  String get providerName => 'password';

  @override
  String get photoUrl => null;
}

class MockUserGoogleAccount extends AuthUserAccount {
  MockUserGoogleAccount()
      : super(
            canChangeDisplayName: false,
            canChangeEmail: false,
            canChangePassword: false);

  @override
  String get displayName => 'Mocked Google Name';

  @override
  String get email => 'some@gmail.com';

  @override
  String get providerName => 'google';

  @override
  String get photoUrl => null;
}
