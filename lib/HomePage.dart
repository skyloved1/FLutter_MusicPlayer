import 'package:fluent_ui/fluent_ui.dart';
import 'package:netease_cloud_music/Icon/Icon.dart';
import 'package:netease_cloud_music/subView/MyMusic.dart';
import 'package:netease_cloud_music/subView/account.dart';
import 'package:netease_cloud_music/subView/recommend.dart';
import 'package:smtc_windows/smtc_windows.dart';
import 'package:window_manager/window_manager.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SMTCWindows smtc;

  @override
  void initState() {
    super.initState();
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
    // Dispose SMTC
    smtc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NavigationViewRoute(),
        //TODO 添加底部播放器
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 76,
            child: Placeholder(),
          ),
        )
      ],
    );
  }
}

class NavigationViewRoute extends StatefulWidget {
  NavigationViewRoute({
    super.key,
  });

  List<NavigationPaneItem> items = <NavigationPaneItem>[
    PaneItem(
      icon: Icon(MyIcon.appIcon),
      title: Text('推荐'),
      //TODO 添加推荐的子项
      body: RecommendRoute(),
      selectedTileColor:
          WidgetStateProperty.all(Color.fromRGBO(250, 45, 73, 1)),
    ),
    PaneItem(
      icon: Icon(MyIcon.appIcon),
      title: Text('精选'),
      //TODO 添加精选的子项
      body: const Text("精选"),
      selectedTileColor:
          WidgetStateProperty.all(Color.fromRGBO(250, 45, 73, 1)),
    ),
    PaneItem(
      icon: Icon(MyIcon.appIcon),
      title: Text('关注'),
      //TODO 添加关注的子项
      body: const Text("关注"),
      selectedTileColor:
          WidgetStateProperty.all(Color.fromRGBO(250, 45, 73, 1)),
    ),
    PaneItemSeparator(),
    PaneItemExpander(
      title: Text('我的音乐'),
      icon: SizedBox(),
      //TODO 添加我的音乐的子项
      items: myMusicNavigationPaneItems,
      body: Placeholder(),
    ),
    PaneItem(
      icon: Icon(MyIcon.appIcon),
      title: Text('本地音乐'),
      body: const Text("本地音乐"),
      selectedTileColor:
          WidgetStateProperty.all(Color.fromRGBO(250, 45, 73, 1)),
    ),
  ];

  var WindowsButtons = WindowsButton();
  var title = DragToMoveArea(
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        '网易云音乐',
        textScaler: TextScaler.linear(2.0),
        style: TextStyle(
          fontFamily: "楷体",
        ),
      ),
    ),
  );

  @override
  State<NavigationViewRoute> createState() => _NavigationViewRouteState();
}

class _NavigationViewRouteState extends State<NavigationViewRoute> {
  int seletedIndex = 0;

  _openSettingWindow() {
    //TODO 设置跳转  方法
  }

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(
        leading: const Icon(
          MyIcon.appIcon2,
          size: 35,
          fill: 1,
          color: Color.fromARGB(250, 255, 42, 90),
        ),
        title: widget.title,
        actions: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Account(),
            IconButton(
                icon: Icon(
                  MyIcon.setting,
                  size: 20,
                  color: Colors.grey[80],
                ),
                onPressed: () {
                  //TODO 打开设置窗口
                }),
            SizedBox(
              width: 15,
            ),
            RotatedBox(
              quarterTurns: 1,
              child: SizedBox(
                width: 40,
                child: Divider(
                  style: DividerThemeData(
                      thickness: 1,
                      decoration: BoxDecoration(color: Colors.grey[130])),
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            widget.WindowsButtons,
          ],
        ),
      ),
      pane: NavigationPane(
        indicator: StickyNavigationIndicator(
          color: Colors.white,
        ),
        size: NavigationPaneSize(
          openMaxWidth: 175,
          compactWidth: 50,
        ),
        displayMode: PaneDisplayMode.open,
        header: SizedBox(
          height: 25,
        ),
        selected: seletedIndex,
        onChanged: (index) {
          setState(() {
            seletedIndex = index;
          });
        },
        onItemPressed: (index) {
          print("index: $index");
        },
        items: widget.items,
      ),
    );
  }
}

/// 这里是一个自定义的窗口按钮
class WindowsButton extends StatelessWidget {
  final double width;
  final double height;

  const WindowsButton({super.key, this.width = 138, this.height = 50});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        child: WindowCaption(
          brightness: Brightness.dark,
        ));
  }
}
