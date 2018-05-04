import 'dart:async';
import 'dart:io';

import 'package:flutter_auth_base/flutter_auth_base.dart';
import '../common/md5.dart';

enum ImageType {
  None,
  MysteryMan,
  Identicon,
  MonsterId,
  Wavatar,
  Retro,
  Robohash,
  Error
}

class GravatarProvider extends PhotoUrlProvider {
  GravatarProvider({this.missingImageType = ImageType.None});

  final ImageType missingImageType;

  @override
  Future<PhotoUrlInfo> emailToPhotoUrl(String email,
      {int size = 100, bool checkIfImageExists = false}) async {
    if (email != null) {
      var hash = md5(email.trim().toLowerCase());

      if (checkIfImageExists) {
        //we use http error code 404 to get the http response
        var url =
            'https://www.gravatar.com/avatar/$hash?d=404&s=${size.toString()}&r=g';
        var hasImage = await _haveValidImage(url);
        if (hasImage) {
          return new PhotoUrlInfo(url: url);
        } else {
          return new PhotoUrlInfo();
        }
      } else {
        var url;
        switch (missingImageType) {
          case ImageType.None:
            url =
                'https://www.gravatar.com/avatar/$hash?s=${size.toString()}&r=g&d=blank';
            break;
          case ImageType.MysteryMan:
            url =
                'https://www.gravatar.com/avatar/$hash?s=${size.toString()}&r=g&d=mm';
            break;
          case ImageType.Identicon:
            url =
                'https://www.gravatar.com/avatar/$hash?s=${size.toString()}&r=g&d=identicon';
            break;
          case ImageType.MonsterId:
            url =
                'https://www.gravatar.com/avatar/$hash?s=${size.toString()}&r=g&d=monsterid';
            break;
          case ImageType.Wavatar:
            url =
                'https://www.gravatar.com/avatar/$hash?s=${size.toString()}&r=g&d=wavatar';
            break;
          case ImageType.Retro:
            url =
                'https://www.gravatar.com/avatar/$hash?s=${size.toString()}&r=g&d=retro';
            break;
          case ImageType.Robohash:
            url =
                'https://www.gravatar.com/avatar/$hash?s=${size.toString()}&r=g&d=robohash';
            break;
          case ImageType.Error:
            url =
                'https://www.gravatar.com/avatar/$hash?s=${size.toString()}&r=g&d=404';
            break;
        }

        return new PhotoUrlInfo(url: url);
      }
    }
    return new PhotoUrlInfo();
  }

  Future<bool> _haveValidImage(String url) async {
    var httpClient = new HttpClient();
    try {
      var req = await httpClient.getUrl(Uri.parse(url));

      var resp = await req.close();

      return resp.statusCode == HttpStatus.OK;
    } finally {
      httpClient.close();
    }
  }
}
