import '../../../../validators/validator.dart';
import '../../../../validators/email_validator.dart' as emailValidator;
import '../../../../validators/password_validator.dart' as passwordValidator;
import '../../../../validators/display_name_validator.dart'
    as displayNameValidator;
import '../../../../validators/words_match_validator.dart'
    as passwordsMatchValidator;

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

  String displayName = '';
  String email = '';
  String password = '';
  String passwordConfirm = '';

  Validator _validator;

  String validateDisplayName(String value) =>
      displayNameValidator.validate(value);

  String validateEmail(String value) => emailValidator.validate(value);

  String validatePassword(String value) => passwordValidator.validate(value);

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
