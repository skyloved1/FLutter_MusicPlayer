/*
import 'package:fluent_ui/fluent_ui.dart';
import 'package:netease_cloud_music/subView/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool _loginState = false;
  late final SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  void initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _loginState = _prefs.getBool("_loginState") ?? false;
    });
  }

  Future<String> _showContentDialog(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => LoginWithQRCode(),
    );
    if (result != null) {
      print('The user deleted the file');
    }
    return result ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      !_loginState
          ? IconButton(
              icon: Icon(
                FluentIcons.temporary_user,
                size: 20,
              ),
              onPressed: () async {
                //TODO: 跳转到二维码登入页面并存储登入状态
                _showContentDialog(context);
              })
          : CircleAvatar(),
      HyperlinkButton(
        child: SizedBox(
          //width: 200,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("UserName"),
              SizedBox(width: 5),
              Icon(
                FluentIcons.chevron_down_med,
                size: 10,
              ),
            ],
          ),
        ),
        onPressed: () {},
      )
    ]);
  }
}
*/
