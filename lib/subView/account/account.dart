/*
import 'package:fluent_ui/fluent_ui.dart';
import 'package:netease_cloud_music/subView/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../globalVariable.dart';

class Account extends StatefulWidget {
  Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool _loginState = false;

  @override
  void initState() {
    super.initState();
    if (userModel != null) {
      _loginState = true;
    }
  }

  _showContentDialog(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => LoginWithQRCode(),
    );
    if (result == "success") {
      _loginState = true;
    }
    if (result == "failure") {
      _loginState = false;
    }
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
                if ((await SharedPreferences.getInstance()).get("cookie") ==
                    null) {
                  _showContentDialog(context);
                }
                setState(() {
                  _loginState = true;
                });
              })
          : CircleAvatar(
              backgroundImage: NetworkImage(userModel!.profile.avatarUrl),
              radius: 15,
            ),
      HyperlinkButton(
        child: SizedBox(
          //width: 200,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _loginState ? userModel!.profile.nickname : "未登录",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(width: 5),
              Icon(
                FluentIcons.chevron_down_med,
                size: 10,
                color: Colors.white,
              ),
            ],
          ),
        ),
        onPressed: () {
          //TODO 登入后的界面
        },
      )
    ]);
  }
}
*/
