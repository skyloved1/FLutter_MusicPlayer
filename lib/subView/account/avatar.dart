import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../provider/loginProvider.dart';
import 'loginPage.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, loginProvider, child) {
        return FutureBuilder<String>(
          future: loginProvider.getAvatar(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircleAvatar(
                child: ProgressRing(),
              );
            } else if (snapshot.hasError) {
              return CircleAvatar(
                child: Icon(FluentIcons.error),
              );
            } else {
              return snapshot.data != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data!),
                    )
                  : CircleAvatar(
                      child: Icon(FluentIcons.temporary_user),
                    );
            }
          },
        );
      },
    );
  }
}

class AvatarWithLoginAndOut extends StatefulWidget {
  const AvatarWithLoginAndOut({super.key});

  @override
  State<AvatarWithLoginAndOut> createState() => _AvatarWithLoginAndOutState();
}

class _AvatarWithLoginAndOutState extends State<AvatarWithLoginAndOut> {
  _isLogin() {
    return Provider.of<LoginProvider>(context, listen: false).isLogin;
  }

  showLoginDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Avatar(),
      onPressed: () {
        if (_isLogin()) {
          //TODO 退出登入页面
          print("应当展示退出登入页面");
        } else {
          showLoginDialog(context);
        }
      },
    );
  }
}
