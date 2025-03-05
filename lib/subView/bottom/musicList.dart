import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

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
    final musicListNotifier =
        Provider.of<BottomMusicPlayerProvider>(context, listen: true)
            .musicListNotifier;
    return Stack(
      children: [
        Positioned(
            child: DragToMoveArea(
          child: SizedBox(
            width: double.infinity,
            height: 75,
          ),
        )),
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
                  child: CustomScrollView(
                    slivers: [
                      material.SliverAppBar(
                        backgroundColor: Color.fromRGBO(45, 45, 56, 1),
                        leading: IconButton(
                            icon: Icon(FluentIcons.chrome_back_mirrored),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        title: Text("播放列表"),
                        actions: [
                          IconButton(
                            icon: Icon(FluentIcons.delete),
                            onPressed: () {
                              Provider.of<BottomMusicPlayerProvider>(context,
                                      listen: false)
                                  .clearMusicList();
                            },
                          )
                        ],
                      ),
                      SliverAnimatedList(
                          initialItemCount: musicListNotifier.value.length,
                          itemBuilder: (context, index, animation) {
                            return SizeTransition(
                              sizeFactor: animation,
                              child: ListTile(
                                title: Text(
                                    musicListNotifier.value[index].musicName ??
                                        "未知歌曲"),
                                subtitle: Text(musicListNotifier
                                        .value[index].musicArtist ??
                                    "未知歌手"),
                                onPressed: () {
                                  Provider.of<BottomMusicPlayerProvider>(
                                      context,
                                      listen: false)
                                    ..currentMusicIndexNotifier.value = index
                                    ..playMusicAt(index);
                                },
                              ),
                            );
                          })
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
