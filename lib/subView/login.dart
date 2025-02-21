import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginWithQRCode extends StatefulWidget {
  const LoginWithQRCode({super.key});

  @override
  State<LoginWithQRCode> createState() => _LoginWithQRCodeState();
}

class _LoginWithQRCodeState extends State<LoginWithQRCode> {
  final String apiPrefix = "http://localhost:3000";
  final Dio dio = Dio();
  // Current timestamp
  late int _timeStamp;
  late String sessionKey;
  late Map<String, dynamic> jsonData;
  String? qrCodeBase64;
  late Image qrCodeImage;
  late Future<Response> qrCodeResponse;
  late StreamController<Map<String, dynamic>> qrCodeStreamController;
  int lastQRCodeStatus = 0;
  late Timer _pollingTimer;

  @override
  void initState() {
    super.initState();
    _timeStamp = DateTime.now().millisecondsSinceEpoch;
    qrCodeResponse = dio.get("$apiPrefix/login/qr/key?timestamp=$_timeStamp");
/*    //生成base64的二维码
    qrCodeBase64 = _getQRCode(sessionKey);
    qrCodeImage = decodeQRCodeWithBase64(qrCodeBase64!);*/
    //轮询扫码状态
    qrCodeStreamController = StreamController<Map<String, dynamic>>();
    //开始轮询二维码状态
    _pollingTimer = _pollingQRCodeStatus();
  }

  Future<Response> _getQRCodeBase64Data(String sessionKey) {
    return dio.get("$apiPrefix/login/qr/create",
        queryParameters: {'key': sessionKey, 'qrimg': true});
  }

  Future<Map<String, dynamic>> _fetchQRCodeData() async {
    _timeStamp = DateTime.now().millisecondsSinceEpoch;
    final qrKeyResponse =
        await dio.get("$apiPrefix/login/qr/key?timestamp=$_timeStamp");
    sessionKey = qrKeyResponse.data["data"]["unikey"];
    final qrCodeResponse = await _getQRCodeBase64Data(sessionKey);
    return qrCodeResponse.data["data"];
  }

  //轮询扫码状态，直到扫码成功
  //通过添加流，每隔1.5秒请求一次
  //如果扫码成功，返回用户信息
  /*
  二维码扫码状态,800 为二维码过期,801 为等待扫码,802 为待确认,803 为授权登录成功
  (803 状态码下会返回 cookies),如扫码后返回502,则需加上noCookie参数,如&noCookie=true
   */

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

  StatelessWidget unknownErrrorInfoBar(
      BuildContext context, void Function() close) {
    return Builder(builder: (context) {
      return InfoBar(
        title: const Text('An unknown error occurred'),
        content: const Text("Stream has unknown error,please try again"),
        action: IconButton(
          icon: const Icon(FluentIcons.clear),
          onPressed: close,
        ),
        severity: InfoBarSeverity.error,
      );
    });
  }

  @override
  void dispose() {
    _pollingTimer.cancel();
    qrCodeStreamController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  if (snapshot.hasData) {
                    if (snapshot.hasError) {
                      return const Text("QR Stream has Error");
                    }

                    if (snapshot.data!["code"] == 803) {
                      print("login success，即将存储cookie");
                      //登录成功,使用SharedPreferred持久化存储cookie
                      SharedPreferences.getInstance().then((prefs) {
                        print("the cookie is ${snapshot.data!["cookie"]}");
                        prefs.setString(
                            "cookie", jsonEncode(snapshot.data!["cookie"]));
                      });
                      //取消定时器
                      _pollingTimer.cancel();
                      qrCodeStreamController.close();
                      return const Text("Login success");
                    }
                    if (snapshot.data!["code"] == 801) {
                      return GenerateQRCode(qrCodeData: _fetchQRCodeData());
                    }
                    if (snapshot.data!["code"] == 802) {
                      //返回一个对话框显示 请在手机上确认
                      _showWaitToConfirmQRCodeDialog(snapshot.data!["code"]);
                    }

                    if (snapshot.data!["code"] == 800) {
                      qrCodeStreamController.close();
                      return FilledButton(
                          child: const Text("refresh QR code"),
                          onPressed: () {
                            setState(() {
                              qrCodeStreamController =
                                  StreamController<Map<String, dynamic>>();
                              _pollingQRCodeStatus();
                            });
                          });
                    }
                    lastQRCodeStatus = snapshot.data!["code"];
                    return unknownErrrorInfoBar(context, () {
                      Navigator.pop(context);
                    });
                  } else {
                    return unknownErrrorInfoBar(context, () {
                      Navigator.pop(context);
                    });
                  }
                }),
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
        if (qrCodeBase64 != data["qrimg"]) {
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

                qrCodeBase64 = snapshot.data!["qrimg"];
                var qrCodeImage =
                    Image.memory(decodeQRCodeWithBase64(qrCodeBase64));
                return qrCodeImage;
              } else {
                return const ProgressRing();
              }
            },
          );
  }

  //解析二维码为字节
  Uint8List decodeQRCodeWithBase64(String qrCodeBase64) {
    qrCodeBase64 = qrCodeBase64.split(',')[1];
    Uint8List bytes = Base64Decoder().convert(qrCodeBase64);

    return bytes;
  }
}
