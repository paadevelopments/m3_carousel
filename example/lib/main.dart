import "dart:developer";

import "package:flutter/material.dart";
import "package:m3_carousel/m3_carousel.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> images = [
      {"image": "assets/i1.png", "title": "Android"},
      {"image": "assets/i2.png", "title": "IOS"},
      {"image": "assets/i3.png", "title": "Windows"},
      {"image": "assets/i4.png", "title": "Mac"},
      {"image": "assets/i5.png", "title": "Linux"},
      {"image": "assets/i6.png", "title": "Others"},
    ];
    return Scaffold(
        appBar: AppBar(
          title: const Text("Material Design 3 Carousel"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  const LabelWidget(
                    text: "Hero layout",
                  ),
                  LayoutWidget(
                    child: M3Carousel(
                      type: CarouselType.hero,
                      heroAlignment: HeroAlignment.center,
                      onTap: (int tapIndex) => log(tapIndex.toString()),
                      children: images
                          .asMap()
                          .entries
                          .map((listItem) => ImageElement(
                                listValue: listItem.value,
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  const LabelWidget(
                    text: "Contained layout",
                  ),
                  LayoutWidget(
                      child: M3Carousel(
                    type: CarouselType.contained,
                    onTap: (int tapIndex) => log(tapIndex.toString()),
                    children: List<Widget>.generate(10, (int index) {
                      return ColoredBox(
                        color: Colors.primaries[index % Colors.primaries.length]
                            .withValues(alpha: 0.8),
                        child: const SizedBox.expand(),
                      );
                    }),
                  )),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  const LabelWidget(
                    text: "Uncontained layout",
                  ),
                  LayoutWidget(
                      isExpanded: true,
                      child: M3Carousel(
                        type: CarouselType.uncontained,
                        freeScroll: false,
                        onTap: (int tapIndex) => log(tapIndex.toString()),
                        children: List<Widget>.generate(10, (int index) {
                          return ContainedLayoutCard(
                              index: index, label: "Show $index");
                        }),
                      )),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }
}

class LabelWidget extends StatelessWidget {
  final String text;

  const LabelWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsetsDirectional.only(top: 8.0, start: 12.0, end: 4.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}

class LayoutWidget extends StatelessWidget {
  final bool isExpanded;
  final Widget child;

  const LayoutWidget({super.key, this.isExpanded = false, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isExpanded
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
      child: SizedBox(
        width: double.maxFinite,
        height: 150,
        child: child,
      ),
    );
  }
}

class ImageElement extends StatelessWidget {
  final Map listValue;

  const ImageElement({super.key, required this.listValue});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          listValue["image"],
          fit: BoxFit.cover,
          width: double.maxFinite,
          height: double.maxFinite,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              listValue["title"]!,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.clip,
            ),
          ),
        ),
      ],
    );
  }
}

class ContainedLayoutCard extends StatelessWidget {
  final int index;
  final String label;

  const ContainedLayoutCard({
    super.key,
    required this.index,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.primaries[index % Colors.primaries.length]
          .withValues(alpha: 0.5),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 20),
          overflow: TextOverflow.clip,
          softWrap: false,
        ),
      ),
    );
  }
}
