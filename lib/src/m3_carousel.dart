import "package:flutter/foundation.dart";
import "package:flutter/material.dart"
    hide CarouselController, CarouselScrollPhysics, CarouselView;

import "carousel_scroll_helper.dart";
import "carousel_theme.dart";
import "carousel_type.dart";
import "carousel_view.dart";
import "carousel_wrapper.dart";

/// Creates a Material Design carousel.
///
/// Material Design 3 introduces 3 carousel layouts:
///  * Multi-browse: shows at least one large, medium, and small item at a time.
///  * Uncontained (default): shows items that scroll to the edge of the
///    container.
///  * Hero: shows at least one large and one small item at a time.
///
/// Scrolls along [axis] (horizontal by default, or vertical).
///
/// For more info checkout the
/// [Official Docs](https://m3.material.io/components/carousel).
class M3Carousel extends StatefulWidget {
  /// Creates a Material Design carousel.
  const M3Carousel({
    super.key,
    this.width,
    this.height,
    this.axis = Axis.horizontal,
    this.type = CarouselType.hero,
    this.isExtended = false,
    this.freeScroll = false,
    this.heroAlignment = HeroAlignment.center,
    this.uncontainedItemExtent = CarouselTheme.defaultUncontainedItemExtent,
    this.uncontainedShrinkExtent = CarouselTheme.defaultUncontainedShrinkExtent,
    this.childElementBorderRadius = CarouselTheme.defaultBorderRadiusValue,
    this.scrollAnimationDuration = CarouselTheme.defaultScrollAnimationDuration,
    this.fixedPulseDelta = 4,
    this.singleSwipeGestureSensitivityRange =
        CarouselTheme.defaultSingleSwipeGestureSensitivityRange,
    this.onTap,
    required this.children,
  });

  /// Width of the carousel view.
  ///
  /// Defaults to the max width from an internal [LayoutBuilder].
  final double? width;

  /// Height of the carousel view.
  ///
  /// Defaults to the max height from an internal [LayoutBuilder].
  final double? height;

  /// Scroll and layout axis.
  ///
  /// Defaults to [Axis.horizontal].
  final Axis axis;

  /// The type of carousel.
  ///
  /// * [CarouselType.hero]: 2–3 visible items depending on [heroAlignment].
  /// * [CarouselType.contained]: 3–4 visible items depending on [isExtended].
  /// * [CarouselType.uncontained]: sizes from [uncontainedItemExtent].
  ///
  /// Defaults to [CarouselType.hero].
  final CarouselType type;

  /// Whether to show the extended contained layout (4 visible items).
  ///
  /// Applies to [CarouselType.contained] only. Defaults to false.
  final bool isExtended;

  /// Whether scrolling is free (manual) instead of single-swipe paging.
  ///
  /// When false, a drag gesture advances one frame with snapping.
  /// Defaults to false.
  final bool freeScroll;

  /// Focal-item alignment for [CarouselType.hero].
  ///
  /// Horizontal: left / center / right.
  /// Vertical: [HeroAlignment.left] is top (start),
  /// [HeroAlignment.right] is bottom (end).
  ///
  /// Defaults to [HeroAlignment.center].
  final HeroAlignment heroAlignment;

  /// Main-axis extent for uncontained items.
  ///
  /// Defaults to [CarouselTheme.defaultUncontainedItemExtent].
  final double uncontainedItemExtent;

  /// Minimum main-axis extent while uncontained items shrink during scroll.
  ///
  /// Defaults to [CarouselTheme.defaultUncontainedShrinkExtent].
  final double uncontainedShrinkExtent;

  /// Corner radius applied to carousel items.
  ///
  /// Defaults to [CarouselTheme.defaultBorderRadiusValue].
  final double childElementBorderRadius;

  /// Duration in milliseconds for programmatic scroll animations.
  ///
  /// Used when [freeScroll] is false. Defaults to
  /// [CarouselTheme.defaultScrollAnimationDuration].
  final int scrollAnimationDuration;

  /// Swipe velocity threshold for single-item paging when [freeScroll] is false.
  ///
  /// Higher values require a stronger swipe. Ignored on web. Defaults to
  /// [CarouselTheme.defaultSingleSwipeGestureSensitivityRange].
  final int singleSwipeGestureSensitivityRange;

  /// Fixed logical pixels added or removed per animating edge at peak pulse.
  ///
  /// A value of `4` expands or squishes each active edge by up to 4px.
  /// When both sides animate, each edge uses the full delta independently.
  final double fixedPulseDelta;

