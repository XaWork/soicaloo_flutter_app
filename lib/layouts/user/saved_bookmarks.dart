import 'dart:async';
import 'dart:convert';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:share/share.dart';
import 'package:socialoo/global/global.dart';

import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_pro/carousel_pro.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialoo/Helper/sizeConfig.dart';
import 'package:http/http.dart' as http;

import 'package:inview_notifier_list/inview_notifier_list.dart';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:socialoo/layouts/post/comments.dart';
import 'package:socialoo/layouts/user/profile.dart';
import 'package:socialoo/layouts/user/publicProfile.dart';
import 'package:socialoo/layouts/videoview/videoViewFix.dart';
import 'package:socialoo/layouts/widgets/DrawerWidget.dart';
import 'package:socialoo/layouts/widgets/pdf_widget.dart';
import 'package:socialoo/models/get_bookmarks_model.dart';
import 'package:socialoo/models/likeModal.dart';
import 'package:socialoo/models/unlikeModal.dart';

import 'package:timeago/timeago.dart';
import 'package:video_player/video_player.dart';

class SavedBookmarks extends StatefulWidget {
  @override
  _SavedBookmarksState createState() => _SavedBookmarksState();
}

class _SavedBookmarksState extends State<SavedBookmarks>
    with SingleTickerProviderStateMixin {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;

  late UnlikeModal unlikeModal;

  bool refresh = false;

  late LikeModal likeModal;
  VideoPlayerController? controller1;
  bool tap = false;
  GetBookMarksModel? getBookMarksModel;

  @override
  void initState() {
    _getPost();

    super.initState();
  }

  _getPost() async {
    if (refresh != true) {
      setState(() {
        isLoading = true;
      });
    }

    var uri = Uri.parse('${baseUrl()}/get_user_bookmark_post');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['user_id'] = userID!;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userDataRecent = json.decode(responseData);

    print("RESPONSE OF RECENT POST : $responseData");

    setState(() {
      getBookMarksModel = GetBookMarksModel.fromJson(userDataRecent);
      isLoading = false;
    });
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
        refresh = true;
        _getData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        key: scaffoldKey,
        drawer: DrawerWidget(),
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
          title: Text(
            "Bookmarks",
            style: Theme.of(context).textTheme.headline5!.copyWith(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
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
        body: _body(context));
  }

  Widget _body(BuildContext context) {
    return CustomRefreshIndicator(
      child: Container(
        child: isLoading
            ? Center(
                child: loader(context),
              )
            : getBookMarksModel != null && getBookMarksModel!.post!.length > 0
                ? new InViewNotifierList(
                    itemCount: getBookMarksModel!.post!.length,
                    scrollDirection: Axis.vertical,

                    initialInViewIds: ['0'],
                    isInViewPortCondition: (double deltaTop, double deltaBottom,
                        double viewPortDimension) {
                      tap = true;
                      return deltaTop < (0.5 * viewPortDimension) &&
                          deltaBottom > (0.5 * viewPortDimension);
                    },
                    // reverse: true,
                    shrinkWrap: true,
                    builder: (context, index) {
                      return LayoutBuilder(builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return InViewNotifierWidget(
                          id: '$index',
                          builder: (BuildContext context, bool isInView,
                              Widget? child) {
                            return Container(
                              margin: const EdgeInsets.only(
                                top: 5,
                                bottom: 5,
                              ),
                              color: Theme.of(context).cardColor,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _bodyData(getBookMarksModel!.post![index],
                                      isInView),
                                ],
                              ),
                            );
                          },
                        );
                      });
                    },
                  )
                : Container(
                    width: SizeConfig.screenWidth,
                    height: MediaQuery.of(context).size.height * 8 / 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "No Saved Bookmarks found!",
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 5,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 2,
                        ),
                        Text(
                          "When you add bookmarks, they'll appear here",
                          style: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
      ),
      onRefresh: _getData,
      builder:
          (BuildContext context, Widget child, IndicatorController controller) {
        return AnimatedBuilder(
          animation: controller,
          builder: (BuildContext context, _) {
            return Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                if (!controller.isIdle)
                  Column(
                    children: [
                      Container(
                          height: 40,
                          width: 40,
                          child: CupertinoActivityIndicator(
                            radius: 15,
                          ))
                    ],
                  ),
                Transform.translate(
                  offset: Offset(0, 100.0 * controller.value),
                  child: child,
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _bodyData(Post post, bool isInView) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      InkWell(
        onTap: () {
          if (userID == post.postUserId) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Profile(back: true)),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PublicProfile(
                        peerId: post.postUserId,
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
                    borderRadius: BorderRadius.circular(15.0),
                    child: post.profilePic == null || post.profilePic!.isEmpty
                        ? Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF003a54),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Image.asset(
                              'assets/images/defaultavatar.png',
                              width: 50,
                            ),
                          )
                        : CachedNetworkImage(
                            imageUrl: post.profilePic!,
                            height: 50.0,
                            width: 50.0,
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
                            style:
                                Theme.of(context).textTheme.caption!.copyWith(
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
                        // reportPostData = null;
                        reportSheet(
                          context,
                          post.postId,
                          post.bookmark,
                          post.username,
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
      SizedBox(
        height: 10,
      ),
      post.text != ""
          ? Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text('${post.text}'))
          : Container(),
      SizedBox(
        height: 10,
      ),
      postContentWidget(post),
      SizedBox(
        height: 10,
      ),
      Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CommentsScreen(postID: post.postId)),
                            );
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
                    )),
                    const SizedBox(width: 5.0),
                  ],
                ),
              ],
            ),
            const Divider(height: 30.0),
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
                        onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CommentsScreen(postID: post.postId)),
                            ),
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
                        onTap: () => _onShare(
                            context, post.video, post.image, post.text),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/images/share.svg",
                              height: 20,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            const SizedBox(width: 5.0),
                            Text('Share',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Theme.of(context).iconTheme.color,
                                )),
                          ],
                        )),
                    const SizedBox(width: 5.0),
                  ],
                )
              ],
            ),
            const Padding(padding: EdgeInsets.only(bottom: 10.0))
          ],
        ),
      ),
    ]);
  }

  postContentWidget(Post post) {
    bool isimage = post.allImage!.length > 0;
    bool isvideo = post.video != "";
    bool ispdf = post.pdf != "";
    if (isimage) {
      return InkWell(
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
        child: Stack(
          children: [
            Container(
              height: SizeConfig.blockSizeVertical * 40,
              width: SizeConfig.screenWidth,
              // child:
              // Carousel(
              //   images: post.allImage.map((it) {
              //     return ClipRRect(
              //       child: ZoomOverlay(
              //         twoTouchOnly: true,
              //         child: CachedNetworkImage(
              //           imageUrl: it,
              //           imageBuilder: (context, imageProvider) => Container(
              //             decoration: BoxDecoration(
              //               image: DecorationImage(
              //                 image: imageProvider,
              //                 fit: BoxFit.cover,
              //               ),
              //             ),
              //           ),
              //           placeholder: (context, url) => Center(
              //             child: Container(
              //                 // height: 40,
              //                 // width: 40,
              //                 child: CircularProgressIndicator()),
              //           ),
              //           errorWidget: (context, url, error) => Icon(Icons.error),
              //           fit: BoxFit.cover,
              //         ),
              //       ),
              //     );
              //   }).toList(),
              //   showIndicator: post.allImage.length > 1 ? true : false,
              //   dotBgColor: Colors.transparent,
              //   borderRadius: false,
              //   autoplay: false,
              //   dotSize: 5.0,
              //   dotSpacing: 15.0,
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
      // print('pdf : ${post.video}');
      return VideoViewFix(
          url: post.video, play: true, id: post.postId, mute: false);
    } else if (ispdf) {
      // print('pdf : ${post.pdf}');
      return PdfWidget(
        pdf: post.pdf,
        pdfName: post.pdf_name,
        pdfSize: post.pdf_size,
      );
    }
    return Container(
        height: 230,
        width: double.infinity,
        color: Colors.grey[200],
        child: Icon(
          Icons.image,
          size: 200,
          color: Colors.grey[600],
        ));
  }

  reportSheet(BuildContext context, postId, bookmark, postUserId) {
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
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                  height: postUserId != userID ? 150 : 150,
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
                            postUserId != userID
                                ? ListTile(
                                    onTap: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop("Discard");
                                      setState(() {
                                        bookmark = "true";
                                        _removeBookmark(postId);
                                      });
                                    },
                                    title: new Text(
                                      "Remove  Post",
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

  _onShare(BuildContext context, video, image, text) async {
    bool isPhoto = image?.isNotEmpty == true;
    bool isvideo = video?.isNotEmpty == true;
    final RenderBox? box = context.findRenderObject() as RenderBox?;

    if (isPhoto) {
      await Share.share(image[0],
          subject: text,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    } else if (isvideo) {
      // _downloadFile(post['pdfUrl'.);
      await Share.share(video,
          subject: text,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    }
  }

  Future<void> _getData() async {
    setState(() {
      _getPost();
    });
  }
}
