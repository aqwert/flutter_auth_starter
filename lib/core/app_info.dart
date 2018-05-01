import 'package:meta/meta.dart';

class AppInfo {
  AppInfo(
      {@required this.appName,
      @required this.appVersion,
      @required this.appIconPath,
      @required this.avatarDefaultAppIconPath,
      this.termsOfServiceUrl,
      this.privacyPolicyUrl,
      this.applicationLegalese = ''});

  final String appName;
  final String appVersion;
  final String applicationLegalese;

  final String privacyPolicyUrl;
  final String termsOfServiceUrl;

  final String appIconPath;
  final String avatarDefaultAppIconPath;
}
