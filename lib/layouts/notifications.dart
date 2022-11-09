import 'dart:convert';

import 'package:socialoo/ads/anchored_adaptive_ads.dart';
import 'package:socialoo/global/global.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:socialoo/models/notitications_model.dart';

class Notifications extends StatefulWidget {
  final GlobalKey<ScaffoldState>? parentScaffoldKey;
  Notifications({Key? key, this.parentScaffoldKey}) : super(key: key);
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  Future<List?>? notificationData;

  Future<List?> getAllnotification() async {
    Uri url = Uri.parse("${baseUrl()}/user_notification_listing");
    var response = await http.post(url, body: {'user_id': userID});

    if (response.statusCode == 200) {
      var output = response.body;
      var json = jsonDecode(output);
      //print(json);
      //print(json['services'][0]["id"]);
      return json['data'];
    }
    return null;
  }

  @override
  void initState() {
    setState(() {
      notificationData = getAllnotification();
    });

    super.initState();
  }

  NotificationsModel? notificationsModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        elevation: 1,
        title: Text(
          "Notifications",
          style: Theme.of(context).textTheme.headline5!.copyWith(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),

        centerTitle: true,
      ),
      body: FutureBuilder(
          future: notificationData,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length <= 0) {
                return Center(
                  child: Text("Don't have any Notification"),
                );
              } else {
                return Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.separated(
                        padding: const EdgeInsets.only(bottom: 50.0),
                        separatorBuilder: (BuildContext context, int index) {
                          return Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              height: 0.5,
                              width: MediaQuery.of(context).size.width / 1.3,
                              child: Divider(),
                            ),
                          );
                        },
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return notiTile(snapshot.data[index]);
                        },
                      ),
                    ),
                    AnchoredAd(),
                  ],
                );
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Widget notiTile(data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            data['profile_pic'],
          ),
          radius: 25,
        ),
        contentPadding: EdgeInsets.all(0),
        title: Text(
          data['username'],
        ),
        subtitle: Text(
          data['message'],
        ),
        trailing: Text(
          data['date'],
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 11,
          ),
        ),
        onTap: () {},
      ),
    );
  }
}
