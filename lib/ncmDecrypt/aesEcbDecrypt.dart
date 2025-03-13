import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';

void aesEcbDecrypt(List<int> key, String src, StringBuffer dst) {
  final encrypter =
      Encrypter(AES(Key(Uint8List.fromList(key)), mode: AESMode.ecb));
  final encrypted = Encrypted(base64.decode(src));
  final decrypted = encrypter.decrypt(encrypted);
  dst.write(decrypted);
}
