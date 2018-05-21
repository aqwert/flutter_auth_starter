import 'package:flutter_auth_base/flutter_auth_base.dart';

import '../../../../validators/validator.dart';
import '../../../../validators/email_validator.dart' as emailValidator;
import '../../../../validators/password_validator.dart' as passwordValidator;

import '../../../../common/app_exception.dart';
import '../../../../validators/validate_if.dart';

class ViewModel {
  ViewModel() {
    _validator = new Validator();
    _validator.validations.add(() => validateEmail(email));
    _validator.validations.add(() => validatePassword(password));
  }

  //only want to validate field if either there is some text or
  // the submit button clicked and the field is empty
  bool emptyTextValidation = false;

  String currentEmail = '';
  String email = '';
  String password = '';

  Validator _validator;
  String validateEmail(String value) =>
      validateIfNotEmpty(emptyTextValidation, value, emailValidator.validate);
  String validatePassword(String value) => validateIfNotEmpty(
      emptyTextValidation, value, passwordValidator.validate);

  void validateAll() {
    emptyTextValidation = true;

    var errors = _validator.validate();
    if (errors != null && errors.length > 0) {
      throw new AppException(errors);
    }
  }

  void init(AuthService authService) async {
    var user = await authService.currentUser();
    currentEmail = user.email;
  }
}
