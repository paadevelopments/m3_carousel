part of 'carousel_wrapper.dart';

/// Tap handling and the container-transform launch for
/// [_CarouselWrapperState].
extension _CarouselWrapperTap on _CarouselWrapperState {
  Future<void> _handleTap(int index) async {
    if (widget.onTap != null) {
      CarouselHaptics.trigger(widget.haptic);
    }
    widget.onTap?.call(index);
    if (_pulseController.isAnimating) {
      return;
    }

    setState(() {
      _activeIndex = index;
      _snapshotVisibleNeighbors(index, _viewportBox);
    });

    await _pulseController.forward();
    await _pulseController.reverse();

    if (mounted) {
      setState(() {
        _activeIndex = null;
        _leftVisibleNeighborIndex = null;
        _rightVisibleNeighborIndex = null;
      });
    }
    final CarouselItem item = _itemAt(index);
    final Widget? destination = item.transform;
    if (destination != null && item.enabled && mounted) {
      _openItemTransform(index, destination);
    }
  }

  void _openItemTransform(int index, Widget destination) {
    RenderBox? box = _itemBoxes[index];
    if (box == null || !box.hasSize || !box.attached) {
      final RenderObject? object = _itemFocus[index].context
          ?.findRenderObject();
      if (object is RenderBox && object.hasSize && object.attached) {
        box = object;
      }
    }
    if (box == null) {
      return;
    }
    final Rect origin = box.localToGlobal(Offset.zero) & box.size;
    final theme = Theme.of(context);
    final radius = widget.shape is RoundedRectangleBorder
        ? (widget.shape! as RoundedRectangleBorder).borderRadius as BorderRadius
        : BorderRadius.zero;
    CarouselContainerTransform.show<void>(
      context: context,
      origin: origin,
      originRadius: radius.topLeft.x,
      originColor: theme.colorScheme.surface,
      builder: (BuildContext context) => destination,
    );
  }
}
