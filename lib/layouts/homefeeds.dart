// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:blur/blur.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:photofilters/filters/image_filters.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialoo/Helper/sizeConfig.dart';
import 'package:socialoo/global/global.dart';
import 'package:socialoo/layouts/menu/suggested_users.dart';
import 'package:socialoo/layouts/post/add_post/create_post_first_step.dart';
import 'package:socialoo/layouts/post/add_post/post_box.dart';
import 'package:socialoo/layouts/post/comments.dart';
import 'package:socialoo/layouts/story/previewStory.dart';
import 'package:socialoo/layouts/story/sendVideoStory.dart';
import 'package:socialoo/layouts/story/story.dart';
import 'package:socialoo/layouts/user/profile.dart';
import 'package:socialoo/layouts/user/publicProfile.dart';
import 'package:socialoo/layouts/videoview/videoViewFix.dart';
import 'package:socialoo/layouts/widgets/pdf_widget.dart';
import 'package:socialoo/models/adsToShow.dart';
import 'package:socialoo/models/deleteStoryModal.dart';
import 'package:socialoo/models/followerPostModal.dart';
import 'package:socialoo/models/followersModal.dart';
import 'package:socialoo/models/followingModal.dart';
import 'package:socialoo/models/likeModal.dart';
import 'package:socialoo/models/loginModal.dart';
import 'package:socialoo/models/unlikeModal.dart';
import 'package:socialoo/shared_preferences/preferencesKey.dart';
// import 'package:nb_utils/nb_utils.dart';
import 'package:timeago/timeago.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

import 'post/add_post/edit_post_first_step.dart';
import 'post/viewPublicPost.dart';

class HomeFeeds extends StatefulWidget {
  final GlobalKey<ScaffoldState>? parentScaffoldKey;

  HomeFeeds({Key? key, this.parentScaffoldKey}) : super(key: key);

  @override
  _HomeFeedsState createState() => _HomeFeedsState();
}

