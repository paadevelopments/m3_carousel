import "package:flutter/material.dart";

/// Default values and helpers for [M3Carousel] / [CarouselView] styling.
@immutable
class CarouselTheme {
  /// Default main-axis extent for uncontained carousel items.
  static const double defaultUncontainedItemExtent = 270;

  /// Default minimum extent while uncontained items shrink during scroll.
  static const double defaultUncontainedShrinkExtent = 150;

  /// Default corner radius for carousel items.
  static const double defaultBorderRadiusValue = 28;

  /// Default duration (ms) for programmatic scroll animations.
  static const int defaultScrollAnimationDuration = 500;

  /// Default swipe velocity threshold for single-item paging.
  static const int defaultSingleSwipeGestureSensitivityRange = 300;

  /// Creates carousel theme defaults.
  const CarouselTheme({
    this.uncontainedItemExtent = defaultUncontainedItemExtent,
    this.uncontainedShrinkExtent = defaultUncontainedShrinkExtent,
    this.borderRadiusValue = defaultBorderRadiusValue,
    this.scrollAnimationDuration = defaultScrollAnimationDuration,
    this.singleSwipeGestureSensitivityRange =
        defaultSingleSwipeGestureSensitivityRange,
    this.itemPadding = const EdgeInsets.all(4),
    this.elevation = 0,
    this.itemClipBehavior = Clip.antiAlias,
  });

  /// Shared default instance.
  static const CarouselTheme defaults = CarouselTheme();

  /// Main-axis extent for uncontained items.
  final double uncontainedItemExtent;

  /// Minimum extent while uncontained items shrink during scroll.
  final double uncontainedShrinkExtent;

  /// Corner radius applied to item shapes.
  final double borderRadiusValue;

  /// Duration in milliseconds for scroll animations.
  final int scrollAnimationDuration;

  /// Swipe velocity threshold for single-item paging.
  final int singleSwipeGestureSensitivityRange;

  /// Padding around each carousel item.
  final EdgeInsetsGeometry itemPadding;

  /// Elevation for each item's [Material].
  final double elevation;

  /// Clip behavior for each item's [Material].
  final Clip itemClipBehavior;

  /// Border radius derived from [borderRadiusValue].
  BorderRadius get borderRadius =>
      BorderRadius.all(Radius.circular(borderRadiusValue));

  /// Shape derived from [borderRadius].
  ShapeBorder get shape => RoundedRectangleBorder(borderRadius: borderRadius);

  /// Default item background color from [scheme].
  Color backgroundColor(ColorScheme scheme) => scheme.surface;

  /// Default ink overlay colors from [scheme].
  WidgetStateProperty<Color?> overlayColor(ColorScheme scheme) {
    return WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.pressed)) {
        return scheme.onSurface.withValues(alpha: 0.1);
      }
      if (states.contains(WidgetState.hovered)) {
        return scheme.onSurface.withValues(alpha: 0.08);
      }
      if (states.contains(WidgetState.focused)) {
        return scheme.onSurface.withValues(alpha: 0.1);
      }
      return null;
    });
  }

  /// Returns a copy with the given fields replaced.
  CarouselTheme copyWith({
    double? uncontainedItemExtent,
    double? uncontainedShrinkExtent,
    double? borderRadiusValue,
    int? scrollAnimationDuration,
    int? singleSwipeGestureSensitivityRange,
    EdgeInsetsGeometry? itemPadding,
    double? elevation,
    Clip? itemClipBehavior,
  }) {
    return CarouselTheme(
      uncontainedItemExtent:
          uncontainedItemExtent ?? this.uncontainedItemExtent,
      uncontainedShrinkExtent:
          uncontainedShrinkExtent ?? this.uncontainedShrinkExtent,
      borderRadiusValue: borderRadiusValue ?? this.borderRadiusValue,
      scrollAnimationDuration:
          scrollAnimationDuration ?? this.scrollAnimationDuration,
      singleSwipeGestureSensitivityRange:
          singleSwipeGestureSensitivityRange ??
          this.singleSwipeGestureSensitivityRange,
      itemPadding: itemPadding ?? this.itemPadding,
      elevation: elevation ?? this.elevation,
      itemClipBehavior: itemClipBehavior ?? this.itemClipBehavior,
    );
  }

  /// Linearly interpolates between this theme and [other].
  CarouselTheme lerp(CarouselTheme? other, double t) {
    if (other is! CarouselTheme) {
      return this;
    }
    return CarouselTheme(
      uncontainedItemExtent: _lerpDouble(
        uncontainedItemExtent,
        other.uncontainedItemExtent,
        t,
      )!,
      uncontainedShrinkExtent: _lerpDouble(
        uncontainedShrinkExtent,
        other.uncontainedShrinkExtent,
        t,
      )!,
      borderRadiusValue: _lerpDouble(
        borderRadiusValue,
        other.borderRadiusValue,
        t,
      )!,
      scrollAnimationDuration: _lerpInt(
        scrollAnimationDuration,
        other.scrollAnimationDuration,
        t,
      ),
      singleSwipeGestureSensitivityRange: _lerpInt(
        singleSwipeGestureSensitivityRange,
        other.singleSwipeGestureSensitivityRange,
        t,
      ),
      itemPadding:
          EdgeInsets.lerp(
            itemPadding as EdgeInsets?,
            other.itemPadding as EdgeInsets?,
            t,
          ) ??
          itemPadding,
      elevation: _lerpDouble(elevation, other.elevation, t)!,
      itemClipBehavior: t < 0.5 ? itemClipBehavior : other.itemClipBehavior,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;

  int _lerpInt(int a, int b, double t) => (a + (b - a) * t).round();
}
