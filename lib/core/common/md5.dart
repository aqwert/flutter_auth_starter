import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;
import 'package:convert/convert.dart';

String md5(String input) {
  var bytes = utf8.encode(input);
  var digest = crypto.md5.convert(bytes);
  var hash = hex.encode(digest.bytes);

  return hash;
}