class _HomeFeedsState extends State<HomeFeeds>
    with SingleTickerProviderStateMixin {
  late Animation base;
  late AnimationController controller;

  DeleteStoryModal? deleteStoryModal;

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  FollowersModal? followersModal;

  late FollwingModal follwingModal;
  Animation? gap;
  bool isLoading = false;

  // LatestPostModel latestPostModel;
  late LikeModal likeModal;
  LoginModal? loginModal;
  FollowerPostModal? modal;
  Animation? reverse;
  int? page = 1;
  bool show = false;

  // bool tap = true;
  late UnlikeModal unlikeModal;
  bool pageloader = false;

  // ignore: unused_field
  double? _height, _width, _fixedPadding;

  // ignore: unused_field
  int _current = 0;
  late LoginModal loginModel;

  @override
  void initState() {
    print(userID);
    // _getRecentPost();
    globleFollowers = [];
    globleFollowing = [];
    getUserDataFromPrefs().then((value) {
      _getPost(page);
      _getAdsToShow();
    });

    // this._getPost(page);
    initialiZeController();

    _getFollowers(userID);
    _getFollowing(userID);
    // getUserDataFromPrefs();
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
    print(index);

    // var uri = Uri.parse('${baseUrl()}/all_post_by_user');
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
            modal!.post!.where((element) => element.postReport == "true");

        if (contain.isEmpty) {
          func(page);
          print('if page : $page');
        } else {
          // _getPost(page + 1);
          funcCheck(page);
          print('else page : $page');
        }
      });
    print(responseData);

    for (int i = 0; i < modal!.post!.length; i++) {
      allPost.add(modal!.post![i]);
    }
    print(json.encode(allPost));

    if (mounted)
      setState(() {
        isLoading = false;
      });
  }

  List<AdsToShow> adsList = <AdsToShow>[];

  _getAdsToShow() async {
    var uri = Uri.parse('${baseUrl()}/getadstoshow?user_id=$userID');
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
        if (userData['response_code'] == '1') {
          adsList.addAll(List<AdsToShow>.from(
              userData['ads'].map((item) => AdsToShow.fromJson(item))));
        }
      });
    print(responseData);
    print('irshad');

    print(json.encode(adsList));
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
    if (modal!.responseCode != '0') {
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
    if (modal!.responseCode != '0') {
      print('if');

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

  final TextEditingController postText = TextEditingController();

  sharePost(postID, postOwnerId) async {
    var uri = Uri.parse('${baseUrl()}/share_post');
    print(uri.path);
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    request.headers.addAll(headers);
    // request.fields['user_id'] = id;
    request.fields.addAll({
      'user_id': userID ?? '',
      'post_id': postID,
      'post_owner_id': postOwnerId,
      'shared_post_text': postText.text,
    });
    print(request.fields);

    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    Map<String, dynamic> userData = json.decode(responseData);

    if (userData['response_code'] == '1') {
      Fluttertoast.showToast(msg: userData['message']);
    } else {
      socialootoast("Error", userData['message'], context);
    }
    print(userData);
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

  _unlikePost(String postid) async {
    var uri = Uri.parse('${baseUrl()}/unlike_post');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['post_id'] = postid;
    request.fields['user_id'] = userID!;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    unlikeModal = UnlikeModal.fromJson(userData);
    print(responseData);

    if (unlikeModal.responseCode == "1") {
      likedPost = [];
      setState(() {
        likedPost.add(postid);
      });
    }
  }

  _likePost(String postid) async {
    var uri = Uri.parse('${baseUrl()}/like_post');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['post_id'] = postid;
    request.fields['user_id'] = userID!;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    likeModal = LikeModal.fromJson(userData);
    print(responseData);

    if (likeModal.responseCode == "1") {
      likedPost = [];
      setState(() {
        likedPost.add(postid);
      });
    }
  }

  _addBookmark(String postid) async {
    var uri = Uri.parse('${baseUrl()}/bookmark_post');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['post_id'] = postid;
    request.fields['user_id'] = userID!;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);

    print(responseData);

    if (userData['response_code'] == "1") {
      addedBookmarks = [];
      setState(() {
        addedBookmarks.add(postid);
      });
    }
  }

  _removeBookmark(String postid) async {
    var uri = Uri.parse('${baseUrl()}/delete_bookmark_post');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['post_id'] = postid;
    request.fields['user_id'] = userID!;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);

    print(responseData);

    if (userData['response_code'] == "1") {
      addedBookmarks = [];
      setState(() {
        addedBookmarks.remove(postid);
      });
    }
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
    // request.fields['user_id'] = userID;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    deleteStoryModal = DeleteStoryModal.fromJson(userData);
    print(responseData);

    setState(() {
      isLoading = false;
    });
  }

  bool stackLoader = false;
  var reportPostData;
  TextEditingController _textFieldController = TextEditingController();

  _reportPost(postId, status, reportTxt) async {
    print(status);
    setState(() {
      stackLoader = true;
    });

    var uri = Uri.parse('${baseUrl()}/posts_report');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['blockedByUserId'] = userID!;
    request.fields['blockedPostsId'] = postId;
    request.fields['status'] = status;
    request.fields['report_text'] = reportTxt;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    reportPostData = json.decode(responseData);
    if (reportPostData['response_code'] == '1') {
      setState(() {
        stackLoader = false;
        _textFieldController.clear();
      });

      allPost.removeWhere((item) => item.postId == postId);
    } else {
      allPost.removeWhere((item) => item.postId == postId);
      setState(() {
        stackLoader = false;
      });

      print('REPORT RESPONSE FAIL');
      debugPrint('${reportPostData['response_code']}');
    }
    openHideSheet(context, status);
    // deleteStoryModal = DeleteStoryModal.fromJson(userData);
    print(responseData);

    setState(() {
      stackLoader = false;
    });
  }

  _blockUser(blockedUserId) async {
    print(blockedUserId);
    setState(() {
      stackLoader = true;
    });

    var uri = Uri.parse('${baseUrl()}/profile_block');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['blockedByUserId'] = userID!;
    request.fields['blockedUserId'] = blockedUserId;

    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var reportPostData = json.decode(responseData);
    if (reportPostData['response_code'] == '1') {
      setState(() {
        stackLoader = false;
      });
      allPost.removeWhere((item) => item.userId == blockedUserId);

      Fluttertoast.showToast(
          msg: 'User Blocked', toastLength: Toast.LENGTH_LONG);
    } else {
      Fluttertoast.showToast(msg: 'Fail to block');
    }

    print(responseData);

    setState(() {
      stackLoader = false;
    });
  }

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
    super.dispose();
    sc.dispose();
  }

  Widget _body(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height! * 0.015;
    return RefreshIndicator(
      child: Container(
        child: modal != null
            ? SingleChildScrollView(
                controller: sc,
                child: Column(
                  children: [
                    PostBox(
                      userimage: userImage,
                      userName: userName,
                    ),
                    SizedBox(
                      height: 05,
                    ),
                    storyWidget(),
                    SizedBox(height: 5),
                    allPost.length > 0
                        ? new ListView.builder(
                            itemCount: allPost.length,
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              if ((index + 1) % 5 == 0) {
                                return Column(
                                  children: [
                                    Container(
                                      height: 400,
                                      child: SuggestedUsers(),
                                    ),
                                  ],
                                );
                              } else {
                                return Column(
                                  children: [
                                    Card(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _bodyData(allPost[index]),
                                        ],
                                      ),
                                    ),
                                    if (index % 2 == 0) adsCardWidget()
                                  ],
                                );
                              }
                            },
                          )
                        : modal!.post!.length > 0
                            ? Container(
                                height:
                                    MediaQuery.of(context).size.height - 300,
                                child:
                                    Center(child: CircularProgressIndicator()))
                            : Container(
                                height:
                                    MediaQuery.of(context).size.height - 300,
                                child: Center(
                                    child: Text('No Post Found',
                                        style:
                                            TextStyle(color: Colors.black)))),
                    isLoading
                        ? Container()
                        : pageloader
                            ? Container(
                                height: _height! * 1 / 10,
                                width: _width,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(7.0),
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          appColor),
                                      strokeWidth: 3,
                                    ),
                                  ),
                                ),
                              )
                            : Container()
                  ],
                ),
              )
            : Center(
                child: loader(context),
              ),
      ),
      onRefresh: _getData,
    );
  }

  int adsIndex = 0;

  Widget adsCardWidget() {
    if (adsIndex < adsList.length) {
      adsIndex++;
      return Card(
        child: Column(
          children: [
            if (adsList[adsIndex - 1].image != null &&
                adsList[adsIndex - 1].image != '')
              CachedNetworkImage(
                imageUrl: adsList[adsIndex - 1].image!,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                height: 60,
                width: double.infinity,
                placeholder: (context, url) => Center(
                  child: Container(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
              )
            else
              Container(
                  height: 60,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: Icon(
                    Icons.image,
                    size: 35,
                    color: Colors.grey[600],
                  ))
          ],
        ),
      );
    } else
      return SizedBox.shrink();
  }

  Widget _bodyData(Post post) {
    return post.postReport != 'true' && post.profileBlock != 'true'
        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            InkWell(
              onTap: () {
                if (userID == post.userId) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Profile(back: true)),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PublicProfile(
                              peerId: post.userId,
                              peerUrl: post.profilePic,
                              peerName: post.username,
                            )),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: post.profilePic == null ||
                                  post.profilePic!.isEmpty
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
                                  imageUrl: post.profilePic!,
                                  height: 55.0,
                                  width: 55.0,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        SizedBox(
                          width: SizeConfig.blockSizeHorizontal * 2,
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.username == ""
                                      ? "No name"
                                      : post.username!.capitalize(),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(post.createDate!)),
                                      locale: 'en_short'),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(
                                        fontSize: 12.0,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 05),
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              reportPostData = null;
                              reportSheet(
                                context,
                                post.postId,
                                post.bookmark,
                                post.userId,
                                post,
                              );
                            },
                            icon: Icon(Icons.more_horiz),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            post.text != ""
                ? InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ViewPublicPost(id: post.postId)),
                      );
                    },
                    child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text('${post.text}')),
                  )
                : Container(),
            SizedBox(height: 10),
            postContentWidget(post),
            SizedBox(height: 10),
            // if (post.missingData != null)
            //   Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 10.0),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Text('${post.missingData?.fullName ?? ''}',
            //             style: TextStyle(
            //                 fontSize: 14,
            //                 color: Theme.of(context).iconTheme.color)),
            //         Text(
            //             '${post.missingData?.age} Y / ${post.missingData?.gender}',
            //             style: TextStyle(
            //                 fontSize: 14,
            //                 color: Theme.of(context).iconTheme.color)),
            //       ],
            //     ),
            //   ),
            if (post.missingData != null /*|| post.deadData != null*/)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  'Missing Person ${post.missingData?.fullName ?? ''}, ${post.missingData?.gender ?? ''}, ${post.missingData?.age ?? ''} Year old, ${post.missingData?.dateMissing ?? ''}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            if (post.deadData != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  'Dead Person ${post.deadData?.fullName ?? ''}, ${post.deadData?.gender ?? ''}, ${post.deadData?.age ?? ''} Year old, ${post.deadData?.dateFound ?? ''} ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            if (post.foundData != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  'Found Person ${post.foundData?.fullName ?? ''}, ${post.foundData?.gender ?? ''}, ${post.foundData?.age ?? ''} Year old, ${post.foundData?.date ?? ''}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            // if (post.deadData != null)
            //   Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 10.0),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Text('${post.deadData?.fullName ?? ''}',
            //             style: TextStyle(
            //                 fontSize: 14,
            //                 color: Theme.of(context).iconTheme.color)),
            //         Text('${post.deadData?.age} Y / ${post.deadData?.gender}',
            //             style: TextStyle(
            //                 fontSize: 14,
            //                 color: Theme.of(context).iconTheme.color)),
            //       ],
            //     ),
            //   ),
            // if (post.missingData != null)
            //   Padding(
            //     padding: const EdgeInsets.only(left: 10.0, top: 10),
            //     child: Text('${post.missingData?.dateMissing ?? ''}',
            //         style: TextStyle(
            //             fontSize: 14,
            //             color: Theme.of(context).iconTheme.color)),
            //   ),
            // if (post.deadData != null)
            //   Padding(
            //     padding: const EdgeInsets.only(left: 10.0, top: 10),
            //     child: Text('${post.deadData?.dateFound ?? ''}',
            //         style: TextStyle(
            //             fontSize: 14,
            //             color: Theme.of(context).iconTheme.color)),
            //   ),
            // if (post.missingData != null || post.deadData != null)
            //   const Divider(height: 30.0),
            SizedBox(height: 10),
            footerWidget(post),
          ])
        : Container();
  }

  postContentWidget(Post post) {
    bool isimage = post.allImage!.length > 0;
    bool isvideo = post.video != "";
    bool ispdf = post.pdf != "";
    bool istext = post.video == "" &&
        post.pdf == "" &&
        post.allImage!.length == 0 &&
        post.text != "";
    if (isimage) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewPublicPost(id: post.postId)),
          );
          print('tapped');
        },
        onDoubleTap: () {
          if (post.isLikes == "false") {
            setState(() {
              post.dataV = true;
              post.isLikes = "true";
              post.totalLikes = post.totalLikes! + 1;
              _likePost(post.postId!);
            });
            var _duration = new Duration(milliseconds: 500);
            Timer(_duration, () {
              post.dataV = false;
            });
            print('dataV : ${post.dataV}');
          }
        },
        child: post.deadData != null
            ? Blur(
                blur: 15,
                child: Stack(
                  children: [
                    Container(
                      // height: SizeConfig.blockSizeVertical * 40,
                      width: SizeConfig.screenWidth,
                      child: CachedNetworkImage(
                        imageUrl: post.allImage![0],
                        placeholder: (context, url) => Center(
                          child: Container(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      // child: Swiper.children(
                      //   autoplay: false,
                      //   pagination: const SwiperPagination(
                      //       margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
                      //       builder: DotSwiperPaginationBuilder(
                      //           color: Colors.white30,
                      //           activeColor: Colors.white,
                      //           size: 20.0,
                      //           activeSize: 20.0)),
                      //   children: post.allImage!.map((it) {
                      //     return ClipRRect(
                      //       child: ZoomOverlay(
                      //         twoTouchOnly: true,
                      //         child: CachedNetworkImage(
                      //           imageUrl: it,
                      //           imageBuilder: (context, imageProvider) => Container(
                      //             decoration: BoxDecoration(
                      //               image: DecorationImage(
                      //                 image: imageProvider,
                      //                 fit: BoxFit.contain,
                      //               ),
                      //             ),
                      //           ),
                      //           placeholder: (context, url) => Center(
                      //             child: Container(child: CircularProgressIndicator()),
                      //           ),
                      //           errorWidget: (context, url, error) => Icon(Icons.error),
                      //           fit: BoxFit.cover,
                      //         ),
                      //       ),
                      //     );
                      //   }).toList(),
                      // ),
                    ),
                    post.dataV == true
                        ? Positioned.fill(
                            child: AnimatedOpacity(
                                opacity: post.dataV! ? 1.0 : 0.0,
                                duration: Duration(milliseconds: 700),
                                child: Icon(
                                  CupertinoIcons.heart_fill,
                                  color: Colors.red,
                                  size: 100,
                                )))
                        : Container(),
                  ],
                ),
              )
            : Stack(
                children: [
                  Container(
                    // height: SizeConfig.blockSizeVertical * 40,
                    width: SizeConfig.screenWidth,
                    child: CachedNetworkImage(
                      imageUrl: post.allImage![0],
                      placeholder: (context, url) => Center(
                        child: Container(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    // child: Swiper.children(
                    //   autoplay: false,
                    //   pagination: const SwiperPagination(
                    //       margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
                    //       builder: DotSwiperPaginationBuilder(
                    //           color: Colors.white30,
                    //           activeColor: Colors.white,
                    //           size: 20.0,
                    //           activeSize: 20.0)),
                    //   children: post.allImage!.map((it) {
                    //     return ClipRRect(
                    //       child: ZoomOverlay(
                    //         twoTouchOnly: true,
                    //         child: CachedNetworkImage(
                    //           imageUrl: it,
                    //           imageBuilder: (context, imageProvider) => Container(
                    //             decoration: BoxDecoration(
                    //               image: DecorationImage(
                    //                 image: imageProvider,
                    //                 fit: BoxFit.contain,
                    //               ),
                    //             ),
                    //           ),
                    //           placeholder: (context, url) => Center(
                    //             child: Container(child: CircularProgressIndicator()),
                    //           ),
                    //           errorWidget: (context, url, error) => Icon(Icons.error),
                    //           fit: BoxFit.cover,
                    //         ),
                    //       ),
                    //     );
                    //   }).toList(),
                    // ),
                  ),
                  post.dataV == true
                      ? Positioned.fill(
                          child: AnimatedOpacity(
                              opacity: post.dataV! ? 1.0 : 0.0,
                              duration: Duration(milliseconds: 700),
                              child: Icon(
                                CupertinoIcons.heart_fill,
                                color: Colors.red,
                                size: 100,
                              )))
                      : Container(),
                ],
              ),
      );
    } else if (isvideo) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewPublicPost(id: post.postId)),
          );
          print('tapped');
        },
        child: VideoViewFix(
            url: post.video, play: true, id: post.postId, mute: false),
      );
    } else if (ispdf) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewPublicPost(id: post.postId)),
          );
          print('tapped');
        },
        child: PdfWidget(
          pdf: post.pdf,
          pdfName: post.pdf_name,
          pdfSize: post.pdf_size,
        ),
      );
    } else if (istext) {
      return Container();
    }
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ViewPublicPost(id: post.postId)),
        );
        print('tapped');
      },
      child: Container(
          height: 230,
          width: double.infinity,
          color: Colors.grey[200],
          child: Icon(
            Icons.image,
            size: 200,
            color: Colors.grey[600],
          )),
    );
  }

  footerWidget(Post post) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    '${post.totalLikes.toString()} Likes',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  const SizedBox(width: 5.0),
                ],
              ),
              Row(
                children: <Widget>[
                  GestureDetector(
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            int? commentL = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CommentsScreen(postID: post.postId)),
                            );
                            if (commentL != null) {
                              setState(() {
                                post.totalComments = commentL;
                              });
                            }
                          },
                          child: Text(
                            post.totalComments.toString() + " Comments",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5.0),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 25.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                post.isLikes == "true"
                    ? InkWell(
                        onTap: () {
                          setState(() {
                            post.isLikes = "false";
                            post.totalLikes = post.totalLikes! - 1;
                            _unlikePost(post.postId!);
                          });
                          print("Unlike Post");
                        },
                        child: Icon(
                          CupertinoIcons.heart_fill,
                          size: 20,
                          color: Colors.red,
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          print("Like Post");
                          setState(() {
                            post.totalLikes = post.totalLikes! + 1;
                            post.isLikes = "true";
                            _likePost(post.postId!);
                          });
                        },
                        child: Icon(
                          CupertinoIcons.heart,
                          color: Theme.of(context).iconTheme.color,
                          size: 20,
                        ),
                      ),
                SizedBox(
                  width: 5,
                ),
                CustomTextStyle1(
                  title: ' Like',
                  weight: FontWeight.w500,
                  color: Theme.of(context).iconTheme.color,
                ),
                SizedBox(width: 5.0),
              ],
            ),
            Row(
              children: <Widget>[
                GestureDetector(
                    onTap: () async {
                      int? commentL = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CommentsScreen(postID: post.postId)),
                      );

                      if (commentL != null) {
                        setState(() {
                          post.totalComments = commentL;
                        });
                      }
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/images/comment.svg",
                          height: 20,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        const SizedBox(width: 5.0),
                        Text('Comment',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Theme.of(context).iconTheme.color,
                            )),
                      ],
                    )),
                const SizedBox(width: 5.0),
              ],
            ),
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    chooseShareOption(context, post);
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/images/share.svg",
                        height: 20,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      const SizedBox(width: 5.0),
                      Text(
                        'Share',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5.0),
              ],
            )
          ],
        ),
        const Padding(padding: EdgeInsets.only(bottom: 10.0))
      ],
    );
  }

  chooseShareOption(BuildContext context, Post post) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 10),
                Center(
                  child: Text(
                    'Choose Option',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true)
                              .pop("Discard");
                          postText.clear();
                          shareOnYourProfileText(context, post);
                          // sharePost(post.postId, post.userId);
                        },
                        title: new Text(
                          "Share to your own profile",
                          style: new TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 15.0),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true)
                              .pop("Discard");
                          _onShare(context, post.video, post.image, post.text,
                              post.pdf);
                        },
                        title: new Text(
                          "Share to other media",
                          style: new TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 15.0),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  shareOnYourProfileText(BuildContext context, Post post) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      "What's on your mind",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          EditTextField(
                            validator: (value) {
                              if (value.isEmpty)
                                return 'Field is required';
                              else
                                return null;
                            },
                            controller: postText,
                            onChanged: (input) {},
                            maxLines: 5,
                            keyBoard: TextInputType.text,
                            hint: "Enter what\'s on your mind",
                          ),
                          SizedBox(height: 25),
                          InkWell(
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                Navigator.of(context, rootNavigator: true)
                                    .pop("Discard");
                                sharePost(post.postId, post.userId);
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xFF1246A5),
                                    Color(0xFF1e3c72)
                                  ],
                                ),
                              ),
                              child: const Text(
                                'Share',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // onlyRequiredValidate

  _onShare(BuildContext context, video, image, text, pdf) async {
    bool isPhoto = image?.isNotEmpty == true;
    bool isvideo = video?.isNotEmpty == true;
    bool ispdf = pdf?.isNotEmpty == true;
    final RenderBox? box = context.findRenderObject() as RenderBox?;

    if (isPhoto) {
      await Share.share(image[0],
          subject: text,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    } else if (isvideo) {
      await Share.share(video,
          subject: text,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    } else if (ispdf) {
      await Share.share(pdf,
          subject: text,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    }
  }

  Future<void> _getData() async {
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      allPost.clear();
      _getPost(1);
      _getAdsToShow();
    });
  }

  Widget storyWidget() {
    return Card(
      child: SizedBox(
        height: 150,
        // height: MediaQuery.of(context).size.height * 0.20,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Stories",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(Icons.play_arrow),
                        Text(
                          "Stories",
                          style: TextStyle(fontSize: 16.0),
                        )
                      ],
                    )
                  ]),
            ),
            Expanded(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => openDeleteDialog(context),
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: new Column(
                        children: <Widget>[
                          new Stack(
                            alignment: Alignment.topCenter,
                            children: <Widget>[
                              new Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Container(
                                  width: 70.0,
                                  height: 70.0,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: (userImage == null ||
                                                  userImage!.isEmpty
                                              ? AssetImage(
                                                  'assets/images/defaultavatar.png',
                                                )
                                              : new NetworkImage(userImage!))
                                          as ImageProvider<Object>,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                  right: 10.0,
                                  top: 10.0,
                                  child: new FractionalTranslation(
                                    translation: Offset(0.2, -0.2),
                                    child: new CircleAvatar(
                                      backgroundColor: Color(0xff3b5998),
                                      radius: 15.0,
                                      child: new Icon(
                                        Icons.add,
                                        size: 14.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                          Text(
                            'Add',
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(child: Stories()),
                ],
              ),
            ),
          ],
        ),
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
            // Navigator.pop(context, 'Cancel');
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

  void containerForSheet<T>({required BuildContext context, Widget? child}) {
    showCupertinoModalPopup<T>(
      context: context,
      builder: (BuildContext context) => child!,
    ).then<void>((T? value) {});
  }

  Future<dynamic> checkPostTypeDialog(context) {
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
    SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldkey,
      body: _body(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          checkPostTypeDialog(context);
        },
        child: Container(
          width: 60,
          height: 60,
          child: Icon(
            Icons.add,
            size: 40,
            color: Theme.of(context).appBarTheme.iconTheme!.color,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.indigo,
          ),
        ),
      ),
    );
  }

  reportSheet(BuildContext context, postId, bookmark, postUserId, Post post) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).canvasColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext context,
            StateSetter setState /*You can rename this!*/) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                  height: postUserId != userID ? 250 : 200,
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop("Discard");
                                openBottmSheet(context, 'report', postId);
                              },
                              title: new Text(
                                "Report",
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),
                              ),
                            ),
                            if (postUserId == userID)
                              ListTile(
                                onTap: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop("Discard");
                                  // Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditPostFirstStep(
                                                  userName: userName,
                                                  userimage: userImage,
                                                  postId: postId)));
                                },
                                title: new Text(
                                  "Edit",
                                  style: new TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15.0),
                                ),
                              ),
                            postUserId != userID
                                ? ListTile(
                                    onTap: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop("Discard");

                                      _reportPost(postId, 'hide', '');
                                    },
                                    title: new Text(
                                      "Hide",
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15.0),
                                    ),
                                  )
                                : ListTile(
                                    onTap: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop("Discard");

                                      _reportPost(postId, 'hide', '');
                                    },
                                    title: new Text(
                                      "Delete",
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15.0),
                                    ),
                                  ),
                            postUserId != userID
                                ? ListTile(
                                    onTap: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop("Discard");
                                      _blockUser(postUserId);
                                    },
                                    title: new Text(
                                      "Block User",
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15.0),
                                    ),
                                  )
                                : Container(),
                            // postUserId != userID
                            //     ? ListTile(
                            //         onTap: () {
                            //           Navigator.of(context, rootNavigator: true)
                            //               .pop("Discard");
                            //           sharePost(postId, postUserId);
                            //         },
                            //         title: new Text(
                            //           "Share Post",
                            //           style: new TextStyle(
                            //               fontWeight: FontWeight.w500,
                            //               fontSize: 15.0),
                            //         ),
                            //       )
                            //     : Container(),
                            postUserId != userID
                                ? bookmark == "true"
                                    ? ListTile(
                                        onTap: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop("Discard");
                                          setState(() {
                                            bookmark = "false";
                                            _removeBookmark(postId);
                                          });
                                        },
                                        title: new Text(
                                          "Remove Post",
                                          style: new TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15.0),
                                        ),
                                      )
                                    : ListTile(
                                        onTap: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop("Discard");
                                          setState(() {
                                            bookmark = "true";
                                            _addBookmark(postId);
                                          });
                                        },
                                        title: new Text(
                                          "Save Post",
                                          style: new TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15.0),
                                        ),
                                      )
                                : Container(),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          );
        });
      },
    );
  }

  openBottmSheet(BuildContext context, String reportType, String? postId) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext context,
            StateSetter setState /*You can rename this!*/) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                  height: 700,
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                          child: Text(
                        'Report',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                      )),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              'Why are you reporting this post?',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop("Discard");
                                _reportPost(postId, reportType,
                                    'Nudity or sexual activity');
                              },
                              title: new Text(
                                "Nudity or sexual activity",
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop("Discard");
                                _reportPost(postId, reportType,
                                    'I just don\'t like it');
                              },
                              title: new Text(
                                "I just don\'t like it",
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop("Discard");
                                _reportPost(postId, reportType,
                                    'Hate speech or symbol');
                              },
                              title: new Text(
                                "Hate speech or symbol",
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop("Discard");
                                _reportPost(postId, reportType,
                                    'Bullying or harassment');
                              },
                              title: new Text(
                                "Bullying or harassment",
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop("Discard");
                                _reportPost(postId, reportType,
                                    'Violence or dangerous organisation');
                              },
                              title: new Text(
                                "Violence or dangerous organisation",
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop("Discard");
                                _displayTextInputDialog(
                                    context, postId, reportType);
                              },
                              title: new Text(
                                "Something else",
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          );
        });
      },
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context, id, type) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                    onChanged: (value) {},
                    maxLines: 5,
                    controller: _textFieldController,
                    decoration: InputDecoration.collapsed(
                        hintText: "Enter your text here")),
              ),
            ),
            actions: <Widget>[
              TextButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop("Discard");
                  }),
              TextButton(
                  child: Text('Submit'),
                  onPressed: () {
                    if (_textFieldController.text.isNotEmpty) {
                      Navigator.of(context, rootNavigator: true).pop("Discard");
                      _reportPost(id, type, _textFieldController.text);
                    } else {
                      Fluttertoast.showToast(
                          msg: 'Please enter text to continue..');
                    }
                  })
            ],
          );
        });
  }

  openHideSheet(BuildContext context, String reportType) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext context,
            StateSetter setState /*You can rename this!*/) {
          return Padding(
            padding: EdgeInsets.only(
                // bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
            child: Container(
                // height: 700,
                child: Container(
                    child: reportPostData != null &&
                            reportPostData['response_code'] == '1'
                        ? Container(
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/Done-pana.png',
                                  height: 270,
                                  width: MediaQuery.of(context).size.width,
                                ),
                                reportType == 'hide'
                                    ? Column(
                                        children: [
                                          Text(
                                            'Post Hidden successfully',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      )
                                    : Container(),
                                reportType == 'report'
                                    ? Column(
                                        children: [
                                          Text(
                                            'Thanks for letting us know',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                              'Your feedback is important in helping us keep the community safe.',
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption!
                                                  .copyWith(fontSize: 15)),
                                          SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      )
                                    : Container(),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    // background color
                                    backgroundColor: appColor,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 10),
                                    textStyle: const TextStyle(fontSize: 15),
                                  ),
                                  child: const Text('Continue'),
                                  onPressed: () {
                                    debugPrint('Button clicked!');
                                    Navigator.of(context, rootNavigator: true)
                                        .pop("Discard");
                                  },
                                ),
                              ],
                            ),
                          )
                        : reportPostData != null &&
                                reportPostData['response_code'] == '0'
                            ? Container(
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/Done-pana.png',
                                      height: 300,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                    reportPostData['status'] != 'fail'
                                        ? Text(
                                            'This post is already reported',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          )
                                        : Text(
                                            'Fail to submit',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Fail to submit your report please try again',
                                      textAlign: TextAlign.center,
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        // background color
                                        backgroundColor: appColor,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 10),
                                        textStyle:
                                            const TextStyle(fontSize: 15),
                                      ),
                                      child: const Text('Continue'),
                                      onPressed: () {
                                        debugPrint('Button clicked!');
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop("Discard");
                                      },
                                    ),
                                  ],
                                ),
                              )
                            : Container())),
          );
        });
      },
    );
  }
}

