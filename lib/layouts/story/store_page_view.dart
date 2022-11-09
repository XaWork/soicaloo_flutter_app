import 'dart:convert';

import 'package:socialoo/storyPlugin/story_view.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class StoryPageView extends StatelessWidget {
  List? images;

  StoryPageView({this.images});

  @override
  Widget build(BuildContext context) {
    print(json.encode(images));
    final controller = StoryController();
    List<StoryItem> stories = [];

    for (var value in images!) {
      if (value.type == "image") {
        stories.add(
          StoryItem.pageImage(
            controller: controller,
            url: value.url,
            duration: Duration(seconds: 5),
            shown: true,
            imageFit: BoxFit.contain,
          ),
        );
      } else {
        stories.add(StoryItem.pageVideo(value.url,
            controller: controller,
            shown: true,
            duration: Duration(seconds: 10)));
      }
    }

    return Material(
      child: Stack(
        children: <Widget>[
          StoryView(
              storyItems: stories,
              controller: controller,
              inline: false,
              repeat: false,
              onComplete: () {
                controller.pause();
                Navigator.pop(context);
              },
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  controller.pause();
                  Navigator.pop(context);
                }
              }),
        ],
      ),
    );
  }
}
