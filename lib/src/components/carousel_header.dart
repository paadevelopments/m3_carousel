part of '../m3_carousel.dart';

/// Header, "Show all" button, and the shared full-item-list transition for
/// [_M3CarouselState].
extension _CarouselHeader on _M3CarouselState {
  void _openList(CarouselTheme theme) {
    final box = _trackKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) {
      return;
    }
    final Rect origin = box.localToGlobal(Offset.zero) & box.size;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    CarouselContainerTransform.show<void>(
      context: context,
      origin: origin,
      originRadius: theme.radiusFor(widget.type),
      originColor: scheme.surface,
      builder: (BuildContext context) {
        return CarouselShowAll(
          header: widget.header,
          children: widget.children,
        );
      },
    );
  }

  Widget _header(CarouselTheme theme) {
    return SizedBox(
      height: theme.arrowSize,
      child: Padding(
        padding: EdgeInsetsDirectional.only(start: theme.headerInset)
            .resolve(Directionality.of(context)),
        child: Row(
          children: <Widget>[
            Expanded(child: widget.header!),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              tooltip: 'Show all',
              onPressed: () => _openList(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showAll(CarouselTheme theme) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Padding(
        padding: EdgeInsets.only(top: theme.showAllGap),
        child: Padding(
          padding: EdgeInsets.all(theme.showAllPadding),
          child: TextButton(
            onPressed: () => _openList(theme),
            child: const Text('Show all'),
          ),
        ),
      ),
    );
  }
}
