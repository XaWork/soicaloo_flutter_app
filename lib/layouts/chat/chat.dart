import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:socialoo/Helper/sizeConfig.dart';
import 'package:socialoo/global/global.dart';
import 'package:socialoo/layouts/chat/chatPost.dart';
import 'package:socialoo/layouts/chat/chat_appbar.dart';

class Chat extends StatefulWidget {
  final String? peerID;
  final String? peerUrl;
  final String? peerName;

  Chat({
    required this.peerID,
    this.peerUrl,
    required this.peerName,
  });

  @override
  _ChatState createState() =>
      _ChatState(peerID: peerID, peerUrl: peerUrl, peerName: peerName);
}

class _ChatState extends State<Chat> {
  final String? peerID;
  final String? peerUrl;
  final String? peerName;

  _ChatState({required this.peerID, this.peerUrl, required this.peerName});

  String? groupChatId;
  var listMessage;
  File? imageFile;
  late bool isLoading;
  bool isDataLoad = true;
  late String imageUrl;
  int limit = 20;
  String? peerToken = '';
  String? peerCode;

  final TextEditingController textEditingController = TextEditingController();
  ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  TextEditingController reviewCode = TextEditingController();
  TextEditingController reviewText = TextEditingController();
  // ignore: unused_field
  GiphyGif? _gif;
  final textFieldFocusNode = FocusNode();

  @override
  void initState() {
    _getPeerData();
    super.initState();

    groupChatId = '';
    isLoading = false;

    print(peerID! + peerName!);

    imageUrl = '';

    readLocal();
    removeBadge();
    setState(() {});
  }

  removeBadge() async {
    await FirebaseFirestore.instance
        .collection("chatList")
        .doc(userID)
        .collection(userID!)
        .doc(peerID)
        .get()
        .then((doc) async {
      if (doc.exists) {
        await FirebaseFirestore.instance
            .collection("chatList")
            .doc(userID)
            .collection(userID!)
            .doc(peerID)
            .update({'badge': '0'});
      }
    });
  }

  void _scrollListener() {
    if (listScrollController.position.pixels ==
        listScrollController.position.maxScrollExtent) {
      startLoader();
    }
  }

  void startLoader() {
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
    setState(() {
      isLoading = false;
      limit = limit + 20;
    });
  }

  readLocal() {
    if (userID.hashCode <= peerID.hashCode) {
      groupChatId = '$userID-$peerID';
    } else {
      groupChatId = '$peerID-$userID';
    }

    setState(() {});
  }

  _getPeerData() async {
    var uri = Uri.parse('${baseUrl()}/user_data');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['user_id'] = peerID!;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);

    print(responseData);
    if (userData['response_code'] == "1") {
      peerToken = userData['user']['device_token'];
      print(peerToken);
    }

