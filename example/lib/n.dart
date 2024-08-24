// ignore_for_file: no_leading_underscores_for_local_identifiers

import "dart:math";
import "package:example/t.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class M3Carousel extends StatefulWidget {

  const M3Carousel({
    super.key,
    this.width,
    this.height,
    this.type = "hero",
    this.isExtended = false,
    this.freeScroll = false,
    this.heroAlignment = "center",
    this.uncontainedItemExtent = 270,
    this.uncontainedShrinkExtent = 150,
    this.childElementBorderRadius = 20,
    this.onTap, required this.children,
  });

  final double? width;
  final double? height;
  final String type;
  final bool isExtended;
  final bool freeScroll;
  final String heroAlignment;
  final double uncontainedItemExtent;
  final double uncontainedShrinkExtent;
  final double childElementBorderRadius;
  final void Function(int selectedIndex)? onTap;
  final List<Widget> children;

  @override
  State<M3Carousel> createState() => _M3CarouselState();
}
class _M3CarouselState extends State<M3Carousel> {

  double frameWidth = 0.0;
  double frameHeight = 0.0;
  bool initiated = false;
  bool isDragging = false;
  CarouselController controller = CarouselController();
  List<int> layoutWeight = [];
  int itemScrolled = 0;

  void scrollFrame(int direction) {
    double prevScrollPosition = controller.position.pixels, nextScrollPosition = 0.0;
    if (widget.type == "hero") {
      double shouldAddOrSubtract = (((layoutWeight.reduce(widget.heroAlignment == "left" ? max : min) * 10) / 100) * frameWidth);
      int limit = 0;
      switch(widget.heroAlignment) {
        case "center":  limit = direction == 0 ? 0 : 3; break;
        case "left":    limit = direction == 0 ? 0 : 2; break;
        case "right":   limit = direction == 0 ? 0 : 2; break;
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
    } else
    if (widget.type == "contained") {
      double shouldAddOrSubtract = (((layoutWeight.reduce(max) * 10) / 100) * frameWidth);
      if (direction == 0) {
        if (itemScrolled <= 0) return;
        nextScrollPosition = prevScrollPosition - shouldAddOrSubtract;
        itemScrolled -= 1;
      } else {
        if (itemScrolled >= (widget.children.length - (widget.isExtended ? 4 : 3))) return;
        nextScrollPosition = prevScrollPosition + shouldAddOrSubtract;
        itemScrolled += 1;
      }
    }
    else {
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
    controller.animateTo(nextScrollPosition, duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  void onHorizontalDragEnd(DragEndDetails details) {
    isDragging = false;
    if (details.primaryVelocity! > (kIsWeb ? 0 : 300)) {
      scrollFrame(0);
    } else
    if (details.primaryVelocity! < -(kIsWeb ? 0 : 300)) {
      scrollFrame(1);
    }
  }

  Widget setGestureLayer(Widget child) => widget.freeScroll
  ? child : GestureDetector(
    onHorizontalDragStart: (details) { isDragging = true; },
    onHorizontalDragEnd: onHorizontalDragEnd,
    child: child,
  );

  @override
  void initState() {
    switch(widget.type) {
      case "hero":
        switch(widget.heroAlignment) {
          case "left":    layoutWeight = [8,2];   controller = CarouselController(initialItem: 0); break;
          case "center":  layoutWeight = [2,6,2]; controller = CarouselController(initialItem: 1); break;
          default:        layoutWeight = [2,8];   controller = CarouselController(initialItem: 1); break;
        }
        break;
      case "contained":
        layoutWeight = widget.isExtended ? [4,3,2,1] : [5,4,1];
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
    return LayoutBuilder(builder: (_c,_d) {
      frameWidth = widget.width ?? _d.maxWidth;
      frameHeight = widget.height ?? _d.maxHeight;
      return setGestureLayer(SizedBox(
        width: frameWidth,
        height: frameHeight,
        child: widget.type == "uncontained"
        ? CarouselView(
          key: UniqueKey(),
          controller: controller,
          physics: widget.freeScroll ? null : const NeverScrollableScrollPhysics(),
          itemExtent: widget.uncontainedItemExtent,
          shrinkExtent: widget.uncontainedShrinkExtent,
          children: widget.children.asMap().entries.map((listItem) => ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(widget.childElementBorderRadius)),
            child: Stack(children: [
              listItem.value,
              widget.onTap == null ? const SizedBox(width: 0,height: 0,) : InkWell(onTap: () => widget.onTap!(listItem.key),),
            ],),
          )).toList(),
        )
        : CarouselView.weighted(
          key: UniqueKey(),
          controller: controller,
          layoutWeights: layoutWeight,
          physics: widget.freeScroll ? null : const NeverScrollableScrollPhysics().applyTo(const CarouselScrollPhysics()),
          itemSnapping: widget.freeScroll,
          children: widget.children.asMap().entries.map((listItem) => ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(widget.childElementBorderRadius)),
            child: Stack(children: [
              listItem.value,
              widget.onTap == null ? const SizedBox(width: 0,height: 0,) : InkWell(onTap: () => widget.onTap!(listItem.key),),
            ],),
          )).toList(),
        ),
      ));
    });
  }
}
