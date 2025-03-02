import 'package:audioplayers/audioplayers.dart';
import 'package:netease_cloud_music/model/accountModel.dart';

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
  String? musicAvatar;
  String? musicAlbum;

  MusicInfo(
      {required this.source,
      required this.sourceType,
      this.musicName,
      this.musicArtist,
      this.musicAvatar,
      this.musicAlbum}) {
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

  static void tryToSetMusicAvatarWithDeviceFileSource(
      {required MusicInfo musicInfo}) async {
    if (musicInfo.sourceType == SourceType.file) {
      final DeviceFileSource deviceFileSource =
          musicInfo.source as DeviceFileSource;
      final String path = deviceFileSource.path;
      //找寻与文件名相同的图片
      var fileName = path.split("/").last.split(".").first;
      DeviceFileSource? musicAvatar;
      try {
        musicAvatar ??=
            DeviceFileSource("assets/images/musicAvatar/$fileName.jpg");
      } catch (e) {
        print(e);
        try {
          musicAvatar ??=
              DeviceFileSource("assets/images/musicAvatar/$fileName.jpeg");
        } catch (e) {
          print(e);
          musicAvatar ??=
              DeviceFileSource("assets/images/musicAvatar/$fileName.webp");
        }
      }
      musicInfo.musicAvatar = musicAvatar.path;
    }
  }
}
