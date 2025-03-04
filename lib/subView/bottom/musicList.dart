import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';

import '../../provider/bottomMusicPlayerProvider.dart';

class MusicList extends StatelessWidget {
  const MusicList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    print("列表重建");
    print(
        "重建后的列表长度为${Provider.of<BottomMusicPlayerProvider>(context, listen: false).musicListNotifier.value.length}");
    return Stack(
      children: [
        Positioned(
          right: 0,
          top: 50 + 25,
          bottom: 75 + 25,
          child: SizedBox(
            width: 350,
            height: MediaQuery.of(context).size.height,
            child: Transform.rotate(
              angle: pi,
              child: material.Drawer(
                key: ValueKey("playListDrawer"),
                backgroundColor: Color.fromRGBO(45, 45, 56, 1),
                child: Transform.rotate(
                  angle: -pi,
                  //TODO  完成播放列表组件
                  child: CustomScrollView(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
