import 'package:example/data/parallax_preference.dart';
import 'package:example/routes/settings_route.dart';
import 'package:example/ui/parallax_item.dart';
import 'package:flutter/material.dart';
import 'package:parallax_animation/parallax_animation.dart';

class ParallaxRoute extends StatefulWidget {
  @override
  _ParallaxRouteState createState() => _ParallaxRouteState();
}

class _ParallaxRouteState extends State<ParallaxRoute> {
  var preferences = ParallaxPreferences();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Parallax sample"),
        actions: [
          IconButton(
              onPressed: () async {
                ParallaxPreferences? newPreferences =
                    await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                  return SettingsRoute(preferences);
                }));
                if(newPreferences != null) {
                  setState(() {
                    preferences = newPreferences;
                  });
                }
              },
              icon: Icon(
                Icons.settings,
              ))
        ],
      ),
      body: ParallaxArea(
        child: preferences.usePageView
            ? PageView.builder(
                scrollDirection: preferences.scrollDirection,
                itemBuilder: (context, index) {
                  return ParallaxItem(
                    preferences: preferences,
                    text: "PAGE ${index + 1}",
                    index: index,
                  );
                })
            : ListView.builder(
                scrollDirection: preferences.scrollDirection,
                itemBuilder: (context, index) {
                  return Container(
                    width: preferences.scrollDirection == Axis.vertical
                        ? double.infinity
                        : 200,
                    height: preferences.scrollDirection == Axis.horizontal
                        ? double.infinity
                        : 200,
                    child: ParallaxItem(
                      preferences: preferences,
                      text: "ITEM ${index + 1}",
                      index: index,
                    ),
                  );
                }),
      ),
    );
  }
}
