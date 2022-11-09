import 'dart:convert';
import 'package:nb_utils/nb_utils.dart';
// import 'package:socialoo/Helper/sizeConfig.dart';
import 'package:socialoo/global/global.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:socialoo/layouts/chat/chat.dart';
import 'package:socialoo/layouts/user/publicProfile.dart';
import 'package:socialoo/models/followingModal.dart';
import 'package:socialoo/models/postFollowModal.dart';
import 'package:socialoo/models/unFollowModal.dart';

class FollowingScreen extends StatefulWidget {
  final String? id;
  FollowingScreen({this.id});

  @override
  _Discover1State createState() => _Discover1State(id: id);
}

class _Discover1State extends State<FollowingScreen> {
  final String? id;
  _Discover1State({this.id});
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  final dio = new Dio();
  FollwingModal? modal;
  late FollowModal followModal;
  late UnfollowModal unfollowModal;

  @override
  void initState() {
    _getFollowing();

    super.initState();
  }

  _getFollowing() async {
    setState(() {
      isLoading = true;
    });
    var uri = Uri.parse('${baseUrl()}/my_following');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['user_id'] = id!;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    Map<String, dynamic> userData = json.decode(responseData);
    modal = FollwingModal.fromJson(userData);
    print(modal!.status);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      child: Scaffold(
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
            elevation: 0.5,
            title: Text(
              "Following",
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
          body: LayoutBuilder(
            builder: (context, constraint) {
              return _designPage();
            },
          )),
    );
  }

  Widget _designPage() {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
          child: isLoading
              ? Center(
                  child: loader(context),
                )
              : modal != null && modal!.follower!.length > 0
                  ? new GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, crossAxisSpacing: 5),
                      itemCount: modal!.follower!.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PublicProfile(
                                        peerId:
                                            modal!.follower![index].followUserId,
                                        peerUrl:
                                            modal!.follower![index].profilePic,
                                        peerName:
                                            modal!.follower![index].username,
                                      )),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Stack(children: <Widget>[
                                modal!.follower![index].coverPic == null ||
                                        modal!.follower![index].coverPic!.isEmpty
                                    ? ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            topRight: Radius.circular(12)),
                                        child: Image.asset(
                                          'assets/images/defaultcover.png',
                                          alignment: Alignment.center,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          height: 60,
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            topRight: Radius.circular(12)),
                                        child: SizedBox(
                                          height: 60,
                                          width: double.infinity,
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                modal!.follower![index].coverPic!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12)),
                                  ),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 60,
                                    child: Container(
                                      alignment: const Alignment(0.0, 5.5),
                                      child: modal!.follower![index].profilePic !=
                                                  null ||
                                              modal!.follower![index].profilePic!
                                                  .isNotEmpty
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              child: CachedNetworkImage(
                                                imageUrl: modal!
                                                    .follower![index].profilePic!,
                                                height: 50.0,
                                                width: 50.0,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF003a54),
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                              child: Image.asset(
                                                'assets/images/defaultavatar.png',
                                                width: 50,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ]),
                              const SizedBox(height: 30),
                              Text(
                                modal!.follower![index].username
                                    .toString()
                                    .capitalize(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(fontSize: 18),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              modal!.follower![index].country != null
                                  ? Text(
                                      modal!.follower![index].country
                                          .toString()
                                          .capitalize(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(fontSize: 12),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : Text(''),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  globleFollowing.contains(
                                          modal!.follower![index].followUserId)
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(top: 10.0),
                                          height: 30,
                                          width: (context.width() - (3 * 16)) *
                                              0.2,
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
                                                // fontWeight: FontWeight.w700,
                                                fontSize: 12,
                                                letterSpacing: 0.0,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ).onTap(() {
                                          unfollowApiCall(index);
                                        })
                                      : Container(
                                          margin:
                                              const EdgeInsets.only(top: 10.0),
                                          height: 30,
                                          width: (context.width() - (3 * 16)) *
                                              0.2,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF0D56F2),
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
                                                // fontWeight: FontWeight.w700,
                                                fontSize: 12,
                                                letterSpacing: 0.0,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ).onTap(() {
                                          followApiCall(index);
                                        }),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10.0),
                                    height: 30,
                                    width: (context.width() - (3 * 16)) * 0.2,
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
                                          fontSize: 12,
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
                                          peerID:
                                              modal!.follower![index].followId,
                                          peerUrl:
                                              modal!.follower![index].profilePic,
                                          peerName:
                                              modal!.follower![index].username,
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        "User list is empty",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                      ),
                    )),
    );
  }

  followApiCall(int index) async {
    var uri = Uri.parse('${baseUrl()}/follow_user');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['from_user'] = userID!;
    request.fields['to_user'] = modal!.follower![index].followUserId!;
    var response = await request.send();
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    followModal = FollowModal.fromJson(userData);
    if (followModal.responseCode == "1") {
      setState(() {
        globleFollowing.add(modal!.follower![index].followUserId);
      });
    }
  }

  unfollowApiCall(int index) async {
    var uri = Uri.parse('${baseUrl()}/unfollow_user');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['from_user'] = userID!;
    request.fields['to_user'] = modal!.follower![index].followUserId!;
    var response = await request.send();
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    unfollowModal = UnfollowModal.fromJson(userData);
    if (unfollowModal.responseCode == "1") {
      setState(() {
        globleFollowing.remove(modal!.follower![index].followUserId);
      });
    }
  }
}
