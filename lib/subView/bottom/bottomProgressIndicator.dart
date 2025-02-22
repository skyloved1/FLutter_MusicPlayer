import 'package:audioplayers/audioplayers.dart';
import 'package:fluent_ui/fluent_ui.dart';

class BottomProgressIndicator extends StatefulWidget {
  const BottomProgressIndicator({super.key, required this.audioPlayer});
  final AudioPlayer audioPlayer;
  @override
  State<BottomProgressIndicator> createState() =>
      _BottomProgressIndicatorState();
}

class _BottomProgressIndicatorState extends State<BottomProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
