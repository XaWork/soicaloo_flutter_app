import 'dart:convert';

import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:socialoo/global/global.dart';
import 'package:socialoo/layouts/widgets/bezier_container.dart';
import 'package:socialoo/models/intrest_model.dart';
import 'package:socialoo/shared_preferences/preferencesKey.dart';

// ignore: must_be_immutable
class CreateProfile extends StatefulWidget {
  CreateProfile({this.name, this.password, this.email, this.id});
  String? id;
  String? email;
  String? name;
  String? password;

  @override
  _LoginState createState() => _LoginState(
        id: id,
        name: name,
        password: password,
        email: email,
      );
}

class _LoginState extends State<CreateProfile> {
  _LoginState({this.name, this.password, this.email, this.id});

  FocusNode ageNode = new FocusNode();
  String? id;
  bool buttonclick = false;
  String? cityValue;
  String? countryValue;
  String? dataheight;
  String? email;
  String? gender;

  var gender1 = ['Male', 'Female', 'Other'];

  String? height;
  IntrestModel? intrestModel;
  bool isLoading = false;
  String? name;
  String? orietantion;
  String? password;
  List<String> selectedCat = [];
  var splitData = [];
  String? stateValue;

  final TextEditingController _ageController = TextEditingController();

  @override
  void initState() {
    print('USER ID >>>>>>$id');
    _getintrest();

    super.initState();
  }

  _getintrest() async {
    setState(() {
      isLoading = true;
    });
    var uri = Uri.parse('${baseUrl()}/get_all_interests');
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
    intrestModel = IntrestModel.fromJson(userData);
    print(responseData);

    setState(() {
      isLoading = false;
    });
  }

  //EditInfoData >>>>Start

  Widget editInfoData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(height: 15),
        ageWidget(),
        Container(height: 15),
        genderWidget(),
        Container(height: 15),
        locationWidget(),
        Container(height: 30),
      ],
    );
  }

  Widget ageWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _ageController,
            focusNode: ageNode,
            maxLines: 1,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Theme.of(context).inputDecorationTheme.fillColor,
              filled: true,
              labelText: "Age",
              labelStyle: const TextStyle(fontSize: 15.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget genderWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Gender",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15.0),
          ),
          FormField<String>(
            builder: (FormFieldState<String> state) {
              return Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor:
                              Theme.of(context).inputDecorationTheme.fillColor,
                          filled: true,
                          labelText: "Gender",
                          labelStyle: const TextStyle(fontSize: 15.0),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: gender,
                            isDense: true,
                            hint: Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Text(
                                'Select Gender',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 14),
                              ),
                            ),
                            icon: Padding(
                              padding: const EdgeInsets.only(right: 0, top: 5),
                              child: Icon(
                                Icons.arrow_drop_down, // Add this
                                color: appColorBlack, // Add this
                              ),
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                gender = newValue;
                                state.didChange(newValue);
                              });
                            },
                            items: gender1.map((item) {
                              return new DropdownMenuItem(
                                child: new Text(
                                  item,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                value: item,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Container(
            height: 1,
            color: Colors.grey[300],
          )
        ],
      ),
    );
  }

  Widget locationWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Location",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15.0),
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            children: [
              CSCPicker(
                flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
                cityDropdownLabel: 'District',
                disabledDropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: appColorWhite,
                    border: Border.all(color: Colors.grey.shade300, width: 1)),
                onCountryChanged: (value) {
                  setState(() {
                    countryValue = value;
                  });
                },
                onStateChanged: (value) {
                  setState(() {
                    stateValue = value;
                  });
                },
                onCityChanged: (value) {
                  setState(() {
                    cityValue = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buttonWidget(title) {
    return splitData.contains(title)
        ? SelectedButton2(
            title: title,
            onPressed: () {
              setState(() {
                splitData.remove(title);
              });
            },
          )
        : UnSelectedButton2(
            title: title,
            onPressed: () {
              setState(() {
                splitData.add(title);
              });
            },
          );
  }

  updateData() {
    FirebaseMessaging.instance.getToken().then((token) async {
      try {
        setState(() {
          buttonclick = true;
        });

        final response =
            await client.post(Uri.parse('${baseUrl()}/register_new'), body: {
          'id': id,
          "email": email,
          "username": name,
          "age": _ageController.text,
          "gender": gender,
          "country": countryValue != null ? countryValue : '',
          "state": stateValue != null ? stateValue : '',
          "city": cityValue != null ? cityValue : '',
          "bio": '',
          'interest_id': '1',
          "device_token": token,
        });
        print(response.statusCode);

        if (response.statusCode == 200) {
          setState(() {
            buttonclick = false;
          });
          Map<String, dynamic> dic = json.decode(response.body);
          print(response.body);

          if (dic['response_code'] == "1") {
            setState(() {
              buttonclick = false;
            });

            String userResponseStr = json.encode(dic);
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.setString(
                SharedPreferencesKey.LOGGED_IN_USERRDATA, userResponseStr);

            setState(() {
              isLoading = false;
            });

            Navigator.of(context).pushReplacementNamed('/Pages', arguments: 0);
          } else {
            setState(() {
              buttonclick = false;
            });
            socialootoast("Error", dic['message'], context);
          }
        } else {
          setState(() {
            buttonclick = false;
          });
          socialootoast("Error", "Cannot communicate with server", context);
        }
      } catch (e) {
        if (mounted)
          setState(() {
            buttonclick = false;
          });
        socialootoast("Error", e.toString(), context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: const BezierContainer(),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    _title(),
                    const SizedBox(
                      height: 20,
                    ),
                    editInfoData(),
                    const SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                  ],
                ),
              ),
            ),
            Center(child: buttonclick == true ? loader(context) : Container())
          ],
        ));
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
      if (_ageController.text.isNotEmpty &&
          gender != null &&
          countryValue != null &&
          stateValue != null &&
          cityValue != null) {
        updateData();
      } else {
        socialootoast("Error", "All fields are mandatory", context);
      }
    });
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'Create Profile',
        style: GoogleFonts.portLligatSans(
          textStyle: Theme.of(context).textTheme.headline4,
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1e3c72),
        ),
      ),
    );
  }
}
