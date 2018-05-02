import 'package:flutter/foundation.dart';

class Validator {
  final List<ValueGetter<String>> validations = new List<ValueGetter<String>>();

  String validate() {
    var errors = new List<String>();

    for (var validator in validations) {
      var error = validator();
      if (error != null) errors.add(error);
    }

    if (errors.length > 1) {
      return "Please fix multiple validation errors";
    } else {
      return errors.join("\n");
    }
  }
}
