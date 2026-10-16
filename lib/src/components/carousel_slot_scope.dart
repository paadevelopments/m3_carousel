import 'package:flutter/widgets.dart';

/// The visible main-axis size of one carousel slot.
class CarouselSlotScope extends InheritedWidget {
  /// CarouselSlotScope.
  const CarouselSlotScope({
    required this.slotMain,
    required super.child,
    super.key,
  });

  /// Current slot length along the scroll axis.
  final double slotMain;

  /// Nearest slot scope, or null.
  static CarouselSlotScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CarouselSlotScope>();
  }

  @override
  bool updateShouldNotify(CarouselSlotScope oldWidget) =>
      slotMain != oldWidget.slotMain;
}
