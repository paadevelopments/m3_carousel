# M3_Carousel
A flutter implementation of the [Material Design 3 carousel](https://m3.material.io/components/carousel/overview).
Built on the [`CarouselView`](https://github.com/flutter/flutter/blob/7e87f1f5bb5cdafa1efa1600d48b9e0a41dc4af1/packages/flutter/lib/src/material/carousel.dart).

## Feature Highlights
- Hero carousel with support for "left", "center" and "right" alignments.  
  ![](https://raw.githubusercontent.com/paadevelopments/m3_carousel/main/extras/hero.gif)

- Contained carousel. Extended view inclusive.  
  ![](https://raw.githubusercontent.com/paadevelopments/m3_carousel/main/extras/contained.gif)

- Uncontained carousel.  
  ![](https://raw.githubusercontent.com/paadevelopments/m3_carousel/main/extras/uncontained.gif)

- Horizontal or vertical scrolling via `axis`.

## Installing
In your pubspec.yaml
```yaml
dependencies:
  m3_carousel: ^2.1.2 # requires Dart => ^3.12.0, Flutter >=3.38.0
```

## Usage
```dart
import "package:m3_carousel/m3_carousel.dart";

M3Carousel(
    type: CarouselType.hero,
    heroAlignment: HeroAlignment.center,
    axis: Axis.horizontal,
    onTap: (int tapIndex) => log(tapIndex.toString()),
    children: List<Widget>.generate(10, (int index) {
        return ColoredBox(
            color: Colors.primaries[index % Colors.primaries.length]
                .withValues(alpha: 0.8),
            child: const SizedBox.expand(),
        );
    }),
),
```
See [example/lib/main.dart](https://github.com/paadevelopments/m3_carousel/blob/main/example/lib/main.dart)
for complete examples.

## Reference
Use of `CarouselView` is govern by the [`Flutter Authors LICENSE`](https://github.com/flutter/flutter/blob/7e87f1f5bb5cdafa1efa1600d48b9e0a41dc4af1/LICENSE)

## License
MIT license
