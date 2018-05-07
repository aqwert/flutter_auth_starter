import 'package:flutter/material.dart';

import 'package:meta/meta.dart';

import '../../../../common/actionable.dart';
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
  final FutureContextCallback linkAction;

  @override
  createState() => new LinkCardState();
}

class LinkCardState extends ProgressActionableState<LinkCard> {
  @override
  void initState() {
    super.initState();
  }

  // @override
  // Future<Null> doSubmit({options}) async {
  //   var action = linkActions[widget.providerName];
  //   if (action != null) {
  //     await action(context, widget.linkableProvider);
  //   }
  // }

  // Future doLink(BuildContext context) async {
  //   await widget.linkableProvider.linkAccount({});
  // }

  bool isEmpty(String str) {
    return str == null || str.length == 0;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: EdgeInsets.all(0.0),
      child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
        ListTile(
          leading: Icon(widget.icon),
          title: isEmpty(widget.title) ? null : Text(widget.title),
          subtitle: isEmpty(widget.subTitle) ? null : Text(widget.subTitle),
          trailing: super.showProgress
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                )
              : null,
        ),
        ButtonTheme.bar(
            child: ButtonBar(
          children: <Widget>[
            FlatButton(
                child: Text((super.showProgress ? 'ADDING' : 'ADD')),
                onPressed: super.showProgress
                    ? null
                    : () async {
                        await super.performAction(widget.linkAction);
                      }),
          ],
        ))
      ]),
    ));
  }
}
