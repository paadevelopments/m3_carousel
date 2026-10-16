import 'package:material_ui/material_ui.dart';

/// Shared tokens for the Material 3 Expressive keyboard focus ring.
@immutable
class CarouselFocusRingTheme extends ThemeExtension<CarouselFocusRingTheme> {
  /// Creates focus ring theme tokens.
  const CarouselFocusRingTheme({this.color, this.width = 2, this.gap = 2});

  /// Package defaults.
  static const CarouselFocusRingTheme defaults = CarouselFocusRingTheme();

  /// The ambient focus ring theme, or [defaults] when none is installed.
  static CarouselFocusRingTheme of(BuildContext context) =>
      Theme.of(context).extension<CarouselFocusRingTheme>() ?? defaults;

  /// Optional override; when null, resolves to [ColorScheme.primary].
  final Color? color;

  /// Stroke width of the focus ring outline (dp).
  final double width;

  /// Gap between the component edge and the focus ring outline (dp).
  final double gap;

  /// Total outset past the component edge (`gap + width`).
  double get outset => gap + width;

  /// Resolved ring color for [scheme].
  Color resolveColor(ColorScheme scheme) => color ?? scheme.primary;

  @override
  CarouselFocusRingTheme copyWith({
    Color? color,
    bool clearColor = false,
    double? width,
    double? gap,
  }) {
    return CarouselFocusRingTheme(
      color: clearColor ? null : (color ?? this.color),
      width: width ?? this.width,
      gap: gap ?? this.gap,
    );
  }

  @override
  CarouselFocusRingTheme lerp(CarouselFocusRingTheme? other, double t) {
    if (other is! CarouselFocusRingTheme) {
      return this;
    }
    return CarouselFocusRingTheme(
      color: Color.lerp(color, other.color, t) ?? color ?? other.color,
      width: _lerpDouble(width, other.width, t),
      gap: _lerpDouble(gap, other.gap, t),
    );
  }

  static double _lerpDouble(double a, double b, double t) => a + (b - a) * t;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is CarouselFocusRingTheme &&
        other.color == color &&
        other.width == width &&
        other.gap == gap;
  }

  @override
  int get hashCode => Object.hash(color, width, gap);
}
