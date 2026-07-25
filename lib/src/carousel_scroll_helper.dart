import 'dart:math';

import 'carousel_type.dart';

/// Scroll-step helpers for carousel frame navigation.
abstract final class CarouselScrollHelper {
  const CarouselScrollHelper._();

  /// Computes the next scroll position and updated [itemScrolled] for one step.
  ///
  /// Returns `null` when the step is out of bounds.
  static ({double nextScrollPosition, int itemScrolled})? nextStep({
    required CarouselType type,
    required HeroAlignment heroAlignment,
    required bool isExtended,
    required double uncontainedItemExtent,
    required List<int> layoutWeight,
    required double mainExtent,
    required int childrenLength,
    required int itemScrolled,
    required double prevScrollPosition,
    required int direction,
  }) {
    return switch (type) {
      CarouselType.hero => _heroStep(
        heroAlignment: heroAlignment,
        layoutWeight: layoutWeight,
        mainExtent: mainExtent,
        childrenLength: childrenLength,
        itemScrolled: itemScrolled,
        prevScrollPosition: prevScrollPosition,
        direction: direction,
      ),
      CarouselType.contained => _containedStep(
        isExtended: isExtended,
        layoutWeight: layoutWeight,
        mainExtent: mainExtent,
        childrenLength: childrenLength,
        itemScrolled: itemScrolled,
        prevScrollPosition: prevScrollPosition,
        direction: direction,
      ),
      CarouselType.uncontained => _uncontainedStep(
        uncontainedItemExtent: uncontainedItemExtent,
        childrenLength: childrenLength,
        itemScrolled: itemScrolled,
        prevScrollPosition: prevScrollPosition,
        direction: direction,
      ),
    };
  }

  static ({double nextScrollPosition, int itemScrolled})? _heroStep({
    required HeroAlignment heroAlignment,
    required List<int> layoutWeight,
    required double mainExtent,
    required int childrenLength,
    required int itemScrolled,
    required double prevScrollPosition,
    required int direction,
  }) {
    final double delta =
        ((layoutWeight.reduce(heroAlignment == HeroAlignment.left ? max : min) *
                10) /
            100) *
        mainExtent;
    final int limit = switch (heroAlignment) {
      HeroAlignment.center => direction == 0 ? 0 : 3,
      HeroAlignment.left => direction == 0 ? 0 : 2,
      HeroAlignment.right => direction == 0 ? 0 : 2,
    };
    return _boundedStep(
      direction: direction,
      itemScrolled: itemScrolled,
      minIndex: limit,
      maxIndex: childrenLength - limit,
      prevScrollPosition: prevScrollPosition,
      delta: delta,
    );
  }

  static ({double nextScrollPosition, int itemScrolled})? _containedStep({
    required bool isExtended,
    required List<int> layoutWeight,
    required double mainExtent,
    required int childrenLength,
    required int itemScrolled,
    required double prevScrollPosition,
    required int direction,
  }) {
    final double delta = ((layoutWeight.reduce(max) * 10) / 100) * mainExtent;
    final int trailingLimit = childrenLength - (isExtended ? 4 : 3);
    return _boundedStep(
      direction: direction,
      itemScrolled: itemScrolled,
      minIndex: 0,
      maxIndex: trailingLimit,
      prevScrollPosition: prevScrollPosition,
      delta: delta,
    );
  }

  static ({double nextScrollPosition, int itemScrolled})? _uncontainedStep({
    required double uncontainedItemExtent,
    required int childrenLength,
    required int itemScrolled,
    required double prevScrollPosition,
    required int direction,
  }) {
    return _boundedStep(
      direction: direction,
      itemScrolled: itemScrolled,
      minIndex: 0,
      maxIndex: childrenLength - 1,
      prevScrollPosition: prevScrollPosition,
      delta: uncontainedItemExtent,
    );
  }

  static ({double nextScrollPosition, int itemScrolled})? _boundedStep({
    required int direction,
    required int itemScrolled,
    required int minIndex,
    required int maxIndex,
    required double prevScrollPosition,
    required double delta,
  }) {
    if (direction == 0) {
      if (itemScrolled <= minIndex) {
        return null;
      }
      return (
        nextScrollPosition: prevScrollPosition - delta,
        itemScrolled: itemScrolled - 1,
      );
    }
    if (itemScrolled >= maxIndex) {
      return null;
    }
    return (
      nextScrollPosition: prevScrollPosition + delta,
      itemScrolled: itemScrolled + 1,
    );
  }
}
