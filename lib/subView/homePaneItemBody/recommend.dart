import 'package:flutter/material.dart';
import 'package:netease_cloud_music/provider/bottomMusicPlayerProvider.dart';
import 'package:provider/provider.dart';

class RecommendRoute extends StatelessWidget {
  const RecommendRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          context
              .read<BottomMusicPlayerProvider>()
              .setMusicSource(type: SourceType.asset, value: "yuanyangxi.mp3");
        },
        child: Text("Set Source"));
  }
}
