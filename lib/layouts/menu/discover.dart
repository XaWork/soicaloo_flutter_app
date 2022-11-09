import 'dart:async';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:socialoo/Helper/sizeConfig.dart';
import 'package:socialoo/bloc/lates_post_bloc.dart';
import 'package:socialoo/bloc/search_tag_bloc.dart';
import 'package:socialoo/bloc/search_user_bloc.dart';
import 'package:socialoo/global/global.dart';
import 'package:socialoo/layouts/post/viewPublicPost.dart';
import 'package:socialoo/models/latest_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialoo/models/search_post_model.dart' as postsearch;

class Discover extends StatefulWidget {
  final GlobalKey<ScaffoldState>? parentScaffoldKey;
  Discover({Key? key, this.parentScaffoldKey}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Discover>
    with SingleTickerProviderStateMixin {
  TextEditingController controller = new TextEditingController();
  bool isLoading = false;
  int limit = 10;
  ScrollController listScrollController = ScrollController();
  FocusNode focus = new FocusNode();
  RegExp exp = new RegExp(r"\B#\w\w+");
  List allList = [];
  bool isSearch = false;
  TabController? tabController;
  postsearch.SearchPostModel? searchPostModel;

  @override
  void initState() {
    latestBloc.latestSink(userID);

    tabController = new TabController(length: 1, vsync: this);
    focus.addListener(_onFocusChange);
    super.initState();
  }

  void _onFocusChange() {}

  void _onTap() {
    setState(() {
      focus.hasFocus;
    });
    FocusScope.of(context).requestFocus(focus);
  }

  @override
  void dispose() {
    focus.dispose();
    tabController!.dispose();

    super.dispose();
  }

  // ignore: unused_element
  void _scrollListener() {
    setState(() {
      latestBloc.latestSink(userID);
    });
    if (listScrollController.position.pixels ==
        listScrollController.position.maxScrollExtent) {
      startLoader();
    }
  }

  void startLoader() {
    if (mounted)
      setState(() {
        isLoading = true;
        fetchData();
      });
  }

  fetchData() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, onResponse);
  }

