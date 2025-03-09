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
  List<Widget> tabs = [
    material.Tab(
      text: "账号",
    ),
    material.Tab(
      text: "通用",
    ),
    material.Tab(
      text: "关于",
    ),
  ];

  @override
  void initState() {
    tabController = material.TabController(length: tabs.length, vsync: this);
    tabController?.addListener(_onTabChanged);
    scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    if (isAnimating) return;

    final scrollPosition = scrollController.position.pixels;
    int index;
    if (scrollPosition < 200) {
      index = 0;
    } else if (scrollPosition < 2200) {
      index = 1;
    } else {
      index = 2;
    }
    tabController?.animateTo(index);
    print("Current component index: $index");
  }

  void _onTabChanged() {
    if (tabController?.indexIsChanging ?? false) {
      isAnimating = true;
      switch (tabController?.index) {
        case 0:
          scrollController
              .animateTo(0,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut)
              .then((_) {
            isAnimating = false;
          });
          break;
        case 1:
          scrollController
              .animateTo(200,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut)
              .then((_) {
            isAnimating = false;
          });
          break;
        case 2:
          scrollController
              .animateTo(2200,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut)
              .then((_) {
            isAnimating = false;
          });
          break;
      }
    }
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
        color: material.Colors.transparent,
        type: material.MaterialType.transparency,
        child: material.Scaffold(
            appBar: material.TabBar(
              tabs: tabs,
              controller: tabController,
            ),
            body: NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                _onScroll();
                return false;
              },
              child: ListView(
                controller: scrollController,
                children: [
                  Container(
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
                    height: 2000,
                    child: material.ListView(children: [
                      ListTile(
                        title: Text("通用"),
                      ),
                    ]),
                  ),
                  Container(
                    height: 2000,
                    child: material.ListView(children: [
                      ListTile(
                        title: Text("关于"),
                      ),
                    ]),
                  ),
                ],
              ),
            )));
  }
}
