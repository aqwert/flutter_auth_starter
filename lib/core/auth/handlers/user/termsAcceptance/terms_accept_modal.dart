import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_auth_base/flutter_auth_base.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../dialogs/show_error_dialog.dart';
import '../../../../widgets/email_image_circle_avatar.dart';
import '../../../../widgets/modalAppBar.dart';
import '../../../../app_model.dart';
import '../../../../app_info.dart';

class TermsAcceptModal extends StatefulWidget {
  @override
  createState() => new TermsAcceptModalState();
}

class TermsAcceptModalState extends State<TermsAcceptModal> {
  @override
  void initState() {
    super.initState();
  }

  bool termsAccepted = false;
  final avatarKey = GlobalKey<EmailImageCircleAvatarState>();

  Future _launchURL(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (error) {
      showErrorDialog(context, 'An error occured opening that link');
    }
  }

  Widget _logoGravatar(AppInfo appInfo, AuthService authService) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: EmailImageCircleAvatar(
          checkIfImageExists: true,
          key: avatarKey,
          imageSize: 150,
          backgroundColor: Colors.white70,
          defaultImage: AssetImage(appInfo.appIconPath),
          imageProvider: authService.preAuthPhotoProvider),
    );
  }

  Widget _termsAcceptance(AppInfo appInfo) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Checkbox(
              value: termsAccepted,
              onChanged: (val) => setState(() {
                    termsAccepted = val;
                  })),
          Expanded(
            child: Text('By checking this box you agree to the following:'),
          ),
        ],
      ),
    );
  }

  Widget _termsButtons(AppInfo appInfo) {
    return Column(
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.all(8.0),
          child: PlatformButton(
            child: Text('Terms of Service'),
            onPressed: () async => await _launchURL(appInfo.termsOfServiceUrl),
          ),
        ),
        new Padding(
          padding: const EdgeInsets.all(8.0),
          child: PlatformButton(
            child: Text('Privacy Policy'),
            onPressed: () async => await _launchURL(appInfo.privacyPolicyUrl),
          ),
        ),
      ],
    );
  }

  void _accept() {
    if (!termsAccepted) {
      showErrorDialog(context, 'You need to agree first.');
    } else {
      Navigator.maybePop(context, termsAccepted);
    }
  }

  Widget _buildPage(AppInfo appInfo, AuthService authService) {
    return Center(
      child: Column(
        children: <Widget>[
          _logoGravatar(appInfo, authService),
          _termsAcceptance(appInfo),
          _termsButtons(appInfo),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: ModalAppBar(
        title: Text('T & C'),
        closeAction: () => Navigator.maybePop(context, false),
        acceptText: 'Accept',
        acceptAction: () => _accept(),
        android: (_) => MaterialAppBarData(
              actions: [
                FlatButton(
                  child: Text(
                    'I Accept',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            Theme.of(context).primaryTextTheme.headline.color),
                  ),
                  onPressed: () => _accept(),
                )
              ],
            ),
      ),
      body: Material(
        color: isMaterial ? null : Theme.of(context).cardColor,
        child: ScopedModelDescendant<AppModel>(
          rebuildOnChange: false,
          builder: (_, child, model) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildPage(model.appInfo, model.authService)),
        ),
      ),
    );
  }
}
