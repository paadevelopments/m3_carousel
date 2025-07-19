library m3_carousel;

import "dart:math";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:m3_carousel/base_layout.dart" as m3bl;

enum CarouselType {
  hero,
  contained,
  uncontained;
}

enum HeroAlignment {
  left,
  center,
  right;
}

class M3Carousel extends StatefulWidget {
  /// Creates a Material Design carousel from the underlying [CarouselView].
  ///
  /// Material Design 3 introduces 4 carousel layouts:
  ///  * Multi-browse: This layout shows at least one large, medium, and small
  /// carousel item at a time.
  ///  * Uncontained (default): This layout show items that scroll to the edge of
  /// the container.
  ///  * Hero: This layout shows at least one large and one small item at a time.
  ///  * Full-screen: This layout shows one edge-to-edge large item at a time and
  /// scrolls vertically.
  ///
  /// For more info checkout the [Official Docs](https://m3.material.io/components/carousel).
  const M3Carousel({
    super.key,
    this.width,
    this.height,
    this.type = CarouselType.hero,
    this.isExtended = false,
    this.freeScroll = false,
    this.heroAlignment = HeroAlignment.center,
    this.uncontainedItemExtent = 270.0,
    this.uncontainedShrinkExtent = 150.0,
    this.childElementBorderRadius = 28.0,
    this.scrollAnimationDuration = 500,
    this.singleSwipeGestureSensitivityRange = 300,
    this.onTap,
    required this.children,
  });

  /// Width of the carousel view.
  ///
  /// Defaults to using a calculated [maxWidth] value provided by an internally
  /// wrapped [LayoutBuilder]
  final double? width;

  /// Height of the carousel view.
  ///
  /// Defaults to using a calculated [maxHeight] value provided by an internally
  /// wrapped [LayoutBuilder]
  final double? height;

  /// The type of carousel.
  ///
  /// Available values are [CarouselType.hero], [CarouselType.contained] and [CarouselType.uncontained].
  ///  * Hero carousel shows 2 - 3 visible items. 2 items if an associated [heroAlignment]
  ///  value is set to either [HeroAlignment.left] or [HeroAlignment.right] and 3 if [heroAlignment] value is set to
  ///  [HeroAlignment.center].
  ///  * Contained carousel shows 3 - 4 visible items. 3 items if an associated [isExtended]
  ///  is set to false and 4 if [isExtended] is set to true.
  ///  * Uncontained shows visible items depending on the associated [uncontainedItemExtent]
  ///  and [uncontainedShrinkExtent] values.
  ///
  /// Defaults to [CarouselType.hero].
  final CarouselType type;

  /// Determines whether or not to display an extended carousel.
  ///
  /// This applies to "contained" type carousels ONLY. If value is set to true,
  /// the visible items of the carousel will be extended to 4.
  ///
  /// Defaults to false.
  final bool isExtended;

  /// Determines whether to enable/disable manual scrolling of carousel items.
  ///
  /// If set to false, scrolling will be actionable via a horizontal single-swipe gesture
  /// and item snapping will be automatic. If true, scrolling and item snapping will
  /// be manual.
  ///
  /// Defaults to false.
  final bool freeScroll;

  /// Sets alignment for "hero" type carousel.
  ///
  /// Pre-defined alignments are [HeroAlignment.left], [HeroAlignment.center] and [HeroAlignment.right].
  /// [HeroAlignment.left] and [HeroAlignment.right] alignments comes with 2 visible items whiles [HeroAlignment.center] comes with
  ///  3 visible items.
  ///  This applies to "hero" type carousel ONLY.
  ///
  /// Defaults to [HeroAlignment.center] alignment.
  final HeroAlignment heroAlignment;

  /// The extent the children are forced to have in the main axis.
  ///
  /// The item extent should not exceed the available space that the carousel view
  /// occupies to ensure at least one item is fully visible.
  /// This applies to "uncontained" carousel ONLY.
  ///
  /// Defaults to 270.0.
  final double uncontainedItemExtent;