  void onResponse() {
    if (mounted)
      setState(() {
        isLoading = false;
        limit = limit + 2;
      });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    latestBloc.latestSink(userID);
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Theme.of(context).appBarTheme.iconTheme!.color,
          ),
          title: _searchTextfield(context),
          centerTitle: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: Icon(
              Icons.arrow_back_ios,
            ),
          ),
          titleSpacing: 0,
          actions: [
            focus.hasFocus == true
                ? Container(
                    width: 80,
                    child: IconButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () {
                          setState(() {
                            focus.unfocus();
                            isSearch = false;
                            controller.clear();
                            latestBloc.latestSink(userID);
                            searchUserBloc.searchSink('');
                            searchBloc.searchSink('', userID);
                          });
                        },
                        icon: Icon(
                          Icons.cancel_rounded,
                          size: 24,
                        )),
                  )
                : Container(),
            Container(width: 10),
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverToBoxAdapter(
                child: TabBar(
                  controller: tabController,
                  labelColor: Theme.of(context).appBarTheme.iconTheme!.color,
                  unselectedLabelColor:
                      Theme.of(context).appBarTheme.backgroundColor,
                  indicatorColor: Theme.of(context).appBarTheme.backgroundColor,
                  tabs: [
                    Tab(icon: Text("Tags")),
                  ],
                ),
              ),
            ];
          },
          body: Container(
            child: TabBarView(
              controller: tabController,
              children: <Widget>[
                Tab1Data(isSearch: isSearch, focus: focus),
              ],
            ),
          ),
        ));
  }

  Widget _searchTextfield(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
        child: Container(
          height: 40,
          child: InkWell(
            onTap: _onTap,
            child: Container(
              color: appColorWhite,
              child: TextField(
                controller: controller,
                onChanged: (value) {
                  setState(() {
                    isSearch = true;
                  });
                  searchBloc.searchSink(value, userID);
                  searchUserBloc.searchSink(value);
                },
                focusNode: focus,
                style: TextStyle(color: Colors.grey),
                decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey[200]!),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(15.0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey[200]!),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(15.0),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey[200]!),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(15.0),
                    ),
                  ),
                  filled: true,
                  hintStyle:
                      new TextStyle(color: Colors.grey[600], fontSize: 14),
                  hintText: "Search",
                  contentPadding: EdgeInsets.only(top: 10.0),
                  fillColor: Colors.grey[200],
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[600],
                    size: 25.0,
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget allPost() {
    return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: !isSearch
            ? StreamBuilder<LatestPostModel>(
                stream: latestBloc.latestStream,
                builder: (context, AsyncSnapshot<LatestPostModel> snapshot) {
                  if (!snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  List<RescentPost> getAllPost =
                      snapshot.data!.rescentPost != null
                          ? snapshot.data!.rescentPost!
                          : [];
                  return getAllPost.length > 0
                      ? StaggeredGridView.countBuilder(
                          crossAxisCount: 4,
                          itemCount: getAllPost.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          staggeredTileBuilder: (int index) =>
                              StaggeredTile.count(2, index.isEven ? 3 : 2),
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                          itemBuilder: (BuildContext context, int index) =>
                              recentDetails(getAllPost[index]))
                      : Center(
                          child: Text(
                            "No result found!",
                            style: TextStyle(
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        );
                },
              )
            : StreamBuilder<postsearch.SearchPostModel>(
                stream: searchBloc.searchStream,
                builder: (context,
                    AsyncSnapshot<postsearch.SearchPostModel> snapshot) {
                  if (!snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  List<postsearch.Post> getAllPost =
                      snapshot.data!.post != null ? snapshot.data!.post! : [];
                  return getAllPost.length > 0
                      ? StaggeredGridView.countBuilder(
                          crossAxisCount: 4,
                          itemCount: getAllPost.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          staggeredTileBuilder: (int index) =>
                              StaggeredTile.count(2, index.isEven ? 3 : 2),
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                          itemBuilder: (BuildContext context, int index) =>
                              postdetails(getAllPost[index]))
                      : Center(
                          child: Text(
                            "No result found!",
                            style: TextStyle(
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        );
                },
              ));
  }

  Widget recentDetails(RescentPost document) {
    return Container(
        // color: Colors.white,
        child: Padding(
      padding: EdgeInsets.all(3),
      child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewPublicPost(id: document.postId)),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: CachedNetworkImage(
              placeholder: (context, url) => Container(
                child: CupertinoActivityIndicator(),
                width: 35.0,
                height: 35.0,
                padding: EdgeInsets.all(10.0),
              ),
              errorWidget: (context, url, error) => Material(
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.grey,
                  ),
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
                clipBehavior: Clip.hardEdge,
              ),
              imageUrl: document.allImage!.length > 0
                  ? document.image![0]
                  : document.video!,
              width: 35.0,
              height: 35.0,
              fit: BoxFit.cover,
            ),
          )),
    ));
  }

  Widget postdetails(postsearch.Post document) {
    return Container(
        // color: Colors.white,
        child: Padding(
      padding: EdgeInsets.all(3),
      child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewPublicPost(id: document.postId)),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: CachedNetworkImage(
              placeholder: (context, url) => Container(
                child: CupertinoActivityIndicator(),
                width: 35.0,
                height: 35.0,
                padding: EdgeInsets.all(10.0),
              ),
              errorWidget: (context, url, error) => Material(
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.grey,
                  ),
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
                clipBehavior: Clip.hardEdge,
              ),
              imageUrl: document.allImage!.length > 0
                  ? document.image![0]
                  : document.video!,
              width: 35.0,
              height: 35.0,
              fit: BoxFit.cover,
            ),
          )),
    ));
  }
}

