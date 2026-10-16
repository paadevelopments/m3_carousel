import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart'
    hide CarouselController, CarouselScrollPhysics, CarouselView;

import 'components/carousel_item.dart';
import 'components/carousel_show_all.dart';
import 'components/carousel_view.dart';
import 'components/carousel_wrapper.dart';
import 'enums/carousel_type.dart';
import 'foundations/foundations.dart';
import 'models/carousel_change_details.dart';
import 'styles/carousel_theme.dart';
import 'utils/carousel_layout.dart';
import 'utils/carousel_scroll_helper.dart';

export 'components/carousel_item.dart';
export 'components/carousel_show_all.dart';
export 'components/carousel_slot_scope.dart';
export 'components/carousel_view.dart';
export 'components/carousel_wrapper.dart';
export 'enums/carousel_type.dart';
export 'models/carousel_change_details.dart';
export 'models/carousel_scrim.dart';
export 'styles/carousel_theme.dart';
export 'utils/carousel_layout.dart';
export 'utils/carousel_scroll_helper.dart';

part 'components/carousel_navigation.dart';
part 'components/carousel_layout_resolution.dart';
part 'components/carousel_header.dart';

/// Creates a Material Design carousel.
///
/// Layouts:
///  * Multi-browse ([CarouselType.contained]): large, medium, and small.
///  * Uncontained: one item size, scrolling to the container edge.
///  * Uncontained multi-aspect: widths from 9:16 to 16:9.
///  * Hero: one large item and a small peek.
///  * Full-screen: one edge-to-edge item, scrolled vertically.
///
/// Scrolls along [axis] (horizontal by default). Full-screen is always
/// vertical. A swipe advances one item unless [freeScroll] is on, which
/// drags and snaps to the nearest item.
class M3Carousel extends StatefulWidget {
  /// Creates a Material Design carousel.
  const M3Carousel({
    super.key,
    this.controller,
    this.width,
    this.height,
    this.axis = Axis.horizontal,
    this.type = CarouselType.hero,
    this.isExtended,
    this.freeScroll,
    this.heroAlignment = HeroAlignment.center,
    this.uncontainedItemExtent = CarouselTheme.defaultUncontainedItemExtent,
    this.uncontainedShrinkExtent =
        CarouselTheme.defaultUncontainedShrinkExtent,
    this.childElementBorderRadius,
    this.largeMaxWidth,
    this.itemPadding,
    this.scrollAnimationDuration =
        CarouselTheme.defaultScrollAnimationDuration,
    this.fixedPulseDelta = 4,
    this.singleSwipeGestureSensitivityRange =
        CarouselTheme.defaultSingleSwipeGestureSensitivityRange,
    this.onTap,
    this.onChange,
    this.haptic = CarouselHapticFeedback.none,
    this.header,
    this.showAll = false,
    required this.children,
  });

  /// Scroll and action controller. The carousel creates one when this is omitted.
  ///
  /// Use [CarouselController.next], [CarouselController.previous],
  /// [CarouselController.animateToItem], [CarouselController.jumpToItem],
  /// and [CarouselController.showAll].
  final CarouselController? controller;

  /// The explicit bounded width allocation applied to the root carousel container wrapper.
  final double? width;

  /// The explicit bounded height allocation applied to the root carousel container wrapper.
  final double? height;

  /// Scroll and layout axis. Defaults to [Axis.horizontal].
  ///
  /// [CarouselType.fullScreen] always scrolls vertically.
  final Axis axis;

  /// Specifies the structural layout rule type determining element sizes and scaling constraints.
  final CarouselType type;

  /// Expanded slot pattern.
  ///
  /// When null, a wide contained carousel uses the extended pattern.
  ///
  /// Hero ignores this. Below the breakpoint, contained shows at most three
  /// slots.
  final bool? isExtended;

  /// When false, a swipe advances one item and the scroll view does not drag.
  /// When true, the scroll view drags and snaps to the nearest item.
  ///
  /// Defaults to false.
  final bool? freeScroll;

  /// Focal-item alignment for [CarouselType.hero].
  ///
  /// Horizontal: left / center / right.
  /// Vertical: [HeroAlignment.left] is top (start),
  /// [HeroAlignment.right] is bottom (end).
  final HeroAlignment heroAlignment;

  /// Baseline main-axis extent for items in uncontained layouts
  /// (width when horizontal, height when vertical).
  final double uncontainedItemExtent;

  /// The minimal compressed dimension boundary applied to items scaling down near container thresholds.
  final double uncontainedShrinkExtent;

  /// Corner radius. Defaults to the theme value for the layout.
  final double? childElementBorderRadius;

  /// Largest large-item extent. Defaults to the theme value.
  final double? largeMaxWidth;

  /// Padding inside each item. Defaults to the layout gap.
  final EdgeInsetsGeometry? itemPadding;

  /// The total lifespan millisecond count allocated to complete layout transition slide curves.
  final int scrollAnimationDuration;

  /// The dimensional drag delta requirement needed to trigger single-item sweep navigation actions.
  final int singleSwipeGestureSensitivityRange;

  /// Fixed logical pixels added or removed per animating edge at peak pulse.
  ///
  /// A value of `4` expands or squishes each active edge by up to 4px.
  /// When both sides animate, each edge uses the full delta independently.
  final double fixedPulseDelta;

  /// Click event notification pipe exposing the zero-based list tracking index of the interacted element.
  final void Function(int selectedIndex)? onTap;

  /// Called when the leading or focal item index changes after scrolling.
  final ValueChanged<CarouselChangeDetails>? onChange;

