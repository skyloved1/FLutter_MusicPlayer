import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:smtc_windows/smtc_windows.dart';

import '../globalVariable.dart';

enum SourceType { url, asset, file, bytes }

class BottomMusicPlayerProvider with ChangeNotifier {
  String? _musicAvatar;
  String? _musicName;
  String? _musicArtist;
  String? _musicAlbum;
  Uint8List? _musicBytes;
  Duration? _songDuration = Duration.zero;
  ValueNotifier<PlayerState?> playerStateNotifier = ValueNotifier(null);
  ValueNotifier<MyPlayerMode> playerModeNotifier =
      ValueNotifier(MyPlayerMode.sequencePlay);

  final SourceType _sourceType = SourceType.url;
  late final AudioPlayer player;
  late final SMTCWindows smtc;

  String? get musicAvatar => _musicAvatar;

  String? get musicName => _musicName;

  String? get musicArtist => _musicArtist;

  get sourceType => _sourceType;

  get musicBytes => _musicBytes;

  get musicAlbum => _musicAlbum;

  get songDuration => _songDuration;

  get playerState => playerStateNotifier.value;

  void setMusicAvatar(String value) {
    _musicAvatar = value;
    notifyListeners();
  }

  ValueNotifier<Duration?> songDurationNotifier = ValueNotifier(Duration.zero);

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
      // Handle the error, e.g., show a message to the user
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

  BottomMusicPlayerProvider() {
    player = AudioPlayer(playerId: 'bottomMusicPlayer');
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
  }

  @override
  void dispose() {
    print("player disposed");
    smtc.dispose();
    player.dispose();
    playerStateNotifier.dispose();
    playerModeNotifier.dispose();
    super.dispose();
  }
}
