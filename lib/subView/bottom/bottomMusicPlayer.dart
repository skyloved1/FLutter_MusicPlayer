import 'package:audioplayers/audioplayers.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:netease_cloud_music/Icon/Icon.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smtc_windows/smtc_windows.dart';

import '../../provider/bottomMusicPlayerProvider.dart';

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
    )..repeat();
    //..stop(canceled: false);
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
    print('build bottom music player/n 这个不应该出现，即不应该重建整个底部音乐播放器');
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
                      child: IconButton(
                        onPressed: () {
                          //TODO 跳转到全屏播放页面
                        },
                        icon: Consumer<BottomMusicPlayerProvider>(
                          builder: (context, provider, child) {
                            if (provider.playerState == PlayerState.playing) {
                              _animationController.repeat();
                            } else {
                              _animationController.stop();
                            }
                            return AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle: _animationController.value,
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Container(
                                          width: 75,
                                          height: 75,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                Color.fromRGBO(45, 45, 56, 1),
                                          ),
                                          child: Image.asset(
                                              "assets/img/black.png"),
                                        ),
                                      ),
                                      Center(
                                        child: provider.musicAvatar != null
                                            ? CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    provider.musicAvatar!),
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
                            );
                          },
                        ),
                      ),
                    ),
                    Consumer<BottomMusicPlayerProvider>(
                      builder: (context, provider, child) {
                        print("provider.musicName: ${provider.musicName}");
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
              child: Consumer<BottomMusicPlayerProvider>(
                builder: (context, bottomMusicPlayerProvider, child) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 64, vertical: 4),
                        child: IconTheme(
                          data: IconThemeData(
                            color: Colors.white,
                            size: 28,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(
                                  MyIcon.like,
                                  size: 20,
                                ),
                                onPressed: () {
                                  //TODO 将该歌曲添加到我喜欢的音乐
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  MyIcon.lastSong,
                                  size: 20,
                                ),
                                onPressed: () {
                                  //TODO 播放上一首歌曲
                                },
                              ),
                              Consumer<BottomMusicPlayerProvider>(builder: (
                                context,
                                bottomMusicPlayerProvider,
                                child,
                              ) {
                                return IconButton(
                                  icon: CircleAvatar(
                                    child: Icon(
                                        size: 24,
                                        color: Colors.white,
                                        bottomMusicPlayerProvider.playerState ==
                                                PlayerState.playing
                                            ? MyIcon.pause
                                            : MyIcon.play),
                                  ),
                                  onPressed: () {
                                    if (bottomMusicPlayerProvider.playerState ==
                                        PlayerState.playing) {
                                      bottomMusicPlayerProvider
                                          .setPlayerState(PlayerState.paused);
                                    } else {
                                      bottomMusicPlayerProvider
                                          .setPlayerState(PlayerState.playing);
                                    }
                                  },
                                );
                              }),
                              IconButton(
                                icon: Icon(
                                  MyIcon.nextSong,
                                  size: 20,
                                ),
                                onPressed: () {
                                  //TODO 播放下一首歌曲
                                },
                              ),
                              Consumer<BottomMusicPlayerProvider>(builder: (
                                context,
                                bottomMusicPlayerProvider,
                                child,
                              ) {
                                return IconButton(
                                  icon: _setIconWithPlayMode(
                                    bottomMusicPlayerProvider.playerMode,
                                  ),
                                  onPressed: () {
                                    bottomMusicPlayerProvider.setPlayerMode(
                                        MyPlayerMode.values[
                                            (bottomMusicPlayerProvider
                                                        .playerMode.index +
                                                    1) %
                                                MyPlayerMode.values.length]);
                                  },
                                );
                              })
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
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

  Icon _setIconWithPlayMode(MyPlayerMode mode, {double iconSize = 24.0}) {
    switch (mode) {
      case MyPlayerMode.listLoop:
        return Icon(
          PlayModeIcon.listLoop,
          key: ValueKey('listLoop'),
          size: iconSize,
        );
      case MyPlayerMode.singleLoop:
        return Icon(
          PlayModeIcon.singleLoop,
          key: ValueKey('singleLoop'),
          size: iconSize,
        );
      case MyPlayerMode.sequencePlay:
        return Icon(
          PlayModeIcon.sequencePlay,
          key: ValueKey('sequencePlay'),
          size: iconSize,
        );
      case MyPlayerMode.heartPatten:
        return Icon(
          PlayModeIcon.heartPatten,
          key: ValueKey('heartPatten'),
          size: iconSize,
        );
      case MyPlayerMode.randomPlay:
        return Icon(
          PlayModeIcon.randomPlay,
          key: ValueKey('randomPlay'),
          size: iconSize,
        );
    }
  }
}
