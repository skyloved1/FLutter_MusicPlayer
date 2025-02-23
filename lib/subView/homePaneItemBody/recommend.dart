import 'package:file_selector/file_selector.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:netease_cloud_music/provider/bottomMusicPlayerProvider.dart';
import 'package:provider/provider.dart';

class RecommendRoute extends StatelessWidget {
  const RecommendRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Button(
            onPressed: () async {
              var file = await openFile(acceptedTypeGroups: [
                XTypeGroup(label: 'audio', extensions: ['mp3', 'wav', 'flac'])
              ]);
              context
                  .read<BottomMusicPlayerProvider>()
                  .setMusicSource(type: SourceType.file, value: file?.path);
            },
            child: Text("Set Source")),
      ],
    );
  }
}
