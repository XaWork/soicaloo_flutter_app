import 'package:flutter/material.dart';
import 'package:socialoo/layouts/chat/chat_list.dart';
import 'package:socialoo/layouts/menu/all_stories.dart';

class SocialooChat extends StatefulWidget {
  final String? userId;

  const SocialooChat({Key? key, this.userId}) : super(key: key);

  @override
  _SocialooChatState createState() => _SocialooChatState();
}

class _SocialooChatState extends State<SocialooChat>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final PageController pageController = PageController(initialPage: 0);
  int pageIndex = 0;
  TabController? _tabController;

  bool isFollowing = false;

  bool showElevatedButtonBadge = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _tabController!.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {});
  }

  AnimatedTheme buildAuthScreen() {
    return AnimatedTheme(
      duration: const Duration(milliseconds: 300),
      data: Theme.of(context),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        key: _scaffoldKey,
        appBar: AppBar(
          // backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
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
          automaticallyImplyLeading: true,
          shape: Border(
            bottom: BorderSide(
              color: Theme.of(context).shadowColor,
              width: 1.0,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    'Chats',
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          elevation: 0.0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: Container(
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
                tabs: const [
                  Tab(
                    text: 'Chats',
                  ),
                  Tab(
                    text: 'Stories',
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            ChatList(),
            AllStories(
                // showappbar: false,
                ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildAuthScreen();
  }
}
