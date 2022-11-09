import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:socialoo/Helper/sizeConfig.dart';
import 'package:socialoo/global/global.dart';
import 'package:socialoo/models/addCommentModal.dart';
import 'package:socialoo/models/getCommentModal.dart';
import 'package:timeago/timeago.dart';

// ignore: must_be_immutable
class CommentsScreen extends StatefulWidget {
  String? postID;
  CommentsScreen({this.postID});

  @override
  _LoginPage1State createState() => _LoginPage1State(postID: postID);
}

class _LoginPage1State extends State<CommentsScreen> {
  String? postID;
  _LoginPage1State({this.postID});
  late GetCommentModal modal;
  late AddCommentModal addCommentModal;
  bool isLoading = false;
  final myController = TextEditingController();

  @override
  void initState() {
    _getComment();
    super.initState();
  }

  _getComment() async {
    setState(() {
      isLoading = true;
    });
    var uri = Uri.parse('${baseUrl()}/comments_by_post');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['post_id'] = postID!;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    modal = GetCommentModal.fromJson(userData);
    print(responseData);

    setState(() {
      isLoading = false;
    });
  }

  _addComment() async {
    setState(() {
      isLoading = true;
    });
    var uri = Uri.parse('${baseUrl()}/add_comments');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['post_id'] = postID!;
    request.fields['user_id'] = userID!;
    request.fields['text'] = myController.text;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    addCommentModal = AddCommentModal.fromJson(userData);
    print(responseData);

    if (addCommentModal.responseCode == "1") {
      _getComment();
      myController.clear();
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    // ScreenUtil.instance =
    ScreenUtil.init(context, designSize: Size(750, 1334), minTextAdapt: true);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, modal.likes!.length);
        return true;
      },
      child: Scaffold(
        // backgroundColor: Colors.white,
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
            "Comments",
            style: Theme.of(context).textTheme.headline5!.copyWith(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context, modal.likes!.length);
              },
              icon: Icon(
                Icons.arrow_back_ios,
              )),
        ),
        body: isLoading
            ? Center(
                child: loader(context),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: commentList(),
                  ),
                  Center(
                    child: Container(
                      margin: safeQueries(context)
                          ? EdgeInsets.only(bottom: 25)
                          : null,
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 10,
                          ),

                          Flexible(
                            child: Container(
                              child: TextFormField(
                                style: Theme.of(context).textTheme.bodyText2,
                                controller: myController,
                                autofocus: true,
                                decoration: InputDecoration(
                                  hintText: "Type here",
                                  hintStyle:
                                      Theme.of(context).textTheme.bodyText2,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(40),
                                    ),
                                    borderSide: BorderSide(
                                        color: Theme.of(context).shadowColor,
                                        width: 0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(40),
                                    ),
                                    borderSide: BorderSide(
                                        color: Theme.of(context).shadowColor,
                                        width: 0),
                                  ),
                                  isDense: true,
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(16, 12, 16, 12),
                                  filled: true,
                                  fillColor: Theme.of(context).canvasColor,
                                ),
                              ),
                            ),
                          ),

                          // Button send message
                          Material(
                            child: new Container(
                              margin: new EdgeInsets.symmetric(horizontal: 8.0),
                              child: new IconButton(
                                icon: new Icon(
                                  Icons.send,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                                onPressed: () {
                                  _addComment();
                                },
                                // color: primaryColor,
                              ),
                            ),
                            color: Colors.transparent,
                          ),
                        ],
                      ),
                      width: double.infinity,
                      height: 50.0,
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Widget commentList() {
    return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: modal.likes!.length,
        itemBuilder: (BuildContext context, int index) {
          return Slidable(
            // actionPane: SlidableDrawerActionPane(),
            // actionExtentRatio: 0.25,
            child: Container(
              child: Container(
                decoration: BoxDecoration(
                  //color: Colors.grey,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Material(
                            child:
                                // peerUrl != null
                                //     ?
                                CachedNetworkImage(
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
                              imageUrl: modal.likes![index].profilePic!,
                              width: 45.0,
                              height: 45.0,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(120.0),
                            ),
                            clipBehavior: Clip.hardEdge,
                          ),
                          Container(width: 15.0),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(height: 10.0),
                                    Expanded(
                                      child: RichText(
                                        text: new TextSpan(
                                          style: new TextStyle(
                                            fontSize: 14.0,
                                          ),
                                          children: <TextSpan>[
                                            new TextSpan(
                                                text: modal
                                                    .likes![index].username,
                                                style: TextStyle(
                                                    fontStyle: FontStyle.normal,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .color,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: "  " +
                                                    modal.likes![index].text!,
                                                style: TextStyle(
                                                    fontSize: SizeConfig
                                                            .safeBlockHorizontal *
                                                        3.5,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .color,
                                                    fontWeight:
                                                        FontWeight.normal)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 10,
                                    ),
                                    Text(
                                      format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            int.parse(
                                                modal.likes![index].date!)),
                                      ),
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                          fontWeight: FontWeight.normal,
                                          fontStyle: FontStyle.normal),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // actions: <Widget>[],
          );
        });
  }
}