    setState(() {
      isDataLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    listScrollController = new ScrollController()..addListener(_scrollListener);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: MyCustomAppBar(
          height: 70,
          receiverId: peerID,
          receiverAvatar: peerUrl,
          receiverName: peerName),
      body: isDataLoad
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        buildListMessage(),
                        Container(
                          child: createInput(),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: isLoading
                      ? Container(
                          padding: EdgeInsets.all(5),
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF1e3c72),
                          ),
                          child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor: AlwaysStoppedAnimation<Color?>(
                                  Colors.grey[200])))
                      : Container(),
                ),
              ],
            ),
    );
  }

  createInput() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        height: 43,
        child: ListView(
          padding: Spacing.zero,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    getImage();
                  },
                  child: Container(
                      padding: EdgeInsets.all(8),
                      child: const Icon(Ionicons.camera_outline)),
                ),
                InkWell(
                  onTap: () async {
                    setState(() {
                      textFieldFocusNode.unfocus();
                      textFieldFocusNode.canRequestFocus = false;
                    });

                    GiphyGif? gif = await GiphyGet.getGif(
                      context: context,
                      apiKey:
                          "5O0S0RL6CRLQj3Ch8wnTFctv7lswZt0G", //YOUR API KEY HERE
                      lang: GiphyLanguage.spanish,
                    );

                    if (gif != null) {
                      setState(() {
                        _gif = gif;

                        onSendMessage(gif.images!.original!.url, 1);
                        print(gif.images!.original!.url);
                      });
                    }
                  },
                  child: Container(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.gif_rounded,
                      )),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 16),
                    child: TextFormField(
                      style: Theme.of(context).textTheme.bodyText2,
                      decoration: InputDecoration(
                        hintText: "Type here",
                        hintStyle: Theme.of(context).textTheme.bodyText2,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(40),
                          ),
                          borderSide: BorderSide(
                              color: Theme.of(context).shadowColor, width: 0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(40),
                          ),
                          borderSide: BorderSide(
                              color: Theme.of(context).shadowColor, width: 0),
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                        filled: true,
                        fillColor: Theme.of(context).canvasColor,
                      ),
                      textInputAction: TextInputAction.send,
                      onFieldSubmitted: (message) {
                        onSendMessage(textEditingController.text, 0);
                      },
                      controller: textEditingController,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 16),
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF1246A5), Color(0xFF1e3c72)],
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      onSendMessage(textEditingController.text, 0);
                    },
                    child: SvgPicture.asset(
                      'assets/images/chat_send.svg',
                      width: 20,
                      height: 20,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId == ''
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(appColor)))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .doc(groupChatId)
                  .collection(groupChatId!)
                  .orderBy('timestamp', descending: true)
                  .limit(limit)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(appColor)));
                } else {
                  listMessage = snapshot.data!.docs;
                  return Padding(
                    padding: const EdgeInsets.only(left: 0, right: 0),
                    child: Container(
                      child: ListView.builder(
                        padding: EdgeInsets.all(10.0),
                        itemBuilder: (context, index) =>
                            buildItem(index, snapshot.data!.docs[index]),
                        itemCount: snapshot.data!.docs.length,
                        reverse: true,
                        controller: listScrollController,
                      ),
                    ),
                  );
                }
              },
            ),
    );
  }

  Future getImage() async {
    late File _image;

    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
        _image = File(imageFile.path);
      });
      final dir = await getTemporaryDirectory();
      final targetPath = dir.absolute.path +
          "/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";

      await FlutterImageCompress.compressAndGetFile(
        _image.absolute.path,
        targetPath,
        quality: 20,
      ).then((value) async {
        print("Compressed");

        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference reference =
            FirebaseStorage.instance.ref().child("ChatMedia").child(fileName);

        UploadTask uploadTask = reference.putFile(value!);
        // TaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
        String downloadUrl = await (await uploadTask).ref.getDownloadURL();
        // storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
        imageUrl = downloadUrl;
        setState(() {
          isLoading = false;
          onSendMessage(imageUrl, 1);
        });
        // }, onError: (err) {
        //   setState(() {
        //     isLoading = false;
        //   });
        // });
      });
    }
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    double cWidth = MediaQuery.of(context).size.width * 0.8;
    if (document['idFrom'] == userID) {
      // Right (my message)
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              document['type'] == 0
                  // Text
                  ? Container(
                      width: cWidth,
                      margin: EdgeInsets.only(top: 6, bottom: 4).add(
                          EdgeInsets.only(
                              right: MediaQuery.of(context).size.width * 0.02)),
                      alignment: Alignment.centerRight,
                      child: Container(
                          padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            document["content"],
                            style:
                                Theme.of(context).textTheme.subtitle2!.copyWith(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                            overflow: TextOverflow.fade,
                          )),
                    )
                  : document['type'] == 2
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Container(
                              color: Colors.transparent,
                              height: SizeConfig.blockSizeHorizontal * 95,
                              width: SizeConfig.blockSizeHorizontal * 70,
                              child: ChatPost(
                                id: document['content'],
                              )),
                        )
                      : Container(
                          // ignore: deprecated_member_use
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(0)),
                            child: Material(
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                  child: CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(appColor),
                                  ),
                                  width: 200.0,
                                  height: 200.0,
                                  padding: EdgeInsets.all(70.0),
                                  decoration: BoxDecoration(
                                    color: Color(0xffE8E8E8),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Material(
                                  child: Text("Not Avilable"),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                ),
                                imageUrl: document['content'],
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              clipBehavior: Clip.hardEdge,
                            ),
                            onPressed: () {
                              imagePreview(
                                document['content'],
                              );
                            },
                          ),
                          margin: EdgeInsets.only(
                              bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                              right: 10.0),
                        ),
            ],
            mainAxisAlignment: MainAxisAlignment.end,
          ),
          isLastMessageRight(index)
              ? Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    DateFormat('dd MMM kk:mm').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            int.parse(document['timestamp']))),
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12.0,
                        fontStyle: FontStyle.italic),
                  ),
                  margin: EdgeInsets.only(right: 10.0),
                )
              : Container()
        ],
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                document['type'] == 0
                    ? Container(
                        constraints:
                            BoxConstraints(minWidth: 40, maxWidth: cWidth),
                        padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          document["content"],
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(fontSize: 15),
                        ),
                      )
                    : document['type'] == 2
                        ? Padding(
                            padding: const EdgeInsets.only(),
                            child: Container(
                                height: SizeConfig.blockSizeHorizontal * 95,
                                width: SizeConfig.blockSizeHorizontal * 70,
                                child: ChatPost(
                                  id: document['content'],
                                )),
                          )
                        : Container(
                            // ignore: deprecated_member_use
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(0),
                              ),
                              child: Material(
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          appColor),
                                    ),
                                    width: 200.0,
                                    height: 200.0,
                                    padding: EdgeInsets.all(70.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Material(
                                    child: Text("Not Avilable"),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                                  imageUrl: document['content'],
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                              onPressed: () {
                                imagePreview(document['content']);
                              },
                            ),
                            margin: EdgeInsets.only(left: 10.0),
                          ),
              ],
            ),

            // Time
            isLastMessageLeft(index)
                ? Container(
                    child: Text(
                      DateFormat('dd MMM kk:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(document['timestamp']))),
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                          fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] == userID) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] != userID) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> onSendMessage(String content, int type) async {
    // type: 0 = text, 1 = image, 2 = sticker
    int badgeCount = 0;
    print(content);
    print(content.trim());
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId!)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'idFrom': userID,
            'idTo': peerID,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
      }).then((onValue) async {
        await FirebaseFirestore.instance
            .collection("chatList")
            .doc(userID)
            .collection(userID!)
            .doc(peerID)
            .set({
          'id': peerID,
          'name': peerName,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'content': content,
          'badge': '0',
          'profileImage': peerUrl,
          'type': type
        }).then((onValue) async {
          try {
            await FirebaseFirestore.instance
                .collection("chatList")
                .doc(peerID)
                .collection(peerID!)
                .doc(userID)
                .get()
                .then((doc) async {
              debugPrint(doc["badge"]);
              if (doc["badge"] != null) {
                badgeCount = int.parse(doc["badge"]);
                await FirebaseFirestore.instance
                    .collection("chatList")
                    .doc(peerID)
                    .collection(peerID!)
                    .doc(userID)
                    .set({
                  'id': userID,
                  'name': userName,
                  'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
                  'content': content,
                  'badge': '${badgeCount + 1}',
                  'profileImage': userImage,
                  'type': type
                });
              }
            });
          } catch (e) {
            await FirebaseFirestore.instance
                .collection("chatList")
                .doc(peerID)
                .collection(peerID!)
                .doc(userID)
                .set({
              'id': userID,
              'name': userName,
              'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
              'content': content,
              'badge': '${badgeCount + 1}',
              'profileImage': userImage,
              'type': type
            });
            print(e);
          }
        });
      });

      if (type == 1) {
        sendImageNotification(peerToken, content);
      } else if (type == 4) {
        sendVideoNotification(peerToken, content);
      } else {
        sendNotification(peerToken, content);
      }
    }
  }

  Future<http.Response> sendVideoNotification(
    String? peerToken,
    String content,
  ) async {
    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: "key=$serverKey"
      },
      body: jsonEncode({
        "to": peerToken,
        "priority": "high",
        "data": {
          "type": "100",
          "user_id": userID,
          "title": content,
          "message": userName,
          "time": DateTime.now().millisecondsSinceEpoch,
          "sound": "default",
          "vibrate": "300",
        },
        "notification": {
          "vibrate": "300",
          "priority": "high",
          "body": "🎥 Video",
          "title": userName,
          "sound": "default",
        }
      }),
    );
    print(response);
    return response;
  }

  Future<http.Response> sendImageNotification(
    String? peerToken,
    String content,
  ) async {
    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: "key=$serverKey"
      },
      body: jsonEncode({
        "to": peerToken,
        "priority": "high",
        "data": {
          "type": "100",
          "user_id": userID,
          "title": content,
          "message": userName,
          "time": DateTime.now().millisecondsSinceEpoch,
          "sound": "default",
          "vibrate": "300",
        },
        "notification": {
          "vibrate": "300",
          "priority": "high",
          "body": "📷 Image",
          "title": userName,
          "sound": "default",
        }
      }),
    );
    print(response);
    return response;
  }

  Future<http.Response> sendNotification(
    String? peerToken,
    String content,
  ) async {
    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: "key=$serverKey"
      },
      body: jsonEncode({
        "to": peerToken,
        "priority": "high",
        "data": {
          "type": "100",
          "user_id": userID,
          "title": content,
          "message": userName,
          "time": DateTime.now().millisecondsSinceEpoch,
          "sound": "default",
          "vibrate": "300",
        },
        "notification": {
          "vibrate": "300",
          "priority": "high",
          "body": content,
          "title": userName,
          "sound": "default",
        }
      }),
    );
    print(response);
    return response;
  }

  imagePreview(String? url) {
    return showDialog(
      context: context,
      builder: (_) => Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                top: 100, left: 10, right: 10, bottom: 100),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                child: PhotoView(
                  imageProvider: NetworkImage(url!),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFilterCloseButton(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        color: Colors.black.withOpacity(0.0),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}
