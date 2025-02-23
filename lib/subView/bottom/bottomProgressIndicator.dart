import 'package:audioplayers/audioplayers.dart';
import 'package:fluent_ui/fluent_ui.dart';

class BottomProgressIndicator extends StatefulWidget {
  const BottomProgressIndicator({super.key});

  @override
  State<BottomProgressIndicator> createState() =>
      _BottomProgressIndicatorState();
}

class _BottomProgressIndicatorState extends State<BottomProgressIndicator> {
  late final AudioPlayer audioPlayer;
  Duration currentPos = Duration(seconds: 0);
  Duration totalPos = Duration(seconds: 0);

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer(playerId: "bottomMusicPlayer");
    audioPlayer.onPositionChanged.listen((event) {
      setState(() {
        currentPos = event;
      });
    });
  }

  String _formatDuration(Duration duration) {
    return "${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(_formatDuration(currentPos)),
        Spacer(
          flex: 1,
        ),
        Expanded(
            flex: 10,
            child: Slider(
                min: 0,
                max: totalPos.inSeconds.toDouble(),
                value: currentPos.inSeconds.toDouble(),
                divisions: 1,
                onChanged: (value) {
                  audioPlayer.seek(
                    Duration(seconds: (value * totalPos.inSeconds).toInt()),
                  );
                })),
        Spacer(
          flex: 1,
        ),
        Text(_formatDuration(totalPos)),
      ],
    );
  }
}
