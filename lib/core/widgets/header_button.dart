import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:meta/meta.dart';

class HeaderButton extends StatelessWidget {
  HeaderButton({@required this.text, this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return PlatformWidget(
      android: (_) => FlatButton(
            onPressed: onPressed,
            child: Text(
              text,
              style: TextStyle(
                  color: Theme.of(context).primaryTextTheme.title.color),
            ),
          ),
      ios: (_) => PlatformButton(
            onPressed: onPressed,
            child: Text(
              text,
              style: Theme
                  .of(context)
                  .textTheme
                  .body1
                  .copyWith(color: theme.primaryColor),
            ),
          ),
    );
  }
}
