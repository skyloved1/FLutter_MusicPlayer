import 'package:audioplayers/audioplayers.dart';
import 'package:fluent_ui/fluent_ui.dart';

enum MyPlayerMode {
  listLoop,
  singleLoop,
  sequencePlay,
  heartPatten,
  randomPlay,
}

class BottomMusicPlayerProvider with ChangeNotifier {
  String? _musicAvatar;
  String? _musicName;
  String? _musicArtist;
  String? _musicSource;
  PlayerState? _playerState;
  MyPlayerMode _playerMode = MyPlayerMode.sequencePlay;

  String? get musicAvatar => _musicAvatar;

  String? get musicName => _musicName;

  String? get musicArtist => _musicArtist;

  String? get musicSource => _musicSource;

  MyPlayerMode get playerMode => _playerMode;

  PlayerState? get playerState => _playerState;

  void setMusicAvatar(String value) {
    _musicAvatar = value;
    notifyListeners();
  }

  void setMusicName(String value) {
    _musicName = value;
    notifyListeners();
  }

  void setMusicArtist(String value) {
    _musicArtist = value;
    notifyListeners();
  }

  void setMusicSource(String value) {
    _musicSource = value;
    notifyListeners();
  }

  void setPlayerState(PlayerState value) {
    _playerState = value;
    notifyListeners();
  }

  void setPlayerMode(MyPlayerMode value) {
    _playerMode = value;
    notifyListeners();
  }
}
