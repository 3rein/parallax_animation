A Parallax behavior for any Flutter Scrollable

<!-- Add badges here -->

This plugin enable a parallax effect in any `Scrollable`, simply wrap your `Scrollable` in a `ParallaxArea` and use a `ParallaxWidget` inside it.
 
<img src="pathToImage?raw=true" alt="An animated image of the parallax animation inside a PageView"/>

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
