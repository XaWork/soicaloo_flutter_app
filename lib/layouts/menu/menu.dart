import 'dart:convert';
import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:socialoo/global/global.dart';
import 'package:socialoo/layouts/ads/create_ads.dart';
import 'package:socialoo/layouts/ads/my_ads.dart';
import 'package:socialoo/layouts/chat/socialoo_chat_main.dart';
import 'package:socialoo/layouts/menu/all_stories.dart';
import 'package:socialoo/layouts/menu/all_videos.dart';
import 'package:socialoo/layouts/menu/comming_soon_page.dart';
import 'package:socialoo/layouts/menu/discover.dart';
import 'package:socialoo/layouts/menu/help_support.dart';
import 'package:socialoo/layouts/menu/recent_users.dart';
import 'package:socialoo/layouts/user/editprofile1.dart';
import 'package:socialoo/layouts/user/login.dart';
import 'package:socialoo/layouts/user/myFollowers.dart';
import 'package:socialoo/layouts/user/myFollowing.dart';
import 'package:socialoo/layouts/user/profile.dart';
import 'package:socialoo/layouts/user/saved_bookmarks.dart';
import 'package:socialoo/models/postModal.dart';
import 'package:socialoo/models/userdata_model.dart';
import 'package:socialoo/shared_preferences/preferencesKey.dart';

class SettingsPage extends StatefulWidget {
  final String? currentUserId;
  final GlobalKey<ScaffoldState>? parentScaffoldKey;
  const SettingsPage({
    Key? key,
    this.currentUserId,
    this.parentScaffoldKey,
  }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  late UserDataModel modal;
  PostModal? postModal;
  String totalPost = '0';

  File? imageFileAvatar;
  String? imageFileAvatarUrl;

  @override
  void initState() {
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
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    postModal = PostModal.fromJson(userData);
    print(responseData);
    if (mounted)
      setState(() {
        isLoading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    final mode = AdaptiveTheme.of(context).mode;
    return AnimatedTheme(
      duration: const Duration(milliseconds: 300),
      data: Theme.of(context),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        key: _scaffoldKey,
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
            "Menu",
            style: Theme.of(context).textTheme.headline5!.copyWith(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: isLoading
            ? Center(
                child: loader(context),
              )
            : ListView(children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 20,
                          height: 85.0,
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: userImage == null || userImage!.isEmpty
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF003a54),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: Image.asset(
                                          'assets/images/defaultavatar.png',
                                          width: 40,
                                        ),
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: userImage!,
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              const SizedBox(height: 5.0),
                              Text(userName!.capitalize(),
                                  style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ).onTap(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Profile(back: true)),
                        );
                      }),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 30,
                          height: 85.0,
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Image.asset(
                                "assets/images/chat.png",
                                width: 40,
                              ),
                              const SizedBox(height: 5.0),
                              const Text('Messenger',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ).onTap(() {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => SocialooChat(),
                            ));
                      }),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 20,
                          height: 85.0,
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Image.asset(
                                "assets/images/recent_useers_1.png",
                                width: 40,
                              ),
                              const SizedBox(height: 5.0),
                              const Text('Recent Users',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ).onTap(() {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => RecentUsers(back: true),
                            ));
                      }),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 30,
                          height: 85.0,
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Image.asset(
                                "assets/images/edit.png",
                                width: 40,
                              ),
                              const SizedBox(height: 5.0),
                              const Text('Edit Profile',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ).onTap(() {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => EditProfile(),
                            ));
                      }),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 20,
                          height: 85.0,
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Image.asset(
                                "assets/images/following.png",
                                width: 40,
                              ),
                              const SizedBox(height: 5.0),
                              const Text('Following',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ).onTap(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FollowingScreen(id: userID)),
                        );
                      }),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 30,
                          height: 85.0,
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Image.asset(
                                "assets/images/followers.png",
                                width: 40,
                              ),
                              const SizedBox(height: 5.0),
                              const Text('Followers',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ).onTap(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FollowersScreen(id: userID)),
                        );
                      }),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 20,
                          height: 85.0,
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Image.asset(
                                "assets/images/earth.png",
                                width: 40,
                              ),
                              const SizedBox(height: 5.0),
                              const Text('Tags',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ).onTap(() {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => Discover(),
                            ));
                      }),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 30,
                          height: 85.0,
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Image.asset(
                                "assets/images/open_book.png",
                                width: 40,
                              ),
                              const SizedBox(height: 5.0),
                              const Text('Stories',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ).onTap(() {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => AllStories(),
                            ));
                      }),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 20,
                          height: 85.0,
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Image.asset(
                                "assets/images/video.png",
                                width: 40,
                              ),
                              const SizedBox(height: 5.0),
                              const Text('Videos',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ).onTap(() {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => AllVideos(),
                            ));
                      }),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 30,
                          height: 85.0,
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Image.asset(
                                "assets/images/saved.png",
                                width: 40,
                              ),
                              const SizedBox(height: 5.0),
                              const Text('Saved Posts',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ).onTap(() {
                        Navigator.of(context)
                            .push(new MaterialPageRoute(
                                builder: (_) => new SavedBookmarks()))
                            .then((val) => val ? _getRequests() : null);
                      }),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 20,
                          height: 85.0,
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Image.asset(
                                "assets/images/shield.png",
                                width: 40,
                              ),
                              const SizedBox(height: 5.0),
                              const Text('Help & Support',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ).onTap(() {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => HelpSupportPage(
                                currentUserId: widget.currentUserId,
                              ),
                            ));
                      }),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 30,
                          height: 85.0,
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Image.asset(
                                "assets/images/block-user.png",
                                width: 40,
                              ),
                              const SizedBox(height: 5.0),
                              const Text('Deactivate Account',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ).onTap(() {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => CommimgSoon(),
                            ));
                      }),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 30,
                          height: 85.0,
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Image.asset(
                                "assets/images/block-user.png",
                                width: 40,
                              ),
                              const SizedBox(height: 5.0),
                              const Text('Add Ads',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ).onTap(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateAds()));
                      }),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 30,
                          height: 85.0,
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Image.asset(
                                "assets/images/block-user.png",
                                width: 40,
                              ),
                              const SizedBox(height: 5.0),
                              const Text('My Ads',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ).onTap(() {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => MyAds()));
                      }),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (mode == AdaptiveThemeMode.light) {
                        AdaptiveTheme.of(context).setDark();
                      } else {
                        AdaptiveTheme.of(context).setLight();
                      }
                    },
                    icon: mode == AdaptiveThemeMode.light
                        ? const Icon(Icons.light_mode)
                        : const Icon(Icons.dark_mode),
                    label: mode == AdaptiveThemeMode.light
                        ? const Text('Set Dark')
                        : const Text('Set Light'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      minimumSize: const Size(100, 38),
                      maximumSize: const Size(100, 38),
                    ),
                  ),
                ),
                ListTile(
                  title: Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    height: 38,
                    width: (MediaQuery.of(context).size.width * 0.4),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Logout',
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
                    () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      preferences
                          .remove(SharedPreferencesKey.LOGGED_IN_USERRDATA)
                          .then((_) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      });
                    },
                  ),
                ),
              ]),
      ),
    );
  }
}