  /// The minimum allowable extent (size) in the main axis for carousel items
  /// during scrolling transitions.
  ///
  /// As the carousel scrolls, the first visible item is pinned and gradually
  /// shrinks until it reaches this minimum extent before scrolling off-screen.
  /// Similarly, the last visible item enters the viewport at this minimum size
  /// and expands to its full [uncontainedItemExtent].
  /// This applies to "uncontained" carousel ONLY.
  ///
  /// Defaults to 150.0.
  final double uncontainedShrinkExtent;

  /// Border radius value for carousel items
  ///
  /// Defaults to 28.0.
  final double childElementBorderRadius;

  /// Animation duration for automatic scroll.
  ///
  /// This works if [freeScroll] value is set to false (enables automatic scroll).
  ///
  /// Defaults to 500. Value unit is in milliseconds.
  final int scrollAnimationDuration;

  /// Swipe scroll sensitivity for single-swipe gesture (automatic) scrolling.
  ///
  /// A higher value will imply a longer horizontal swipe to trigger scroll action
  /// on carousel. Hence, reducing swipe sensitivity.
  /// This works if [freeScroll] value is set to false (enables automatic scroll).
  /// And on all platforms except Web.
  ///
  /// Defaults to 300.
  final int singleSwipeGestureSensitivityRange;

  /// Sets listener for clicks/taps on carousel items.
  ///
  /// Clicked / Tapped item's index is return as [selectedIndex] value.
  ///
  /// If null, no click/tap event is registered.
  final void Function(int selectedIndex)? onTap;

  /// The child widgets for the carousel.
  final List<Widget> children;

  @override
  State<M3Carousel> createState() => _M3CarouselState();
}

class _M3CarouselState extends State<M3Carousel> {
  double frameWidth = 0.0;
  double frameHeight = 0.0;
  bool initiated = false;
  List<int> layoutWeight = [];
  int itemScrolled = 0;
  late m3bl.CarouselController controller;

  void scrollFrame(int direction) {
    double prevScrollPosition = controller.position.pixels,
        nextScrollPosition = 0.0;
    if (widget.type == CarouselType.hero) {
      double shouldAddOrSubtract = (((layoutWeight.reduce(
                      widget.heroAlignment == HeroAlignment.left ? max : min) *
                  10) /
              100) *
          frameWidth);
      int limit = 0;
      switch (widget.heroAlignment) {
        case HeroAlignment.center:
          limit = direction == 0 ? 0 : 3;
          break;
        case HeroAlignment.left:
          limit = direction == 0 ? 0 : 2;
          break;
        case HeroAlignment.right:
          limit = direction == 0 ? 0 : 2;
          break;
      }
      if (direction == 0) {
        if (itemScrolled <= limit) return;
        nextScrollPosition = prevScrollPosition - shouldAddOrSubtract;
        itemScrolled -= 1;
      } else {
        if (itemScrolled >= (widget.children.length - limit)) return;
        nextScrollPosition = prevScrollPosition + shouldAddOrSubtract;
        itemScrolled += 1;
      }
    } else if (widget.type == CarouselType.contained) {
      double shouldAddOrSubtract =
          (((layoutWeight.reduce(max) * 10) / 100) * frameWidth);
      if (direction == 0) {
        if (itemScrolled <= 0) return;
        nextScrollPosition = prevScrollPosition - shouldAddOrSubtract;
        itemScrolled -= 1;
      } else {
        if (itemScrolled >=
            (widget.children.length - (widget.isExtended ? 4 : 3))) return;
        nextScrollPosition = prevScrollPosition + shouldAddOrSubtract;
        itemScrolled += 1;
      }
    } else {
      if (direction == 0) {
        if (itemScrolled <= 0) return;
        nextScrollPosition = prevScrollPosition - widget.uncontainedItemExtent;
        itemScrolled -= 1;
      } else {
        if (itemScrolled >= (widget.children.length - 1)) return;
        nextScrollPosition = prevScrollPosition + widget.uncontainedItemExtent;
        itemScrolled += 1;
      }
    }
    controller.animateTo(nextScrollPosition,
        duration: Duration(milliseconds: widget.scrollAnimationDuration),
        curve: Curves.ease);
  }

