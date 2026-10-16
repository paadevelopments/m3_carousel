import 'package:flutter_test/flutter_test.dart';
import 'package:m3_carousel/m3_carousel.dart';
import 'package:material_ui/material_ui.dart';

void _enableItem() {}

List<M3CarouselItem> _items(int count) {
  return <M3CarouselItem>[
    for (int i = 0; i < count; i++)
      M3CarouselItem(
        onTap: _enableItem,
        image: ColoredBox(
          color: Colors.blue,
          child: Center(child: Text('item$i')),
        ),
      ),
  ];
}

void main() {
  testWidgets(
    'hero center keeps leading item onstage after light/dark toggle',
    _heroCenterKeepsLeadingItemOnstageAfterLightDarkTogg,
  );
  testWidgets(
    'weighted view with consumeMaxWeight false keeps item0 after theme toggle',
    _weightedViewWithConsumemaxweightFalseKeepsItem0After,
  );
}

Future<void> _heroCenterKeepsLeadingItemOnstageAfterLightDarkTogg(
  WidgetTester tester,
) async {
  final light = ThemeData(colorSchemeSeed: const Color(0xFF6750A4));
  final dark = ThemeData(
    colorSchemeSeed: const Color(0xFF6750A4),
    brightness: Brightness.dark,
  );
  var data = light;
  late void Function(void Function()) setHostState;

  await tester.pumpWidget(
    StatefulBuilder(
      builder: (context, setState) {
        setHostState = setState;
        return MaterialApp(
          home: Theme(
            data: data,
            child: Center(
              child: SizedBox(
                width: 400,
                height: 200,
                child: M3Carousel(children: _items(6)),
              ),
            ),
          ),
        );
      },
    ),
  );
  await tester.pumpAndSettle();

  expect(find.text('item0'), findsOneWidget);
  expect(find.text('item1'), findsOneWidget);
  final Offset before = tester.getTopLeft(find.text('item0'));

  setHostState(() => data = dark);
  await tester.pumpAndSettle();

  expect(find.text('item0'), findsOneWidget);
  expect(find.text('item1'), findsOneWidget);
  expect(tester.getTopLeft(find.text('item0')), before);
}

Future<void> _weightedViewWithConsumemaxweightFalseKeepsItem0After(
  WidgetTester tester,
) async {
  final light = ThemeData(colorSchemeSeed: const Color(0xFF6750A4));
  final dark = ThemeData(
    colorSchemeSeed: const Color(0xFF6750A4),
    brightness: Brightness.dark,
  );
  var data = light;
  late void Function(void Function()) setHostState;

  await tester.pumpWidget(
    StatefulBuilder(
      builder: (context, setState) {
        setHostState = setState;
        return MaterialApp(
          home: Theme(
            data: data,
            child: Center(
              child: SizedBox(
                width: 400,
                height: 200,
                child: M3CarouselView.weighted(
                  consumeMaxWeight: false,
                  flexWeights: const [2, 6, 2],
                  children: <Widget>[
                    for (int i = 0; i < 6; i++)
                      ColoredBox(
                        color: Colors.blue,
                        child: Center(child: Text('item$i')),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
  await tester.pumpAndSettle();
  expect(find.text('item0'), findsOneWidget);

  setHostState(() => data = dark);
  await tester.pumpAndSettle();
  expect(find.text('item0'), findsOneWidget);
}
