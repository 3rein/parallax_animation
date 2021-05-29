import 'dart:math';

import 'package:flutter/material.dart';

import 'parallax_area.dart';

/// A widget that overlap two widgets and gives a parallax effect to the background one.
/// The effect is obtained by using a Stack and a nested [OverflowBox] twice the size of the main child
/// For this widget working it needs to find a [ParallaxArea] somewhere above the tree
/// The center of the parallax effect will be on the center of the first [ParallaxArea] found
/// If no [ParallaxArea] is found this widget will simply render the [child] and the [background] without any effect.

class ParallaxWidget extends StatefulWidget {
  const ParallaxWidget({
    Key? key,
    required this.child,
    this.background,
    this.overflowWidthFactor = 2,
    this.overflowHeightFactor = 2,
    this.fixedHorizontal = false,
    this.fixedVertical = false,
    this.inverted = false,
    this.alignment = Alignment.center,
    this.clipOverflow = true,
    this.showDebugInfo = false,
    this.parallaxPadding = EdgeInsets.zero,
  }) : super(key: key);

  /// Main child to be displayed
  /// the size of the background will be matched to this child
  final Widget child;

  /// The widget to be placed in the background,
  /// it will be contained in a OverflowBox and sized according
  /// to overflowWidthFactor and overflowHeightFactor
  final Widget? background;

  /// The width multiplier factor, the background will be as larger as the child
  /// multiplied by the overflowWidthFactor.
  /// increasing this value will increase the parallax effect during horizontal scroll
  /// Min value 1, default value 2
  final double overflowWidthFactor;

  /// The height multiplier factor, the background will be as taller as the child
  /// multiplied by the overflowHeightFactor
  /// increasing this value will increase the parallax effect during vertical scroll
  /// Min value 1, default value 2
  final double overflowHeightFactor;

  /// if true the parallax effect will be disabled for the horizontal Axis
  /// default value false
  final bool fixedHorizontal;

  /// if true the parallax effect will be disabled for the vertical Axis
  /// default value false
  final bool fixedVertical;

  /// if true the parallax effect will be inverted for both Axis
  /// default value false
  final bool inverted;

  /// define the point where this Parallax should be centered
  /// The aligment will be relative to the parent ParallaxArea, for example
  /// if you set the Alignment.topLeft, the Background widget will be centered
  /// when the ParallaxWidget top and left will be aligned with the top and the
  /// left of the ParallaxArea parent.
  /// default value [Alignment.center]
  final Alignment alignment;

  /// define if the overflow should be clipped
  /// if not clipped the content will overflow outside the ParallaxWidget
  /// default value true
  final bool clipOverflow;

  /// give the parallax a general padding, used to avoid pixel
  /// bleeding if the content doesn't cover completely the viewport
  /// default value [EdgeInsets.zero]
  final EdgeInsets parallaxPadding;

  ///show some debug info like positioning on the currentParallax boundary and overflows
  final bool showDebugInfo;

  @override
  _ParallaxWidgetState createState() => _ParallaxWidgetState();
}

class _ParallaxWidgetState extends State<ParallaxWidget> {
  ParallaxData? parallaxArea;
  late Function(ScrollNotification?, RenderObject?) parallaxListener;
  Offset _backgroundOffset = Offset(0.5, 0.5);
  String _debugInfo = "No info";

