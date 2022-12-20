// ignore_for_file: implementation_imports

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:socialoo/Helper/sizeConfig.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
// import 'package:nb_utils/src/context_extensions.dart';
// import 'package:nb_utils/src/widget_extensions.dart';
import 'package:socialoo/global/global.dart';
import 'package:socialoo/layouts/chat/chat.dart';
import 'package:socialoo/layouts/homefeeds.dart';
import 'package:socialoo/layouts/post/viewPublicPost.dart';
import 'package:socialoo/layouts/user/myFollowers.dart';
import 'package:socialoo/layouts/user/myFollowing.dart';
import 'package:socialoo/layouts/widgets/report_alertdialogmessage.dart';
import 'package:socialoo/models/postFollowModal.dart';
import 'package:socialoo/models/postModal.dart';
import 'package:socialoo/models/unFollowModal.dart';
import 'package:socialoo/models/userdata_model.dart';

class PublicProfile extends StatefulWidget {
  final String? peerId;
  final String? peerUrl;
  final String? peerName;

  PublicProfile({this.peerId, this.peerUrl, this.peerName});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<PublicProfile> {
  bool isInView = false;

  bool isLoading = false;
  UserDataModel? modal;
  late PostModal postModal;
  late FollowModal followModal;
  late UnfollowModal unfollowModal;

  @override
  void initState() {
    // print(widget.peerId + ">>>>>>>>>>");
    // print(widget.peerId + ">>>>>>>>>>");
    print(userID! + ' User Id');
    _getUser();
    _getPost();
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
    request.fields['user_id'] = widget.peerId!;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    modal = UserDataModel.fromJson(userData);
    print(responseData);
    _getPost();
  }

  _getPost() async {
    var uri = Uri.parse('${baseUrl()}/post_by_user');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields["user_id"] = widget.peerId!;
    request.fields['to_user_id'] = userID!;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    postModal = PostModal.fromJson(userData);
    print(responseData);
    print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
    // print(modal.user.profilePic);
    if (mounted)
      setState(() {
        isLoading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

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
          // backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          iconTheme: IconThemeData(
            color: Theme.of(context).appBarTheme.iconTheme!.color,
          ),
          elevation: 0.5,
          title: Text(
            modal != null && modal!.user!.username != ''
                ? modal!.user!.username!.capitalize()
                : '',
            style: Theme.of(context).textTheme.headline5!.copyWith(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
          actions: [
            Row(
              children: [
                modal != null && modal!.user!.username != ''
                    ? globleFollowing.contains(modal!.user!.id)
                        ? Container(
                            margin: EdgeInsets.only(
                                top: 10.0, bottom: 10.0, right: 10.0),
                            height: 38,
                            width: (context.width() - (3 * 16)) * 0.15,
                            decoration: BoxDecoration(
                              color: Colors.redAccent[700],
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            child: Center(
                                child: Image.asset(
                                    "assets/images/block-user.png")),
                          ).onTap(() {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return ReportDialog3(
                                    ontap: () {
                                      unfollowApiCall();
                                      Navigator.pop(context);
                                      Navigator.of(context)
                                          .pushReplacementNamed('/Pages',
                                              arguments: 0);
                                    },
                                  );
                                });
                          })
                        : Container(
                            margin: EdgeInsets.only(
                                top: 10.0, bottom: 10.0, right: 10.0),
                            height: 38,
                            width: (context.width() - (3 * 16)) * 0.15,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            child: Center(
                                child: Image.asset(
                                    "assets/images/block-user.png")),
                          ).onTap(() {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return ReportDialog3(
                                    ontap: () {
                                      unfollowApiCall();
                                      Navigator.pop(context);
                                      Navigator.of(context)
                                          .pushReplacementNamed('/Pages',
                                              arguments: 0);
                                    },
                                  );
                                });
                          })
                    : Container(),
                Container(
                  margin: const EdgeInsets.only(
                      top: 10.0, bottom: 10.0, right: 10.0),
                  height: 35,
                  width: 100,
                  decoration: const BoxDecoration(
                    color: Color(0xffE5E6EB),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Report',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        letterSpacing: 0.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ).onTap(() {
              showDialog(
                  context: context,
                  builder: (context) {
                    return ReportDialog2();
                  });
            })
          ],
        ),
        body: isLoading
            ? Center(
                child: loader(context),
              )
            : modal != null
                ? ListView(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              modal!.user!.coverPic!.isEmpty
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
                                        imageUrl: modal!.user!.coverPic!,
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
                                        borderRadius:
                                            BorderRadius.circular(60.0),
                                        child: modal!.user!.profilePic ==
                                                    null ||
                                                modal!.user!.profilePic!.isEmpty
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFF003a54),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          60.0),
                                                ),
                                                child: Image.asset(
                                                  'assets/images/defaultavatar.png',
                                                  width: 120,
                                                ),
                                              )
                                            : CachedNetworkImage(
                                                imageUrl:
                                                    modal!.user!.profilePic!,
                                                height: 120,
                                                width: 120,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 70),
                          Text(
                            modal!.user!.username!.capitalize(),
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(fontSize: 16),
                          ),
                          const SizedBox(height: 3),
                          Text(modal!.user!.bio!,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(fontSize: 14)),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 10),
                            child: widget.peerId != userID
                                ? Row(
                                    children: [
                                      globleFollowing.contains(modal!.user!.id)
                                          ? Expanded(
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    top: 10.0),
                                                height: 38,
                                                width: (context.width() -
                                                        (3 * 16)) *
                                                    0.4,
                                                decoration: BoxDecoration(
                                                  color: Colors.redAccent[700],
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(5.0),
                                                  ),
                                                ),
                                                child: const Center(
                                                  child: Text(
                                                    'Unfollow',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 16,
                                                      letterSpacing: 0.0,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ).onTap(() {
                                                unfollowApiCall();
                                              }),
                                            )
                                          : Expanded(
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    top: 10.0),
                                                height: 38,
                                                width: (context.width() -
                                                        (3 * 16)) *
                                                    0.4,
                                                decoration: BoxDecoration(
                                                  color: Colors.blue[700],
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(5.0),
                                                  ),
                                                ),
                                                child: const Center(
                                                  child: Text(
                                                    'Follow',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 16,
                                                      letterSpacing: 0.0,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ).onTap(() {
                                                followApiCall();
                                              }),
                                            ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(top: 10.0),
                                          height: 38,
                                          width: (context.width() - (3 * 16)) *
                                              0.4,
                                          decoration: const BoxDecoration(
                                            color: Color(0xffE5E6EB),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5.0),
                                            ),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'Message',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                                letterSpacing: 0.0,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ).onTap(() {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Chat(
                                                peerID: widget.peerId,
                                                peerUrl: widget.peerUrl,
                                                peerName: widget.peerName,
                                              ),
                                            ),
                                          );
                                        }),
                                      )
                                    ],
                                  )
                                : globleFollowing.contains(modal!.user!.id)
                                    ? Expanded(
                                        child: Container(
                                          // width: 100,
                                          // ignore: deprecated_member_use
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.transparent,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  side: BorderSide(
                                                      color: Colors.grey,
                                                      width: 1.5)),
                                            ),
                                            child: Text(
                                              "Following",
                                              style: TextStyle(
                                                  color: Colors.grey[700]),
                                            ),
                                            onPressed: () {
                                              unfollowApiCall();
                                            },
                                          ),
                                        ),
                                      )
                                    : Expanded(
                                        child: Container(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  // ignore: deprecated_member_use
                                                  Theme.of(context).accentColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                            child: Text(
                                              "Follow",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onPressed: () {
                                              followApiCall();
                                            },
                                          ),
                                        ),
                                      ),
                          ),
                          const SizedBox(height: 20),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                buildCountColumn("Posts", modal!.userPost),
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FollowingScreen(
                                                    id: modal!.user!.id)),
                                      );
                                    },
                                    child: buildCountColumn(
                                        "Following", modal!.following)),
                                InkWell(
                                  onTap: () {
                                    print(modal!.user!.id);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FollowersScreen(
                                              id: modal!.user!.id)),
                                    );
                                  },
                                  child: buildCountColumn(
                                      "Followers", modal!.followers),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Divider(),
                          myPost()
                        ],
                      ),
                    ],
                  )
                : Container());
  }

  Widget myPost() {
    return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: postModal.follower!.length > 0
            ? GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                primary: false,
                padding: EdgeInsets.all(5),
                itemCount: postModal.follower!.length,
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Share photos and videos",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "When you share photos and videos, they'll appear\non your profile",
                      style: TextStyle(fontSize: 17, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ));
  }

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

  followApiCall() async {
    var uri = Uri.parse('${baseUrl()}/follow_user');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['from_user'] = userID!;
    request.fields['to_user'] = widget.peerId!;
    var response = await request.send();
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    followModal = FollowModal.fromJson(userData);
    if (followModal.responseCode == "1") {
      setState(() {
        globleFollowing.add(widget.peerId);
      });
    }
  }

  unfollowApiCall() async {
    var uri = Uri.parse('${baseUrl()}/unfollow_user');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['from_user'] = userID!;
    request.fields['to_user'] = widget.peerId!;
    var response = await request.send();
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    unfollowModal = UnfollowModal.fromJson(userData);
    if (unfollowModal.responseCode == "1") {
      setState(() {
        globleFollowing.remove(widget.peerId);
      });
    }
  }
}