class EditTextField extends StatefulWidget {
  final List<TextInputFormatter>? inputFormatterData;
  final TextEditingController? controller;
  final AutovalidateMode? autoValidateMode;
  final String? hint;
  final bool? readOnly;
  final bool nullMaxLine;
  final TextInputType? keyBoard;
  final FocusNode? focusNode;
  final TextAlign? textAlign;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final double? horizontal;
  final double? vertical;
  final int? lengthLimiting;
  final Function? onChanged;
  final VoidCallback? onTap;
  final Function? validator;
  final String? labelText;
  final String? counterText;
  final bool? obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? initialVal;
  final Color? primaryColor;

  EditTextField({
    this.inputFormatterData,
    this.controller,
    this.autoValidateMode,
    this.hint,
    this.readOnly,
    this.nullMaxLine = false,
    this.keyBoard,
    this.textAlign,
    this.focusNode,
    this.maxLength,
    this.minLines,
    this.maxLines,
    this.horizontal,
    this.onTap,
    this.vertical,
    this.lengthLimiting,
    this.onChanged,
    this.validator,
    this.labelText,
    this.counterText,
    this.obscureText,
    this.suffixIcon,
    this.prefixIcon,
    this.initialVal,
    this.primaryColor,
  });

  @override
  _EditTextFieldState createState() => _EditTextFieldState();
}

