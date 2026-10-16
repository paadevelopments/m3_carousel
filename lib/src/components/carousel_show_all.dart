import 'package:material_ui/material_ui.dart';

import '../foundations/foundations.dart';
import 'carousel_item.dart';

/// Vertical page of every carousel item.
///
/// Shown by Show all and the header arrow. Repeats [header] when one was set.
class M3CarouselShowAll extends StatelessWidget {
  /// M3CarouselShowAll.
  const M3CarouselShowAll({required this.children, this.header, super.key});

  /// The same items the carousel shows.
  final List<M3CarouselItem> children;

  /// Header repeated from the carousel, when it has one.
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    return Material(
      color: scheme.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 48,
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  children: <Widget>[
                    Expanded(child: header ?? const SizedBox.shrink()),
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      tooltip: 'Back',
                      onPressed: () =>
                          M3CarouselContainerTransformScope.closeOf(context),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: children.length,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                itemBuilder: (BuildContext context, int index) {
                  final M3CarouselItem item = children[index];
                  return _ShowAllRow(
                    headline: item.semanticLabel ?? 'Item ${index + 1}',
                    leading: SizedBox(width: 56, height: 56, child: item.image),
                    transform: item.transform,
                    onTap: item.onTap,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One row of [M3CarouselShowAll]. When [transform] is set, tapping the row
/// morphs it into that full-screen destination.
class _ShowAllRow extends StatelessWidget {
  const _ShowAllRow({
    required this.headline,
    required this.leading,
    this.transform,
    this.onTap,
  });

  final String headline;
  final Widget leading;
  final Widget? transform;
  final VoidCallback? onTap;

  void _open(BuildContext context, Widget destination) {
    final RenderObject? object = context.findRenderObject();
    if (object is! RenderBox || !object.hasSize) {
      return;
    }
    M3CarouselContainerTransform.show<void>(
      context: context,
      origin: object.localToGlobal(Offset.zero) & object.size,
      originRadius: 0,
      originColor: Theme.of(context).colorScheme.surface,
      builder: (BuildContext context) => destination,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget? destination = transform;
    return ListTile(
      leading: leading,
      title: Text(headline),
      onTap: destination != null ? () => _open(context, destination) : onTap,
    );
  }
}
