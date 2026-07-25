// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'carousel_view.dart';

/// Metrics for a [CarouselView].
class _CarouselMetrics extends FixedScrollMetrics {
  /// Creates an immutable snapshot of values associated with a [CarouselView].
  _CarouselMetrics({
    required super.minScrollExtent,
    required super.maxScrollExtent,
    required super.pixels,
    required super.viewportDimension,
    required super.axisDirection,
    this.itemExtent,
    this.flexWeights,
    this.consumeMaxWeight,
    required super.devicePixelRatio,
  });

  /// Extent for the carousel item.
  final double? itemExtent;

  /// The fraction of the viewport that the first item occupies.
  final List<int>? flexWeights;

  /// Determine whether each child can be expanded to occupy the maximum weight while scrolling.
  final bool? consumeMaxWeight;

  @override
  _CarouselMetrics copyWith({
    double? minScrollExtent,
    double? maxScrollExtent,
    double? pixels,
    double? viewportDimension,
    AxisDirection? axisDirection,
    double? itemExtent,
    List<int>? flexWeights,
    bool? consumeMaxWeight,
    double? devicePixelRatio,
  }) {
    return _CarouselMetrics(
      minScrollExtent:
          minScrollExtent ??
          (hasContentDimensions ? this.minScrollExtent : null),
      maxScrollExtent:
          maxScrollExtent ??
          (hasContentDimensions ? this.maxScrollExtent : null),
      pixels: pixels ?? (hasPixels ? this.pixels : null),
      viewportDimension:
          viewportDimension ??
          (hasViewportDimension ? this.viewportDimension : null),
      axisDirection: axisDirection ?? this.axisDirection,
      itemExtent: itemExtent ?? this.itemExtent,
      flexWeights: flexWeights ?? this.flexWeights,
      consumeMaxWeight: consumeMaxWeight ?? this.consumeMaxWeight,
      devicePixelRatio: devicePixelRatio ?? this.devicePixelRatio,
    );
  }
}
