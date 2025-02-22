import 'package:fluent_ui/fluent_ui.dart';

class BottomMusicPlayerProvider with ChangeNotifier {
  String? _musicAvatar;
  String? _musicName;
  String? _musicArtist;
  bool _onHover = false;

  String? get musicAvatar => _musicAvatar;
  String? get musicName => _musicName;
  String? get musicArtist => _musicArtist;
  bool get onHover => _onHover;

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

  void setHover(bool value) {
    _onHover = value;
    notifyListeners();
  }
}
