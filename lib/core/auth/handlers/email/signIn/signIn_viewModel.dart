import '../../../../validators/validator.dart';
import '../../../../validators/emailValidator.dart' as emailValidator;
import '../../../../validators/passwordValidator.dart' as passwordValidator;

import '../../../../common/appException.dart';

class ViewModel {
  ViewModel({this.email, this.password}) {
    _validator = new Validator();
    _validator.validations.add(() => validateEmail(email));
    _validator.validations.add(() => validatePassword(password));
  }

  String email = '';
  String password = '';

  Validator _validator;
  String validateEmail(String value) => emailValidator.validate(value);
  String validatePassword(String value) => passwordValidator.validate(value);

  void validateAll() {
    var errors = _validator.validate();
    if (errors != null && errors.length > 0) {
      throw new AppException(errors);
    }
  }
}
