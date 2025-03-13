import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:netease_cloud_music/homePage.dart';
import 'package:netease_cloud_music/provider/bottomMusicPlayerProvider.dart';
import 'package:provider/provider.dart';
import 'package:smtc_windows/smtc_windows.dart';
import 'package:window_manager/window_manager.dart';

import 'globalVariable.dart';

//TODO smtc BUG 当点击控制中心的按钮后会导致smtc与音频识别壁纸无法更新
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
    minimumSize: Size(800 + 221, 600),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    title: "音乐播放器",
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setIcon("assets/img/appicon.ico");
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
  late AudioPlayer player;
  late SMTCWindows smtc;
  late ValueNotifier<List<MusicInfo>> musicListNotifier;

  @override
  void initState() {
    musicListNotifier = ValueNotifier([]);
    player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.loop);
    smtc = SMTCWindows(
      enabled: true,
      metadata: MusicMetadata(
        title: '网易云音乐',
        artist: '网易云音乐',
        album: '网易云音乐',
        albumArtist: '网易云音乐',
      ),
      config: const SMTCConfig(
        fastForwardEnabled: true,
        nextEnabled: true,
        pauseEnabled: true,
        playEnabled: true,
        rewindEnabled: true,
        prevEnabled: true,
        stopEnabled: true,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    smtc.dispose();
    musicListNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BottomMusicPlayerProvider(
        player: player,
        musicListNotifier: musicListNotifier,
        smtcWindows: smtc,
      ),
      child: FluentApp(
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
      ),
    );
  }
}
