import 'dart:convert';
import 'dart:io';
import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

import 'aesEcbDecrypt.dart';

class NeteaseCrypt {
  static const List<int> sCoreKey = [
    0x68,
    0x7A,
    0x48,
    0x52,
    0x41,
    0x6D,
    0x73,
    0x6F,
    0x35,
    0x6B,
    0x49,
    0x6E,
    0x62,
    0x61,
    0x78,
    0x57
  ];
  static const List<int> sModifyKey = [
    0x23,
    0x31,
    0x34,
    0x6C,
    0x6A,
    0x6B,
    0x5F,
    0x21,
    0x5C,
    0x5D,
    0x26,
    0x30,
    0x55,
    0x3C,
    0x27,
    0x28
  ];

  File file;
  String filepath;
  List<int> keyBox = List<int>.filled(256, 0);
  String imageData = '';
  String format = '';
  String dumpFilepath = '';
  NeteaseMusicMetadata? metaData;

  NeteaseCrypt(this.filepath) : file = File(filepath) {
    file = File(filepath);
    if (!file.existsSync()) {
      throw ArgumentError("Can't open file");
    }

    if (!isNcmFile()) {
      throw ArgumentError("Not netease protected file");
    }

    file.openSync(mode: FileMode.read);
    file.readAsBytesSync().skip(2);

    int n = readInt();
    if (n <= 0) {
      throw ArgumentError("Broken NCM file");
    }

    List<int> keydata = file.readAsBytesSync().sublist(0, n);
    for (int i = 0; i < n; i++) {
      keydata[i] ^= 0x64;
    }

    String rawKeyData = utf8.decode(keydata);
    StringBuffer mKeyData = StringBuffer();
    aesEcbDecrypt(sCoreKey, rawKeyData, mKeyData);

    buildKeyBox(
        mKeyData.toString().codeUnits.sublist(17), mKeyData.length - 17);

    n = readInt();
    if (n <= 0) {
      print(
          "[Warn] '$filepath' missing metadata information can't fix some information!");
      metaData = null;
    } else {
      List<int> modifyData = file.readAsBytesSync().sublist(0, n);
      for (int i = 0; i < n; i++) {
        modifyData[i] ^= 0x63;
      }

      // Fix the error by converting Uint8List to String
      String swapModifyData = utf8.decode(modifyData.sublist(22));
      String modifyOutData = base64.encode(base64.decode(swapModifyData));
      StringBuffer modifyDecryptData = StringBuffer();
      aesEcbDecrypt(sModifyKey, modifyOutData, modifyDecryptData);

      modifyDecryptData =
          StringBuffer(modifyDecryptData.toString().substring(6));
      metaData = NeteaseMusicMetadata(jsonDecode(modifyDecryptData.toString()));
    }

    file.readAsBytesSync().skip(5);
    int coverFrameLen = readInt();
    n = readInt();
    if (n > 0) {
      imageData = utf8.decode(file.readAsBytesSync().sublist(0, n));
    } else {
      print("[Warn] '$filepath' missing album can't fix album image!");
    }
    file.readAsBytesSync().skip(coverFrameLen - n);
  }

  Uint8List? get decryptedData => null;

  bool isNcmFile() {
    int header = readInt();
    if (header != 0x4e455443) {
      return false;
    }

    header = readInt();
    if (header != 0x4d414446) {
      return false;
    }

    return true;
  }

  int readInt() {
    List<int> buffer = file.readAsBytesSync().sublist(0, 4);
    return buffer[0] | (buffer[1] << 8) | (buffer[2] << 16) | (buffer[3] << 24);
  }

  void buildKeyBox(List<int> key, int keyLen) {
    for (int i = 0; i < 256; ++i) {
      keyBox[i] = i;
    }

    int swap = 0;
    int c = 0;
    int lastByte = 0;
    int keyOffset = 0;

    for (int i = 0; i < 256; ++i) {
      swap = keyBox[i];
      c = ((swap + lastByte + key[keyOffset++]) & 0xff);
      if (keyOffset >= keyLen) keyOffset = 0;
      keyBox[i] = keyBox[c];
      keyBox[c] = swap;
      lastByte = c;
    }
  }
}

class NeteaseMusicMetadata {
  String name = '';
  String album = '';
  String artist = '';
  int bitrate = 0;
  int duration = 0;
  String format = '';

  NeteaseMusicMetadata(Map<String, dynamic> raw) {
    name = raw['musicName'] ?? '';
    album = raw['album'] ?? '';
    artist = (raw['artist'] as List).map((e) => e[0]).join('/');
    bitrate = raw['bitrate'] ?? 0;
    duration = raw['duration'] ?? 0;
    format = raw['format'] ?? '';
  }
}
