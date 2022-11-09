// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:socialoo/global/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:socialoo/Helper/sizeConfig.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:socialoo/layouts/story/previewStory.dart';
import 'package:socialoo/layouts/story/sendVideoStory.dart';
import 'package:socialoo/layouts/story/ver_stories.dart';
import 'package:socialoo/models/deleteStoryModal.dart';
import 'package:socialoo/models/followerPostModal.dart';
import 'package:socialoo/models/followersModal.dart';
import 'package:socialoo/models/followingModal.dart';
import 'package:socialoo/models/latest_model.dart';
import 'package:socialoo/models/likeModal.dart';
import 'package:socialoo/models/loginModal.dart';
import 'package:socialoo/models/unlikeModal.dart';
import 'package:socialoo/shared_preferences/preferencesKey.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

class AllStories extends StatefulWidget {
  final GlobalKey<ScaffoldState>? parentScaffoldKey;
  AllStories({Key? key, this.parentScaffoldKey}) : super(key: key);
  @override
  _AllStoriesState createState() => _AllStoriesState();
}

class _AllStoriesState extends State<AllStories>
    with SingleTickerProviderStateMixin {
  late Animation base;
  late AnimationController controller;

  DeleteStoryModal? deleteStoryModal;

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  FollowersModal? followersModal;

  late FollwingModal follwingModal;
  Animation? gap;
  bool isLoading = false;
  LatestPostModel? latestPostModel;
  LikeModal? likeModal;
  LoginModal? loginModal;
  late FollowerPostModal modal;
  Animation? reverse;
  int? page = 1;
  bool show = false;
  UnlikeModal? unlikeModal;
  bool pageloader = false;
  // ignore: unused_field
  double? _height, _width, _fixedPadding;
  // ignore: unused_field
  int _current = 0;
  late LoginModal loginModel;
  @override
  void initState() {
    print(userID);
    globleFollowers = [];
    globleFollowing = [];
    getUserDataFromPrefs().then((value) => this._getPost(page));

    initialiZeController();

    _getFollowers(userID);
    _getFollowing(userID);
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    base = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    reverse =
        Tween<double>(begin: .0, end: -1.0).animate(base as Animation<double>);
    gap = Tween<double>(begin: 5, end: 1.0).animate(base as Animation<double>)
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
    _deleteStory();

    super.initState();
  }

  Future getUserDataFromPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String userDataStr =
        preferences.getString(SharedPreferencesKey.LOGGED_IN_USERRDATA)!;
    Map<String, dynamic> userData = json.decode(userDataStr);
    loginModel = LoginModal.fromJson(userData);

    setState(() {
      userID = loginModel.user!.id;
      userImage = loginModel.user!.profilePic;
      userName = loginModel.user!.username;
      userfullname = loginModel.user!.fullname;
      userEmail = loginModel.user!.email;
      userBio = loginModel.user!.bio;
      userPhone = loginModel.user!.phone;
      userGender = loginModel.user!.gender;
      intrestarray = loginModel.user!.interestsId;

      _getFollowers(loginModel.user!.id);
      _getFollowing(loginModel.user!.id);
    });
  }

  List<Post> allPost = [];

  _getPost(int? index) async {
    setState(() {
      isLoading = true;
    });

    var uri = Uri.parse(
        '${baseUrl()}/all_post_by_user_pagination?per_page=10&page=${index.toString()}&user_id=$userID');
    var request = new http.MultipartRequest("GET", uri);
    print(uri.toString());
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    request.headers.addAll(headers);
    // request.fields['user_id'] = userID;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    if (mounted)
      setState(() {
        // allPost.clear();
        modal = FollowerPostModal.fromJson(userData);

        var contain =
            modal.post!.where((element) => element.postReport == "true");

        if (contain.isEmpty) {
          func(page);
        } else {
          funcCheck(page);
        }
      });
    print(responseData);

    for (int i = 0; i < modal.post!.length; i++) {
      allPost.add(modal.post![i]);
    }

    if (mounted)
      setState(() {
        isLoading = false;
      });
  }

  ScrollController sc = new ScrollController();

  initialiZeController() {
    sc.addListener(() {
      if (sc.position.pixels == sc.position.maxScrollExtent) {
        Future.delayed(Duration(seconds: 2)).whenComplete(() async {
          await _getPost(page);
        });
        print(page);
      }
    });
  }

  void func(page1) async {
    int? value = page1 + 10;
    int noValue = page1;
    if (modal.responseCode != '0') {
      print('if');
      setState(() {
        page = value;
        pageloader = true;
      });
    } else {
      setState(() {
        page = noValue;
        pageloader = false;
      });
    }
  }

  void funcCheck(page1) async {
    int? value = page1 + 10;
    int noValue = page1;
    if (modal.responseCode != '0') {
      setState(() {
        page = value;
        pageloader = true;
        _getPost(value);
      });
    } else {
      setState(() {
        page = noValue;
        pageloader = false;
      });
    }
  }

  _getFollowers(id) async {
    var uri = Uri.parse('${baseUrl()}/my_followers');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    request.headers.addAll(headers);
    request.fields['user_id'] = id;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    Map<String, dynamic> userData = json.decode(responseData);
    print(userData);
    followersModal = FollowersModal.fromJson(userData);
    if (followersModal != null) {
      print(followersModal!.follower!.length);

      followersModal!.follower!.forEach((userDetail) {
        globleFollowers.add(userDetail.fromUser);
      });
    }

    print("Followers" + globleFollowers.toString());
  }

  _getFollowing(id) async {
    var uri = Uri.parse('${baseUrl()}/my_following');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['user_id'] = id;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    Map<String, dynamic> userData = json.decode(responseData);
    follwingModal = FollwingModal.fromJson(userData);
    print(userData);

    follwingModal.follower!.forEach((userDetail) {
      globleFollowing.add(userDetail.toUser);
    });
    print("Following" + globleFollowing.toString());
  }

  _deleteStory() async {
    setState(() {
      isLoading = true;
    });
    var uri = Uri.parse('${baseUrl()}/delete_story');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    var response = await request.send();

    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    deleteStoryModal = DeleteStoryModal.fromJson(userData);
    print(responseData);

    setState(() {
      isLoading = false;
    });
  }

  bool stackLoader = false;

  startTime(data) async {
    var _duration = new Duration(milliseconds: 500);
    return new Timer(_duration, navigationPage(data));
  }

  navigationPage(data) {
    setState(() {
      data = false;
    });
  }

  @override
  void dispose() {
    sc.dispose();
    super.dispose();
  }

  Widget _body(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height! * 0.015;
    return storyWidget();
  }

  Widget storyWidget() {
    return Container(
      // color: Theme.of(context).cardColor,
      child: Row(
        children: [
          Expanded(
            child: Container(child: VerStories()),
          ),
        ],
      ),
    );
  }

  openDeleteDialog(BuildContext context) {
    containerForSheet<String>(
      context: context,
      child: CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(
              "Video",
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                  fontSize: 16,
                  fontFamily: "Lato"),
            ),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop("Discard");

              _pickVideo();
            },
          ),
          CupertinoActionSheetAction(
            child: Text(
              "Camera",
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                  fontSize: 16,
                  fontFamily: "Lato"),
            ),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop("Discard");

              File _image;
              final picker = ImagePicker();
              final imageFile =
                  await picker.pickImage(source: ImageSource.camera);

              if (imageFile != null) {
                setState(() {
                  if (imageFile != null) {
                    _image = File(imageFile.path);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PreviewStory(imageFile: _image)),
                    );
                  } else {
                    print('No image selected.');
                  }
                });
              }
            },
          ),
          CupertinoActionSheetAction(
            child: Text(
              "Gallery",
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                  fontSize: 16,
                  fontFamily: "MontserratBold"),
            ),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop("Discard");

              File _image;
              final picker = ImagePicker();
              final imageFile =
                  await picker.pickImage(source: ImageSource.gallery);

              if (imageFile != null) {
                setState(() {
                  if (imageFile != null) {
                    _image = File(imageFile.path);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PreviewStory(imageFile: _image)),
                    );
                  } else {
                    print('No image selected.');
                  }
                });
              }
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(
            "Cancel",
            style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1!.color,
                fontFamily: "Lato"),
          ),
          isDefaultAction: true,
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop("Discard");
          },
        ),
      ),
    );
  }

  // ignore: unused_field
  VideoPlayerController? _videoPlayerController;

  _pickVideo() async {
    var video = await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (video != null) {
      indicatorDialog(context);
      await VideoCompress.setLogLevel(0);

      final compressedVideo = await VideoCompress.compressVideo(
        video.path,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false,
        includeAudio: true,
      );

      if (compressedVideo != null) {
        // _video = File(compressedVideo.path);
        _videoPlayerController =
            VideoPlayerController.file(File(compressedVideo.path!))
              ..initialize().then((_) {
                setState(() {
                  Navigator.pop(context);

                  if (video != null) {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) =>
                    //           SendVideoStory(videoFile: video)),
                    // );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SendVideoStory(
                              videoFile: File(compressedVideo.path!))),
                    );
                  } else {
                    print('issue with compressing video in story');
                  }
                });
                // _videoPlayerController.play();
              });
      } else {
        Navigator.pop(context);
      }
    }
  }

  void containerForSheet<T>({required BuildContext context, Widget? child}) {
    showCupertinoModalPopup<T>(
      context: context,
      builder: (BuildContext context) => child!,
    ).then<void>((T? value) {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AnimatedTheme(
      duration: const Duration(milliseconds: 300),
      data: Theme.of(context),
      child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          key: _scaffoldkey,
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Theme.of(context).primaryColorDark,
                      Theme.of(context).primaryColor
                    ]),
              ),
            ),
            elevation: 0.5,
            title: Text(
              "All Stories",
              style: Theme.of(context).textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
            ),
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                )),
          ),
          body: _body(context)),
    );
  }
}
