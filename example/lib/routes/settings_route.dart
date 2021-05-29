import 'package:example/data/parallax_preference.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsRoute extends StatefulWidget {
  final ParallaxPreferences preferences;

  const SettingsRoute(this.preferences, {Key? key}) : super(key: key);

  @override
  _SettingsRouteState createState() => _SettingsRouteState();
}

class _SettingsRouteState extends State<SettingsRoute> {
  late ParallaxPreferences preferences;
  final labelPageView = "PageView";
  final labelListView = "ListView";

  final labelVertical = "Vertical";
  final labelHorizontal = "Horizontal";

  final availableAlignments = [
    Alignment.topLeft,
    Alignment.topCenter,
    Alignment.topRight,
    Alignment.centerLeft,
    Alignment.center,
    Alignment.centerRight,
    Alignment.bottomLeft,
    Alignment.bottomCenter,
    Alignment.bottomRight,
  ];

  @override
  void initState() {
    preferences = widget.preferences;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Settings")),
        body: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      SizedBox(height: 16.0),

                      /// Use pageView
                      ListTile(
                        title: Text("Display option"),
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: CupertinoSegmentedControl(
                              children: <String, Widget>{
                                labelPageView: Text(labelPageView),
                                labelListView: Text(labelListView),
                              },
                              groupValue: preferences.usePageView
                                  ? labelPageView
                                  : labelListView,
                              onValueChanged: (value) {
                                this.setState(() => preferences =
                                    preferences.copyWith(
                                        usePageView: value == labelPageView));
                              }),
                        ),
                      ),
                      Divider(),

                      /// Scroll direction
                      ListTile(
                        title: Text("Scroll direction"),
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: CupertinoSegmentedControl(
                              children: <String, Widget>{
                                labelVertical: Text(labelVertical),
                                labelHorizontal: Text(labelHorizontal),
                              },
                              groupValue:
                                  preferences.scrollDirection == Axis.vertical
                                      ? labelVertical
                                      : labelHorizontal,
                              onValueChanged: (value) {
                                this.setState(() => preferences =
                                    preferences.copyWith(
                                        scrollDirection: value == labelVertical
                                            ? Axis.vertical
                                            : Axis.horizontal));
                              }),
                        ),
                      ),
                      Divider(),

                      /// overflowWidthFactor
                      ListTile(
                        title: Text("Overflow width factor"),
                        subtitle: Column(
                          children: [
                            Text(
                              "The width multiplier factor, the background will be as larger as the child multiplied by the overflowWidthFactor",
                            ),
                            Row(children: [
                              Text("1"),
                              Expanded(
                                child: Slider(
                                    value: preferences.overflowWidthFactor,
                                    min: 1,
                                    max: 10,
                                    onChanged: (newValue) {
                                      setState(
                                        () {
                                          preferences = preferences.copyWith(
                                              overflowWidthFactor: newValue);
                                        },
                                      );
                                    }),
                              ),
                              Text("10"),
                            ]),
                          ],
                        ),
                      ),
                      Divider(),

                      /// overflowHeightFactor
                      ListTile(
                        title: Text("Overflow height factor"),
                        subtitle: Column(
                          children: [
                            Text(
                              "The height multiplier factor, the background will be as taller as the child multiplied by the overflowWidthFactor",
                            ),
                            Row(children: [
                              Text("1"),
                              Expanded(
                                child: Slider(
                                    value: preferences.overflowHeightFactor,
                                    min: 1,
                                    max: 10,
                                    onChanged: (newValue) {
                                      setState(
                                        () {
                                          preferences = preferences.copyWith(
                                              overflowHeightFactor: newValue);
                                        },
                                      );
                                    }),
                              ),
                              Text("10"),
                            ]),
                          ],
                        ),
                      ),
                      Divider(),

                      /// fixedHorizontal
                      SwitchListTile(
                          title: Text("Fixed horizontal"),
                          subtitle: Text(
                            "Enabling this will disable the parallax effect for the horizontal Axis",
                          ),
                          value: preferences.fixedHorizontal,
                          onChanged: (newValue) {
                            setState(
                              () {
                                preferences = preferences.copyWith(
                                    fixedHorizontal: newValue);
                              },
                            );
                          }),
                      Divider(),

                      /// fixedVertical
                      SwitchListTile(
                          title: Text("Fixed vertical"),
                          subtitle: Text(
                            "Enabling this will disable the parallax effect for the vertical Axis",
                          ),
                          value: preferences.fixedVertical,
                          onChanged: (newValue) {
                            setState(
                              () {
                                preferences = preferences.copyWith(
                                    fixedVertical: newValue);
                              },
                            );
                          }),
                      Divider(),

                      /// inverted
                      SwitchListTile(
                          title: Text("Inverted"),
                          subtitle: Text(
                            "By enabling this, the parallax effect will be inverted for both Axis",
                          ),
                          value: preferences.inverted,
                          onChanged: (newValue) {
                            setState(
                              () {
                                preferences =
                                    preferences.copyWith(inverted: newValue);
                              },
                            );
                          }),
                      Divider(),

                      /// alignment
                      ListTile(
                        title: Row(
                          children: [
                            Expanded(child: Text("Alignment")),
                            DropdownButton(
                              value: preferences.alignment,
                              items: availableAlignments
                                  .map((element) => DropdownMenuItem<Alignment>(
                                        child: Text("$element"),
                                        value: element,
                                      ))
                                  .toList(),
                              onChanged: (Alignment? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    preferences = preferences.copyWith(
                                        alignment: newValue);
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        subtitle: Text(
                          "define the point where this Parallax should be centered The aligment will be relative to the parent ParallaxArea, for example if you set the Alignment.topLeft, the Background widget will be centered when the ParallaxWidget top and left will be aligned with the top and theleft of the ParallaxArea parent.",
                        ),
                      ),
                      Divider(),

                      /// clipOverflow
                      SwitchListTile(
                          title: Text("Clip overflow"),
                          subtitle: Text(
                            "If enabed the content of the background will be clipped on the same size of the child, otherwise it will overflow outside the ParallaxWidget",
                          ),
                          value: preferences.clipOverflow,
                          onChanged: (newValue) {
                            setState(
                              () {
                                preferences = preferences.copyWith(
                                    clipOverflow: newValue);
                              },
                            );
                          }),
                      Divider(),

                      /// showDebug
                      SwitchListTile(
                          title: Text("Show debug info"),
                          subtitle: Text(
                            "If enabed an overlay with some debug information (position/offsets) will cover the ParallaxWidget",
                          ),
                          value: preferences.showDebugInfo,
                          onChanged: (newValue) {
                            setState(
                              () {
                                preferences = preferences.copyWith(
                                    showDebugInfo: newValue);
                              },
                            );
                          }),
                      Divider(),

                      ///show some debug info like positioning on the currentParallax boundary and overflows
                      //final bool showDebugInfo;
                      SizedBox(height: 16.0),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 60,
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(preferences);
                    },
                    child: Text("Save"),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
