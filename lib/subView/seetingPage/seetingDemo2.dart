import 'package:flutter/material.dart';

class SettingDemo2 extends StatefulWidget {
  const SettingDemo2({super.key});

  @override
  State<SettingDemo2> createState() => _SettingDemo2State();
}

class _SettingDemo2State extends State<SettingDemo2>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final TabController _tabController;
  final headerKey = GlobalKey();
  List<Tab> tabs = [
    Tab(
      text: "账号",
    ),
    Tab(
      text: "通用",
    ),
    Tab(
      text: "关于",
    ),
  ];
  late final List<Widget> tabViews;
  late final List<GlobalKey> tabViewsKeys;

  @override
  void initState() {
    _scrollController = ScrollController();
    _tabController = TabController(length: tabs.length, vsync: this);
    tabViewsKeys = tabs.map((e) => GlobalKey()).toList();
    //TODO 添加设置页面内容
    tabViews = [
      Container(
        key: tabViewsKeys[0],
        height: 200,
        child: ListTile(
          title: Text(
            "账号",
            style: TextStyle(fontFamily: "黑体"),
          ),
        ),
      ),
      Container(
        key: tabViewsKeys[1],
        height: 2000,
        child: ListView(children: [
          ListTile(
            title: Text(
              "通用",
              style: TextStyle(fontFamily: "黑体"),
            ),
          ),
        ]),
      ),
      Container(
        key: tabViewsKeys[2],
        height: 2000,
        child: ListView(children: [
          ListTile(
            title: Text(
              "关于",
              style: TextStyle(fontFamily: "黑体"),
            ),
          ),
        ]),
      ),
    ];
    super.initState();
  }

  double caculateScrollOffset(int index) {
    double offset = 0;
    for (int i = 0; i < index; i++) {
      offset += tabViewsKeys[i].currentContext!.size!.height;
    }
    return offset;
  }

  int caculateTabIndex(double offset) {
    double temp = 0;
    for (int i = 0; i < tabViewsKeys.length; i++) {
      temp += tabViewsKeys[i].currentContext!.size!.height;
      if (temp > offset) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollStartNotification) {
          print('Scroll Start');
        } else if (notification is ScrollUpdateNotification) {
          print('Scroll Update');
        } else if (notification is ScrollEndNotification) {
          print('Scroll End');
          _tabController.animateTo(caculateTabIndex(_scrollController.offset));
        }
        return false;
      },
      child: Material(
        textStyle: TextStyle(fontFamily: "黑体"),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverPersistentHeader(
                key: headerKey,
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  onTap: (index) {
                    _scrollController.animateTo(
                      caculateScrollOffset(index),
                      duration: Duration(milliseconds: 200),
                      curve: Curves.bounceInOut,
                    );
                  },
                  tabController: _tabController,
                  tabs: tabs,
                  height: 120,
                )),
            for (int i = 0; i < tabs.length; i++)
              SliverToBoxAdapter(
                child: tabViews[i],
              ),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  final List<Widget> tabs;
  final num height;
  final Function(int) onTap;

  _SliverAppBarDelegate({
    required this.tabController,
    required this.tabs,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Color(0xff27272d),
      height: height.toDouble(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 32, top: 16),
            child: SizedBox(
              width: double.infinity,
              child: const Text(
                "设置",
                style: TextStyle(
                  fontSize: 28,
                ),
              ),
            ),
          ),
          TabBar(
            labelStyle: TextStyle(fontFamily: "黑体"),
            overlayColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) {
                return Colors.grey[850];
              }
              //也可以设置其他状态的颜色，这里仅设置hover悬停时的颜色，其他均为透明
              return Colors.transparent;
            }),
            splashFactory: NoSplash.splashFactory,
            dividerColor: Colors.transparent,
            onTap: onTap,
            controller: tabController,
            tabs: tabs,
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => height.toDouble();

  @override
  double get minExtent => height.toDouble();

  @override
  bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) {
    return oldDelegate.maxExtent != maxExtent ||
        oldDelegate.minExtent != minExtent ||
        oldDelegate.tabs != tabs ||
        oldDelegate.tabController != tabController;
  }
}
