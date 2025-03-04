import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:fluent_ui/fluent_ui.dart';

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

  BottomMusicPlayerProvider(
      {required this.player, required this.musicListNotifier});

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
        break;
      case PlayerState.paused:
        player.pause();
        break;
      case PlayerState.stopped:
        player.stop();
        break;
      case PlayerState.completed:
        player.stop();
        break;
      case PlayerState.disposed:
        print("Player has been disposed");
        break;
    }
  }

  void setPlayerMode(MyPlayerMode value) {
    playerModeNotifier.value = value;
  }

  void addMusic(MusicInfo musicInfo) {
    musicListNotifier.value.add(musicInfo);
  }

  void removeMusicWhere(bool Function(MusicInfo) callback) {
    musicListNotifier.value.removeWhere(callback);
  }

  void clearMusicList() {
    musicListNotifier.value.clear();
  }

  void removeMusicAt(int index) {
    musicListNotifier.value.removeAt(index);
  }

  void insertMusic(int index, MusicInfo musicInfo) {
    musicListNotifier.value.insert(index, musicInfo);
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
    int index = musicListNotifier.value
        .indexWhere((element) => element.source == player.source);
    if (index == -1) {
      return;
    }
    if (index == 0) {
      index = musicListNotifier.value.length - 1;
    } else {
      index--;
    }
    playMusicAt(index);
  }

  @override
  void dispose() {
    playerStateNotifier.dispose();
    playerModeNotifier.dispose();
    songDurationNotifier.dispose();
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
