import 'package:flutter/material.dart';

abstract class ProgressableState<T extends StatefulWidget> extends State<T> {
  bool showProgress = false;
  void setProgress(bool value) {
    if (mounted) {
      setState(() {
        showProgress = value;
      });
    }
  }
}
