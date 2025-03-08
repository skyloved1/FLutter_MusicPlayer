import 'package:flutter/material.dart';

class SettingDemo2 extends StatefulWidget {
  const SettingDemo2({super.key});

  @override
  State<SettingDemo2> createState() => _SettingDemo2State();
}

class _SettingDemo2State extends State<SettingDemo2>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
        SliverAppBar(),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 2000,
          ),
        ),
      ],
    );
  }
}
