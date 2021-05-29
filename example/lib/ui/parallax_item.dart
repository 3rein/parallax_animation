import 'package:example/data/parallax_preference.dart';
import 'package:flutter/material.dart';

import 'package:parallax_animation/parallax_animation.dart';

class ParallaxItem extends StatelessWidget {
  final ParallaxPreferences preferences;
  final String text;
  final int index;

  const ParallaxItem({
    Key? key,
    required this.preferences,
    required this.text,
    required this.index,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return ParallaxWidget(
      overflowHeightFactor: preferences.overflowHeightFactor,
      overflowWidthFactor: preferences.overflowWidthFactor,
      fixedHorizontal: preferences.fixedHorizontal,
      fixedVertical: preferences.fixedVertical,
      inverted: preferences.inverted,
      alignment: preferences.alignment,
      clipOverflow: preferences.clipOverflow,
      showDebugInfo: preferences.showDebugInfo,
      parallaxPadding: preferences.parallaxPadding,
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      background: Image.asset(
        "assets/background_${index % 3}.jpg",
        fit: BoxFit.cover,
      ),
    );
  }
}
