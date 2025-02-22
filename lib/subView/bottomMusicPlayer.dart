import 'package:audioplayers/audioplayers.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smtc_windows/smtc_windows.dart';

import '../provider/bottomMusicPlayerProvider.dart';

class BottomMusicPlayer extends StatefulWidget {
  static BottomMusicPlayer? _instance;

  static BottomMusicPlayer get instance {
    _instance ??= BottomMusicPlayer();
    return _instance!;
  }

  factory BottomMusicPlayer() => _instance ??= BottomMusicPlayer._();

  const BottomMusicPlayer._({super.key});

  static _BottomMusicPlayerState? of(BuildContext context) {
    return context.findAncestorStateOfType<_BottomMusicPlayerState>();
  }

  @override
  State<BottomMusicPlayer> createState() => _BottomMusicPlayerState();
}

class _BottomMusicPlayerState extends State<BottomMusicPlayer>
    with SingleTickerProviderStateMixin {
  late final SMTCWindows smtc;
  late final AudioPlayer player;
  late final AnimationController _animationController;
  PlayerState playerState = PlayerState.stopped;
  late SharedPreferences prefs;

  initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  void updateBottomMusicPlayer() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 20),
      lowerBound: 0,
      upperBound: 2 * 3.1415926,
    )
      ..repeat()
      ..stop(canceled: false);
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
    player = AudioPlayer();
  }

  @override
  void dispose() {
    smtc.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BottomMusicPlayerProvider(),
      child: ColoredBox(
        color: Color.fromRGBO(45, 45, 56, 1),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Transform.translate(
              offset: Offset(35, 0),
              child: SizedBox(
                width: 300,
                height: 75,
                child: Stack(
                  children: [
                    SizedBox(
                      width: 75,
                      height: 75,
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: playerState == PlayerState.playing
                                ? _animationController.value
                                : 0,
                            child: MouseRegion(
                              onHover: (_) {
                                context
                                    .read<BottomMusicPlayerProvider>()
                                    .setHover(true);
                              },
                              onExit: (_) {
                                context
                                    .read<BottomMusicPlayerProvider>()
                                    .setHover(false);
                              },
                              child: GestureDetector(
                                onTap: () {
                                  //TODO 跳转到全屏播放页面
                                  print("跳转到全屏播放页面");
                                },
                                child: Consumer<BottomMusicPlayerProvider>(
                                  builder: (context, provider, child) {
                                    return ColoredBox(
                                      color: provider.onHover
                                          ? Color.fromRGBO(115, 115, 115, 1.0)
                                          : Color.fromRGBO(45, 45, 56, 1),
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: Container(
                                              width: 75,
                                              height: 75,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color.fromRGBO(
                                                    45, 45, 56, 1),
                                              ),
                                              child: Image.asset(
                                                  "assets/img/black.png"),
                                            ),
                                          ),
                                          Center(
                                            child: provider.musicAvatar != null
                                                ? CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(provider
                                                            .musicAvatar!),
                                                  )
                                                : CircleAvatar(
                                                    child: const Icon(
                                                        FluentIcons.music_note),
                                                  ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Consumer<BottomMusicPlayerProvider>(
                      builder: (context, provider, child) {
                        return Positioned(
                          left: 85,
                          child: SizedBox(
                            width: 225,
                            height: 75,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  provider.musicName ?? '歌曲名',
                                  style: FluentTheme.of(context)
                                      .typography
                                      .subtitle,
                                ),
                                Text(
                                  provider.musicArtist ?? '歌手名',
                                  style: FluentTheme.of(context)
                                      .typography
                                      .caption,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 400,
              height: 75,
              child: Placeholder(),
            ),
            SizedBox(
              width: 300,
              height: 75,
              child: Placeholder(),
            ),
          ],
        ),
      ),
    );
  }
}
