import 'package:flutter/material.dart';

/// Widget used to provide his viewport boundary and scroll notification
/// to any [ParallaxWidget] along the subtree.
/// This widget needs to be placed above the [Scrollable] where we want to obtain the parallax effect
class ParallaxArea extends StatefulWidget {
  ParallaxArea({Key? key, required this.child, this.scrollController})
      : super(key: key);

  /// Provided child will be wrapped in a [NotificationListener] and shown as is
  final Widget child;

  /// Optional ScrollController, this is needed if you want to manage your scroll inside
  final ScrollController? scrollController;

  // Inner list for ParallaxWidget notifications handling
  @override
  _ParallaxAreaState createState() => _ParallaxAreaState();

  /// Utility method to obtain the current [ParallaxData] instance provided by [InheritedWidget] class
  static ParallaxData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ParallaxData>();
  }
}

class _ParallaxAreaState extends State<ParallaxArea> {
  final List<Function(ScrollNotification?, RenderObject?)> _listeners = [];
  late VoidCallback scrollListener;

  @override
  void initState() {
    super.initState();
    scrollListener = () => _handleEvent();
    widget.scrollController?.addListener(scrollListener);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _handleEvent();
    });
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollEvent) {
        _handleEvent(scrollEvent);
        return false;
      },
      child: ParallaxData(
        listeners: _listeners,
        child: widget.child,
        onAdd: (listener) {
          final renderObject = context.findRenderObject();
          if (renderObject != null) {
            listener(null, renderObject);
          }
        },
        onUpdateRequest: () {
          _handleEvent();
        },
      ),
    );
  }

  void _handleEvent([ScrollNotification? event]) {
    if (_listeners.isNotEmpty) {
      RenderObject? renderObject = context.findRenderObject();
      _listeners.forEach((callback) {
        callback(null, renderObject);
      });
    }
  }
}

/// ParallaxData InheritedWidget used to manage the [ParallaxWidget] listeners
class ParallaxData extends InheritedWidget {
  final Widget child;
  final List<Function(ScrollNotification, RenderObject)> listeners;
  final Function(Function(ScrollNotification?, RenderObject)) onAdd;
  final VoidCallback? onUpdateRequest;

  ParallaxData(
      {Key? key,
      this.listeners = const [],
      required this.child,
      required this.onAdd,
      this.onUpdateRequest})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return (oldWidget as ParallaxData).listeners != listeners;
  }

  // Subscribe to the ScrollNotification listener
  // the listener function will be called on any scroll event caught by the ParallaxArea
  void addListener(
      Function(ScrollNotification? scrollEvent, RenderObject? renderObject)
          listener) {
    listeners.add(listener);
    onAdd.call(listener);
  }

  void requestUpdate() {
    onUpdateRequest?.call();
  }

  // Remove the subscription to the ScrollNotification listener
  // Each listener should be removed when the creating Widget is disposed to avoid memory leaks
  void removeListener(
      Function(ScrollNotification scrollEvent, RenderObject renderObject)
          listener) {
    listeners.remove(listener);
  }
}
