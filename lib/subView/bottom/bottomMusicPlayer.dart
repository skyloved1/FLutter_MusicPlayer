import 'dart:io';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ffi/ffi.dart';
import 'package:file_selector/file_selector.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:netease_cloud_music/Icon/Icon.dart';
import 'package:netease_cloud_music/subView/bottom/bottomProgressIndicator.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:smtc_windows/smtc_windows.dart';

import '../../globalVariable.dart';
import '../../ncmDecrypt/libncmdump_ffi.dart';
import '../../provider/bottomMusicPlayerProvider.dart';
import 'musicList.dart';

class BottomMusicPlayer extends StatefulWidget {
  static BottomMusicPlayer? _instance;

  static BottomMusicPlayer get instance {
    _instance ??= BottomMusicPlayer();
    return _instance!;
  }

  factory BottomMusicPlayer() => _instance ??= BottomMusicPlayer._();

  const BottomMusicPlayer._({super.key});

  @override
  State<BottomMusicPlayer> createState() => BottomMusicPlayerState();
}

class BottomMusicPlayerState extends State<BottomMusicPlayer>
    with AutomaticKeepAliveClientMixin {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ColoredBox(
      color: Color.fromRGBO(45, 45, 56, 1),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Left(),
          Mid(
              audioPlayer: context.read<BottomMusicPlayerProvider>().player,
              smtcWindows:
                  context.read<BottomMusicPlayerProvider>().smtcWindows),
          Right(),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class Right extends StatelessWidget {
  const Right({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 75,
      child: Row(
        children: [
          Spacer(),
          Tooltip(
            message: "添加音乐到播放列表",
            useMousePosition: true,
            triggerMode: TooltipTriggerMode.manual,
            //TODO 尝试添加动画效果
            //TODO 添加选择文件夹并搜索文件夹内的音乐文件
            child: IconButton(
              key: ValueKey('add_music_button'),
              onPressed: () async {
                var file = await openFile(acceptedTypeGroups: [
                  XTypeGroup(
                      label: 'audio',
                      extensions: ['mp3', 'wav', 'flac', 'm4a', 'aac'])
                ]);
                if (file != null) {
                  String name = file.name.split('\\').last;
                  print("name:$name");
                  Provider.of<BottomMusicPlayerProvider>(context, listen: false)
                      .addMusic(MusicInfo(
                          musicName: name,
                          source: DeviceFileSource(file.path),
                          sourceType: SourceType.file));
                }
              },
              icon: Icon(
                MyIcon.add,
                size: 24,
              ),
            ),
          ),
          Tooltip(
            message: "添加音乐到播放列表",
            useMousePosition: true,
            triggerMode: TooltipTriggerMode.manual,
            //TODO 尝试添加动画效果
            //TODO 添加选择文件夹并搜索文件夹内的音乐文件
            child: IconButton(
              key: ValueKey('add_music_button_ncm'),
              onPressed: () async {
                var file = await openFile(acceptedTypeGroups: [
                  XTypeGroup(label: 'audio', extensions: ['ncm'])
                ]);
                if (file != null) {
                  final inputPath = file.path.toNativeUtf8();
                  final outputDir = path.dirname(file.path).toNativeUtf8();

                  decryptFile(inputPath, outputDir);
                  malloc.free(inputPath);
                  malloc.free(outputDir);

                  String dir = path.dirname(file.path);
                  String outputFilePath = isMp3OrFlac(
                      dir: dir,
                      outputFileNameWithoutExtension:
                          path.basenameWithoutExtension(file.name));
                  var metaData =
                      readMetadata(File('$dir\\$outputFilePath').absolute);
                  String name = file.name.split('\\').last;
                  print("name:$name");
                  Provider.of<BottomMusicPlayerProvider>(context, listen: false)
                      .addMusic(MusicInfo(
                          musicName: metaData.title ?? name,
                          musicArtist: metaData.artist,
                          musicAlbum: metaData.album,
                          source: DeviceFileSource('$dir\\$outputFilePath'),
                          sourceType: SourceType.file));
                }
              },
              icon: Icon(
                FluentIcons.add_bookmark,
                size: 24,
              ),
            ),
          ),
          IconButton(
              icon: Icon(
                MyIcon.playList,
                size: 24,
              ),
              onPressed: () {
                showGeneralDialog(
                    barrierColor: Colors.transparent,
                    barrierLabel: "Play list",
                    barrierDismissible: true,
                    context: context,
                    transitionBuilder: (context, a1, a2, widget) {
                      return material.SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1, 0),
                          end: Offset.zero,
                        )
                            .chain(CurveTween(curve: Curves.bounceInOut))
                            .animate(a1),
                        child: widget,
                      );
                    },
                    pageBuilder: (context, animation1, animation2) {
                      return MusicList();
                    });
              })
        ],
      ),
    );
  }

  String isMp3OrFlac(
      {required String dir, required String outputFileNameWithoutExtension}) {
    final outputPathMp3 = path.join(dir, '$outputFileNameWithoutExtension.mp3');
    final outputPathFlac =
        path.join(dir, '$outputFileNameWithoutExtension.flac');

    if (File(outputPathMp3).existsSync()) {
      return "$outputFileNameWithoutExtension.mp3";
    } else if (File(outputPathFlac).existsSync()) {
      return "$outputFileNameWithoutExtension.flac";
    } else {
      //TODO 添加 displayInfoBar 来显示错误信息
      throw "Decryption failed";
    }
  }
}