  /// Called when a carousel item is tapped, with its zero-based index.
  final void Function(int selectedIndex)? onTap;

  /// The child widgets for the carousel.
  final List<Widget> children;

  @override
  State<M3Carousel> createState() => _M3CarouselState();
}

class _M3CarouselState extends State<M3Carousel> {
  double frameWidth = 0;
  double frameHeight = 0;
  List<int> layoutWeight = [];
  int itemScrolled = 0;
  late CarouselController controller;

  bool get _horizontal => widget.axis == Axis.horizontal;

  /// Viewport extent along the scroll axis.
  double get _mainExtent => _horizontal ? frameWidth : frameHeight;

  void scrollFrame(int direction) {
    final step = CarouselScrollHelper.nextStep(
      type: widget.type,
      heroAlignment: widget.heroAlignment,
      isExtended: widget.isExtended,
      uncontainedItemExtent: widget.uncontainedItemExtent,
      layoutWeight: layoutWeight,
      mainExtent: _mainExtent,
      childrenLength: widget.children.length,
      itemScrolled: itemScrolled,
      prevScrollPosition: controller.position.pixels,
      direction: direction,
    );
    if (step == null) {
      return;
    }
    itemScrolled = step.itemScrolled;
    controller.animateTo(
      step.nextScrollPosition,
      duration: Duration(milliseconds: widget.scrollAnimationDuration),
      curve: Curves.ease,
    );
  }

  void onDragEnd(DragEndDetails details) {
    final double? velocity = details.primaryVelocity;
    if (velocity == null) {
      return;
    }
    if (velocity > (kIsWeb ? 0 : widget.singleSwipeGestureSensitivityRange)) {
      scrollFrame(0);
    } else if (velocity <
        -(kIsWeb ? 0 : widget.singleSwipeGestureSensitivityRange)) {
      scrollFrame(1);
    }
  }

  Widget setGestureLayer(Widget child) {
    if (widget.freeScroll) {
      return child;
    }
    if (_horizontal) {
      return GestureDetector(onHorizontalDragEnd: onDragEnd, child: child);
    }
    return GestureDetector(onVerticalDragEnd: onDragEnd, child: child);
  }

  @override
  void initState() {
    // Weighted layouts use consumeMaxWeight: false and initialItem: 0 so
    // flexWeights map onto items 0..n at scroll offset 0. Using
    // consumeMaxWeight with a non-zero initialItem inserts a phantom leading
    // extent that rebuilds can leave offstage.
    controller = CarouselController();
    _applyLayoutWeights();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant M3Carousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.type != widget.type ||
        oldWidget.heroAlignment != widget.heroAlignment ||
        oldWidget.isExtended != widget.isExtended) {
      _applyLayoutWeights();
      itemScrolled = 0;
      if (controller.hasClients) {
        controller.jumpTo(0);
      }
    }
  }

  void _applyLayoutWeights() {
    switch (widget.type) {
      case CarouselType.hero:
        switch (widget.heroAlignment) {
          case HeroAlignment.left:
            layoutWeight = [8, 2];
          case HeroAlignment.center:
            layoutWeight = [2, 6, 2];
          case HeroAlignment.right:
            layoutWeight = [2, 8];
        }
      case CarouselType.contained:
        layoutWeight = widget.isExtended ? [4, 3, 2, 1] : [5, 4, 1];
      case CarouselType.uncontained:
        layoutWeight = [];
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, dimens) {
        frameWidth = widget.width ?? dimens.maxWidth;
        frameHeight = widget.height ?? dimens.maxHeight;
        return setGestureLayer(
          SizedBox(
            width: frameWidth,
            height: frameHeight,
            child: CarouselWrapper(
              controller: controller,
              freeScroll: widget.freeScroll,
              itemSnapping: widget.freeScroll,
              consumeMaxWeight: false,
              scrollDirection: widget.axis,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  widget.childElementBorderRadius,
                ),
              ),
              onTap: widget.onTap,
              flexWeights: widget.type == CarouselType.uncontained
                  ? null
                  : layoutWeight,
              itemExtent: widget.type == CarouselType.uncontained
                  ? widget.uncontainedItemExtent
                  : null,
              fixedPulseDelta: widget.fixedPulseDelta,
              children: widget.children,
            ),
          ),
        );
      },
    );
  }
}