class Tab1Data extends StatefulWidget {
  final bool? isSearch;
  final FocusNode focus = new FocusNode();
  Tab1Data({this.isSearch, FocusNode? focus});

  @override
  _Tab1State createState() => _Tab1State();
}

class _Tab1State extends State<Tab1Data> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: !widget.isSearch!
            ? StreamBuilder<LatestPostModel>(
                stream: latestBloc.latestStream,
                builder: (context, AsyncSnapshot<LatestPostModel> snapshot) {
                  if (!snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  List<RescentPost> getAllPost =
                      snapshot.data!.rescentPost != null
                          ? snapshot.data!.rescentPost!
                          : [];
                  getAllPost.removeWhere((item) => item.postReport == 'true');
                  getAllPost.removeWhere((item) => item.userBlok == 'true');
                  return getAllPost.length > 0
                      ? StaggeredGridView.countBuilder(
                          crossAxisCount: 4,
                          itemCount: getAllPost.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          staggeredTileBuilder: (int index) =>
                              StaggeredTile.count(2, index.isEven ? 3 : 2),
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                          itemBuilder: (BuildContext context, int index) =>
                              recentDetails(getAllPost[index]))
                      : Center(
                          child: Text(
                            "No result found!",
                            style: TextStyle(
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        );
                },
              )
            : StreamBuilder<postsearch.SearchPostModel>(
                stream: searchBloc.searchStream,
                builder: (context,
                    AsyncSnapshot<postsearch.SearchPostModel> snapshot) {
                  if (!snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  List<postsearch.Post> getAllPost =
                      snapshot.data!.post != null ? snapshot.data!.post! : [];
                  getAllPost.removeWhere((item) => item.postReport == 'true');
                  getAllPost.removeWhere((item) => item.userBlok == 'true');
                  return getAllPost.length > 0
                      ? StaggeredGridView.countBuilder(
                          crossAxisCount: 4,
                          itemCount: getAllPost.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          staggeredTileBuilder: (int index) =>
                              StaggeredTile.count(2, index.isEven ? 3 : 2),
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                          itemBuilder: (BuildContext context, int index) =>
                              postdetails(getAllPost[index]))
                      : Center(
                          child: Text(
                            "No result found!",
                            style: TextStyle(
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        );
                },
              ));
  }

  Widget recentDetails(RescentPost document) {
    return Container(
        // color: Colors.white,
        child: Padding(
      padding: EdgeInsets.all(3),
      child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewPublicPost(id: document.postId)),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: CachedNetworkImage(
              placeholder: (context, url) => Container(
                child: CupertinoActivityIndicator(),
                width: 35.0,
                height: 35.0,
                padding: EdgeInsets.all(10.0),
              ),
              errorWidget: (context, url, error) => Material(
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.grey,
                  ),
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
                clipBehavior: Clip.hardEdge,
              ),
              imageUrl: document.allImage!.length > 0
                  ? document.image![0]
                  : document.video!,
              width: 35.0,
              height: 35.0,
              fit: BoxFit.cover,
            ),
          )),
    ));
  }

  _getRequests() async {
    setState(() {
      latestBloc.latestSink('2');
    });
  }

  Widget postdetails(postsearch.Post document) {
    return Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(3),
          child: GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(new MaterialPageRoute(
                        builder: (_) => ViewPublicPost(id: document.postId)))
                    .then((val) => val ? _getRequests() : null);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: CachedNetworkImage(
                  placeholder: (context, url) => Container(
                    child: CupertinoActivityIndicator(),
                    width: 35.0,
                    height: 35.0,
                    padding: EdgeInsets.all(10.0),
                  ),
                  errorWidget: (context, url, error) => Material(
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.grey,
                      ),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                    clipBehavior: Clip.hardEdge,
                  ),
                  imageUrl: document.allImage!.length > 0
                      ? document.image![0]
                      : document.video!,
                  width: 35.0,
                  height: 35.0,
                  fit: BoxFit.cover,
                ),
              )),
        ));
  }
}
