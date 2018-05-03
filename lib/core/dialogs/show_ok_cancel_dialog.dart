import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

Future<Null> showOkCancelDialog(onOk, onCancel,
    {@required String message,
    @required String caption,
    @required BuildContext context}) async {
  return showDialog<Null>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(caption),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('CANCEL'),
            onPressed: () => onCancel(),
          ),
          FlatButton(child: Text('OK'), onPressed: () => onOk()),
        ],
      );
    },
  );
}
