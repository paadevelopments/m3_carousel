import 'package:flutter/services.dart';

/// Haptic feedback intensity levels for carousel interactions.
///
/// Use with [CarouselHaptics.trigger], component decoration / style haptic fields,
/// or the shared tappable interaction primitive.
///
/// ## Levels
/// - [none] — No haptic feedback (default)
/// - [light] — Light tap feedback for subtle interactions
/// - [medium] — Medium impact for standard presses
/// - [heavy] — Heavy impact for significant actions
enum CarouselHapticFeedback {
  /// No haptic feedback.
  none(0),

  /// Light tap feedback.
  light(1),

  /// Medium impact feedback.
  medium(2),

  /// Heavy impact feedback.
  heavy(3);

  /// Ordinal value for the level.
  final int value;

  const CarouselHapticFeedback(this.value);
}

/// Shared haptic helpers for Material 3 Expressive components.
///
/// Prefer this API over raw [HapticFeedback] calls so intensity stays consistent
/// and platform no-ops remain centralized.
abstract final class CarouselHaptics {
  const CarouselHaptics._();

  /// Fires impact feedback for [level]. [CarouselHapticFeedback.none] is a no-op.
  static void trigger(CarouselHapticFeedback level) {
    switch (level) {
      case CarouselHapticFeedback.light:
        HapticFeedback.lightImpact();
      case CarouselHapticFeedback.medium:
        HapticFeedback.mediumImpact();
      case CarouselHapticFeedback.heavy:
        HapticFeedback.heavyImpact();
      case CarouselHapticFeedback.none:
        break;
    }
  }

  /// Fires selection feedback (e.g. discrete slider ticks, picker selection).
  static void selection() {
    HapticFeedback.selectionClick();
  }
}
