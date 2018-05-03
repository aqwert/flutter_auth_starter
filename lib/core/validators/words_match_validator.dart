String validate(String value1, String value2, {String customOnError}) {
  if (value1 != value2) {
    return customOnError ?? 'Values do not match';
  }

  return null;
}
