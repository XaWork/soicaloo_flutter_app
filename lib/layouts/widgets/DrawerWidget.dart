// ignore_for_file: deprecated_member_use, duplicate_ignore

import 'package:socialoo/global/global.dart';
import 'package:socialoo/layouts/user/login.dart';
import 'package:socialoo/layouts/user/saved_bookmarks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialoo/layouts/webview/webview.dart';
import 'package:socialoo/shared_preferences/preferencesKey.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  void _handleURLButtonPress(BuildContext context, String url) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url)));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          GestureDetector(
              onTap: () {},
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: appColor,
                ),
                accountName: Text(
                  userName!,
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .merge(TextStyle(color: Colors.white)),
                ),
                accountEmail: Text(
                  userEmail!,
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .merge(TextStyle(color: Colors.white)),
                ),
                currentAccountPicture: userImage != '' && userImage != null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(userImage!),
                      )
                    : CircleAvatar(
                        // backgroundColor: Colors.white,
                        radius: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.asset(
                            'assets/images/user.png',
                            color: Colors.white,
                          ),
                        )),
              )),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Pages', arguments: 0);
            },
            leading: Icon(
              CupertinoIcons.house_fill,
              // ignore: deprecated_member_use
              color: Theme.of(context).accentColor.withOpacity(1),
            ),
            title: Text(
              'Home',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Pages', arguments: 4);
            },
            leading: Icon(
              CupertinoIcons.person_crop_circle_fill,
              // ignore: deprecated_member_use
              color: Theme.of(context).accentColor.withOpacity(1),
              size: 27,
            ),
            title: Text(
              'Profile',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SavedBookmarks()),
              );
            },
            leading: Icon(
              CupertinoIcons.bookmark,
              // ignore: deprecated_member_use
              color: Theme.of(context).accentColor.withOpacity(1),
              size: 27,
            ),
            title: Text(
              'Saved',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              _launch('https://primocys.com/');
            },
            leading: Icon(
              Icons.assignment_rounded,
              // ignore: deprecated_member_use
              color: Theme.of(context).accentColor.withOpacity(1),
            ),
            title: Text(
              'Help',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              // Navigator.of(context).pushNamed('/Pages', arguments: 3);
            },
            trailing: Icon(
              Icons.remove,
              // ignore: deprecated_member_use
              color: Theme.of(context).accentColor.withOpacity(1),
            ),
            title: Text(
              'Application Preferences',
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          ListTile(
            onTap: () {
              _handleURLButtonPress(context,
                  "https://app.waahak.com/missing-person/terms-and-conditions");
              // Navigator.of(context).pushNamed('/Pages', arguments: 3);
            },
            leading: Icon(
              Icons.info,
              // ignore: deprecated_member_use
              color: Theme.of(context).accentColor.withOpacity(1),
            ),
            title: Text(
              'Terms and condition',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              _handleURLButtonPress(context,
                  "https://app.waahak.com/missing-person/privacy-policy");
              // Navigator.of(context).pushNamed('/Pages', arguments: 3);
            },
            leading: Icon(
              Icons.privacy_tip,
              // ignore: deprecated_member_use
              color: Theme.of(context).accentColor.withOpacity(1),
            ),
            title: Text(
              'Privacy policy ',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              _launch('https://primocys.com/portfolio/');
              // Navigator.of(context).pushNamed('/Pages', arguments: 3);
            },
            leading: Icon(
              Icons.help,
              // ignore: deprecated_member_use
              color: Theme.of(context).accentColor.withOpacity(1),
            ),
            title: Text(
              'About',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              preferences
                  .remove(SharedPreferencesKey.LOGGED_IN_USERRDATA)
                  .then((_) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                  (Route<dynamic> route) => false,
                );
              });
            },
            leading: Icon(
              Icons.exit_to_app,
              // ignore: deprecated_member_use
              color: Theme.of(context).accentColor.withOpacity(1),
            ),
            title: Text(
              'Logout',
              // ignore: deprecated_member_use
            ),
          ),
        ],
      ),
    );
  }

  _launch(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
