// ignore_for_file: implementation_imports

import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
// import 'package:nb_utils/src/widget_extensions.dart';
// import 'package:socialoo/Helper/sizeConfig.dart';
import 'package:socialoo/global/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:socialoo/layouts/user/forgetPasswordChange.dart';
import 'package:socialoo/layouts/user/forgetpass2.dart';
import 'package:socialoo/layouts/widgets/bezier_container.dart';

class ForgetPass extends StatefulWidget {
  @override
  _ForgetPassState createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  // ignore: unused_field
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final emailNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: LayoutBuilder(
        builder: (context, constraint) {
          return SizedBox(
            height: height,
            child: Stack(
              children: <Widget>[
                Positioned(
                    top: -height * .15,
                    right: -MediaQuery.of(context).size.width * .4,
                    child: const BezierContainer()),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: height * .25),
                        _title(),
                        const SizedBox(height: 20),
                        Text(
                          'Enter Your registerd email below to receive \n password reset instruction',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontFamily: 'Poppins-Medium',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 50),
                        _emailPasswordWidget(),
                        const SizedBox(height: 20),
                        _submitButton(),
                      ],
                    ),
                  ),
                ),
                Positioned(top: 40, left: 0, child: _backButton()),
                isLoading == true
                    ? Center(child: loader(context))
                    : Container(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'Forgot your password?',
        style: GoogleFonts.portLligatSans(
          textStyle: Theme.of(context).textTheme.headline4,
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1e3c72),
        ),
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Email id", emailController),
      ],
    );
  }

  Widget _entryField(String title, TextEditingController controller,
      {bool isPassword = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
              controller: controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFF1246A5), Color(0xFF1e3c72)])),
      child: const Text(
        'Next',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    ).onTap(() {
      if (emailController.text.trim() != "") {
        _signInWithEmailAndPassword();
      } else {
        socialootoast(
            "Error",
            "Please, Enter your Email Address for reset your password",
            context);
      }
    });
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left,
                  color: Theme.of(context).iconTheme.color),
            ),
            const Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      setState(() {
        emailNode.unfocus();
        isLoading = true;
      });

      _forgotpassAPICall();
    } catch (e) {
      setState(() {
        isLoading = false;
        socialootoast("Error", e.toString(), context);
      });
    }
  }

  _forgotpassAPICall() async {
    setState(() {
      isLoading = true;
    });
    var uri = Uri.parse('${baseUrl()}/get_forgot_password_otp');
    //var uri = Uri.parse(
    //'https://app.waahak.com/missing-person/api/get_forgot_password_otp');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['email'] = emailController.text;

    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    if (userData['status'] == 1) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => PasswordChange(),
        ),
        (Route<dynamic> route) => false,
      );
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Success"),
                content: Text(
                    "OTP to reset your password has been sent successfully to your email. Please verify it."),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      color: Colors.blue,
                      padding: const EdgeInsets.all(14),
                      child: const Text(
                        "okay",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ));
      socialootoast(
          "Success",
          "OTP to reset your password has been sent successfully to your email. Please verify it.",
          context);
    } else {
      socialootoast("Error", userData['msg'], context);
    }

    setState(() {
      isLoading = false;
    });
  }
}
