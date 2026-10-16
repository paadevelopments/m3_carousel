# M3_Carousel
A flutter implementation of the [Material Design 3 carousel](https://m3.material.io/components/carousel/overview).
Built on the [`CarouselView`](https://github.com/flutter/flutter/blob/7e87f1f5bb5cdafa1efa1600d48b9e0a41dc4af1/packages/flutter/lib/src/material/carousel.dart).

## Feature Highlights
- Hero carousel with support for "left", "center" and "right" alignments.  
  ![](https://raw.githubusercontent.com/paadevelopments/m3_carousel/main/extras/hero_v2.gif)

- Contained carousel. Extended view inclusive.  
  ![](https://raw.githubusercontent.com/paadevelopments/m3_carousel/main/extras/contained_v2.gif)

- Uncontained carousel.  
  ![](https://raw.githubusercontent.com/paadevelopments/m3_carousel/main/extras/uncontained_v2.gif)

- Horizontal or vertical scrolling via `axis`.

## Installing
In your pubspec.yaml
```yaml
dependencies:
  m3_carousel: ^2.1.5 # requires Dart => ^3.13.0, Flutter >=3.47.0
```

## Migrating to `material_ui`
As of `2.1.5`, this package imports Material from the
[`material_ui`](https://pub.dev/packages/material_ui) package instead of `package:flutter/material.dart`.
To migrate your app, add `material_ui` to your pubspec.yaml:
```yaml
dependencies:
  material_ui: ^1.7.0
```
Then replace your Material imports:
```dart
// Before
import "package:flutter/material.dart";

// After
import "package:material_ui/material_ui.dart";
```
Every public `m3_carousel` type carries the `M3` prefix (`M3CarouselItem`, `M3CarouselController`,
`M3CarouselView`, ...), so it imports alongside material_ui without name clashes.

## Usage
```dart
import "package:m3_carousel/m3_carousel.dart";
import "package:material_ui/material_ui.dart";

M3Carousel(
  type: M3CarouselType.hero,
  heroAlignment: M3HeroAlignment.center,
  axis: Axis.horizontal,
  onTap: (int tapIndex) => log(tapIndex.toString()),
  children: List<M3CarouselItem>.generate(10, (int index) {
    return M3CarouselItem(
      image: Image.asset("assets/i${index % 6 + 1}.png", fit: BoxFit.cover),
      title: Text("Item $index"),
      showScrim: const M3CarouselScrim.gradient(),
      onTap: () {},
    );
  }),
),
```
Available layouts: `M3CarouselType.hero`, `M3CarouselType.contained`, `M3CarouselType.uncontained`,
`M3CarouselType.uncontainedMultiAspect` and `M3CarouselType.fullScreen`.

Customize spec defaults by installing an `M3CarouselTheme` extension:
```dart
MaterialApp(
  theme: ThemeData(
    extensions: const <ThemeExtension<dynamic>>[
      M3CarouselTheme(itemGap: 8, borderRadiusValue: 28),
    ],
  ),
);
```
See [example/lib/main.dart](https://github.com/paadevelopments/m3_carousel/blob/main/example/lib/main.dart)
for complete examples.

## Reference
Use of `CarouselView` is govern by the [`Flutter Authors LICENSE`](https://github.com/flutter/flutter/blob/7e87f1f5bb5cdafa1efa1600d48b9e0a41dc4af1/LICENSE)

## License
MIT license
