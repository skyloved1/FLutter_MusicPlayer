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

  final GlobalKey posKey1 = GlobalKey();
  final GlobalKey posKey2 = GlobalKey();
  final GlobalKey posKey3 = GlobalKey();

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
    super.initState();
  }

  void _onScroll() {
    if (isAnimating) return;

    final scrollPosition = scrollController.position.pixels;
    int index;
    if (scrollPosition < _getPosition(posKey1)) {
      index = 0;
    } else if (scrollPosition < _getPosition(posKey2)) {
      index = 1;
    } else {
      index = 2;
    }
    tabController?.animateTo(index);
  }

  void _onTabChanged() {
    if (tabController?.indexIsChanging ?? false) {
      isAnimating = true;
      switch (tabController?.index) {
        case 0:
          _scrollToPosition(posKey1);
          break;
        case 1:
          _scrollToPosition(posKey2);
          break;
        case 2:
          _scrollToPosition(posKey3);
          break;
      }
    }
  }

  double _getPosition(GlobalKey key) {
    final context = key.currentContext;

    final renderBox = context?.findRenderObject();
    if (renderBox is RenderBox) {
      return renderBox.localToGlobal(Offset.zero).dy;
    }
    return 0.0;
  }

  void _scrollToPosition(GlobalKey key) {
    final position = _getPosition(key);
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
                      Container(
                        key: posKey1,
                        height: 200,
                        child: material.ListView(children: [
                          ListTile(
                            title: Text("账号"),
                          ),
                          ListTile(
                            title: Text("通用"),
                          ),
                          ListTile(
                            title: Text("关于"),
                          ),
                        ]),
                      ),
                      Container(
                        key: posKey2,
                        height: 2000,
                        child: material.ListView(children: [
                          ListTile(
                            title: Text("通用"),
                          ),
                        ]),
                      ),
                      Container(
                        key: posKey3,
                        height: 2000,
                        child: material.ListView(children: [
                          ListTile(
                            title: Text("关于"),
                          ),
                        ]),
                      ),
                    ],
                  ),
                )),
          ),
        ));
  }
}
