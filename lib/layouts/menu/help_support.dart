import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:nb_utils/nb_utils.dart';
import 'package:socialoo/layouts/menu/about_us.dart';
import 'package:socialoo/layouts/webview/webview.dart';

class HelpSupportPage extends StatefulWidget {
  final String? currentUserId;

  const HelpSupportPage({Key? key, this.currentUserId}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<HelpSupportPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void _handleURLButtonPress(BuildContext context, String url) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url)));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedTheme(
      duration: const Duration(milliseconds: 300),
      data: Theme.of(context),
      child: Scaffold(
        key: _scaffoldKey,
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
          elevation: 0.5,
          title: Text(
            "Help & Support",
            style: Theme.of(context).textTheme.headline5!.copyWith(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: ListView(children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1 - 40,
                    height: 50.0,
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const <Widget>[
                        Text('About Us',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ).onTap(() {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => AboutUsPage(
                          currentUserId: widget.currentUserId,
                        ),
                      ));
                }),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1 - 40,
                    height: 50.0,
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const <Widget>[
                        Text('Privacy Policy',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ).onTap(() {
                  _handleURLButtonPress(
                      context, "https://docsopedia.com/privacy-policy.html");
                }),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1 - 40,
                    height: 50.0,
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const <Widget>[
                        Text('Term of Use',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ).onTap(() {
                  _handleURLButtonPress(
                      context, "https://docsopedia.com/term-policy.html");
                }),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
