import '../../../../validators/validator.dart';
import '../../../../validators/email_validator.dart' as emailValidator;
import '../../../../validators/password_validator.dart' as passwordValidator;
import '../../../../validators/display_name_validator.dart'
    as displayNameValidator;
import '../../../../validators/words_match_validator.dart'
    as passwordsMatchValidator;

import '../../../../validators/validate_if.dart';

import '../../../../common/app_exception.dart';

class ViewModel {
  ViewModel({this.email, this.password}) {
    _validator = new Validator();
    _validator.validations.add(() => validateDisplayName(displayName));
    _validator.validations.add(() => validateEmail(email));
    _validator.validations.add(() => validatePassword(password));
    _validator.validations.add(() => validatePassword(passwordConfirm));
    _validator.validations
        .add(() => validatePasswordsMatch(password, passwordConfirm));
  }

  //only want to validate field if either there is some text or
  // the submit button clicked and the field is empty
  bool emptyTextValidation = false;

  String displayName = '';
  String email = '';
  String password = '';
  String passwordConfirm = '';

  Validator _validator;

  String validateDisplayName(String value) => validateIfNotEmpty(
      emptyTextValidation, value, displayNameValidator.validate);

  String validateEmail(String value) =>
      validateIfNotEmpty(emptyTextValidation, value, emailValidator.validate);

  String validatePassword(String value) => validateIfNotEmpty(
      emptyTextValidation, value, passwordValidator.validate);

  String validatePasswordsMatch(String value1, String value2) =>
      passwordsMatchValidator.validate(value1, value2,
          customOnError: "Passwords do not match");

  void validateAll() {
    emptyTextValidation = true;

    var errors = _validator.validate();
    if (errors != null && errors.length > 0) {
      throw new AppException(errors);
    }
  }
}
