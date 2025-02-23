import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider with ChangeNotifier {
  final Dio dio = Dio();
  final String apiPrefix = "http://localhost:3000";
  late SharedPreferences prefs;
  bool _isLoggedIn = false;
  String? _sessionKey;
  int? _timeStamp;
  Future<void>? _avatarFuture;

  bool get isLoggedIn => _isLoggedIn;

  LoginProvider() {
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getString("cookie") != null;
    if (_isLoggedIn) {
      _avatarFuture = getAvatar();
    }
    notifyListeners();
  }

  Future<void> generateSessionKey() async {
    _timeStamp = DateTime.now().millisecondsSinceEpoch;
    final qrKeyResponse =
        await dio.get("$apiPrefix/login/qr/key?timestamp=$_timeStamp");
    _sessionKey = qrKeyResponse.data["data"]["unikey"] as String;
  }

  Future<Map<String, dynamic>> fetchQRCodeData() async {
    final qrCodeResponse = await dio.get("$apiPrefix/login/qr/create",
        queryParameters: {'key': _sessionKey, 'qrimg': true});
    return qrCodeResponse.data["data"];
  }

  Future<void> checkQRCodeStatus() async {
    final qrCodeStatusResponse = await dio.get(
        "$apiPrefix/login/qr/check?key=$_sessionKey&timestamp=$_timeStamp");
    if (qrCodeStatusResponse.data["code"] == 803) {
      await prefs.setString("cookie", qrCodeStatusResponse.data["cookie"]);
      _isLoggedIn = true;
      notifyListeners();
      _avatarFuture = getAvatar();
    }
  }

  Future<String> getAvatar() async {
    final Response? response;
    try {
      response = await dio.get(
        "$apiPrefix/user/account",
        queryParameters: {
          'cookie': prefs.getString("cookie"),
        },
      );

      if (response.data["code"] == 200) {
        prefs.setString("avatarUrl", response.data["profile"]["avatarUrl"]);
        // notifyListeners();
      }
      return response.data["profile"]["avatarUrl"];
    } catch (e) {
      //TOOD 处理连接失败
      print(e);
    }

    return "";
  }

  String? get avatarUrl => prefs.getString("avatarUrl");

  get isLogin => _isLoggedIn;
}
