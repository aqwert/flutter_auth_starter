import '../../../../validators/validator.dart';
import '../../../../validators/email_validator.dart' as emailValidator;

import '../../../../common/app_exception.dart';
import '../../../../validators/validate_if.dart';

class ViewModel {
  ViewModel({this.email}) {
    _validator = new Validator();
    _validator.validations.add(() => validateEmail(email));
  }

  //only want to validate field if either there is some text or
  // the submit button clicked and the field is empty
  bool emptyTextValidation = false;

  String email = '';

  Validator _validator;
  String validateEmail(String value) =>
      validateIfNotEmpty(emptyTextValidation, value, emailValidator.validate);

  void validateAll() {
    emptyTextValidation = true;

    var errors = _validator.validate();
    if (errors != null && errors.length > 0) {
      throw new AppException(errors);
    }
  }
}
