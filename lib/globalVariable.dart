import 'package:audioplayers/audioplayers.dart';
import 'package:fluent_ui/fluent_ui.dart';

import './model/accountModel.dart';

String apiPrefix = "http://localhost:3000";
UserModel? userModel;

enum MyPlayerMode {
  listLoop,
  singleLoop,
  sequencePlay,
  heartPatten,
  randomPlay,
}

enum SourceType { url, asset, file, bytes }

class MusicInfo {
  Source source;
  SourceType sourceType;
  String? musicName;
  String? musicArtist;
  Image? musicAvatar;
  String? musicAlbum;

  MusicInfo({
    required this.source,
    required this.sourceType,
    this.musicName,
    this.musicArtist,
    this.musicAvatar,
    this.musicAlbum,
  }) {
    musicName ??= caculateMusicName(source_: source, sourceType_: sourceType);
    // if (musicAvatar == null) {
    //   tryToSetMusicAvatarWithDeviceFileSource(musicInfo: this);
    // }
  }

  static String caculateMusicName(
      {required Source source_, required SourceType sourceType_}) {
    String? musicName;
    switch (sourceType_) {
      case SourceType.url:
        musicName ??=
            (source_ as UrlSource).url.split("\\").last.split(".").first;
        break;
      case SourceType.asset:
        musicName =
            (source_ as AssetSource).path.split("\\").last.split(".").first;
      case SourceType.file:
        musicName = (source_ as DeviceFileSource)
            .path
            .split("\\")
            .last
            .split(".")
            .first;
        break;
      case SourceType.bytes:
        musicName ??= "未知歌曲";
        break;
    }
    return musicName;
  }
}
