import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_auth_base/flutter_auth_base.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../widgets/progress_actionable_state.dart';

import '../email/signIn/sign_in_page.dart';
import '../email/sign_in_button.dart' as email;
import '../google/sign_in_button.dart' as google;

class SignInPicker extends StatefulWidget {
  SignInPicker({this.authProviders});

  final List<AuthProvider> authProviders;

  @override
  createState() => new SignInPickerState();
}

class SignInPickerState extends ProgressActionableState<SignInPicker> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var buttons =
        widget.authProviders.map((prov) => _getProviderButton(prov)).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        super.showProgress
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: PlatformCircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: ListBody(
                  children: buttons,
                ),
              ),
      ],
    );
  }

  Widget _getProviderButton(AuthProvider prov) {
    if (prov.providerName == 'google') {
      return new Padding(
        padding: const EdgeInsets.all(8.0),
        child: google.SignInButton(action: (_) async {
          await performAction((BuildContext context) async {
            await prov.signIn({});
            Navigator.pop(context);
          });
        }),
      );
    } else if (prov.providerName == 'password') {
      return new Padding(
        padding: const EdgeInsets.all(8.0),
        child: email.SignInButton(action: (context) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SignInPassword(
                  popRouteOnSignin: true, displaySignInButton: false),
            ),
          );
          return null;
        }),
      );
    } else {
      return Container();
    }
  }
}
