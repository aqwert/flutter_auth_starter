import 'package:flutter_auth_base/flutter_auth_base.dart';
import 'package:meta/meta.dart';
import 'dart:async';

class AuthUserImageProvider extends PhotoUrlProvider {
  AuthUserImageProvider({@required this.service});

  final AuthService service;

  @override
  Future<PhotoUrlInfo> emailToPhotoUrl(String email,
      {int size: 100, bool checkIfImageExists}) async {
    var user = await service.currentUser();

    if (user != null) {
      return new PhotoUrlInfo(url: user.photoUrl);
    }
    return new PhotoUrlInfo();
  }
}