class Mid extends StatelessWidget {
  const Mid({
    super.key,
    required this.audioPlayer,
    required this.smtcWindows,
  });

  final AudioPlayer audioPlayer;
  final SMTCWindows smtcWindows;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 75,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 4),
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
                      Provider.of<BottomMusicPlayerProvider>(context,
                              listen: false)
                          .playPrevious();
                    },
                  ),
                  ValueListenableBuilder<PlayerState?>(
                    valueListenable: Provider.of<BottomMusicPlayerProvider>(
                            context,
                            listen: false)
                        .playerStateNotifier,
                    builder: (context, playerState, child) {
                      print("Player state have been changed to $playerState");
                      return IconButton(
                        icon: CircleAvatar(
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 200),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: child,
                              );
                            },
                            child: Icon(
                              key: ValueKey(playerState),
                              size: 24,
                              color: Colors.white,
                              playerState == PlayerState.playing
                                  ? MyIcon.pause
                                  : MyIcon.play,
                            ),
                          ),
                        ),
                        onPressed: () {
                          final provider =
                              Provider.of<BottomMusicPlayerProvider>(context,
                                  listen: false);
                          if (provider.getCurrentMusicIndex == -1) {
                            displayInfoBar(context, builder: (context, close) {
                              return InfoBar(
                                title: const Text('列表为空！'),
                                content: const Text('列表为空，不能播放音乐，请先添加音乐到播放列表！'),
                                action: IconButton(
                                  icon: const Icon(FluentIcons.clear),
                                  onPressed: close,
                                ),
                                severity: InfoBarSeverity.error,
                              );
                            });
                            return;
                          }
                          if (playerState == PlayerState.playing) {
                            provider.setPlayerState(PlayerState.paused);
                          } else {
                            provider.setPlayerState(PlayerState.playing);
                          }
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      MyIcon.nextSong,
                      size: 20,
                    ),
                    onPressed: () {
                      context.read<BottomMusicPlayerProvider>().playNext();
                    },
                  ),
                  ValueListenableBuilder<MyPlayerMode>(
                    valueListenable: Provider.of<BottomMusicPlayerProvider>(
                            context,
                            listen: false)
                        .playerModeNotifier,
                    builder: (context, playerMode, child) {
                      print("Play mode have been changed to $playerMode");
                      return IconButton(
                        icon: PlayModeIcon.setIconWithPlayMode(playerMode),
                        onPressed: () {
                          final provider =
                              Provider.of<BottomMusicPlayerProvider>(context,
                                  listen: false);
                          provider.setPlayerMode(MyPlayerMode.values[
                              (provider.playerModeNotifier.value.index + 1) %
                                  MyPlayerMode.values.length]);
                        },
                      );
                    },
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              width: 400,
              child: BottomProgressIndicator(
                audioPlayer: audioPlayer,
                smtcWindows: smtcWindows,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Left extends StatefulWidget {
  const Left({
    super.key,
  });

  @override
  State<Left> createState() => _LeftState();
}

class _LeftState extends State<Left> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 20),
      lowerBound: 0,
      upperBound: 2 * 3.1415926,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  CircleAvatar tryToSetMusicAvatar(BottomMusicPlayerProvider provider) {
    final musicList = provider.musicListNotifier.value;
    if (musicList.isNotEmpty) {
      return CircleAvatar(
        backgroundImage:
            NetworkImage(musicList[provider.getCurrentMusicIndex].musicAvatar!),
      );
    } else {
      return CircleAvatar(
        child: const Icon(FluentIcons.music_note),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
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
                icon: ValueListenableBuilder<PlayerState?>(
                  valueListenable: Provider.of<BottomMusicPlayerProvider>(
                          context,
                          listen: false)
                      .playerStateNotifier,
                  builder: (context, playerState, child) {
                    if (playerState == PlayerState.playing) {
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
                                    color: Color.fromRGBO(45, 45, 56, 1),
                                  ),
                                  child: Image.asset("assets/img/black.png"),
                                ),
                              ),
                              Center(
                                child: context
                                        .watch<BottomMusicPlayerProvider>()
                                        .musicListNotifier
                                        .value
                                        .isEmpty
                                    ? CircleAvatar(
                                        child:
                                            const Icon(FluentIcons.music_note),
                                      )
                                    : context
                                                .watch<
                                                    BottomMusicPlayerProvider>()
                                                .musicListNotifier
                                                .value[context
                                                    .watch<
                                                        BottomMusicPlayerProvider>()
                                                    .getCurrentMusicIndex]
                                                .musicAvatar ==
                                            null
                                        ? CircleAvatar(
                                            child: const Icon(
                                                FluentIcons.music_note),
                                          )
                                        : CircleAvatar(
                                            backgroundImage: NetworkImage(context
                                                .watch<
                                                    BottomMusicPlayerProvider>()
                                                .musicListNotifier
                                                .value[context
                                                    .watch<
                                                        BottomMusicPlayerProvider>()
                                                    .getCurrentMusicIndex]
                                                .musicAvatar!),
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
            ValueListenableBuilder(
                valueListenable: Provider.of<BottomMusicPlayerProvider>(context,
                        listen: true)
                    .currentMusicIndexNotifier,
                builder: (context, value, child) {
                  final provider = Provider.of<BottomMusicPlayerProvider>(
                      context,
                      listen: false);
                  return Positioned(
                    left: 85,
                    child: SizedBox(
                      width: 225,
                      height: 75,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //TODO 当歌曲名过长时 添加歌曲名和歌手名的滚动效果
                          FittedBox(
                            child: Text(
                              provider.musicListNotifier.value.isNotEmpty
                                  ? provider
                                          .musicListNotifier
                                          .value[provider.getCurrentMusicIndex]
                                          .musicName ??
                                      '未知歌曲名'
                                  : "未知歌曲名",
                              style:
                                  FluentTheme.of(context).typography.subtitle,
                            ),
                          ),
                          Text(
                            provider.musicListNotifier.value.isNotEmpty
                                ? provider
                                        .musicListNotifier
                                        .value[provider.getCurrentMusicIndex]
                                        .musicArtist ??
                                    '未知歌手'
                                : "未知歌手",
                            style: FluentTheme.of(context).typography.caption,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
