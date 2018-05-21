import 'dart:async';

import 'package:flutter/material.dart';

import 'future_action_callback.dart';

//typedef Future FutureContextCallback(BuildContext context);

abstract class Actionable {
  Future performAction(FutureActionCallback<BuildContext> action);
}
