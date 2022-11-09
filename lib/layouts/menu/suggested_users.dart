// ignore_for_file: implementation_imports, must_be_immutable

import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:socialoo/global/global.dart';
import 'package:socialoo/layouts/chat/chat.dart';
import 'package:socialoo/layouts/user/publicProfile.dart';
import 'package:socialoo/models/intrest_model.dart';
import 'package:socialoo/models/postFollowModal.dart';
import 'package:socialoo/models/unFollowModal.dart';

class SuggestedUsers extends StatefulWidget {
  final GlobalKey<ScaffoldState>? parentScaffoldKey;
  bool? back;

  SuggestedUsers({Key? key, this.parentScaffoldKey, this.back})
      : super(key: key);
  @override
  _SuggestedUsersState createState() => _SuggestedUsersState();
}

class _SuggestedUsersState extends State<SuggestedUsers> {
  // var scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController controller = new TextEditingController();

  // ignore: unused_field
  String? _categoryValue;
  String? categoryName;
  IntrestModel? intrestModel;
  bool isSearch = false;
  bool isSearchData = false;
  bool clearData = false;
  String? countryValue;
  String? stateValue;
  String? gender;
  var gender1 = [
    'Male',
    'Female',
    'Trans Male',
    'Trans Female',
    'Gender-Fluid',
    'Non-Binary',
    'Queer',
    'Intersex',
    'Other'
  ];

  double startAge = 18;
  double endAge = 99;

  bool isLoading = false;
  var userData;
  late var serchedUserData;
  // UserDataModel? modal;
  late FollowModal followModal;
  late UnfollowModal unfollowModal;

  List userList = [];
  @override
  void initState() {
    _getTopUser();
    super.initState();
  }

  _getTopUser() async {
    setState(() {
      isSearch = true;
    });
    var uri = Uri.parse('${baseUrl()}/get_all_users');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['user_id'] = userID!;
    var response = await request.send();
    String responseData = await response.stream.transform(utf8.decoder).join();
    userData = json.decode(responseData);

    setState(() {
      isSearch = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 1,
            title: Text(
              "People You May Know",
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
            ),
            automaticallyImplyLeading: false,
          ),
          body: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : LayoutBuilder(
                  builder: (context, constraint) {
                    return Column(
                      children: <Widget>[
                        Expanded(
                            child: isSearch == true
                                ? CupertinoActivityIndicator()
                                : _serachuser()),
                      ],
                    );
                  },
                )),
    );
  }

  Widget _serachuser() {
    return isSearchData == true
        ? ListView.builder(
            itemCount: serchedUserData['users'].length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, int index) {
              return allUserWidget(serchedUserData['users'][index]);
            },
          )
        : isSearchData == false
            ? ListView.builder(
                itemCount: userData['users'].length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return allUserWidget(userData['users'][index]);
                },
              )
            : Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Center(
                  child: Text("No search found"),
                ),
              );
  }

  Widget allUserWidget(lists) {
    return lists['id'] == userID
        ? Container()
        : globleFollowing.contains(lists["id"])
            ? Container()
            : InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PublicProfile(
                            peerId: lists["id"],
                            peerUrl: lists["profile_pic"],
                            peerName: lists["username"])),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Theme.of(context).shadowColor,
                    ),
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                  ),
                  width: 260,
                  height: 400,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: 242,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              child: lists["profile_pic"] == null ||
                                      lists["profile_pic"].isEmpty
                                  ? Container(
                                      decoration: const BoxDecoration(
                                          color: Color(0xFF003a54),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10))),
                                      child: Image.asset(
                                        'assets/images/defaultavatar.png',
                                        width: 50,
                                      ),
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: lists["profile_pic"],
                                      height: 50.0,
                                      width: 50.0,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(
                          lists["username"].toString().capitalize(),
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            globleFollowing.contains(lists["id"])
                                ? Container(
                                    margin: const EdgeInsets.only(top: 10.0),
                                    height: 38,
                                    width: (context.width() - (3 * 16)) * 0.33,
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent[700],
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0),
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Unfollow',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          letterSpacing: 0.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ).onTap(() {
                                    unfollowApiCall(lists);
                                  })
                                : Container(
                                    margin: const EdgeInsets.only(top: 10.0),
                                    height: 38,
                                    width: (context.width() - (3 * 16)) * 0.33,
                                    decoration: BoxDecoration(
                                      color: Colors.blue[700],
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0),
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Follow',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          letterSpacing: 0.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ).onTap(() {
                                    followApiCall(lists);
                                  }),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10.0),
                              height: 38,
                              width: (context.width() - (3 * 16)) * 0.33,
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
                                    peerID: lists["id"],
                                    peerUrl: lists["profile_pic"],
                                    peerName: lists["username"],
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      Container(height: 10),
                    ],
                  ),
                ),
              );
  }

  startTime() async {
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, navigationPage);
  }

  navigationPage() {
    setState(() {
      isSearch = false;
      clearData = false;
    });
  }

  followApiCall(lists) async {
    var uri = Uri.parse('${baseUrl()}/follow_user');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['from_user'] = userID!;
    request.fields['to_user'] = lists["id"];
    var response = await request.send();
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    followModal = FollowModal.fromJson(userData);
    if (followModal.responseCode == "1") {
      setState(() {
        globleFollowing.add(lists["id"]);
      });
    }
  }

  unfollowApiCall(lists) async {
    var uri = Uri.parse('${baseUrl()}/unfollow_user');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['from_user'] = userID!;
    request.fields['to_user'] = lists["id"];
    var response = await request.send();
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    unfollowModal = UnfollowModal.fromJson(userData);
    if (unfollowModal.responseCode == "1") {
      setState(() {
        globleFollowing.remove(lists["id"]);
      });
    }
  }
}
