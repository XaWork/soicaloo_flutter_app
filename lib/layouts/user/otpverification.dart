// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialoo/layouts/user/createProfile.dart';

import '../../global/global.dart';
import '../widgets/bezier_container.dart';

class OtpVerification extends StatelessWidget {
  String id;
  String name;
  String password;
  String email;
  OtpVerification(
      {Key? key,
      required this.id,
      required this.name,
      required this.password,
      required this.email})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController otpController = TextEditingController();
    void verifyaccount() async {
      try {
        final response = await client
            .post(Uri.parse("https://mph.missingpersonhelpline.org/api/verify_otp"), body: {
          "otp": otpController.text,
          "user_id": id,
        });
        print(response.body);
        if (response.statusCode == 200) {
          print("account verified");
          var data = json.decode(response.body.toString());
          print(data);
          Map<String, dynamic> dic = json.decode(response.body);
          if (dic['response_code'] == "1") {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CreateProfile(
                    id: id, name: name, password: password, email: email)));
          } else {
            socialootoast("Error", dic['message'], context);
          }
        } else {
          print("cannot verify account");
        }
      } catch (e) {
        print(e.toString());
      }
    }

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
                  RichText(
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
                  ),
                  const SizedBox(height: 50),
                  Text(
                    'Enter the OTP we sent',
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
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Color(0xFF1246A5), Color(0xFF1e3c72)])),
                    child: const Text(
                      'Next',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ).onTap(() {
                    verifyaccount();
                  })
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
