import 'dart:convert';
import 'dart:typed_data';

String? uint8ListToString(Uint8List? data) {
  return data != null ? base64Encode(data) : null;
}

Uint8List? stringToUint8List(String? data) {
  return data != null ? base64Decode(data) : null;
}