  /// Haptic intensity on item tap. Defaults to [CarouselHapticFeedback.none].
  final CarouselHapticFeedback haptic;

  /// Title shown above the items, with an arrow that opens every item.
  final Widget? header;

  /// Trailing text button that opens every item. Ignored when [header] is set
  /// or the layout is full-screen.
  final bool showAll;

  /// Items rendered in the scroll track.
  final List<CarouselItem> children;

  @override
  State<M3Carousel> createState() => _M3CarouselState();
}

class _M3CarouselState extends State<M3Carousel> {
  double frameWidth = 0;
  double frameHeight = 0;
  double _trackMain = 0;
  double _stepExtent = 0;
  List<int> layoutWeight = [];
  int itemScrolled = 0;
  List<double>? _aspectExtents;
  CarouselController? _ownedController;
  final GlobalKey _trackKey = GlobalKey();

  CarouselController get _controller =>
      widget.controller ?? _ownedController!;

  bool get _fullScreen => widget.type == CarouselType.fullScreen;

  Axis get _axis => _fullScreen ? Axis.vertical : widget.axis;

  bool get _horizontal => _axis == Axis.horizontal;

  /// Viewport extent along the scroll axis.
  double get _mainExtent => _horizontal ? frameWidth : frameHeight;

  bool _freeScroll() => widget.freeScroll ?? false;

  @override
  void initState() {
    if (widget.controller == null) {
      _ownedController = CarouselController();
    }
    _bindController(_controller);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant M3Carousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      (oldWidget.controller ?? _ownedController)?.detachActions();
      if (oldWidget.controller == null) {
        _ownedController?.dispose();
        _ownedController = null;
      }
      if (widget.controller == null) {
        _ownedController = CarouselController();
      }
      _bindController(_controller);
    }
    if (oldWidget.type != widget.type ||
        oldWidget.heroAlignment != widget.heroAlignment ||
        oldWidget.isExtended != widget.isExtended) {
      itemScrolled = 0;
      if (_controller.hasClients) {
        _controller.jumpTo(0);
      }
    }
  }

  @override
  void dispose() {
    _controller.detachActions();
    _ownedController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        final CarouselTheme theme = CarouselTheme.of(context);
        final bool freeScroll = _freeScroll();
        final bool reduced = MediaQuery.disableAnimationsOf(context);
        return LayoutBuilder(
          builder: (BuildContext ctx, BoxConstraints dimens) {
            frameWidth = widget.width ?? dimens.maxWidth;
            frameHeight = widget.height ?? dimens.maxHeight;
            final bool extended = _extended(theme);
            final reducedMotion = reduced;
            final double main = _mainExtent;
            final EdgeInsets container = _containerPadding(
              theme,
              reducedMotion,
            );
            final double trackMain = math.max(
              0,
              main - (_horizontal ? container.horizontal : container.vertical),
            );
            _trackMain = trackMain;
            layoutWeight = _resolvedWeights(
              theme,
              extended,
              reducedMotion,
              trackMain,
            );
            final List<double>? varied = _aspectExtentsFor(theme, container);
            _aspectExtents = varied;
            final double? itemExtent = _fixedExtent(theme, reduced, trackMain);
            _stepExtent = itemExtent ?? widget.uncontainedItemExtent;
            final bool showHeader = widget.header != null && !_fullScreen;
            final bool showAllButton =
                widget.showAll && widget.header == null && !_fullScreen;
            final Widget track = _gestureLayer(
              KeyedSubtree(
                key: _trackKey,
                child: Padding(
                  padding: container,
                  child: CarouselWrapper(
                    controller: _controller,
                    freeScroll: freeScroll,
                    itemSnapping: freeScroll,
                    consumeMaxWeight: false,
                    scrollDirection: _axis,
                    padding: _itemPadding(theme, reducedMotion),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        widget.childElementBorderRadius ??
                            theme.radiusFor(widget.type),
                      ),
                    ),
                    onTap: widget.onTap,
                    onChange: widget.onChange,
                    haptic: widget.haptic,
                    flexWeights: varied == null && itemExtent == null
                        ? layoutWeight
                        : null,
                    itemExtent: varied == null ? itemExtent : null,
                    itemExtents: varied,
                    leadingInset: _leadingGap(theme),
                    shrinkExtent:
                        widget.type == CarouselType.uncontained ||
                            widget.type ==
                                CarouselType.uncontainedMultiAspect
                        ? widget.uncontainedShrinkExtent
                        : 0,
                    scaleItems:
                        widget.type == CarouselType.uncontained ||
                        widget.type == CarouselType.uncontainedMultiAspect,
                    reducedMotion: reduced,
                    fixedPulseDelta: widget.fixedPulseDelta,
                    children: widget.children,
                  ),
                ),
              ),
            );
            return Semantics(
              container: true,
              child: FocusTraversalGroup(
                policy: OrderedTraversalPolicy(),
                child: SizedBox(
                  width: frameWidth,
                  height: frameHeight,
                  child: !frameHeight.isFinite
                      ? track
                      : Column(
                          children: <Widget>[
                            if (showHeader)
                              FocusTraversalOrder(
                                order: const NumericFocusOrder(2),
                                child: _header(theme),
                              ),
                            Expanded(
                              child: FocusTraversalOrder(
                                order: const NumericFocusOrder(1),
                                child: track,
                              ),
                            ),
                            if (showAllButton)
                              FocusTraversalOrder(
                                order: const NumericFocusOrder(2),
                                child: _showAll(theme),
                              ),
                          ],
                        ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
