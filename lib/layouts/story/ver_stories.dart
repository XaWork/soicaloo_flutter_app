// ignore_for_file: unnecessary_null_comparison, unused_local_variable

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:socialoo/global/global.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:socialoo/layouts/story/store_page_view.dart';
import 'package:socialoo/models/getStoryModal.dart';

class Product {
  int? id;
  String? title;
  String? image;
  String? description;

  Product({this.id, this.title, this.image, this.description});
}

class VerStories extends StatefulWidget {
  @override
  _VerStoriesState createState() => _VerStoriesState();
}

class _VerStoriesState extends State<VerStories>
    with SingleTickerProviderStateMixin {
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
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 200 / 350,
                    crossAxisSpacing: 1),
                padding: const EdgeInsets.only(
                  top: 0,
                ),
                itemCount: modal.post!.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  String name = modal.post![index].username!;

                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
                    child: InkWell(
                      child: Container(
                        width: 100,
                        height: 200,
                        child: Stack(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: CachedNetworkImage(
                                imageUrl: modal.post![index].profilePic!,
                                width: 100,
                                height: 200,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                            Container(
                              width: 100,
                              height: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0, bottom: 8.0),
                                    child: Text(
                                      name.capitalize(),
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                                top: 8.0,
                                left: 8.0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: modal.post![index].storyImage!
                                                  .length ==
                                              null ||
                                          modal.post![index].storyImage!
                                                  .length ==
                                              0
                                      ? Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF003a54),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Image.asset(
                                            'assets/images/defaultavatar.png',
                                            width: 40,
                                          ),
                                        )
                                      : CachedNetworkImage(
                                          imageUrl:
                                              modal.post![index].profilePic!,
                                          height: 40.0,
                                          width: 40.0,
                                          fit: BoxFit.cover,
                                        ),
                                )),
                          ],
                        ),
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
