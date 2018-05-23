import '../../../../validators/validator.dart';
import '../../../../validators/password_validator.dart' as passwordValidator;
import '../../../../validators/words_match_validator.dart'
    as passwordsMatchValidator;

import '../../../../common/app_exception.dart';
import '../../../../validators/validate_if.dart';

class ViewModel {
  ViewModel() {
    _validator = new Validator();

    _validator.validations.add(() => validatePassword(currentPassword));
    _validator.validations.add(() => validatePassword(newPassword));
    _validator.validations.add(() => validatePassword(newPasswordConfirm));
    _validator.validations
        .add(() => validatePasswordsMatch(newPassword, newPasswordConfirm));
  }

  //only want to validate field if either there is some text or
  // the submit button clicked and the field is empty
  bool emptyTextValidation = false;

  String currentPassword = '';
  String newPassword = '';
  String newPasswordConfirm = '';

  Validator _validator;

  String validatePassword(String value) => validateIfNotEmpty(
      emptyTextValidation, value, passwordValidator.validate);

  String validatePasswordsMatch(String value1, String value2) =>
      passwordsMatchValidator.validate(value1, value2,
          customOnError: "Passwords do not match");

  void validateAll() {
    var errors = _validator.validate();
    if (errors != null && errors.length > 0) {
      throw new AppException(errors);
    }
  }
}
