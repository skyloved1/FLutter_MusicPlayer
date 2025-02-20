import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fluent_ui/fluent_ui.dart';

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
  @override
  void initState() {
    super.initState();
    _timeStamp = DateTime.now().millisecondsSinceEpoch;
    qrCodeResponse = dio.get("$apiPrefix/login/qr/key?timestamp=$_timeStamp");
/*    //生成base64的二维码
    qrCodeBase64 = _getQRCode(sessionKey);
    qrCodeImage = decodeQRCodeWithBase64(qrCodeBase64!);*/
  }

  Future<Response> _getQRCode(String sessionKey) {
    return dio.get("$apiPrefix/login/qr/create",
        queryParameters: {'key': sessionKey, 'qrimg': true});
  }

  //解析二维码为字节
  Uint8List decodeQRCodeWithBase64(String qrCodeBase64) {
    print("qrCodeBase64: $qrCodeBase64");
    qrCodeBase64 = qrCodeBase64.split(',')[1];
    Uint8List bytes = Base64Decoder().convert(qrCodeBase64);

    return bytes;
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
          Container(
            width: 200,
            height: 200,
            child: FutureBuilder(
                future: qrCodeResponse,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Text('Error');
                    }
                    jsonData = snapshot.data!.data;
                    sessionKey = jsonData["data"]["unikey"];
                    return FutureBuilder(
                        future: _getQRCode(sessionKey),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError) {
                              return const Text('Error');
                            }
                            qrCodeBase64 = snapshot.data!.data["data"]["qrimg"];
                            qrCodeImage = Image.memory(
                                decodeQRCodeWithBase64(qrCodeBase64!));
                            return qrCodeImage;
                          } else {
                            return const ProgressRing();
                          }
                        });
                  } else {
                    return const ProgressRing();
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
