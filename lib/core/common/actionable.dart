import 'dart:async';

import 'package:flutter/material.dart';

typedef Future FutureContextCallback(BuildContext context);

abstract class Actionable {
  Future performAction(FutureContextCallback action);
}
