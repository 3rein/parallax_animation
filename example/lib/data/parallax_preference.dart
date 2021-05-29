import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ParallaxPreferences {
  final Axis scrollDirection;
  final bool usePageView;
  final double overflowWidthFactor;
  final double overflowHeightFactor;
  final bool fixedHorizontal;
  final bool fixedVertical;
  final bool inverted;
  final Alignment alignment;
  final bool clipOverflow;
  final EdgeInsets parallaxPadding; 
  final bool showDebugInfo;

  const ParallaxPreferences(
      {
        this.scrollDirection = Axis.vertical,
        this.usePageView = true,
        this.overflowWidthFactor = 1.5,
        this.overflowHeightFactor = 1.5,
        this.fixedHorizontal = false,
        this.fixedVertical = false,
        this.inverted = false,
        this.alignment = Alignment.center,
        this.clipOverflow = true,
        this.showDebugInfo = false,
        this.parallaxPadding = const EdgeInsets.all(0)});

  ParallaxPreferences copyWith({
    Axis? scrollDirection,
    bool? usePageView,
    double? overflowWidthFactor,
    double? overflowHeightFactor,
    bool? fixedHorizontal,
    bool? fixedVertical,
    bool? inverted,
    Alignment? alignment,
    bool? clipOverflow,
    EdgeInsets? parallaxPadding,
    bool? showDebugInfo,
  }) {
    return new ParallaxPreferences(
      scrollDirection: scrollDirection ?? this.scrollDirection,
      usePageView: usePageView ?? this.usePageView,
      overflowWidthFactor: overflowWidthFactor ?? this.overflowWidthFactor,
      overflowHeightFactor: overflowHeightFactor ?? this.overflowHeightFactor,
      fixedHorizontal: fixedHorizontal ?? this.fixedHorizontal,
      fixedVertical: fixedVertical ?? this.fixedVertical,
      inverted: inverted ?? this.inverted,
      alignment: alignment ?? this.alignment,
      clipOverflow: clipOverflow ?? this.clipOverflow,
      parallaxPadding: parallaxPadding ?? this.parallaxPadding,
      showDebugInfo: showDebugInfo ?? this.showDebugInfo,
    );
  }
}