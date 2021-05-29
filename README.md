A Parallax behavior for any Flutter Scrollable

<!-- Add badges here -->

This plugin enable a parallax effect in any `Scrollable`, simply wrap your `Scrollable` in a `ParallaxArea` and use a `ParallaxWidget` inside it.
Interactive web sample [Here](http://parallax.hatdroid.com)
 

PageView Vertical           |  PageView Horizontal
:-------------------------:|:-------------------------:
<img src="pathToImage?raw=true" alt="An animated image of the parallax animation inside a PageView"/>
 |  <img src="pathToImage?raw=true" alt="An animated image of the parallax animation inside a PageView"/>

ListView Vertical           |  ListView Horizontal
:-------------------------:|:-------------------------:
<img src="pathToImage?raw=true" alt="An animated image of the parallax animation inside a PageView"/>
 |  <img src="pathToImage?raw=true" alt="An animated image of the parallax animation inside a PageView"/>


## Features

* Overlap foreground and background parallax
* Customizable magnitude of the Parallax
* Works with any `Scrollable`
* Parallax vertically, horizontally or both
* Inverted parallax

## Usage

This plugin relies on RenderBox calculation and Scrollable notification to move the content accordling
Simply wrap any Scrollable with a ParallaxArea and use a ParallaxWidget inside your scrollable to Enable the effect

### Sample

The following sample show how to add a parallax background to a `PageView`:

```dart
ParallaxArea(
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
```

## Parallax properties

`Widget child;`
Main child to be displayed, the size of the background will be matched to this child.

`Widget? background;`
The widget to be placed in the background, it will be contained in a `OverflowBox` and sized according to `overflowWidthFactor` and `overflowHeightFactor`.

`double overflowWidthFactor;`
The width multiplier factor, the background will be as larger as the child multiplied by the `overflowWidthFactor`, increasing this value will increase the parallax effect during horizontal scroll.
_Min value 1, default value 2._

`double overflowHeightFactor;`
The height multiplier factor, the background will be as taller as the child multiplied by the `overflowHeightFactor`, increasing this value will increase the parallax effect during vertical scroll.
_Min value 1, default value 2._


`bool fixedHorizontal;`
If true the parallax effect will be disabled for the horizontal Axis. 
_Default value false._

`bool fixedVertical;`
If true the parallax effect will be disabled for the vertical Axis. 
_Default value false._

`bool inverted;`
If true the parallax effect will be inverted for both Axis. 
_Default value false._

`Alignment alignment;`
Define the point where this Parallax should be centered The aligment will be relative to the parent ParallaxArea.
For example if you set the Alignment.topLeft, the Background widget will be centered when the ParallaxWidget top and left will be aligned with the top and the left of the ParallaxArea parent.
_default value `Alignment.center`._

`bool clipOverflow;`
Define if the overflow should be clipped, if not clipped the content will overflow outside the ParallaxWidget.
_Default value true._

`EdgeInsets parallaxPadding;`
Give the parallax a general padding, used to avoid pixel bleeding if the content doesn't cover completely the viewport.
_Default value `EdgeInsets.zero`._

`bool showDebugInfo;`
Show some debug info like positioning on the current parallax boundary and overflows.
