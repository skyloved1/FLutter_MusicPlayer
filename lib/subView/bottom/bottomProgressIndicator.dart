import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:netease_cloud_music/provider/bottomMusicPlayerProvider.dart';
import 'package:provider/provider.dart';

class BottomProgressIndicator extends StatefulWidget {
  BottomProgressIndicator({super.key, required this.audioPlayer});

  final AudioPlayer audioPlayer;

  final DisPlaySongDuration songDuration = DisPlaySongDuration();

  @override
  State<BottomProgressIndicator> createState() =>
      _BottomProgressIndicatorState();
}

class _BottomProgressIndicatorState extends State<BottomProgressIndicator> {
  Duration currentPos = Duration(seconds: 0);
  late final StreamSubscription<Duration> positionSubscription;

  @override
  void initState() {
    super.initState();
    positionSubscription = widget.audioPlayer.onPositionChanged.listen((event) {
      setState(() {
        currentPos = event;
      });
    });
  }

  @override
  void dispose() {
    positionSubscription.cancel();
    super.dispose();
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
        Spacer(flex: 1),
        Expanded(
          flex: 10,
          child: ValueListenableBuilder<Duration?>(
            valueListenable: Provider.of<BottomMusicPlayerProvider>(context)
                .songDurationNotifier,
            builder: (context, totalPos, child) {
              return Slider(
                min: 0,
                max: totalPos?.inSeconds.toDouble() ?? 0,
                value: currentPos.inSeconds
                    .toDouble()
                    .clamp(0, totalPos?.inSeconds.toDouble() ?? 0),
                divisions:
                    (totalPos?.inSeconds ?? 1) > 0 ? totalPos?.inSeconds : null,
                onChanged: (value) {
                  widget.audioPlayer.seek(Duration(seconds: value.toInt()));
                },
              );
            },
          ),
        ),
        Spacer(flex: 1),
        widget.songDuration,
      ],
    );
  }
}

class DisPlaySongDuration extends StatefulWidget {
  const DisPlaySongDuration({super.key});

  @override
  State<DisPlaySongDuration> createState() => _DisPlaySongDurationState();
}

class _DisPlaySongDurationState extends State<DisPlaySongDuration> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Duration?>(
      valueListenable:
          Provider.of<BottomMusicPlayerProvider>(context).songDurationNotifier,
      builder: (BuildContext context, Duration? duration, Widget? child) {
        return Text(_formatDuration(duration ?? Duration.zero));
      },
    );
  }
}

String _formatDuration(Duration duration) {
  return "${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}";
}
