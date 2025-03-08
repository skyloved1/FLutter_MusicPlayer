import 'package:fluent_ui/fluent_ui.dart';
import 'package:netease_cloud_music/Icon/Icon.dart';
import 'package:netease_cloud_music/subView/account/avatar.dart';
import 'package:netease_cloud_music/subView/bottom/bottomMusicPlayer.dart';
import 'package:netease_cloud_music/subView/homePaneItemBody/MyMusic.dart';
import 'package:netease_cloud_music/subView/homePaneItemBody/recommend.dart';
import 'package:netease_cloud_music/subView/seetingPage/seetingDemo2.dart';
import 'package:window_manager/window_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            child: BottomMusicPlayer(),
          ),
        ),
      ],
    );
  }
}

class NavigationViewRoute extends StatefulWidget {
  NavigationViewRoute({
    super.key,
  });

  final List<NavigationPaneItem> items = <NavigationPaneItem>[
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

  /// **为了避免重复创建，将状态类用到的组件提取到这里**
  final windowsButtons = WindowsButton();
  final title = DragToMoveArea(
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        '音乐播放器',
        textScaler: TextScaler.linear(2.0),
        style: TextStyle(
          fontFamily: "楷体",
        ),
      ),
    ),
  );
  final avatar = AvatarWithLoginAndOut();

  @override
  State<NavigationViewRoute> createState() => _NavigationViewRouteState();
}

class _NavigationViewRouteState extends State<NavigationViewRoute> {
  int seletedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
            //widget.avatar,
            IconButton(
                icon: Icon(
                  MyIcon.setting,
                  size: 20,
                  color: Colors.grey[80],
                ),
                onPressed: () {
                  setState(() {
                    //8是 正好是 设置页面的panItem的index
                    seletedIndex = 8;
                  });
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
            widget.windowsButtons,
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
          footerItems: [
            //设置页面
            PaneItem(icon: SizedBox(), body: const SettingDemo2()),
          ]),
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
    return SizedBox(
        width: width,
        height: height,
        child: WindowCaption(
          brightness: Brightness.dark,
        ));
  }
}