class _EditTextFieldState extends State<EditTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          widget.labelText != null
              ? Text(widget.labelText!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15))
              : SizedBox(),
          Container(
            child: TextFormField(
              autovalidateMode: widget.autoValidateMode,
              readOnly: widget.readOnly ?? false,
              textAlign: widget.textAlign ?? TextAlign.start,
              expands: false,
              focusNode: widget.focusNode,
              validator: (value) =>
                  widget.validator != null ? widget.validator!(value) : null,
              inputFormatters: widget.inputFormatterData,
              scrollPadding: EdgeInsets.zero,
              style: TextStyle(
                  fontSize: 15.0, color: widget.primaryColor ?? Colors.black87),
              controller: widget.controller,
              keyboardType: widget.keyBoard != null
                  ? widget.keyBoard
                  : TextInputType.text,
              maxLines: widget.nullMaxLine ? null : widget.maxLines,
              minLines: widget.minLines,
              maxLength: widget.maxLength,
              initialValue: widget.initialVal,
              obscureText: widget.obscureText ?? false,
              onChanged: (val) =>
                  widget.onChanged != null ? widget.onChanged!(val) : null,
              onTap: widget.onTap,
              decoration: InputDecoration(
                focusColor: Colors.black,
                hoverColor: Colors.black,
                suffixIcon: widget.suffixIcon,
                counterText: widget.counterText,
                prefixIcon: widget.prefixIcon,
                hintStyle: TextStyle(color: widget.primaryColor ?? null),
                suffixIconConstraints:
                    BoxConstraints(minWidth: 0, minHeight: 0),
                prefixIconConstraints:
                    BoxConstraints(minWidth: 0, minHeight: 0),
                contentPadding: EdgeInsets.symmetric(
                    vertical: widget.vertical ?? 10.0,
                    horizontal: widget.horizontal ?? 10),
                isDense: true,
                hintText: widget.hint,
                border: InputBorder.none,
                filled: true,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
