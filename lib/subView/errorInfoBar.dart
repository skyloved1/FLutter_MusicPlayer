import 'package:fluent_ui/fluent_ui.dart';

StatelessWidget ErrrorInfoBar(
    {required BuildContext context,
    required void Function() close,
    String title = "An unknown error occurred",
    String content = "Stream has unknown error,please try again"}) {
  return Builder(builder: (context) {
    return InfoBar(
      title: Text(title),
      content: Text(content),
      action: IconButton(
        icon: const Icon(FluentIcons.clear),
        onPressed: close,
      ),
      severity: InfoBarSeverity.error,
    );
  });
}
