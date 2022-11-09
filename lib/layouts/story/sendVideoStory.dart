import 'dart:io';
import 'package:socialoo/global/global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:socialoo/layouts/navigationbar/navigation_bar.dart';
import 'package:socialoo/models/addPostModal.dart';
import 'package:video_player/video_player.dart';

class SendVideoStory extends StatefulWidget {
  final File? videoFile;

  SendVideoStory({this.videoFile});

  @override
  ChatBgState createState() => ChatBgState(videoFile: videoFile);
}

class ChatBgState extends State<SendVideoStory> {
  File? videoFile;
  ChatBgState({this.videoFile});
  String userId = '';
  var videoSize = '';
  // ignore: unused_field
  double _progress = 0;
  double percentage = 0;
  bool videoloader = false;
  String videoStatus = '';
  final TextEditingController textEditingController = TextEditingController();
  late VideoPlayerController _videoPlayerController;
  bool isLoading = false;

  AddPostModal? modal;

  @override
  void initState() {
    _pickVideo();

    super.initState();
  }

  _pickVideo() async {
    _videoPlayerController = VideoPlayerController.file(videoFile!)
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        title: Text(
          "Preview",
          style: Theme.of(context).textTheme.headline5!.copyWith(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
            )),
      ),
      body: Container(
        height: double.infinity,
        color: Colors.black,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    videoFile != null
                        ? _videoPlayerController.value.isInitialized
                            ? AspectRatio(
                                aspectRatio:
                                    _videoPlayerController.value.aspectRatio,
                                child: VideoPlayer(_videoPlayerController),
                              )
                            : Center(
                                child: Text(
                                  "Select video",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              )
                        : Container(),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFF1246A5), Color(0xFF1e3c72)],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        height: 45,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                              Colors.red.shade500,
                              Colors.red.shade900
                            ])),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancel",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                        ),
                      ),
                    ),
                    Container(
                        height: double.infinity,
                        width: 0.8,
                        color: Colors.black),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        addPost(context);
                      },
                      child: Text("Add",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    ))
                  ],
                ),
              ),
            ),
            Center(
              child: videoloader == true ? loader(context) : Container(),
            )
          ],
        ),
      ),
    );
  }

  addPost(BuildContext context) async {
    final dio = new Dio();
    setState(() {
      _videoPlayerController.setVolume(0);
      _videoPlayerController.pause();
    });

    LoaderDialog().showIndicator(context);
    var url = '${baseUrl()}/add_story';

    print(url);
    String name = DateTime.now().millisecondsSinceEpoch.toString();

    FormData formData = new FormData();
    formData = FormData.fromMap({
      'user_id': userID,
      'url':
          MultipartFile.fromFileSync(videoFile!.path, filename: name + ".mp4"),
      'type': 'video'
    });

    dio.options.contentType = Headers.jsonContentType;

    final response = await dio.post(url,
        data: formData,
        options: Options(method: 'POST', responseType: ResponseType.json));
    print(response.data.toString());

    LoaderDialog().hideIndicator(context);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => NavBar()),
      (Route<dynamic> route) => false,
    );
  }
}
