import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'errorInfoBar.dart';

class LoginWithQRCode extends StatefulWidget {
  const LoginWithQRCode({super.key});

  @override
  State<LoginWithQRCode> createState() => _LoginWithQRCodeState();
}

class _LoginWithQRCodeState extends State<LoginWithQRCode> {
  final String apiPrefix = "http://localhost:3000";
  final Dio dio = Dio();
  late int _timeStamp;
  late String sessionKey;
  late Map<String, dynamic> jsonData;
  String? qrCodeBase64;
  late Image qrCodeImage;
  late Future<Response> qrCodeResponse;
  late StreamController<Map<String, dynamic>> qrCodeStreamController;
  int lastQRCodeStatus = 0;
  late Timer _pollingTimer;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
    _generateSessionKey();
    qrCodeStreamController = StreamController<Map<String, dynamic>>();
    _pollingTimer = _pollingQRCodeStatus();
  }

  Future<Response> _getQRCodeBase64Data(String sessionKey) {
    return dio.get("$apiPrefix/login/qr/create",
        queryParameters: {'key': sessionKey, 'qrimg': true});
  }

  void _generateSessionKey() async {
    _timeStamp = DateTime.now().millisecondsSinceEpoch;
    final qrKeyResponse =
        await dio.get("$apiPrefix/login/qr/key?timestamp=$_timeStamp");
    sessionKey = qrKeyResponse.data["data"]["unikey"] as String;
  }

  Future<Map<String, dynamic>> _fetchQRCodeData() async {
    final qrCodeResponse = await _getQRCodeBase64Data(sessionKey);
    return qrCodeResponse.data["data"];
  }

  Timer _pollingQRCodeStatus() {
    return Timer.periodic(Duration(milliseconds: 1500 * 3), (timer) async {
      final qrCodeStatusResponse = await dio.get(
          "$apiPrefix/login/qr/check?key=$sessionKey&timestamp=$_timeStamp");
      print("qrCodeStatusResponse: ${qrCodeStatusResponse.data}");
      qrCodeStreamController.add(qrCodeStatusResponse.data);
    });
  }

  void _showWaitToConfirmQRCodeDialog(int qrCodeStatus) {
    print("called _showWaitToConfirmQRCodeDialog");
    if (lastQRCodeStatus == qrCodeStatus) return;
    showDialog(
        context: context,
        builder: (context) {
          return ContentDialog(
            title: const Text("请在手机上确认"),
            content: ProgressRing(),
          );
        });
  }

  @override
  void dispose() {
    _pollingTimer.cancel();
    qrCodeStreamController.close();
    super.dispose();
  }

  initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initSharedPreferences(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If already logged in, show a dialog
          if (prefs.getString("cookie") != null) {
            return ContentDialog(
              title: const Text("You are already logged in"),
              content: const Text(
                  "You are already logged in, no need to log in again"),
              actions: [
                Button(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          }
          // Otherwise, show the QR code login dialog
          return ContentDialog(
            title: const Text('Scan QR code to login'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Open your Netease Cloud Music app, scan the QR code to login',
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 200,
                  height: 200,
                  child: StreamBuilder(
                    stream: qrCodeStreamController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text("QR Stream has Error");
                      }

                      if (snapshot.hasData && snapshot.data != null) {
                        if (snapshot.data!["code"] == 803) {
                          print("login success, saving cookie");
                          SharedPreferences.getInstance().then((prefs) {
                            print("the cookie is ${snapshot.data!["cookie"]}");
                            prefs.setString(
                                "cookie", jsonEncode(snapshot.data!["cookie"]));
                          });
                          _pollingTimer.cancel();
                          qrCodeStreamController.close();
                          return const Text("Login success");
                        }
                        if (snapshot.data!["code"] == 801) {
                          return GenerateQRCode(qrCodeData: _fetchQRCodeData());
                        }
                        if (snapshot.data!["code"] == 802) {
                          _showWaitToConfirmQRCodeDialog(
                              snapshot.data!["code"]);
                        }
                        if (snapshot.data!["code"] == 800) {
                          _pollingTimer.cancel();
                          return FilledButton(
                            child: const Text("refresh QR code"),
                            onPressed: () {
                              setState(() {
                                _generateSessionKey();
                                _pollingTimer = _pollingQRCodeStatus();
                              });
                            },
                          );
                        }
                        lastQRCodeStatus = snapshot.data!["code"];
                        print(
                            "snapshot.data!['code'] is ${snapshot.data!["code"]}");
                        return ErrrorInfoBar(
                          close: () {
                            Navigator.pop(context);
                          },
                          context: NavigationView.of(context).context,
                        );
                      } else {
                        return const ProgressRing();
                      }
                    },
                  ),
                ),
              ],
            ),
            actions: [
              Button(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        } else {
          return const Center(child: ProgressRing());
        }
      },
    );
  }
}

class GenerateQRCode extends StatefulWidget {
  const GenerateQRCode({super.key, required this.qrCodeData});

  final Future<Map<String, dynamic>> qrCodeData;

  @override
  State<GenerateQRCode> createState() => _GenerateQRCodeState();
}

class _GenerateQRCodeState extends State<GenerateQRCode> {
  String qrCodeBase64 = "";

  @override
  void didUpdateWidget(covariant GenerateQRCode oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.qrCodeData != widget.qrCodeData) {
      widget.qrCodeData.then((data) {
        if (data != null &&
            data["code"] == 800 &&
            qrCodeBase64 != data["qrimg"]) {
          setState(() {
            qrCodeBase64 = data["qrimg"];
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return qrCodeBase64.isNotEmpty
        ? Image.memory(decodeQRCodeWithBase64(qrCodeBase64))
        : FutureBuilder<Map<String, dynamic>>(
            future: widget.qrCodeData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const Text('Error');
                }

                if (snapshot.data != null) {
                  qrCodeBase64 = snapshot.data!["qrimg"];
                  var qrCodeImage =
                      Image.memory(decodeQRCodeWithBase64(qrCodeBase64));
                  return qrCodeImage;
                } else {
                  return const Text('No data available');
                }
              } else {
                return const ProgressRing();
              }
            },
          );
  }

  Uint8List decodeQRCodeWithBase64(String qrCodeBase64) {
    qrCodeBase64 = qrCodeBase64.split(',')[1];
    Uint8List bytes = Base64Decoder().convert(qrCodeBase64);
    return bytes;
  }
}
