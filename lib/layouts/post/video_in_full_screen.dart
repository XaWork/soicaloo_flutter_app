import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:video_player/video_player.dart';

class PlayStatus extends StatefulWidget {
  final String videoFile;

  PlayStatus(this.videoFile);

  @override
  _PlayStatusState createState() => new _PlayStatusState();
}

class _PlayStatusState extends State<PlayStatus> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  // final videoPlayerController = VideoPlayerController.network(
  //     'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');
  //
  // await videoPlayerController.initialize();
  //
  // final chewieController = ChewieController(
  //   videoPlayerController: videoPlayerController,
  //   autoPlay: true,
  //   looping: true,
  // );

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.videoFile)
      ..initialize();
    // _videoPlayerController!.initialize();
    // _videoPlayerController1.pause();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: true,
      looping: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController!.dispose();
    _chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: blackColor,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 25),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: _chewieController != null
              ? Chewie(
                  controller: _chewieController!,
                )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
