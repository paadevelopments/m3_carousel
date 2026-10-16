import "dart:developer";

import "package:m3_carousel/m3_carousel.dart";
import "package:material_ui/material_ui.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      theme: ThemeData(colorSchemeSeed: const Color(0xFF6750A4)),
      home: const MyApp(),
    ),
  );
}

const List<Map<String, String>> images = [
  {"image": "assets/i1.png", "title": "Android"},
  {"image": "assets/i2.png", "title": "IOS"},
  {"image": "assets/i3.png", "title": "Windows"},
  {"image": "assets/i4.png", "title": "Mac"},
  {"image": "assets/i5.png", "title": "Linux"},
  {"image": "assets/i6.png", "title": "Others"},
];

List<M3CarouselItem> carouselItems({bool varyAspect = false}) {
  return List<M3CarouselItem>.generate(images.length, (int index) {
    final Map<String, String> image = images[index];
    return M3CarouselItem(
      semanticLabel: image["title"],
      image: Image.asset(image["image"]!, fit: BoxFit.cover),
      title: Text(
        image["title"]!,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: const Text("Photo", style: TextStyle(color: Colors.white)),
      prefixText: Text(
        "P${index + 1}",
        style: const TextStyle(color: Colors.white),
      ),
      aspectRatio: varyAspect && index.isOdd ? 9 / 16 : 16 / 9,
      showScrim: const M3CarouselScrim.gradient(),
      onTap: () => log(index.toString()),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Material Design 3 Carousel")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const LabelWidget(text: "Hero layout"),
            LayoutWidget(
              child: M3Carousel(
                type: M3CarouselType.hero,
                heroAlignment: M3HeroAlignment.center,
                onTap: (int tapIndex) => log(tapIndex.toString()),
                children: carouselItems(),
              ),
            ),
            const SizedBox(height: 20),
            const LabelWidget(text: "Contained layout"),
            LayoutWidget(
              height: 220,
              child: M3Carousel(
                type: M3CarouselType.contained,
                header: const Text("Platforms"),
                onTap: (int tapIndex) => log(tapIndex.toString()),
                children: carouselItems(),
              ),
            ),
            const SizedBox(height: 20),
            const LabelWidget(text: "Uncontained layout"),
            LayoutWidget(
              height: 220,
              child: M3Carousel(
                type: M3CarouselType.uncontained,
                showAll: true,
                onTap: (int tapIndex) => log(tapIndex.toString()),
                children: carouselItems(),
              ),
            ),
            const SizedBox(height: 20),
            const LabelWidget(text: "Uncontained multi-aspect layout"),
            LayoutWidget(
              child: M3Carousel(
                type: M3CarouselType.uncontainedMultiAspect,
                onTap: (int tapIndex) => log(tapIndex.toString()),
                children: carouselItems(varyAspect: true),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const FullScreenPage(),
                ),
              ),
              child: const Text("Open full-screen layout"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class FullScreenPage extends StatelessWidget {
  const FullScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Full-screen layout")),
      body: M3Carousel(
        type: M3CarouselType.fullScreen,
        onTap: (int tapIndex) => log(tapIndex.toString()),
        children: carouselItems(),
      ),
    );
  }
}

class LabelWidget extends StatelessWidget {
  final String text;

  const LabelWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 12.0, bottom: 4.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text, style: const TextStyle(fontSize: 15)),
      ),
    );
  }
}

class LayoutWidget extends StatelessWidget {
  final double height;
  final Widget child;

  const LayoutWidget({super.key, this.height = 180, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: double.maxFinite, height: height, child: child);
  }
}
