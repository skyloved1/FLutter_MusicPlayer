import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;

class SettingDemo2 extends StatefulWidget {
  const SettingDemo2({super.key});

  @override
  State<SettingDemo2> createState() => _SettingDemo2State();
}

class _SettingDemo2State extends State<SettingDemo2>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final material.TabController _tabController =
      material.TabController(length: 3, vsync: this);
  final List<material.Tab> tabs = [
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
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return material.Material(
      type: material.MaterialType.transparency,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: const Text(
                "设置",
                textScaler: TextScaler.linear(2.5),
              ),
            ),
          ),
          material.SliverAppBar(
            floating: true,
            title: material.TabBar(
              tabs: tabs,
              controller: _tabController,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 2000,
            ),
          ),
        ],
      ),
    );
  }
}
