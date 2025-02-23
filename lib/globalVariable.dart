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

/*
Consumer<BottomMusicPlayerProvider>(
builder: (context, provider, child) {
if (provider.musicSource != null) {
switch (provider.sourceType) {
case SourceType.url:
provider.player.setSource(UrlSource(provider.musicSource!));
break;
case SourceType.asset:
provider.player
    .setSource(AssetSource(provider.musicSource!));
break;
case SourceType.file:
provider.player
    .setSource(DeviceFileSource(provider.musicSource!));
break;
case SourceType.bytes:
provider.player
    .setSource(BytesSource(provider.musicBytes!));
}
provider.player.getDuration().then((value) {
provider.setSongDuration(value ?? Duration.zero);
});
}

switch (provider.playerState) {
case PlayerState.playing:
provider.player.resume();
break;
case PlayerState.paused:
provider.player.pause();
break;
case PlayerState.stopped:
provider.player.stop();
break;
case null:
provider.player.stop();
break;
case PlayerState.completed:
provider.player.seek(Duration.zero);
break;
case PlayerState.disposed:
provider.player.stop();
}

provider.smtc.updateMetadata(MusicMetadata(
title: provider.musicName ?? '歌曲名',
artist: provider.musicArtist ?? '歌手名',
album: provider.musicAlbum ?? '专辑名',
));

return Visibility(
visible: false,
child: Container(),
);
},
)*/
