import 'package:flutter/widgets.dart';

/// Scroll physics for a carousel swipe that advances one item.
///
/// The scroll view does not drag. A programmatic step is not followed by a
/// ballistic settle, so the item that just became leading is not snapped away.
class CarouselStepPhysics extends NeverScrollableScrollPhysics {
  /// Creates physics that ignore user dragging and end-of-step flings.
  const CarouselStepPhysics({super.parent});

  @override
  CarouselStepPhysics applyTo(ScrollPhysics? ancestor) {
    return const CarouselStepPhysics();
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    return null;
  }
}
