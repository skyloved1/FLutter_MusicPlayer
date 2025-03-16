import 'dart:async';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:smtc_windows/smtc_windows.dart';

import '../globalVariable.dart';

class BottomMusicPlayerProvider with ChangeNotifier {
  Uint8List? _musicBytes;
  Duration? _songDuration = Duration.zero;
  ValueNotifier<PlayerState?> playerStateNotifier = ValueNotifier(null);
  ValueNotifier<MyPlayerMode> playerModeNotifier =
      ValueNotifier(MyPlayerMode.sequencePlay);

  ValueNotifier<Duration?> songDurationNotifier = ValueNotifier(Duration.zero);

  ValueNotifier<int> currentMusicIndexNotifier = ValueNotifier(-1);
  final SourceType _sourceType = SourceType.url;

  late final ValueNotifier<List<MusicInfo>> musicListNotifier;

  late final AudioPlayer player;
  late final SMTCWindows smtcWindows;

  late final StreamSubscription<PressedButton> buttonPressStream;

  BottomMusicPlayerProvider(
      {required this.player,
      required this.musicListNotifier,
      required this.smtcWindows}) {
    buttonPressStream = smtcWindows.buttonPressStream.listen((event) {
      switch (event) {
        case PressedButton.play:
          setPlayerState(PlayerState.playing);
        case PressedButton.pause:
          setPlayerState(PlayerState.paused);
        case PressedButton.next:
          playNext();
        case PressedButton.previous:
          playPrevious();
        case PressedButton.fastForward:
          // TODO: Handle this case.
          throw UnimplementedError();
        case PressedButton.rewind:
          // TODO: Handle this case.
          throw UnimplementedError();
        case PressedButton.stop:
          // TODO: Handle this case.
          throw UnimplementedError();
        case PressedButton.record:
          // TODO: Handle this case.
          throw UnimplementedError();
        case PressedButton.channelUp:
          // TODO: Handle this case.
          throw UnimplementedError();
        case PressedButton.channelDown:
          // TODO: Handle this case.
          throw UnimplementedError();
      }
    });
  }

  get sourceType => _sourceType;

  get musicBytes => _musicBytes;

  get songDuration => _songDuration;

  get playerState => playerStateNotifier.value;

  get getCurrentMusicIndex => currentMusicIndexNotifier.value;

  set currentMusicIndex(int value) {
    currentMusicIndexNotifier.value = value;
  }

  void setSongDuration(Duration value) {
    songDurationNotifier.value = value;
  }

  void setMusicSource(
      {String? value, Uint8List? bytes, type = SourceType.url}) async {
    print("Setting music source: $value");
    try {
      switch (type) {
        case SourceType.url:
          await player
              .setSource(UrlSource(value!))
              .timeout(Duration(seconds: 60));
          break;
        case SourceType.bytes:
          await player
              .setSource(BytesSource(bytes!))
              .timeout(Duration(seconds: 60));
          break;
        case SourceType.asset:
          await player
              .setSource(AssetSource(value!))
              .timeout(Duration(seconds: 60));
          break;
        case SourceType.file:
          await player
              .setSource(DeviceFileSource(value!))
              .timeout(Duration(seconds: 60));
          break;
      }
      var duration = await player.getDuration();
      setSongDuration(duration ?? Duration.zero);
      smtcWindows.setEndTime(duration ?? Duration.zero);
      player.resume();
      setPlayerState(PlayerState.playing);
    } catch (e) {
      print("Error setting music source: $e");
    }
  }

  void setPlayerState(PlayerState value) {
    playerStateNotifier.value = value;
    switch (value) {
      case PlayerState.playing:
        player.resume();
        smtcWindows.setPlaybackStatus(PlaybackStatus.playing);
        break;
      case PlayerState.paused:
        player.pause();
        smtcWindows.setPlaybackStatus(PlaybackStatus.paused);
        break;
      case PlayerState.stopped:
        player.stop();
        smtcWindows.setPlaybackStatus(PlaybackStatus.stopped);
        break;
      case PlayerState.completed:
        player.stop();
        smtcWindows.setPlaybackStatus(PlaybackStatus.stopped);
        break;
      case PlayerState.disposed:
        print("Player has been disposed");
        smtcWindows.setPlaybackStatus(PlaybackStatus.closed);
        break;
    }
  }

