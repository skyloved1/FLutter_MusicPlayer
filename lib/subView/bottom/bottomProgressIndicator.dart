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
  Duration totalPos = Duration(seconds: 0);
  late final StreamSubscription<Duration> subscrib;

  @override
  void initState() {
    super.initState();
    subscrib = widget.audioPlayer.onPositionChanged.listen((event) {
      print("Position changed: $event");
      setState(() {
        currentPos = event;
      });
    });
  }

  @override
  void dispose() {
    subscrib.cancel();
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
        Spacer(
          flex: 1,
        ),
        Expanded(
          flex: 10,
          child: Slider(
            min: 0,
            max: context
                .read<BottomMusicPlayerProvider>()
                .songDuration
                .inSeconds
                .toDouble(),
            value: currentPos.inSeconds
                .toDouble()
                .clamp(0, totalPos.inSeconds.toDouble()),
            divisions: totalPos.inSeconds > 0 ? totalPos.inSeconds : 1,
            onChanged: (value) {
              widget.audioPlayer.seek(
                Duration(seconds: value.toInt()),
              );
            },
          ),
        ),
        Spacer(
          flex: 1,
        ),
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

String _formatDuration(Duration duration) {
  return "${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}";
}

class _DisPlaySongDurationState extends State<DisPlaySongDuration> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable:
          Provider.of<BottomMusicPlayerProvider>(context).musicSourceNotifier,
      builder: (BuildContext context, duration, Widget? child) {
        return FutureBuilder(
          future: Provider.of<BottomMusicPlayerProvider>(context, listen: false)
              .player
              .getDuration(),
          builder: (BuildContext context, AsyncSnapshot<Duration?> snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            if (snapshot.hasData) {
              return Text(_formatDuration(snapshot.data!));
            }
            return ProgressRing();
          },
        );
      },
    );
  }
}
