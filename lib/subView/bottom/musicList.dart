import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import '../../globalVariable.dart';
import '../../provider/bottomMusicPlayerProvider.dart';

GlobalKey<SliverAnimatedListState> listKey =
    GlobalKey<SliverAnimatedListState>();

class MusicList extends StatefulWidget {
  const MusicList({
    super.key,
  });

  @override
  State<MusicList> createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  @override
  Widget build(BuildContext context) {
    print("列表重建");
    print(
        "重建后的列表长度为${Provider.of<BottomMusicPlayerProvider>(context, listen: false).musicListNotifier.value.length}");
    final musicListNotifier =
        Provider.of<BottomMusicPlayerProvider>(context, listen: false)
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
                  //TODO  完成播放列表组件 添加音乐avatar
                  child: CustomScrollView(
                    slivers: [
                      material.SliverAppBar(
                        surfaceTintColor: Colors.transparent,
                        pinned: true,
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
                              listKey.currentState
                                  ?.removeAllItems((context, animation) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                          begin: Offset(1, 0),
                                          end: Offset(0, 0))
                                      .animate(animation),
                                  child: MusicListTile(
                                    musicListNotifier: musicListNotifier,
                                    listKey: listKey,
                                    index: 0,
                                  ),
                                );
                              });
                              Future.delayed(Duration(milliseconds: 50), () {
                                Provider.of<BottomMusicPlayerProvider>(context,
                                        listen: false)
                                    .clearMusicList();
                              });
                            },
                          )
                        ],
                      ),
                      ValueListenableBuilder<List<MusicInfo>>(
                        valueListenable: Provider.of<BottomMusicPlayerProvider>(
                                context,
                                listen: true)
                            .musicListNotifier,
                        builder: (BuildContext context, value, Widget? child) {
                          return SliverAnimatedList(
                            key: listKey,
                            initialItemCount: value.length,
                            itemBuilder: (context, index, animation) {
                              var position = Tween<Offset>(
                                      begin: Offset(0, 1), end: Offset(0, 0))
                                  .chain(CurveTween(curve: Curves.decelerate))
                                  .animate(animation);
                              return SlideTransition(
                                position: position,
                                child: ScaleTransition(
                                  scale: animation,
                                  child: MusicListTile(
                                    musicListNotifier: musicListNotifier,
                                    listKey: listKey,
                                    index: index,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
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

class MusicListTile extends StatefulWidget {
  const MusicListTile({
    super.key,
    required this.musicListNotifier,
    required this.listKey,
    required this.index,
  });

  final ValueNotifier<List<MusicInfo>> musicListNotifier;
  final GlobalKey<SliverAnimatedListState> listKey;
  final int index;

  @override
  State<MusicListTile> createState() => _MusicListTileState();
}

class _MusicListTileState extends State<MusicListTile> {
  @override
  Widget build(BuildContext context) {
    Image? musicAvatar;
    var currentIndexValueNotifier =
        Provider.of<BottomMusicPlayerProvider>(context, listen: true)
            .currentMusicIndexNotifier;
    musicAvatar = widget.musicListNotifier.value[widget.index].musicAvatar;

    return ValueListenableBuilder<int>(
      valueListenable: currentIndexValueNotifier,
      builder: (BuildContext context, value, Widget? child) {
        if (value == widget.index) {
          return MusicListTileChild(musicAvatar: musicAvatar, widget: widget);
        }

        return child!;
      },
      child: MusicListTileChild(musicAvatar: musicAvatar, widget: widget),
    );
  }
}

class MusicListTileChild extends StatelessWidget {
  const MusicListTileChild({
    super.key,
    required this.musicAvatar,
    required this.widget,
  });

  final Image? musicAvatar;
  final MusicListTile widget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: ListTile(
        tileColor:
            Provider.of<BottomMusicPlayerProvider>(context, listen: false)
                        .getCurrentMusicIndex ==
                    widget.index
                ? WidgetStatePropertyAll<Color>(
                    Colors.grey[120].withAlpha(255 ~/ 2))
                : null,
        leading: FittedBox(
          child: musicAvatar,
          fit: BoxFit.contain,
        ),
        title: FittedBox(
          child: Text(widget.musicListNotifier.value.isEmpty
              ? "未知歌曲"
              : widget.musicListNotifier.value[widget.index].musicName ??
                  "未知歌曲"),
        ),
        subtitle: FittedBox(
          child: Text(widget.musicListNotifier.value.isEmpty
              ? "未知歌曲"
              : widget.musicListNotifier.value[widget.index].musicArtist ??
                  "未知歌手"),
        ),
        onPressed: () {
          Provider.of<BottomMusicPlayerProvider>(context, listen: false)
            ..currentMusicIndexNotifier.value = widget.index
            ..playMusicAt(widget.index);
        },
        trailing: IconButton(
          icon: Icon(
            FluentIcons.delete,
            size: 24,
          ),
          onPressed: () {
            final provider =
                Provider.of<BottomMusicPlayerProvider>(context, listen: false);
            final musicInfo = widget.musicListNotifier.value[widget.index];

            widget.listKey.currentState?.removeItem(
              widget.index,
              (context, animation) {
                var offset =
                    Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
                        .chain(CurveTween(curve: Curves.decelerate))
                        .animate(animation);
                return SlideTransition(
                  position: offset,
                  child: ListTile(
                    leading: musicAvatar ?? Icon(FluentIcons.music_note),
                    title: Text(widget
                            .musicListNotifier.value[widget.index].musicName ??
                        "未知歌曲"),
                    subtitle: Text(widget.musicListNotifier.value[widget.index]
                            .musicArtist ??
                        "未知歌手"),
                  ),
                );
              },
              duration: Duration(milliseconds: 250),
            );

            Future.delayed(Duration(milliseconds: 1), () {
              provider.removeMusicAt(widget.index);
            });
          },
        ),
      ),
    );
  }
}
