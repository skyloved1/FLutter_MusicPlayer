import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;

class SeetingPage extends StatefulWidget {
  const SeetingPage({super.key});

  @override
  State<SeetingPage> createState() => _SeetingPageState();
}

class _SeetingPageState extends State<SeetingPage>
    with SingleTickerProviderStateMixin {
  material.TabController? tabController;
  ScrollController scrollController = ScrollController();
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
    final scrollPosition = scrollController.position.pixels;
    if (scrollPosition < 200) {
      tabController?.animateTo(0);
    } else if (scrollPosition < 2200) {
      tabController?.animateTo(1);
    } else {
      tabController?.animateTo(2);
    }
  }

  void _onTabChanged() {
    if (tabController?.indexIsChanging ?? false) {
      switch (tabController?.index) {
        case 0:
          scrollController.animateTo(0,
              duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          break;
        case 1:
          scrollController.animateTo(200,
              duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          break;
        case 2:
          scrollController.animateTo(2200,
              duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
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
        child: NotificationListener<Notification>(
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
              )),
        ));
  }
}
