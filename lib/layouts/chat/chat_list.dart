import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialoo/global/global.dart';
import 'package:socialoo/layouts/user/publicProfile.dart';
import 'package:timeago/timeago.dart';

import 'chat.dart';

class ChatList extends StatefulWidget {
  final GlobalKey<ScaffoldState>? parentScaffoldKey;
  ChatList({Key? key, this.parentScaffoldKey}) : super(key: key);
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40)),
                  ),
                  child: friendListToMessage(userID!)),
            ),
          ],
        ),
      ),
    );
  }

  Widget friendListToMessage(String userData) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chatList")
          .doc(userData)
          .collection(userData)
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: snapshot.data!.docs.length > 0
                ? ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: snapshot.data!.docs.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: const Divider(),
                    ),
                    itemBuilder: (context, int index) {
                      List chatList = snapshot.data!.docs;
                      return buildItem(chatList, index);
                    },
                  )
                : Center(
                    child: Text("Currently you don't have any messages"),
                  ),
          );
        }
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                CupertinoActivityIndicator(),
              ]),
        );
      },
    );
  }

  Widget buildItem(List chatList, int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
      child: Column(
        children: [
          Container(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 8),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 0, top: 0),
                    child: Container(
                      decoration: new BoxDecoration(
                          //color: Colors.grey[300],
                          borderRadius:
                              new BorderRadius.all(Radius.circular(0.0))),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      child: Stack(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              print(
                                  '${chatList[index]['id']},${chatList[index]['profileImage']},${chatList[index]['name']}');
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => Chat(
                                          peerID: chatList[index]['id'],
                                          peerUrl: chatList[index]
                                                      ['profileImage'] !=
                                                  null
                                              ? chatList[index]['profileImage']
                                              : null,
                                          peerName: chatList[index]['name'])));
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: 35),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 50,
                                        top: 10,
                                        right: 40,
                                        bottom: 5),
                                    child: Container(
                                      // color: Colors.purple,
                                      width: MediaQuery.of(context).size.width -
                                          200,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            height: 5,
                                          ),
                                          Container(
                                            // color: Colors.yellow,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                180,
                                            child: Text(chatList[index]['name'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .copyWith(
                                                      fontSize: 16,
                                                    ),
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 3),
                                            child: Container(
                                              // color: Colors.red,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  150,
                                              height: 20,
                                              child: Text(
                                                chatList[index]['type'] !=
                                                            null &&
                                                        chatList[index]
                                                                ['type'] ==
                                                            1
                                                    ? "📷 Image"
                                                    : chatList[index]
                                                        ['content'],
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: appColorGrey,
                                                  fontSize: 12,
                                                  fontFamily: "Poppins-Medium",
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Row(
                                      children: [
                                        Text(format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                int.parse(
                                              chatList[index]['timestamp'],
                                            )),
                                            locale: 'en_short')),
                                        int.parse(chatList[index]['badge']) > 0
                                            ? Row(
                                                children: [
                                                  SizedBox(
                                                    width: 05,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.red,
                                                    ),
                                                    alignment: Alignment.center,
                                                    height: 30,
                                                    width: 30,
                                                    child: Text(
                                                      chatList[index]['badge'],
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w900),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Container(),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 12),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PublicProfile(
                                  peerId: chatList[index]['id'],
                                  peerUrl: chatList[index]['profileImage'],
                                  peerName: chatList[index]['name'])),
                        );
                      },
                      child: chatList[index]['profileImage'].isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: CachedNetworkImage(
                                imageUrl: chatList[index]['profileImage'],
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF003a54),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Image.asset(
                                'assets/images/defaultavatar.png',
                                width: 50,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget friendName(AsyncSnapshot friendListSnapshot, int index) {
    return Container(
      width: 200,
      alignment: Alignment.topLeft,
      child: RichText(
        text: TextSpan(children: <TextSpan>[
          TextSpan(
            text:
                "${friendListSnapshot.data["firstname"]} ${friendListSnapshot.data["lastname"]}",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
          )
        ]),
      ),
    );
  }

  Widget messageButton(AsyncSnapshot friendListSnapshot, int index) {
    // ignore: deprecated_member_use
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(
        "Message",
        style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
      ),
      onPressed: () {},
    );
  }
}