  @override
  void initState() {
    super.initState();
    if (widget.overflowWidthFactor < 1 || widget.overflowHeightFactor < 1) {
      throw ArgumentError(
          "Overflows minimum value is 1, current overflow values(W: ${widget.overflowWidthFactor} - H: ${widget.overflowHeightFactor})");
    }

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      parallaxListener = _computeParallaxOffset;
      parallaxArea?.addListener(parallaxListener);
    });
  }

  @override
  void didChangeDependencies() {
    parallaxArea = ParallaxArea.of(context);
    if (parallaxArea == null) {
      throw ArgumentError("No ParallaxArea found over this widget in the tree");
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // Remove listeners on dispose
    parallaxArea?.removeListener(parallaxListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
            child: Padding(
          padding: widget.parallaxPadding,
          child: OptionalClipRect(
            clip: widget.clipOverflow,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                // Background sizes real constraint based on widget parameters
                double maxWidth =
                    constraints.maxWidth * widget.overflowWidthFactor;
                double maxHeight =
                    constraints.maxHeight * widget.overflowHeightFactor;
                return OverflowBox(
                    alignment:
                        Alignment(_backgroundOffset.dx, _backgroundOffset.dy),
                    maxHeight: maxHeight,
                    maxWidth: maxWidth,
                    child: SizedBox.fromSize(
                      size: Size(maxWidth, maxHeight),
                      child: widget.background,
                    ));
              },
            ),
          ),
        )),
        widget.child,
        if (widget.showDebugInfo)
          Positioned.fill(
            child: Container(
                alignment: Alignment.center,
                color: Colors.blue.withOpacity(0.8),
                child: Text(
                  _debugInfo,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )),
          ),
      ],
    );
  }

  /// Check if the current context is available and refresh the current state
  void _computeParallaxOffset(ScrollNotification? scrollNotification,
      RenderObject? parallaxAreaRenderObject) {
    // The widget is not rendered if the context is null, so we skip all the computations
    if (parallaxAreaRenderObject == null) {
      return;
    }

    final parallaxOffset = _getParallaxOffset(parallaxAreaRenderObject);

    // check if something has changed before calling set state
    if (parallaxOffset != null &&
        (parallaxOffset.dx != _backgroundOffset.dx ||
            parallaxOffset.dy != _backgroundOffset.dy)) {
      setState(() {
        _backgroundOffset = parallaxOffset;
      });
    }
  }

  /// Return the current offset based on the absolute position of this widget in the viewport
  /// If the widget is not attached or rendered (eg current context == null) this method will return null
  Offset? _getParallaxOffset(RenderObject parallaxAreaRenderObject) {
    // Check current widget RenderObject and the current translation in the viewport
    final renderObject = context.findRenderObject();

    // don't do anything if not attached
    if (renderObject == null || renderObject.attached != true) {
      return null;
    }

    final translation = renderObject.getTransformTo(null).getTranslation();
    final translationOffset = Offset(translation.x, translation.y);
    final shiftedRect = renderObject.paintBounds.shift(translationOffset);

    // Check parallaxArea widget RenderObject and the current translation in the viewport
    final areaTranslation =
        parallaxAreaRenderObject.getTransformTo(null).getTranslation();
    final areaTranslationOffset = Offset(areaTranslation.x, areaTranslation.y);
    final areaShiftedRect =
        parallaxAreaRenderObject.paintBounds.shift(areaTranslationOffset);

    double verticalOffsetRatio;
    double horizontalOffsetRatio;

    // Only move the parallax widget if visibile inside the parallax area
    if (!shiftedRect.overlaps(areaShiftedRect)) {
      return null;
    }

    // Compute the correct vertical axis parallax value taking account of alignment parameter,
    double centerVertical = shiftedRect.center.dy;
    double startingVerticalPoint =
        centerVertical + shiftedRect.height / 2 * widget.alignment.y;

    // if fixedVertical is true it will be centered
    if (widget.fixedVertical) {
      verticalOffsetRatio = widget.alignment.y;
    } else {
      // Shift the vertical center value to be aligned with the ParallaxArea viewport
      double shiftedY = startingVerticalPoint - areaShiftedRect.top;
      verticalOffsetRatio = shiftedY / areaShiftedRect.height;
      //alignment adjusting
      verticalOffsetRatio = verticalOffsetRatio * -2 + 1 + widget.alignment.y;
    }

    // Compute the correct horizontal axis parallax value taking account of alignment parameter,
    final centerHorizontal = shiftedRect.center.dx;
    final startingHorizontalPoint =
        centerHorizontal + shiftedRect.width / 2 * widget.alignment.x;

    // if fixedHorizontal is true it will be centered
    if (widget.fixedHorizontal) {
      horizontalOffsetRatio = widget.alignment.x;
    } else {
      // Shift the horizontal center value to be aligned with the ParallaxArea viewport
      double shiftedX = startingHorizontalPoint - areaShiftedRect.left;
      horizontalOffsetRatio = shiftedX / areaShiftedRect.width;
      horizontalOffsetRatio =
          horizontalOffsetRatio * -2 + 1 + widget.alignment.x;
    }

    Offset finalOffset;

    if (widget.inverted) {
      // Invert the offset
      verticalOffsetRatio *= -1;
      horizontalOffsetRatio *= -1;
    }

    // Normalize the offset in the range -1,1 for vertical and horizontal Parallax
    finalOffset = Offset(
      max(min(1, horizontalOffsetRatio), -1),
      max(min(1, verticalOffsetRatio), -1),
    );

    //store info for debugging
    _debugInfo = "Offset: $finalOffset"
        "\nAligmnent: ${widget.alignment}"
        "\nCenter vertical: $centerVertical"
        "\nshifted: ${shiftedRect.toString()}"
        "\nAreaShifted: ${areaShiftedRect.toString()}"
        "\nAligmnent: ${widget.alignment}";

    return finalOffset;
  }
}

/// ClipRect wrapper, wrap the child with a ClipRect only if the clip parameter is true
class OptionalClipRect extends StatelessWidget {
  final Widget child;
  final bool clip;

  const OptionalClipRect({Key? key, required this.child, this.clip = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return clip ? ClipRect(child: child) : child;
  }
}
