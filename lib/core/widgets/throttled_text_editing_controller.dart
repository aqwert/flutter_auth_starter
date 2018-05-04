import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
//import '../common/throttle_debounce.dart';

typedef StringCallback(String value);

class ThrottledTextEditingController extends TextEditingController {
  ThrottledTextEditingController({@required StringCallback onUpdate}) {
    // _textThrottler =
    //     new Throttler(new Duration(seconds: 1), onUpdate, () => this.text);

    // super.addListener(_textThrottler.throttle);
  }

  //Throttler _textThrottler;
}
