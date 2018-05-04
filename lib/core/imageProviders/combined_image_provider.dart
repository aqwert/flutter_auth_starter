import 'dart:async';

import 'package:flutter_auth_base/flutter_auth_base.dart';

class CombinedPhotoProvider extends PhotoUrlProvider {
  List<PhotoUrlProvider> _providers = new List<PhotoUrlProvider>();

  void add(PhotoUrlProvider provider) {
    _providers.add(provider);
  }

  @override
  Future<PhotoUrlInfo> emailToPhotoUrl(String email,
      {int size: 100, bool checkIfImageExists}) async {
    for (var prov in _providers) {
      try {
        var info = await prov.emailToPhotoUrl(email,
            size: size, checkIfImageExists: checkIfImageExists);

        if (info.isValid) {
          return info;
        }
      } catch (error) {
        //dont let exceptions destory a chance to get te image from another provider
      }
    }

    return new PhotoUrlInfo();
  }
}
