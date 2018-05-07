typedef String StringValidatorCallback(String value);

String validateIfNotEmpty(
    bool force, String value, StringValidatorCallback validator) {
  if (force || (value != null && value.length > 0)) {
    return validator(value);
  }
  return null;
}
