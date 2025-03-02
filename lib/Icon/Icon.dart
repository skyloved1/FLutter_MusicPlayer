import 'package:fluent_ui/fluent_ui.dart';

import '../globalVariable.dart';

class MyIcon {
  static const IconData appIcon = IconData(0xe60b, fontFamily: "musicIcon");
  static const IconData appIcon2 = IconData(0xe60c, fontFamily: "musicIcon");
  static const IconData myLoveMusic = IconData(0xe69e, fontFamily: "musicIcon");
  static const IconData recentPlay = IconData(0xe65d, fontFamily: "musicIcon");
  static const IconData myCollection =
      IconData(0xe601, fontFamily: "musicIcon");
  static const IconData setting = IconData(0xe61c, fontFamily: "musicIcon");
  static const IconData home = IconData(0xe63b, fontFamily: "musicIcon");
  static const IconData like = IconData(0xe69e, fontFamily: "musicIcon");
  static const IconData lastSong = IconData(0xe608, fontFamily: "musicIcon");
  static const IconData nextSong = IconData(0xe609, fontFamily: "musicIcon");
  static const IconData play = IconData(0xe60f, fontFamily: "musicIcon");
  static const IconData pause = IconData(0xe610, fontFamily: "musicIcon");
  static const IconData add = IconData(0xe642, fontFamily: "musicIcon");
  static const IconData playList = IconData(0xea82, fontFamily: "musicIcon");
}

class PlayModeIcon {
  static const IconData listLoop = IconData(0xe606, fontFamily: "musicIcon");
  static const IconData singleLoop = IconData(0xe6ae, fontFamily: "musicIcon");
  static const IconData randomPlay = IconData(0xe622, fontFamily: "musicIcon");
  static const IconData sequencePlay =
      IconData(0xe60a, fontFamily: "musicIcon");
  static const IconData heartPatten = IconData(0xe61a, fontFamily: "musicIcon");

  static Icon setIconWithPlayMode(MyPlayerMode mode, {double iconSize = 24.0}) {
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
