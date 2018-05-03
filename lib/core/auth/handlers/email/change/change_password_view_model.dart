import '../../../../validators/validator.dart';
import '../../../../validators/passwordValidator.dart' as passwordValidator;
import '../../../../validators/words_match_validator.dart'
    as passwordsMatchValidator;

import '../../../../common/appException.dart';

class ViewModel {
  ViewModel() {
    _validator = new Validator();

    _validator.validations.add(() => validatePassword(currentPassword));
    _validator.validations.add(() => validatePassword(newPassword));
    _validator.validations.add(() => validatePassword(newPasswordConfirm));
    _validator.validations
        .add(() => validatePasswordsMatch(newPassword, newPasswordConfirm));
  }

  String currentPassword = '';
  String newPassword = '';
  String newPasswordConfirm = '';

  Validator _validator;

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
