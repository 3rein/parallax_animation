import 'package:example/routes/parallax_route.dart';
import 'package:flutter/material.dart';

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
      home: ParallaxRoute(),
    );
  }
}


