import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialoo/layouts/user/login.dart';
import '../../global/global.dart';
import '../widgets/bezier_container.dart';
import 'createProfile.dart';

class PasswordChange extends StatefulWidget {
  const PasswordChange({Key? key}) : super(key: key);

  @override
  State<PasswordChange> createState() => _PasswordChangeState();
}

class _PasswordChangeState extends State<PasswordChange> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController newpasswordController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  bool _obscureText = false;
  bool isLoading = false;
  String? userId;

  @override
  void dispose() {
    emailController.dispose();
    newpasswordController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SizedBox(
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
                  const SizedBox(height: 50),
                  Text(
                    'Enter the OTP we sent & Create a New Password',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Enter OTP",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                            controller: otpController,
                            obscureText: false,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                fillColor: Theme.of(context)
                                    .inputDecorationTheme
                                    .fillColor,
                                filled: true))
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Email",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                            controller: emailController,
                            obscureText: false,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                fillColor: Theme.of(context)
                                    .inputDecorationTheme
                                    .fillColor,
                                filled: true))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Password',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                            textInputAction: TextInputAction.next,
                            controller: newpasswordController,
                            obscureText: !_obscureText,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: appColorGrey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                                border: InputBorder.none,
                                fillColor: Theme.of(context)
                                    .inputDecorationTheme
                                    .fillColor,
                                filled: true))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _submitButton(),
                ],
              ),
            ),
          ),
          isLoading == true ? Center(child: loader(context)) : Container(),
        ],
      ),
    ));
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'Missing Person Helpline',
        style: GoogleFonts.portLligatSans(
          textStyle: Theme.of(context).textTheme.headline4,
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1e3c72),
        ),
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
          colors: [Color(0xFF1246A5), Color(0xFF1e3c72)],
        ),
      ),
      child: const Text(
        'Next',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    ).onTap(() {
      resetpassword();
    });
  }

  void resetpassword() async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await client
          .post(Uri.parse("https://mph.missingpersonhelpline.org/api/forgot_pass"), body: {
        "email": emailController.text,
        "otp": otpController.text,
        "password": newpasswordController.text
      });
      print(response.body);
      if (response.statusCode == 200) {
        print("password changed successfully");
        var data = json.decode(response.body.toString());
        Map<String, dynamic> dic = json.decode(response.body);
        print(data);
        if (dic['status'] == 1) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Login()),
            (Route<dynamic> route) => false,
          );
          setState(() {
            isLoading = false;
          });
          socialootoast("success", dic['msg'], context);
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("Alert"),
                    content: Text("Password Changed Successfully"),
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
        } else {
          socialootoast("error", dic['msg'], context);
          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
        socialootoast("failed", "cannot change password", context);
        print("password change failed");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e.toString());
    }
  }
}
