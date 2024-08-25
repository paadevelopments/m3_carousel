# M3_Carousel

A flutter implementation of the [Material Design 3 carousel](https://m3.material.io/components/carousel/overview).

![](https://raw.githubusercontent.com/paadevelopments/m3_carousel/809b814b8e66a6f57e0a6fe5af4641237ef247d0/extras/sample.gif)

## Features

Google's M3 standard carousel.

## Usage

```dart
import 'package:m3_carousel/m3_carousel.dart';

M3Carousel(
    visible: 3, // number of visible slabs
    borderRadius: 20,
    slideAnimationDuration: 500, // milliseconds
    titleFadeAnimationDuration: 300, // milliseconds
    childClick: (int index) {
        print("Clicked $index");
    },
    children: [
        { "image": "assets/i1.png", "title": "Android" },
        { "image": "assets/i2.png", "title": "IOS" },
        { "image": "assets/i3.png", "title": "Windows" },
        { "image": "assets/i4.png", "title": "Mac" },
        { "image": "assets/i5.png", "title": "Linux" },
        { "image": "assets/i6.png", "title": "Others" },
    ],
),
```
See [lib/m3_carousel.dart](https://github.com/paadevelopments/m3_carousel/blob/main/lib/m3_carousel.dart) for all available parameters and adjust to 
suit your preference.

## Examples

See [example/lib/main.dart](https://github.com/paadevelopments/m3_carousel/blob/main/example/lib/main.dart) for a complete example.

## Foot Note

This obviously still lacks some details in animation and flow according to M3's standard but 
should give a foundational idea on how to go about with the expected specs.

## License

MIT license
