import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import '../common/throttle.dart';

//typedef void StringCallback(String value);

class ThrottledTextEditingController extends TextEditingController {
  ThrottledTextEditingController(
      {@required ValueCallback onUpdate,
      int throttleDurationMilliseconds = 1000}) {
    _textThrottler = new Throttler(
        delay: new Duration(milliseconds: throttleDurationMilliseconds),
        callback: onUpdate,
        argCallback: () => this.text);

    super.addListener(_textThrottler.throttle);
  }

  Throttler _textThrottler;
}
