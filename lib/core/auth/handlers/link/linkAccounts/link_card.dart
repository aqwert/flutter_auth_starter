import 'package:flutter/material.dart';

import 'package:meta/meta.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../../common/future_action_callback.dart';
import '../../../../widgets/progress_actionable_state.dart';

class LinkCard extends StatefulWidget {
  LinkCard(
      {@required this.linkAction,
      @required this.icon,
      @required this.title,
      this.subTitle});

  final IconData icon;
  final String title;
  final String subTitle;
  final FutureActionCallback<BuildContext> linkAction;

  @override
  createState() => new LinkCardState();
}

class LinkCardState extends ProgressActionableState<LinkCard> {
  @override
  void initState() {
    super.initState();
  }

  bool isEmpty(String str) {
    return str == null || str.length == 0;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(widget.icon),
          title: isEmpty(widget.title)
              ? null
              : Text(widget.title, style: theme.textTheme.body1),
          subtitle: isEmpty(widget.subTitle)
              ? null
              : Text(widget.subTitle, style: theme.textTheme.caption),
          trailing: super.showProgress
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PlatformCircularProgressIndicator(),
                )
              : PlatformButton(
                  onPressed: super.showProgress
                      ? null
                      : () async {
                          await super.performAction(widget.linkAction);
                        },
                  child: Text('Connect'),
                ),
        ),
        Divider(),
      ],
    );
  }
}
