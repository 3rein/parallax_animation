import 'package:example/routes/parallax_route.dart';
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ParallaxSample(),
    );
  }
}

class ParallaxSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Parallax sample"),
        actions: [
          IconButton(
              onPressed: () async {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ParallaxRoute();
                }));
              },
              icon: Icon(
                Icons.gamepad,
                semanticLabel: "Interactive experience",
              ))
        ],
      ),
      body: ParallaxArea(
        child: PageView.builder(
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return ParallaxWidget(
              child: Center(
                child: Text(
                  "PAGE ${index + 1}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              background: Image.asset(
                "assets/background_${index % 4}.jpg",
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
    );
  }
}
