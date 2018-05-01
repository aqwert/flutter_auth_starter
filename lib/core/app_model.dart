import 'dart:async';

import 'package:flutter_auth_base/flutter_auth_base.dart';
import 'package:meta/meta.dart';
import 'package:scoped_model/scoped_model.dart';

import 'app_info.dart';

class AppModel extends Model {
  AppModel({@required this.authService, @required this.appInfo});

  AuthUser _user;
  String _authToken;

  AuthUser get user => _user;
  String get token => _authToken;

  final AppInfo appInfo;
  final AuthService authService;

  Future<AppModel> refreshAuthUser() async {
    _user = await authService.currentUser();
    _authToken = await authService.currentUserToken();

    notifyListeners();

    return this;
  }
}
