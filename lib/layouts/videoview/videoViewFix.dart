import 'package:flutter/material.dart';
import 'package:socialoo/Helper/sizeConfig.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../post/video_in_full_screen.dart';

// ignore: must_be_immutable
class VideoViewFix extends StatefulWidget {
  final String? url;
  bool? play;
  bool? mute;
  final String? id;

  VideoViewFix({this.url, this.play, this.id, this.mute});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<VideoViewFix> with WidgetsBindingObserver {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  VideoPlayerController? controller;

  Duration? duration, position;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = VideoPlayerController.network(
      widget.url!,
    );

    controller!.addListener(() {
      if (mounted) setState(() {});
    });
    controller!.setLooping(true);
    controller!.initialize();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print('didChangeAppLifecycleState CALLED ✅');
    print(state);

    switch (state) {
      case AppLifecycleState.inactive:
        setState(() {
          controller!.setVolume(0.0);
        });
        print('AppLifecycleState inactive');
        break;
      case AppLifecycleState.resumed:
        setState(() {
          controller!.setVolume(0.5);
        });
        print('AppLifecycleState resumed');
        break;
      case AppLifecycleState.paused:
        setState(() {
          controller!.setVolume(0.0);
        });
        print('AppLifecycleState paused');
        break;
      case AppLifecycleState.detached:
        setState(() {
          controller!.setVolume(0.0);
        });
        print('AppLifecycleState detached');
        break;
    }
  }

  @override
  void didUpdateWidget(VideoViewFix oldWidget) {
    if (widget.play != null &&
        widget.play == true &&
        oldWidget.play != widget.play) {
      if (widget.play!) {
        controller!.play();
        controller!.setLooping(true);
      } else {
        controller!.pause();
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller!.dispose();
    controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Center(
            child: ClipRRect(
              child: Container(
                // height: SizeConfig.blockSizeVertical * 40,
                child: controller!.value.isInitialized
                    ? Center(
                        child: AspectRatio(
                            aspectRatio: controller!.value.aspectRatio,
                            child: VisibilityDetector(
                                key: Key(DateTime.now()
                                    .microsecondsSinceEpoch
                                    .toString()),
                                onVisibilityChanged: (VisibilityInfo info) {
                                  if (widget.play == true) {
                                    debugPrint(
                                        "${info.visibleFraction} of my widget is visible");
                                    if (info.visibleFraction <= 0.70) {
                                      if (controller != null)
                                        controller!.pause();
                                    } else {
                                      if (controller != null)
                                        controller!.play();
                                    }
                                  }
                                },
                                child: Stack(
                                  children: [
                                    VideoPlayer(
                                      controller!,
                                    ),
                                  ],
                                ))),
                      )
                    : AspectRatio(
                        aspectRatio: controller!.value.aspectRatio,
                        child: Container(
                            child: Center(
                          child: CircularProgressIndicator(),
                        )),
                      ),
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: controller!,
            builder: (context, VideoPlayerValue value, child) {
              return Padding(
                padding: const EdgeInsets.only(top: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      value.position.inMinutes.toString() +
                          ":" +
                          value.position.inSeconds.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
            },
          ),
          _overlayWidget(controller),
          playPauseButton(controller),
        ],
      ),
    );
  }

  Widget _overlayWidget(VideoPlayerController? controller) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomRight,
        child: RawMaterialButton(
          constraints: BoxConstraints.tight(Size(36, 36)),
          onPressed: () {
            print('Button is Pressed');

            if (widget.mute == false) {
              setState(() {
                widget.mute = true;
              });
              print(widget.mute);
            } else {
              setState(() {
                widget.mute = false;
                // controller.setVolume(0.0);
              });
              print(widget.mute);
            }

            // controller.pause();
            widget.mute!
                ? controller!.setVolume(0.0)
                : controller!.setVolume(0.5);
          },
          child:
              Icon(widget.mute! ? Icons.volume_off : Icons.volume_up, size: 18),
          shape: new CircleBorder(),
          elevation: 0.0,
          fillColor: Color.fromARGB(255, 240, 240, 240),
        ),
      ),
    );
  }

  Widget playPauseButton(VideoPlayerController? controller) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RawMaterialButton(
              constraints: BoxConstraints.tight(Size(36, 36)),
              onPressed: () {
                setState(() {
                  controller!.value.isPlaying
                      ? controller.pause()
                      : controller.play();
                  if (widget.play != null)
                    widget.play = widget.play == true ? false : true;
                });
              },
              child: Icon(
                controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
              shape: new CircleBorder(),
              elevation: 0.0,
              fillColor: Color.fromARGB(255, 240, 240, 240),
            ),
            RawMaterialButton(
              constraints: BoxConstraints.tight(Size(36, 36)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PlayStatus(widget.url!)));
              },
              child: Icon(Icons.fullscreen, size: 22),
              shape: new CircleBorder(),
              elevation: 0.0,
              fillColor: Color.fromARGB(255, 240, 240, 240),
            )
          ],
        ),
      ),
    );
  }
}
