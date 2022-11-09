// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:socialoo/Helper/sizeConfig.dart';
import 'package:socialoo/global/global.dart';
import 'package:socialoo/layouts/story/store_page_view.dart';
import 'package:socialoo/models/getStoryModal.dart';

class Product {
  int? id;
  String? title;
  String? image;
  String? description;

  Product({this.id, this.title, this.image, this.description});
}

class Stories extends StatefulWidget {
  @override
  _StoriesState createState() => _StoriesState();
}

class _StoriesState extends State<Stories> with SingleTickerProviderStateMixin {
  Animation? gap;
  late Animation base;
  Animation? reverse;
  late AnimationController controller;

  late GetStoryModal modal;
  bool isLoading = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _getPost();

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    base = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    reverse =
        Tween<double>(begin: .0, end: -1.0).animate(base as Animation<double>);
    gap = Tween<double>(begin: 5, end: 1.0).animate(base as Animation<double>)
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  _getPost() async {
    setState(() {
      isLoading = true;
    });
    var uri = Uri.parse('${baseUrl()}/get_story_by_user');
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
    modal = GetStoryModal.fromJson(userData);
    print(responseData);
    if (mounted)
      setState(() {
        isLoading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return _userInfo();
  }

  Widget _userInfo() {
    return isLoading
        ? Container(
            width: SizeConfig.screenWidth,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    bottom: getProportionateScreenWidth(20),
                  ),
                  child: CircularProgressIndicator(),
                ),
              ],
            ))
        : Container(
            child: ListView.builder(
                padding: const EdgeInsets.only(
                  top: 0,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: modal.post!.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  String name = modal.post![index].username!;

                  return Container(
                    alignment: Alignment.topCenter,
                    child: InkWell(
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.topCenter,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Container(
                                  width: 70.0,
                                  height: 70.0,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: modal.post![index].profilePic!
                                              .isNotEmpty
                                          ? NetworkImage(
                                              modal.post![index].profilePic!)
                                          : Image.asset(
                                              'assets/images/defaultavatar.png',
                                            ) as ImageProvider<Object>,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 10.0,
                                top: 10.0,
                                child: new FractionalTranslation(
                                  translation: Offset(0.2, 1.2),
                                  child: new CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 15.0,
                                    child: new Container(
                                      width: 26.0,
                                      height: 26.0,
                                      decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                          fit: BoxFit.fill,
                                          image: (modal.post![index].profilePic!
                                                  .isNotEmpty
                                              ? new NetworkImage(modal
                                                  .post![index].profilePic!)
                                              : AssetImage(
                                                  'assets/images/defaultavatar.png',
                                                )) as ImageProvider<Object>,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Text(
                            name.capitalize(),
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ],
                      ),
                      onTap: () async {
                        List listImage = [];
                        for (var i = 0;
                            i < modal.post![index].storyImage!.length;
                            i++) {
                          listImage.add(modal.post![index].storyImage![i]);
                        }
                        print(json.encode(listImage));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  StoryPageView(images: listImage)),
                        );
                      },
                    ),
                  );
                }),
          );
  }

  Widget timeInfo(String orderId, int index, String time) {
    var startTime = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    var currentTime = DateTime.now();
    int diff = currentTime.difference(startTime).inDays;

    return Text("");
  }
}
