import 'dart:convert';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialoo/global/global.dart';
import 'package:socialoo/layouts/chat/socialoo_chat_main.dart';
import 'package:socialoo/layouts/filter/filterview.dart';
import 'package:socialoo/layouts/homefeeds.dart';
import 'package:socialoo/layouts/menu/menu.dart';
import 'package:socialoo/layouts/menu/recent_users.dart';
import 'package:socialoo/layouts/notifications.dart';
import 'package:socialoo/layouts/user/profile.dart';
import 'package:socialoo/layouts/widgets/circle_button.dart';
import 'package:socialoo/models/followersModal.dart';
import 'package:socialoo/models/followingModal.dart';
import 'package:socialoo/models/loginModal.dart';
import 'package:socialoo/shared_preferences/preferencesKey.dart';

GlobalKey navBarGlobalKey = GlobalKey(debugLabel: 'bottomAppBar');

// ignore: must_be_immutable
class NavBar extends StatefulWidget {
  Widget currentPage = HomeFeeds();
  var currentTab;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  _NavBarState createState() {
    return _NavBarState();
  }
}

class _NavBarState extends State<NavBar> with SingleTickerProviderStateMixin {
  FollowersModal? followersModal;
  late FollwingModal follwingModal;
  // ignore: unused_field
  static double? _height, _width, _fixedPadding;
  int currentPage = 0;
  double gap = 2;
  final padding = EdgeInsets.symmetric(horizontal: 8, vertical: 8);
  late LoginModal model;
  final PageController pageController = PageController(initialPage: 0);
  TabController? _tabController;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    globleFollowers = [];
    globleFollowing = [];
    getUserDataFromPrefs();
    _tabController = TabController(vsync: this, length: 5);

    super.initState();
  }

  getUserDataFromPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String userDataStr =
        preferences.getString(SharedPreferencesKey.LOGGED_IN_USERRDATA)!;
    Map<String, dynamic> userData = json.decode(userDataStr);
    model = LoginModal.fromJson(userData);

    setState(() {
      userID = model.user!.id;
      userImage = model.user!.profilePic;
      userName = model.user!.username;
      userfullname = model.user!.fullname;
      userEmail = model.user!.email;
      userBio = model.user!.bio;
      userPhone = model.user!.phone;
      userGender = model.user!.gender;
      intrestarray = model.user!.interestsId;

      _getFollowers(model.user!.id);
      _getFollowing(model.user!.id);
    });
  }

  DateTime now1 = DateTime.now();

  late DateTime currentBackPressTime = DateTime(now1.day - 1);

  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Tap again to close app');
      return Future.value(false);
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height! * 0.025;
    final mode = AdaptiveTheme.of(context).mode;

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        key: widget.scaffoldKey,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text("Missing Person Helpline",
              style: TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 20)),
          actions: [
            Container(
              alignment: Alignment.center,
              width: 40,
              margin: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                color: Theme.of(context).secondaryHeaderColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
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
              ),
            ),
            CircleButton(
              icon: MdiIcons.facebookMessenger,
              iconSize: 25.0,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SocialooChat()),
                );
              },
            ),
            CircleButton(
              icon: Icons.search,
              iconSize: 25.0,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FilterView()),
                );
              },
            ),
          ],
          bottom: new PreferredSize(
            child: new Container(
              decoration: new BoxDecoration(
                color: Theme.of(context).disabledColor,
                border: const Border(
                  top: const BorderSide(width: 0.0),
                  left: const BorderSide(width: 0.0),
                  right: const BorderSide(width: 0.0),
                  bottom: const BorderSide(width: 1.0, color: Colors.grey),
                ),
              ),
              child: TabBar(
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                      width: 4.0,
                      color: Theme.of(context).tabBarTheme.labelColor!),
                ),
                controller: _tabController,
                unselectedLabelColor:
                    Theme.of(context).tabBarTheme.unselectedLabelColor,
                labelColor: Theme.of(context).tabBarTheme.labelColor,
                tabs: [
                  Tab(
                    icon: const Icon(
                      IconData(
                        0xe904,
                        fontFamily: 'icomoon',
                      ),
                    ),
                  ),
                  Tab(
                    icon: const Icon(
                      const IconData(
                        0xe972,
                        fontFamily: 'icomoon',
                      ),
                    ),
                  ),
                  Tab(
                    icon: const Icon(
                      const IconData(
                        0xe971,
                        fontFamily: 'icomoon',
                      ),
                    ),
                  ),
                  Tab(
                    icon: const Icon(
                      const IconData(
                        0xe951,
                        fontFamily: 'icomoon',
                      ),
                    ),
                  ),
                  Tab(
                    icon: const Icon(
                      const IconData(
                        0xe9BD,
                        fontFamily: 'icomoon',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            preferredSize: const Size.fromHeight(50.0),
          ),
          automaticallyImplyLeading: false,
          elevation: 0.5,
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            HomeFeeds(parentScaffoldKey: widget.scaffoldKey),
            RecentUsers(parentScaffoldKey: widget.scaffoldKey),
            Profile(scaffoldKey: widget.scaffoldKey),
            Notifications(parentScaffoldKey: widget.scaffoldKey),
            SettingsPage(parentScaffoldKey: widget.scaffoldKey),
          ],
        ),
      ),
    );
  }

  _getFollowers(id) async {
    var uri = Uri.parse('${baseUrl()}/my_followers');
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
}
