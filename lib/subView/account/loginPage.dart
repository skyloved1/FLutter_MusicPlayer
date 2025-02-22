import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';

import '../../provider/loginProvider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return material.Scaffold(
      appBar: material.AppBar(title: Text('Login')),
      body: Consumer<LoginProvider>(
        builder: (context, loginProvider, child) {
          if (loginProvider.isLoggedIn) {
            return Center(child: Text('You are already logged in'));
          } else {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Button(
                    onPressed: () async {
                      await loginProvider.generateSessionKey();
                      // Show QR code dialog
                      showDialog(
                        context: context,
                        builder: (context) => QRCodeDialog(),
                      );
                    },
                    child: Text('Login with QR Code'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class QRCodeDialog extends StatelessWidget {
  const QRCodeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text('Scan QR code to login'),
      content: Consumer<LoginProvider>(
        builder: (context, loginProvider, child) {
          return FutureBuilder<void>(
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
                return loginProvider.avatarUrl != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(loginProvider.avatarUrl!),
                      )
                    : CircleAvatar(
                        child: Icon(FluentIcons.temporary_user),
                      );
              }
            },
          );
        },
      ),
      actions: [
        Button(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
