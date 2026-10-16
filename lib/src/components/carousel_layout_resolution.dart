part of '../m3_carousel.dart';

/// Resolves layout inputs (slot patterns, weights, extents, padding) for
/// [_M3CarouselState] from the widget's [M3CarouselType] and theme.
extension _CarouselLayoutResolution on _M3CarouselState {
  bool _extended(M3CarouselTheme theme) {
    if (widget.type == M3CarouselType.hero) {
      return false;
    }
    if (widget.isExtended != null) {
      return widget.isExtended!;
    }
    return frameWidth >= theme.expandedBreakpoint;
  }

  /// Gap before the first uncontained item. Later rests keep that gap too.
  double _leadingGap(M3CarouselTheme theme) {
    final bool uncontained =
        widget.type == M3CarouselType.uncontained ||
        widget.type == M3CarouselType.uncontainedMultiAspect;
    if (!_horizontal || !uncontained || widget.itemPadding != null) {
      return 0;
    }
    return theme.itemGap;
  }

  List<int> _pattern(bool extended) {
    switch (widget.type) {
      case M3CarouselType.hero:
        switch (widget.heroAlignment) {
          case M3HeroAlignment.left:
            return <int>[8, 2];
          case M3HeroAlignment.center:
            return <int>[2, 6, 2];
          case M3HeroAlignment.right:
            return <int>[2, 8];
        }
      case M3CarouselType.contained:
        return extended ? <int>[4, 3, 2, 1] : <int>[5, 4, 1];
      case M3CarouselType.uncontained:
      case M3CarouselType.uncontainedMultiAspect:
      case M3CarouselType.fullScreen:
        return const <int>[];
    }
  }

  List<int> _resolvedWeights(
    M3CarouselTheme theme,
    bool extended,
    bool reduced,
    double trackMain,
  ) {
    if (reduced ||
        widget.type == M3CarouselType.uncontained ||
        widget.type == M3CarouselType.uncontainedMultiAspect ||
        _fullScreen) {
      return const <int>[];
    }
    return M3CarouselLayout.clampWeights(
      pattern: _pattern(extended),
      viewport: trackMain,
      smallMin: theme.smallMinWidth,
      smallMax: theme.smallMaxWidth,
      largeMax: widget.largeMaxWidth ?? theme.largeMaxWidth,
    );
  }

  double? _fixedExtent(M3CarouselTheme theme, bool reduced, double trackMain) {
    if (widget.type == M3CarouselType.uncontainedMultiAspect) {
      return null;
    }
    if (_fullScreen) {
      // One item is the viewport. A gap here makes later pages land short.
      return trackMain;
    }
    if (widget.type == M3CarouselType.uncontained) {
      return widget.uncontainedItemExtent;
    }
    if (!reduced) {
      return null;
    }
    if (widget.type == M3CarouselType.hero) {
      return math.max(trackMain - theme.smallMaxWidth, trackMain * 0.5);
    }
    return trackMain;
  }

  List<double>? _aspectExtentsFor(M3CarouselTheme theme, EdgeInsets container) {
    if (widget.type != M3CarouselType.uncontainedMultiAspect) {
      return null;
    }
    final double cross = _horizontal
        ? math.max(0, frameHeight - container.vertical)
        : math.max(0, frameWidth - container.horizontal);
    final EdgeInsets itemPadding = _itemPadding(theme, false);
    final double gap = _horizontal
        ? itemPadding.horizontal
        : itemPadding.vertical;
    return <double>[
      for (int i = 0; i < widget.children.length; i++)
        cross *
                widget.children[i].aspectRatio.clamp(
                  theme.minAspect,
                  theme.maxAspect,
                ) +
            gap,
    ];
  }

  EdgeInsets _containerPadding(M3CarouselTheme theme, bool reduced) {
    if (reduced && widget.type == M3CarouselType.contained) {
      return EdgeInsets.zero;
    }
    return theme.containerPaddingFor(widget.type);
  }

  EdgeInsets _itemPadding(M3CarouselTheme theme, bool reduced) {
    if (widget.itemPadding != null) {
      return widget.itemPadding!.resolve(Directionality.of(context));
    }
    final EdgeInsets themed = theme.itemPadding.resolve(
      Directionality.of(context),
    );
    const fallback = EdgeInsets.symmetric(horizontal: 4);
    if (themed != fallback) {
      return themed;
    }
    if (_fullScreen || (reduced && widget.type == M3CarouselType.contained)) {
      return EdgeInsets.zero;
    }
    final bool bleed =
        widget.type == M3CarouselType.uncontained ||
        widget.type == M3CarouselType.uncontainedMultiAspect;
    if (bleed) {
      // The gap is on the trailing side so the leading edge matches the flush
      // trailing edge of the track.
      if (_horizontal) {
        return EdgeInsetsDirectional.only(end: theme.itemGap)
            .resolve(Directionality.of(context));
      }
      return EdgeInsets.only(top: theme.itemGap);
    }
    return _horizontal
        ? EdgeInsets.symmetric(horizontal: theme.itemGap / 2)
        : EdgeInsets.symmetric(vertical: theme.itemGap / 2);
  }
}
