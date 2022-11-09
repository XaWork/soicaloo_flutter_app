// ignore_for_file: implementation_imports, unnecessary_null_comparison, unused_field, duplicate_ignore

import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:nb_utils/src/widget_extensions.dart';
// import 'package:socialoo/Helper/sizeConfig.dart';
import 'package:socialoo/global/global.dart';
import 'package:socialoo/layouts/post/viewPublicPost.dart';
import 'package:socialoo/layouts/story/previewStory.dart';
import 'package:socialoo/layouts/story/sendVideoStory.dart';
import 'package:socialoo/layouts/user/editprofile1.dart';
import 'package:socialoo/layouts/user/myFollowers.dart';
import 'package:socialoo/layouts/user/myFollowing.dart';
import 'package:socialoo/models/postModal.dart';
import 'package:socialoo/models/userdata_model.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  Profile({Key? key, this.scaffoldKey, this.back}) : super(key: key);
  bool? back;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  bool isInView = false;

  bool isLoading = false;
  late UserDataModel modal;
  late PostModal postModal;
  String totalPost = '0';
  File? _image;
  File? _coverimage;

  @override
  void initState() {
    _getUser();
    super.initState();
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
    _getPost();
  }

  _getPost() async {
    var uri = Uri.parse('${baseUrl()}/post_by_user');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['user_id'] = userID!;
    print(request.fields);
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    print(userData);
    postModal = PostModal.fromJson(userData);
    print(responseData);
    if (mounted)
      setState(() {
        isLoading = false;
      });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getRequests() async {
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double maxWidth = MediaQuery.of(context).size.width * 0.4;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
        iconTheme: IconThemeData(
          color: Theme.of(context).appBarTheme.iconTheme!.color,
        ),
        elevation: 0.5,
        title: userName != ''
            ? Text(
                "$userName".capitalize(),
                style: Theme.of(context).textTheme.headline5!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),
              )
            : Container(),
        centerTitle: true,
        leading: widget.back != null
            ? IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                ))
            : Container(),
      ),
      body: isLoading
          ? Center(
              child: loader(context),
            )
          : ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Stack(children: <Widget>[
                      userCoverImage!.isEmpty
                          ? Image.asset(
                              'assets/images/defaultcover.png',
                              alignment: Alignment.center,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              height: 200,
                            )
                          : SizedBox(
                              height: 200,
                              width: double.infinity,
                              child: CachedNetworkImage(
                                imageUrl: userCoverImage!,
                                fit: BoxFit.cover,
                              ),
                            ),
                      SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: Container(
                          alignment: const Alignment(0.0, 2.5),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(60.0),
                                child: userImage == null || userImage!.isEmpty
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF003a54),
                                          borderRadius:
                                              BorderRadius.circular(60.0),
                                        ),
                                        child: Image.asset(
                                          'assets/images/defaultavatar.png',
                                          width: 120,
                                        ),
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: userImage!,
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 70),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            height: 38,
                            width: maxWidth,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xFF1246A5),
                                    Color(0xFF1e3c72)
                                  ]),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'Add Story',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  letterSpacing: 0.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ).onTap(() => openDeleteDialog(context)),
                          const SizedBox(width: 10),
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            height: 38,
                            width: maxWidth,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'Edit Profile',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  letterSpacing: 0.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ).onTap(
                            () {
                              Navigator.of(context)
                                  .push(new MaterialPageRoute(
                                      builder: (_) => new EditProfile()))
                                  .then((val) => val ? _getRequests() : null);
                            },
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildCountColumn("Posts", modal.userPost),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FollowingScreen(id: userID)),
                                );
                              },
                              child: buildCountColumn(
                                  "Following", modal.following)),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FollowersScreen(id: userID)),
                              );
                            },
                            child:
                                buildCountColumn("Followers", modal.followers),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    myPost()
                  ],
                ),
                // Expanded(child: _userInfo()),
              ],
            ),
    );
  }

  Future<void> pickImageGallery() async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = File(image!.path);
      print('Image Path $_image');
    });
  }

  Future<void> getCoverImage() async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _coverimage = File(image!.path);
      print('Image Path $_image');
    });
  }

  Future<void> pickImageFromCamera() async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _image = File(image!.path);
      print('Image Path $_image');
    });
  }

  selectImageSource() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(height: 10.0),
              Text(
                "Pick Image",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Poppins-Medium",
                ),
              ),
              Container(height: 10.0),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  pickImageFromCamera();
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.camera_alt,
                      color: appColor,
                    ),
                    Container(width: 10.0),
                    Text('Camera',
                        style: TextStyle(fontFamily: "Poppins-Medium"))
                  ],
                ),
              ),
              Container(height: 15.0),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  pickImageGallery();
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.storage,
                      color: appColor,
                    ),
                    Container(width: 10.0),
                    Text('Gallery',
                        style: TextStyle(fontFamily: "Poppins-Medium"))
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void containerForSheet<T>({required BuildContext context, Widget? child}) {
    showCupertinoModalPopup<T>(
      context: context,
      builder: (BuildContext context) => child!,
    ).then<void>((T? value) {});
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
        _videoPlayerController =
            VideoPlayerController.file(File(compressedVideo.path!))
              ..initialize().then((_) {
                setState(() {
                  Navigator.pop(context);

                  if (video != null) {
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
              });
      } else {
        Navigator.pop(context);
      }
    }
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
                  color: appColorBlack, fontSize: 16, fontFamily: "Lato"),
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
                  color: appColorBlack, fontSize: 16, fontFamily: "Lato"),
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
                  color: appColorBlack,
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
            style: TextStyle(color: Colors.black, fontFamily: "Lato"),
          ),
          isDefaultAction: true,
          onPressed: () {
            // Navigator.pop(context, 'Cancel');
            Navigator.of(context, rootNavigator: true).pop("Discard");
          },
        ),
      ),
    );
  }

  // Widget _userInfo() {
  //   return myPost();
  // }

  Widget buildCountColumn(String title, String? value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 4.0),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Text(
          value.toString(),
          style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  createThumb(String url) async {
    final uint8list = await VideoThumbnail.thumbnailFile(
      video: url,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      maxHeight:
          64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 75,
    );

    return uint8list;
  }

  Widget myPost() {
    return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: postModal.follower!.length > 0
            ? GridView.builder(
                shrinkWrap: true,
                primary: false,
                padding: EdgeInsets.all(5),
                itemCount: postModal.follower!.length,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 200 / 200,
                ),
                itemBuilder: (BuildContext context, int index) {
                  bool isimage =
                      postModal.follower![index].allImage!.length > 0;
                  bool isvideo = postModal.follower![index].video != "";
                  bool ispdf = postModal.follower![index].pdf != "";
                  bool istext = postModal.follower![index].pdf == "" &&
                      postModal.follower![index].video == "" &&
                      postModal.follower![index].allImage!.length == 0;
                  if (isimage) {
                    return Padding(
                        padding: EdgeInsets.all(5.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewPublicPost(
                                      id: postModal.follower![index].postId)),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: postModal.follower![index].allImage![0],
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => Center(
                                child: Container(
                                    child: CircularProgressIndicator()),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ));
                  }
                  if (istext) {
                    return Padding(
                      padding: EdgeInsets.all(5.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewPublicPost(
                                    id: postModal.follower![index].postId)),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          width: MediaQuery.of(context).size.width * 0.9,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(color: Colors.grey)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                postModal.follower![index].text!,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  if (isvideo) {
                    return Padding(
                      padding: EdgeInsets.all(5.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewPublicPost(
                                    id: postModal.follower![index].postId)),
                          );
                        },
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: postModal.follower![index].thumbnail!,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => Center(
                                  child: Container(
                                      child: CircularProgressIndicator()),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5, top: 5),
                                child: Icon(
                                  CupertinoIcons.play_circle_fill,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (ispdf) {
                    return Padding(
                      padding: EdgeInsets.all(5.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewPublicPost(
                                    id: postModal.follower![index].postId)),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          width: MediaQuery.of(context).size.width * 0.9,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(color: Colors.grey)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/pdf_file.svg',
                                height: 50,
                                color: Colors.grey,
                              ),
                              Text(
                                postModal.follower![index].pdf_name!,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                postModal.follower![index].pdf_size!,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Container(
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.image,
                        size: 120,
                      ),
                    ),
                  );
                },
              )
            : Container(
                height: SizeConfig.screenWidth! * 20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Share photos and videos",
                      style: TextStyle(
                          fontSize: SizeConfig.screenHeight! * 5,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: SizeConfig.screenWidth! * 2,
                    ),
                    Text(
                      "When you share photos and videos, they'll appear\non your profile",
                      style: TextStyle(
                          fontSize: SizeConfig.screenHeight! * 3,
                          color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ));
  }
}
