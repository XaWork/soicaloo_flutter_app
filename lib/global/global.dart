import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialoo/Helper/sizeConfig.dart';

Color appColor = Color(0XFF297EC4);
Color? iconColor = Colors.grey[800];
Color fontColorBlue = Colors.blue;
Color appColorWhite = Colors.white;

String appName = 'MPH';

Client client = Client();

List<String> likedPost = [];

List<String> addedBookmarks = [];

String baseUrl() {
  //return 'https://app.waahak.com/missing-person/api';
  //return 'http://143.110.190.118/api';
  return 'https://mph.missingpersonhelpline.org/api';
  // return 'http://192.168.56.1/socialoo/api';
}

dynamic safeQueries(BuildContext context) {
  return (MediaQuery.of(context).size.height >= 812.0 ||
      MediaQuery.of(context).size.height == 812.0 ||
      (MediaQuery.of(context).size.height >= 812.0 &&
          MediaQuery.of(context).size.height <= 896.0 &&
          Platform.isIOS));
}

String noImage =
    "https://www.nicepng.com/png/detail/136-1366211_group-of-10-guys-login-user-icon-png.png";

String serverKey =
    "AAAAjf434yI:APA91bEdL6yUh0O1SpuYMdG0sjJW2hxiu-TBLOuf-bPyzEUL5DkChfuX4HiUmkkr5WFv-BOdxG4_9xVTwpMXQYpHs8xMbgNQGW0zfLAqMjydXq42ZIxeVRxUDlU5j_eBmy_7EvaT5lXb";

var globleFollowers = [];
var globleFollowing = [];

SharedPreferences? preferences;
String? userID = '';
String? userfullname = '';

String? userGender = '';
String? userPhone = '';
String? userEmail = '';
String? userName = '';
String? userImage = '';
String? userCoverImage = '';
String userWeb = '';
String? userBio = '';
var intrestarray;

Color appColorBlack = Colors.black;
Color? fontColorGrey = Colors.grey[800];
Color? appColorGrey = Colors.grey[600];
Color buttonColorBlue = Colors.blue;

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

class CustomTextStyle1 extends StatelessWidget {
  final Color? color;
  final String? title;
  final FontWeight? weight;
  final double? fontsize;
  CustomTextStyle1({this.color, this.title, this.weight, this.fontsize});
  @override
  Widget build(BuildContext context) {
    // return RaisedButton(
    //   color: color,
    //   child: Text(
    //     title,
    //     style: TextStyle(
    //       fontSize: 20,
    //       fontWeight: FontWeight.w700,
    //     ),
    //   ),
    //   shape: RoundedRectangleBorder(
    //     side: BorderSide(color: appColorGreen, width: 1.8),
    //     borderRadius: BorderRadius.circular(30),
    //   ),
    //   onPressed: onPressed,
    // );

    return Text(title!,
        style: TextStyle(
          color: color,
          fontSize: fontsize,
          fontWeight: weight,
        ));
  }
}

void indicatorDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () {
          return null;
        } as Future<bool> Function(),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(appColor),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget loader(BuildContext context) {
  return Center(
      child: Material(
    type: MaterialType.transparency,
    child: Stack(
      children: <Widget>[
        Center(
            child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(appColor),
        ))
      ],
    ),
  ));
}

class Loader {
  void showIndicator(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Center(
            child: Material(
          type: MaterialType.transparency,
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.black.withOpacity(0.7),
              ),
              Center(
                  child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(appColor),
              ))
            ],
          ),
        ));
      },
    );
  }

  void hideIndicator(BuildContext context) {
    Navigator.pop(context);
  }
}

void errorDialog(BuildContext context, String message, {bool? button}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(0.0),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(height: 10.0),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 4),
            ),
            Container(height: 30.0),
            // SizedBox(
            //   height: 45,
            //   width: MediaQuery.of(context).size.width - 100,
            //   // ignore: deprecated_member_use
            //   child: OutlineButton(
            //     borderSide: BorderSide(color: appColor, width: 1.0),
            //     focusColor: Colors.white,
            //     highlightedBorderColor: appColor,
            //     onPressed: () {
            //       Navigator.pop(context);
            //       // Navigator.pop(context);
            //     },
            //     child: Text(
            //       "OK",
            //       style: TextStyle(color: Colors.black, fontSize: 18),
            //     ),
            //   ),
            // )
          ],
        ),
      );
    },
  );
}

// ignore: must_be_immutable
class CustomtextField extends StatefulWidget {
  final TextInputType? keyboardType;
  final Function? onTap;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Function? onEditingComplate;
  final Function? onSubmitted;
  final dynamic controller;
  final int? maxLines;
  final dynamic onChange;
  final String? errorText;
  final String? hintText;
  final String? labelText;
  bool obscureText = false;
  bool readOnly = false;
  bool autoFocus = false;
  final Widget? suffixIcon;

