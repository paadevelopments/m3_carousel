import 'package:flutter/widgets.dart';

/// Scroll physics for a carousel swipe that advances one item.
///
/// The scroll view does not drag. A programmatic step is not followed by a
/// ballistic settle, so the item that just became leading is not snapped away.
class M3CarouselStepPhysics extends NeverScrollableScrollPhysics {
  /// Creates physics that ignore user dragging and end-of-step flings.
  const M3CarouselStepPhysics({super.parent});

  @override
  M3CarouselStepPhysics applyTo(ScrollPhysics? ancestor) {
    return const M3CarouselStepPhysics();
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    return null;
  }
}
