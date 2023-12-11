import 'package:flutter/material.dart';
import 'package:m3_carousel/m3_carousel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(home: MyApp()));
}
class MyApp extends StatelessWidget {
  const MyApp({ super.key, });
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> images = [
      { "image": "assets/i1.png", "title": "Android" },
      { "image": "assets/i2.png", "title": "IOS" },
      { "image": "assets/i3.png", "title": "Windows" },
      { "image": "assets/i4.png", "title": "Mac" },
      { "image": "assets/i5.png", "title": "Linux" },
      { "image": "assets/i6.png", "title": "Others" },
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material Design 3 Carousel'),
      ),
      body: Container(
        width: double.maxFinite,
        height: 200,
        padding: const EdgeInsets.all(10),
        child: M3Carousel(
          visible: 3,
          borderRadius: 20,
          slideAnimationDuration: 500,
          titleFadeAnimationDuration: 300,
          childClick: (int index) {
            print("Clicked $index");
          },
          children: images,
        ),
      ),
    );
  }
}
