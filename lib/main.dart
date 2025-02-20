import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:netease_cloud_music/HomePage.dart';
import 'package:smtc_windows/smtc_windows.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  if (!Platform.isWindows) {
    throw UnsupportedError('This platform is only supported on Windows');
  }
  WidgetsFlutterBinding.ensureInitialized();
  // 确保wi
  await windowManager.ensureInitialized();
  //确保Windows媒体集成控件初始化
  await SMTCWindows.initialize();

  WindowOptions windowOptions = WindowOptions(
    size: Size(1075, 750),
    minimumSize: Size(800, 600),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    title: "网易云音乐",
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setIcon("assets\\img\\neteaseIcon.png");
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    windowManager.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      locale: const Locale("zh", "CN"),
      theme: FluentThemeData(
          acrylicBackgroundColor: Color(0x13131a),
          fontFamily: "等线",
          accentColor: Colors.red,
          navigationPaneTheme: NavigationPaneThemeData(
            backgroundColor: Colors.white,
            selectedIconColor: WidgetStateProperty.all(Colors.red),
          )),
      darkTheme: FluentThemeData(
        fontFamily: "等线",
        accentColor: Colors.red,
        brightness: Brightness.dark,
        navigationPaneTheme: NavigationPaneThemeData(
          backgroundColor: Color.fromRGBO(19, 19, 26, 1),
          selectedIconColor: WidgetStateProperty.all(Colors.red),
          unselectedIconColor: WidgetStateProperty.all(Colors.white),
        ),
      ),
      themeMode: ThemeMode.dark,
      home: HomePage(),
    );
  }
}
