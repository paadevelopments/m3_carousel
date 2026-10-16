import 'package:flutter/widgets.dart';

/// The visible main-axis size of one carousel slot.
class M3CarouselSlotScope extends InheritedWidget {
  /// M3CarouselSlotScope.
  const M3CarouselSlotScope({
    required this.slotMain,
    required super.child,
    super.key,
  });

  /// Current slot length along the scroll axis.
  final double slotMain;

  /// Nearest slot scope, or null.
  static M3CarouselSlotScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<M3CarouselSlotScope>();
  }

  @override
  bool updateShouldNotify(M3CarouselSlotScope oldWidget) =>
      slotMain != oldWidget.slotMain;
}
