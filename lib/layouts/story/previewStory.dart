import 'dart:convert';
import 'dart:io';
import 'package:socialoo/global/global.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:socialoo/layouts/navigationbar/navigation_bar.dart';
import 'package:socialoo/models/addPostModal.dart';

// ignore: must_be_immutable
class PreviewStory extends StatefulWidget {
  File? imageFile;
  PreviewStory({this.imageFile});
  @override
  ChatBgState createState() {
    return new ChatBgState();
  }
}

class ChatBgState extends State<PreviewStory> {
  String userId = '';
  bool isLoading = false;

  late AddPostModal modal;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        title: Text(
          "Preview",
          style: Theme.of(context).textTheme.headline5!.copyWith(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
            )),
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                Expanded(
                  child: widget.imageFile != null
                      ? SizedBox(
                          child: Image.file(
                          widget.imageFile!,
                          fit: BoxFit.contain,
                        ))
                      : Center(
                          child: Text(
                            "Select photo",
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: "Poppins-Medium",
                            ),
                          ),
                        ),
                ),
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFF1246A5), Color(0xFF1e3c72)],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          height: 45,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                Colors.red.shade500,
                                Colors.red.shade900
                              ])),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text("Cancel",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          ),
                        ),
                      ),
                      Container(
                          height: double.infinity,
                          width: 0.8,
                          color: Colors.black),
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          addPost(context, widget.imageFile);
                        },
                        child: Text("Add",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ))
                    ],
                  ),
                ),
              ],
            ),
            Center(child: isLoading == true ? loader(context) : Container())
          ],
        ),
      ),
    );
  }

  addPost(BuildContext context, File? image) async {
    if (widget.imageFile != null) {
      var files = [];
      files.add(image);
      setState(() {
        isLoading = true;
      });

      var uri = Uri.parse('${baseUrl()}/add_story');
      var request = new http.MultipartRequest("POST", uri);
      Map<String, String> headers = {
        "Accept": "application/json",
      };
      request.headers.addAll(headers);
      request.fields['user_id'] = userID!;

      request.files
          .add(await http.MultipartFile.fromPath('url', widget.imageFile!.path));
      request.fields['type'] = 'image';

      var response = await request.send();
      print(response.statusCode);
      String responseData =
          await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responseData);
      modal = AddPostModal.fromJson(userData);
      print(responseData);

      if (modal.responseCode == "1") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NavBar()),
        );
      }

      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(
          msg: "Select Image",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
    }
  }
}
