// ignore_for_file: implementation_imports, non_constant_identifier_names, unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:socialoo/global/global.dart';
import 'package:socialoo/models/userdata_model.dart';

import 'create_post_first_step.dart';

class PostBox extends StatefulWidget {
  final GlobalKey<ScaffoldState>? parentScaffoldKey;
  final String? userimage;
  final String? userName;

  PostBox({
    Key? key,
    this.parentScaffoldKey,
    this.userimage,
    this.userName,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _MyHomePageState extends State<PostBox> {
  // AppState? state;
  // File? imageFile;
  // File? pdffile;
  //
  // bool selectPhoto = false;
  //
  // bool selectVideo = false;
  bool isLoading = false;
  // File? _video;

  //File _cameraVideo;

  // late VideoPlayerController _videoPlayerController;

  // ignore: unused_field
  // VideoPlayerController? _cameraVideoPlayerController;

  // List<File?> alldata = [];
  late UserDataModel modal;

  // var savedimageUrls = [];

  // final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    _getRequests();
    super.initState();
  }

  _getRequests() async {
    _getUser();
  }

  _getUser() async {
    setState(() {
      isLoading = true;
    });
    var uri = Uri.parse('${baseUrl()}/user_data');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['user_id'] = userID!;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    modal = UserDataModel.fromJson(userData);
    print(responseData);
    if (modal.responseCode == "1") {
      userfullname = modal.user!.fullname;

      userGender = modal.user!.gender;
      userPhone = modal.user!.phone;
      userEmail = modal.user!.email;
      userName = modal.user!.username;
      userImage = modal.user!.profilePic;
      userCoverImage = modal.user!.coverPic;
      userBio = modal.user!.bio;
      intrestarray = modal.user!.interestsId;
      if (userImage != '') print(userImage);
    }
    // _getPost();
  }

  Future<dynamic> checkPostTypeDialog(context, {int? isStory}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 15),
          titlePadding: EdgeInsets.symmetric(horizontal: 15),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 15),
              Text(
                "Select Post Type",
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 25),
              SizedBox(
                width: MediaQuery.of(context).size.width - 60,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(),
                    child: Text(
                      'MISSING PERSON',
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreatePostFirstStep(
                                    userName: userName,
                                    userimage: userImage,
                                    postType: "missing",
                                  )));
                    }),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 60,
                child: ElevatedButton(
                    child: Text(
                      "UNCLAIMED PERSON",
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreatePostFirstStep(
                                    userName: userName,
                                    userimage: userImage,
                                    postType: "found",
                                  )));
                    }),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 60,
                child: ElevatedButton(
                    child: Text(
                      "UNCLAIMED DEAD BODY",
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreatePostFirstStep(
                                    userName: userName,
                                    userimage: userImage,
                                    postType: "dead",
                                  )));
                    }),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red, fontSize: 15),
                ),
                onPressed: () => Navigator.pop(context)),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 10.0),
      elevation: 0.0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 0.0),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: userImage == null || userImage!.isEmpty
                      ? Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF003a54),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Image.asset(
                            'assets/images/defaultavatar.png',
                            width: 55,
                            height: 55,
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: userImage!,
                          height: 55,
                          width: 55,
                          fit: BoxFit.cover,
                        ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Container(
                    child: IgnorePointer(
                      child: TextField(
                          decoration: InputDecoration(
                              hintText: 'What\'s on your mind?',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 25),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300, width: 1.0),
                              ),
                              filled: false)),
                    ),
                  ).onTap(() {
                    checkPostTypeDialog(context);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => PhotoScreen(
                    //               userName: widget.userName,
                    //               userimage: widget.userimage,
                    //             )));
                  }),
                ),
                const SizedBox(width: 8.0),
              ],
            ),
            const Divider(height: 10.0, thickness: 0.5),
            SizedBox(
              height: 40.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      checkPostTypeDialog(context, isStory: 1);
                      // selectImageSource();
                    },
                    icon: Image.asset(
                      "assets/images/photo_add.png",
                      width: 20,
                    ),
                    label: Text(
                      'Photo',
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                  const VerticalDivider(width: 8.0),
                  TextButton.icon(
                    onPressed: () {
                      checkPostTypeDialog(context, isStory: 2);

                      // selectVideoSource();
                    },
                    icon: Image.asset(
                      "assets/images/video_add.png",
                      width: 20,
                    ),
                    label: Text(
                      'Video',
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                  const VerticalDivider(width: 8.0),
                  TextButton.icon(
                    onPressed: () {
                      checkPostTypeDialog(context, isStory: 3);

                      // selectPDFFile();
                    },
                    icon: Image.asset(
                      "assets/images/pdf_add.png",
                      width: 20,
                    ),
                    label: Text(
                      'PDF',
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
