import 'dart:async';

import 'package:flutter_auth_base/flutter_auth_base.dart';
import 'package:meta/meta.dart';
import 'package:scoped_model/scoped_model.dart';

import 'app_info.dart';

class AuthUserState {
  AuthUserState({this.user, this.hasChanged});

  final AuthUser user;
  final bool hasChanged;
  bool get isValidUser => user != null && user.isValid;
}

class AppModel extends Model {
  AppModel({@required this.authService, @required this.appInfo});

  AuthUser _user;
  String _authToken;

  AuthUser get user => _user;
  String get token => _authToken;

  final AppInfo appInfo;
  final AuthService authService;

  Future<AuthUserState> refreshAuthUser() async {
    var prevUser = _user;

    _user = await authService.currentUser();
    _authToken = await authService.currentUserToken();

    bool changed = false;
    if (prevUser == null) {
      if (_user != null) {
        changed = true;
      }
    } else {
      if (_user != null) {
        if (prevUser.isValid != _user.isValid) {
          changed = true;
        } else {
          if (prevUser.uid != _user.uid) {
            changed = true;
          }
        }
      } else {
        changed = true;
      }
    }

    notifyListeners();

    return new AuthUserState(user: _user, hasChanged: changed);
  }
}