  void onHorizontalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity! >
        (kIsWeb ? 0 : widget.singleSwipeGestureSensitivityRange)) {
      scrollFrame(0);
    } else if (details.primaryVelocity! <
        -(kIsWeb ? 0 : widget.singleSwipeGestureSensitivityRange)) {
      scrollFrame(1);
    }
  }

  Widget setGestureLayer(Widget child) => widget.freeScroll
      ? child
      : GestureDetector(
          onHorizontalDragEnd: onHorizontalDragEnd,
          child: child,
        );

  @override
  void initState() {
    controller = m3bl.CarouselController();
    switch (widget.type) {
      case CarouselType.hero:
        switch (widget.heroAlignment) {
          case HeroAlignment.left:
            layoutWeight = [8, 2];
            controller = m3bl.CarouselController(initialItem: 0);
            break;
          case HeroAlignment.center:
            layoutWeight = [2, 6, 2];
            controller = m3bl.CarouselController(initialItem: 1);
            break;
          case HeroAlignment.right:
            layoutWeight = [2, 8];
            controller = m3bl.CarouselController(initialItem: 1);
            break;
        }
        break;
      case CarouselType.contained:
        layoutWeight = widget.isExtended ? [4, 3, 2, 1] : [5, 4, 1];
        break;
      case CarouselType.uncontained:
        // No layout weights needed for uncontained type
        break;
    }
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    return LayoutBuilder(builder: (_c, _d) {
      frameWidth = widget.width ?? _d.maxWidth;
      frameHeight = widget.height ?? _d.maxHeight;
      return setGestureLayer(SizedBox(
        width: frameWidth,
        height: frameHeight,
        child: widget.type == CarouselType.uncontained
            ? m3bl.CarouselView(
                key: UniqueKey(),
                controller: controller,
                physics: widget.freeScroll
                    ? null
                    : const NeverScrollableScrollPhysics()
                        .applyTo(const m3bl.CarouselScrollPhysics()),
                itemExtent: widget.uncontainedItemExtent,
                shrinkExtent: widget.uncontainedShrinkExtent,
                children: widget.children
                    .asMap()
                    .entries
                    .map((listItem) => ClipRRect(
                          borderRadius: BorderRadius.all(
                              Radius.circular(widget.childElementBorderRadius)),
                          child: Stack(
                            children: [
                              listItem.value,
                              widget.onTap == null
                                  ? const SizedBox(
                                      width: 0,
                                      height: 0,
                                    )
                                  : Material(
                                      color: Colors.transparent,
                                      clipBehavior: Clip.hardEdge,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              widget.childElementBorderRadius)),
                                      child: InkWell(
                                        splashFactory: InkSparkle.splashFactory,
                                        onTap: () =>
                                            widget.onTap!(listItem.key),
                                      ),
                                    ),
                            ],
                          ),
                        ))
                    .toList(),
              )
            : m3bl.CarouselView.weighted(
                key: UniqueKey(),
                controller: controller,
                layoutWeights: layoutWeight,
                physics: widget.freeScroll
                    ? null
                    : const NeverScrollableScrollPhysics()
                        .applyTo(const m3bl.CarouselScrollPhysics()),
                itemSnapping: widget.freeScroll,
                children: widget.children
                    .asMap()
                    .entries
                    .map((listItem) => ClipRRect(
                          borderRadius: BorderRadius.all(
                              Radius.circular(widget.childElementBorderRadius)),
                          child: Stack(
                            children: [
                              listItem.value,
                              widget.onTap == null
                                  ? const SizedBox(
                                      width: 0,
                                      height: 0,
                                    )
                                  : Material(
                                      color: Colors.transparent,
                                      clipBehavior: Clip.hardEdge,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              widget.childElementBorderRadius)),
                                      child: InkWell(
                                        onTap: () =>
                                            widget.onTap!(listItem.key),
                                      ),
                                    ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
      ));
    });
  }
}