  final Widget? prefixIcon;
  CustomtextField({
    this.keyboardType,
    this.onTap,
    this.focusNode,
    this.textInputAction,
    this.onEditingComplate,
    this.onSubmitted,
    this.controller,
    this.maxLines,
    this.onChange,
    this.errorText,
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.readOnly = false,
    this.autoFocus = false,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  _CustomtextFieldState createState() => _CustomtextFieldState();
}

class _CustomtextFieldState extends State<CustomtextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: widget.focusNode,
      readOnly: widget.readOnly,
      textInputAction: widget.textInputAction,
      onTap: widget.onTap as void Function()?,
      autofocus: widget.autoFocus,
      maxLines: widget.maxLines,
      onEditingComplete: widget.onEditingComplate as void Function()?,
      onSubmitted: widget.onSubmitted as void Function(String)?,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      onChanged: widget.onChange,
      style: TextStyle(color: Colors.black, fontSize: 14),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        labelText: widget.labelText,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
        errorStyle: TextStyle(color: Colors.white),
        errorText: widget.errorText,
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: widget.hintText,
        labelStyle: TextStyle(color: Colors.black),
        hintStyle: TextStyle(color: fontColorGrey, fontSize: 12),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: appColorGrey!, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: appColorGrey!, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class LoaderDialog {
  void showIndicator(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Center(
            child: Material(
          type: MaterialType.transparency,
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.black.withOpacity(0.7),
              ),
              Center(
                child: CircularProgressIndicator(),
              )
            ],
          ),
        ));
      },
    );
  }

  void hideIndicator(BuildContext context) {
    Navigator.pop(context);
  }
}

double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  // 812 is the layout height that designer use
  return (inputHeight / 812.0) * screenHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth!;
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * screenWidth;
}

class CustomButtom extends StatelessWidget {
  final Color? color;
  final String? title;
  final Function? onPressed;
  CustomButtom({
    this.color,
    this.title,
    this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          // side: BorderSide(color: appColorGreen, width: 0),
          borderRadius: BorderRadius.circular(5),
        ),
        backgroundColor: color,
      ),
      child: Text(
        title!,
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
      ),
      onPressed: onPressed as void Function()?,
    );
  }
}

socialootoast(title, msg, BuildContext context) {
  Flushbar(
    title: title,
    message: msg,
    titleColor: appColorBlack,
    messageColor: appColorBlack,
    icon: Icon(
      title == "Error" ? Icons.error : Icons.check,
      color: appColorBlack,
    ),
    backgroundColor: Colors.grey[300]!,
    duration: Duration(seconds: 2),
  ).show(context);
}

simpleAlertBox(
    {required BuildContext context, Widget? title, Widget? content}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: title,
        content: content,
        actions: <Widget>[
          // ignore: deprecated_member_use
          ElevatedButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );
    },
  );
}

closeKeyboard() {
  return SystemChannels.textInput.invokeMethod('TextInput.hide');
}

// ignore: must_be_immutable
class CustomtextField3 extends StatefulWidget {
  final TextInputType? keyboardType;
  final Function? onTap;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Function? onEditingComplate;
  final Function? onSubmitted;
  final dynamic controller;
  final int? maxLines;
  final dynamic onChange;
  final String? errorText;
  final String? hintText;
  final String? labelText;
  bool obscureText = false;
  bool readOnly = false;
  bool autoFocus = false;
  final Widget? suffixIcon;
  final textAlign;

  final Widget? prefixIcon;
  CustomtextField3(
      {this.keyboardType,
      this.onTap,
      this.focusNode,
      this.textInputAction,
      this.onEditingComplate,
      this.onSubmitted,
      this.controller,
      this.maxLines,
      this.onChange,
      this.errorText,
      this.hintText,
      this.labelText,
      this.obscureText = false,
      this.readOnly = false,
      this.autoFocus = false,
      this.prefixIcon,
      this.suffixIcon,
      this.textAlign});

  @override
  _CustomtextFieldState3 createState() => _CustomtextFieldState3();
}

class _CustomtextFieldState3 extends State<CustomtextField3> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlign: widget.textAlign,
      focusNode: widget.focusNode,
      readOnly: widget.readOnly,
      textInputAction: widget.textInputAction,
      onTap: widget.onTap as void Function()?,
      autofocus: widget.autoFocus,
      maxLines: widget.maxLines,
      onEditingComplete: widget.onEditingComplate as void Function()?,
      onSubmitted: widget.onSubmitted as void Function(String)?,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      onChanged: widget.onChange,
      style: TextStyle(color: Colors.grey[600], fontSize: 14),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        filled: false,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        labelText: widget.labelText,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        errorStyle: TextStyle(color: Colors.white),
        errorText: widget.errorText,
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        hintText: widget.hintText,
        labelStyle: TextStyle(color: Colors.white),
        hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
    );
  }
}

class SelectedButton2 extends StatelessWidget {
  final String? title;
  final Function? onPressed;
  SelectedButton2({
    this.title,
    this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed as void Function()?,
      child: Container(
          height: 30,
          decoration: BoxDecoration(
              color: appColorBlack,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Center(
              child: Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
            ),
            child: Text(title!,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, color: Colors.white)),
          ))),
    );
  }
}

class UnSelectedButton2 extends StatelessWidget {
  final String? title;
  final Function? onPressed;
  UnSelectedButton2({
    this.title,
    this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed as void Function()?,
      child: Container(
          height: 30,
          decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Center(
              child: Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
            ),
            child: Text(title!,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, color: appColorBlack)),
          ))),
    );
  }
}
