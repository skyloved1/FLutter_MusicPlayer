import 'package:fluent_ui/fluent_ui.dart';

class PlayListPersistentDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final double collapsedHeight;
  Widget child;
  PlayListPersistentDelegate({
    required this.expandedHeight,
    required this.collapsedHeight,
    required this.child,
  });

  @override
  double get minExtent => collapsedHeight;

  @override
  double get maxExtent => expandedHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double paintExtent = maxExtent - shrinkOffset;
    final double layoutExtent = maxExtent - shrinkOffset;

    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate.maxExtent != maxExtent ||
        oldDelegate.minExtent != minExtent;
  }
}