  void setPlayerMode(MyPlayerMode value) {
    playerModeNotifier.value = value;
  }

  void addMusic(MusicInfo musicInfo) {
    //TODO: 应当获取AnimatedSliverList的Key，当音乐添加时，插入新的音乐
    musicListNotifier.value.add(musicInfo);
    if (getCurrentMusicIndex == -1) {
      currentMusicIndex = 0;
      playMusicAt(getCurrentMusicIndex);
    }
    musicListNotifier.notifyListeners();
  }

  void removeMusicWhere(bool Function(MusicInfo) callback) {
    musicListNotifier.value.removeWhere(callback);
    musicListNotifier.notifyListeners();
  }

  void clearMusicList() {
    musicListNotifier.value.clear();
    setPlayerState(PlayerState.paused);
    currentMusicIndex = -1;
    smtcWindows.setPlaybackStatus(PlaybackStatus.stopped);
    player.release();
    musicListNotifier.notifyListeners();
  }

  void removeMusicAt(int index) {
    musicListNotifier.value.removeAt(index);
    // 如果当前播放的音乐被删除，应该停止播放
    if (index == getCurrentMusicIndex) {
      setPlayerState(PlayerState.paused);
      player.release();
      currentMusicIndex = getCurrentMusicIndex - 1;
    }
    musicListNotifier.notifyListeners();
  }

  void insertMusic(int index, MusicInfo musicInfo) {
    musicListNotifier.value.insert(index, musicInfo);
    musicListNotifier.notifyListeners();
  }

  void playMusicAt(int index) {
    switch (musicListNotifier.value[index].sourceType) {
      case SourceType.url:
        setMusicSource(
            value: (musicListNotifier.value[index].source as UrlSource).url,
            type: SourceType.url);
        break;
      case SourceType.asset:
        setMusicSource(
            value: (musicListNotifier.value[index].source as AssetSource).path,
            type: SourceType.asset);
        break;
      case SourceType.file:
        setMusicSource(
            value: (musicListNotifier.value[index].source as DeviceFileSource)
                .path,
            type: SourceType.file);
        break;
      case SourceType.bytes:
        setMusicSource(
            bytes: (musicListNotifier.value[index].source as BytesSource).bytes,
            type: SourceType.bytes);
        break;
    }
    smtcWindows.updateMetadata(MusicMetadata(
        title: musicListNotifier.value[index].musicName ?? "未知歌曲",
        artist: musicListNotifier.value[index].musicArtist ?? "未知歌手",
        album: musicListNotifier.value[index].musicAlbum ?? "未知专辑",
        albumArtist: musicListNotifier.value[index].musicArtist ?? "未知歌手",
        thumbnail:
            //TODO 应当替换成本地文件的绝对路径
            "https://p1.music.126.net/0ju8ET1ApZSXfWacc4w49w==/109951169484091680.jpg?param=130y130"));
  }

  void playNext() {
    currentMusicIndex = getCurrentMusicIndex + 1;
    if (getCurrentMusicIndex == -1) {
      this.currentMusicIndex = 0;
    }
    if (getCurrentMusicIndex >= musicListNotifier.value.length) {
      currentMusicIndex = 0;
    }
    playMusicAt(getCurrentMusicIndex);
  }

  void playPrevious() {
    currentMusicIndex = getCurrentMusicIndex - 1;
    if (getCurrentMusicIndex == -1) {
      currentMusicIndex = musicListNotifier.value.length - 1;
    }

    playMusicAt(getCurrentMusicIndex);
  }

  @override
  void dispose() {
    playerStateNotifier.dispose();
    playerModeNotifier.dispose();
    songDurationNotifier.dispose();
    buttonPressStream.cancel();
    super.dispose();
  }

  void deleteMusic(int index) {
    if (index == getCurrentMusicIndex) {
      player.stop();
      currentMusicIndex = -1;
    }
    removeMusicAt(index);
  }
}
