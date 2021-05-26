import 'package:flutter/material.dart';
import 'package:parallax_animation/parallax_animation.dart';

void main() {
  runApp(ParallaxApp());
}

class ParallaxApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ParallaxPage(),
    );
  }
}

class ParallaxPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Parallax sample")),
      body: ParallaxArea(
        child: PageView.builder(
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return ParallaxWidget(
                child: Center(
                  child: Text(
                    "PAGE ${index + 1}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                overflowWidthFactor: 1,
                background: Image.asset(
                  "assets/background_${index % 3}.jpg",
                  fit: BoxFit.cover,
                ),
              );
            }),
      ),
    );
  }
}
