import 'package:fluent_ui/fluent_ui.dart';
import 'package:netease_cloud_music/Icon/Icon.dart';

List<NavigationPaneItem> myMusicNavigationPaneItems = <NavigationPaneItem>[
  PaneItem(
    icon: Icon(
      MyIcon.myLoveMusic,
      size: 15,
    ),
    title: const Text('我喜欢的音乐'),
    //TODO 添加我喜欢的音乐的子项
    body: Placeholder(),
    selectedTileColor: WidgetStateProperty.all(Color.fromRGBO(250, 45, 73, 1)),
  ),
  PaneItem(
    icon: Icon(
      MyIcon.recentPlay,
      size: 15,
    ),
    title: const Text('最近播放'),
    //TODO 添加最近播放的子项
    body: Placeholder(),
    selectedTileColor: WidgetStateProperty.all(Color.fromRGBO(250, 45, 73, 1)),
  ),
  PaneItem(
    icon: Icon(MyIcon.myCollection, size: 15),
    title: const Text('我的收藏'),
    //TODO 添加我的收藏的子项
    body: Placeholder(),
    selectedTileColor: WidgetStateProperty.all(Color.fromRGBO(250, 45, 73, 1)),
  ),
];
