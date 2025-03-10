import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;

class SettingDemo1 extends StatefulWidget {
  const SettingDemo1({super.key});

  @override
  State<SettingDemo1> createState() => _SettingDemo1State();
}

class _SettingDemo1State extends State<SettingDemo1>
    with SingleTickerProviderStateMixin {
  material.TabController? tabController;
  ScrollController scrollController = ScrollController();
  bool isAnimating = false;

  late final List<GlobalKey<State<StatedWidgetInSettingListTile>>> posKeyList;

  List<Widget> tabs = [
    DefaultTextStyle(
      style: TextStyle(
        fontFamily: "si_yuan_hei_ti",
        fontWeight: FontWeight.w900,
      ),
      child: material.Tab(
        text: "账号",
      ),
    ),
    DefaultTextStyle(
      style: TextStyle(
        fontFamily: "si_yuan_hei_ti",
        fontWeight: FontWeight.w900,
      ),
      child: material.Tab(
        text: "通用",
      ),
    ),
    DefaultTextStyle(
      style: TextStyle(
        fontFamily: "si_yuan_hei_ti",
        fontWeight: FontWeight.w900,
      ),
      child: material.Tab(
        text: "关于",
      ),
    ),
  ];
  @override
  void initState() {
    tabController = material.TabController(length: tabs.length, vsync: this);
    scrollController.addListener(_onScroll);
    posKeyList = tabs
        .map((e) => GlobalKey<State<StatedWidgetInSettingListTile>>(
            debugLabel: e.toString()))
        .toList();
    super.initState();
  }

  void _onScroll() {
    if (isAnimating) return;

    final scrollPosition = scrollController.position.pixels;
    for (var key in posKeyList) {
      int index = 0;
      final position = _getPosition(key);
      if (scrollPosition >= position) {
        index = posKeyList.indexOf(key);
        tabController?.animateTo(index);
      }
    }
  }

  void _onTabChanged() {
    if (tabController?.indexIsChanging ?? false) {
      isAnimating = true;
      final index = tabController?.index ?? 0;
      final key = posKeyList[index];
      _scrollToPosition(key);
    }
  }

  double _getPosition(GlobalKey key) {
    final context = key.currentContext;
    final renderBox = context!.findRenderObject();
    if (renderBox is RenderBox) {
      return renderBox.localToGlobal(Offset.zero).dy;
    }
    return 0.0;
  }

  void _scrollToPosition(GlobalKey key) {
    final position = _getPosition(key);
    print("Position:${position}");
    scrollController
        .animateTo(position,
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut)
        .then((_) {
      isAnimating = false;
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return material.Material(
        textStyle: material.TextStyle(
            fontFamily: "si_yuan_hei_ti", fontWeight: FontWeight.w900),
        color: material.Colors.transparent,
        type: material.MaterialType.transparency,
        surfaceTintColor: material.Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        borderOnForeground: false,
        child: DefaultTextStyle(
          style: TextStyle(
            fontFamily: "si_yuan_hei_ti",
            fontWeight: FontWeight.w900,
          ),
          child: material.Scaffold(
            backgroundColor: Colors.transparent,
            appBar: material.AppBar(
                toolbarHeight: 75,
                title: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: const Text(
                    "设置",
                    style: material.TextStyle(
                      fontFamily: "si_yuan_hei_ti",
                      fontSize: 32,
                      fontWeight: material.FontWeight.w500,
                    ),
                  ),
                ),
                surfaceTintColor: material.Colors.transparent,
                backgroundColor: material.Colors.transparent),
            body: material.Scaffold(
                backgroundColor: material.Colors.transparent,
                appBar: material.TabBar(
                  onTap: (index) {
                    _onTabChanged();
                  },
                  overlayColor:
                      material.WidgetStateProperty.resolveWith<Color?>(
                          (Set<material.WidgetState> states) {
                    if (states.isHovered) {
                      return material.Colors.grey[850];
                    }
                    return Colors.transparent;
                  }),
                  splashFactory: material.NoSplash.splashFactory,
                  dividerColor: Colors.transparent,
                  tabs: tabs,
                  controller: tabController,
                ),
                body: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    _onScroll();
                    return true;
                  },
                  child: ListView(
                    controller: scrollController,
                    children: [
                      StatedWidgetInSettingListTile(
                        key: posKeyList[0],
                        child: SizedBox(
                          height: 200,
                          child: material.ListView(children: [
                            ListTile(
                              title: Text("账号"),
                            ),
                          ]),
                        ),
                      ),
                      StatedWidgetInSettingListTile(
                        key: posKeyList[1],
                        child: SizedBox(
                          height: 1000,
                          child: material.ListView(children: [
                            ListTile(
                              title: Text("通用"),
                            ),
                          ]),
                        ),
                      ),
                      StatedWidgetInSettingListTile(
                        key: posKeyList[2],
                        child: SizedBox(
                          height: 2000,
                          child: material.ListView(children: [
                            ListTile(
                              title: Text("关于"),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ));
  }
}

/// 用于在设置页面中的ListTile中使用StatefulWidget
/// [AutomaticKeepAliveClientMixin]用于保持状态,避免滑出屏幕后对应的[RenderBox]消失，导致不能寻找滑动位置
class StatedWidgetInSettingListTile extends StatefulWidget {
  const StatedWidgetInSettingListTile({super.key, required this.child});
  final Widget child;

  static int count = 0;

  @override
  State<StatedWidgetInSettingListTile> createState() =>
      _StatedWidgetInSettingListTileState();
}

class _StatedWidgetInSettingListTileState
    extends State<StatedWidgetInSettingListTile>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      child: widget.child,
    );
  }

  @override
  void dispose() {
    print("current StatedWidgetInSettingListTileState have been disposed");
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
