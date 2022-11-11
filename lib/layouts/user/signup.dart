// ignore_for_file: implementation_imports

import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
// import 'package:nb_utils/src/widget_extensions.dart';
// import 'package:socialoo/Helper/sizeConfig.dart';
import 'package:socialoo/global/global.dart';
import 'package:socialoo/layouts/user/createProfile.dart';
import 'package:socialoo/layouts/webview/webview.dart';
import 'package:socialoo/layouts/widgets/bezier_container.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  File? imageFile;
  bool isLoading = false;
  // ignore: unused_field
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _obscureText = false;
  bool? checkedValue = false;

  @override
  void initState() {
    super.initState();
  }

  String? userId;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cpassController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

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
                          height: 40,
                        ),
                        _emailPasswordWidget(),
                        const SizedBox(
                          height: 10,
                        ),
                        _termsCondition(context),
                        const SizedBox(
                          height: 10,
                        ),
                        _submitButton(),
                        SizedBox(height: height * .14),
                        _loginAccount(),
                      ],
                    ),
                  ),
                ),
                Positioned(top: 40, left: 0, child: _backButton()),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _loginAccount() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Login',
              style: TextStyle(
                  color: Color(0xFF1e3c72),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
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

  validateMobile(String value) {
    if (value.isEmpty)
      return 'Mobile Number is Required';
    else if (value.length < 10)
      return 'Mobile Number required at least 10 numbers';
    else if (value.length > 10)
      return 'Mobile Number required at most 10 numbers';
    else
      return null;
  }

  List<TextInputFormatter> digitsInputFormatter({int? size}) {
    return [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(size ?? 10),
    ];
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Username", nameController, TextInputAction.next),
        _entryField("Email id", emailController, TextInputAction.next),
        SignUpTextField(
          validator: validateMobile,
          controller: mobileController,
          onChanged: (input) {},
          maxLines: 1,
          inputFormatterData: digitsInputFormatter(),
          keyBoard: TextInputType.number,
          labelText: 'Mobile Number',
        ),
        // _entryField("Mobile Number", mobileController, TextInputAction.next),
        _passwordTextfield(context),
      ],
    );
  }

  Widget _entryField(String title, TextEditingController controller,
      TextInputAction textInputAction,
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
              textInputAction: textInputAction,
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
          colors: [Color(0xFF1246A5), Color(0xFF1e3c72)],
        ),
      ),
      child: const Text(
        'Register Now',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    ).onTap(() {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern as String);
      if (passwordController.text != '' &&
          nameController.text != '' &&
          regex.hasMatch(emailController.text.trim()) &&
          emailController.text.trim() != '' &&
          mobileController.text.trim().length == 10 &&
          passwordController.text.length > 5 &&
          checkedValue != false) {
        _apiCall();
      } else {
        if (nameController.text.isEmpty)
          simpleAlertBox(
              content: Text("Please enter username"), context: context);
        else if (passwordController.text.isEmpty) {
          simpleAlertBox(
              content: Text(
                  "Fields is empty or password length should be between 6-8 characters."),
              context: context);
        } else if (emailController.text.isEmpty) {
          simpleAlertBox(content: Text("please enter email"), context: context);
        } else if (checkedValue == false) {
          simpleAlertBox(
              content: Text("Accept term & condition to continue"),
              context: context);
        } else if (mobileController.text.trim().length != 10) {
          simpleAlertBox(
              content: Text("Please enter valid mobile number"),
              context: context);
        } else {
          simpleAlertBox(
              content: Text("please enter valid email"), context: context);
        }
      }
    });
  }

  Widget _passwordTextfield(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Password',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
              textInputAction: TextInputAction.next,
              controller: passwordController,
              obscureText: !_obscureText,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: appColorGrey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  border: InputBorder.none,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  filled: true))
        ],
      ),
    );
  }

  _termsCondition(BuildContext context) {
    void _handleURLButtonPress(BuildContext context, String url) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => WebViewContainer(url)));
    }

    return CheckboxListTile(
      title: Wrap(
        alignment: WrapAlignment.start,
        children: <Widget>[
          Text("By using our app you agree to our ",
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.normal,
                // color: appColorBlack,
              )),
          InkWell(
            onTap: () {
              _handleURLButtonPress(
                  context, "https://app.waahak.com/missing-person/terms-and-conditions");
            },
            child: Text("Terms and Conditions ",
                style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold)),
          ),
          Text("and ",
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.normal,
                // color: appColorBlack,
              )),
          InkWell(
            onTap: () {
              _handleURLButtonPress(
                  context, "https://app.waahak.com/missing-person/privacy-policy");
            },
            child: Text("Privacy Policy",
                style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),

      value: checkedValue,
      onChanged: (newValue) {
        setState(() {
          checkedValue = newValue;
        });
      },
      controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
    );
  }

  Future<void> _apiCall() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await client
          .post(Uri.parse('${baseUrl()}/username_email_check'), body: {
        "username": nameController.text,
        "email": emailController.text.toLowerCase().trim().toString(),
        "mobile_number": mobileController.text.trim().toString(),
        "password": passwordController.text
      });
      print(response.body);

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        Map<String, dynamic> dic = json.decode(response.body);

        if (dic['response_code'] == "1") {
          setState(() {
            isLoading = false;
          });

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CreateProfile(
                  id: dic['user']['id'],
                  name: nameController.text,
                  password: passwordController.text,
                  email: emailController.text)));
        } else {
          setState(() {
            isLoading = false;
          });
          socialootoast("Error", dic['message'], context);
        }
      } else {
        setState(() {
          isLoading = false;
        });
        socialootoast("Error", "Cannot communicate with server", context);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      socialootoast("Error", e.toString(), context);
    }
  }
}

class SignUpTextField extends StatefulWidget {
  final List<TextInputFormatter>? inputFormatterData;
  final TextEditingController? controller;
  final AutovalidateMode? autoValidateMode;
  final String? hint;
  final bool? readOnly;
  final bool nullMaxLine;
  final TextInputType? keyBoard;
  final FocusNode? focusNode;
  final TextAlign? textAlign;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final double? horizontal;
  final double? vertical;
  final int? lengthLimiting;
  final Function? onChanged;
  final VoidCallback? onTap;
  final Function? validator;
  final String? labelText;
  final String? counterText;

  // final String? initValue;
  final bool? obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? initialVal;
  final Color? primaryColor;

  // final String? suffixText;

  SignUpTextField({
    this.inputFormatterData,
    this.controller,
    this.autoValidateMode,
    this.hint,
    this.readOnly,
    this.nullMaxLine = false,
    this.keyBoard,
    this.textAlign,
    this.focusNode,
    this.maxLength,
    this.minLines,
    this.maxLines,
    this.horizontal,
    this.onTap,
    this.vertical,
    this.lengthLimiting,
    this.onChanged,
    this.validator,
    this.labelText,
    this.counterText,
    // this.initValue,
    this.obscureText,
    this.suffixIcon,
    this.prefixIcon,
    this.initialVal,
    this.primaryColor,
  });

  @override
  _SignUpTextFieldState createState() => _SignUpTextFieldState();
}

class _SignUpTextFieldState extends State<SignUpTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          widget.labelText != null
              ? Text(widget.labelText!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15))
              : SizedBox(),
          Container(
            child: TextFormField(
              autovalidateMode: widget.autoValidateMode,
              readOnly: widget.readOnly ?? false,
              textAlign: widget.textAlign ?? TextAlign.start,

              expands: false,
              focusNode: widget.focusNode,
              validator: (value) =>
                  widget.validator != null ? widget.validator!(value) : null,
              inputFormatters: widget.inputFormatterData,
              scrollPadding: EdgeInsets.zero,
              style: TextStyle(
                  fontSize: 15.0, color: widget.primaryColor ?? Colors.black87),
              controller: widget.controller,
              // ma: widget.maxLines,
              keyboardType: widget.keyBoard != null
                  ? widget.keyBoard
                  : TextInputType.text,
              maxLines: widget.nullMaxLine ? null : widget.maxLines,
              minLines: widget.minLines,
              maxLength: widget.maxLength,
              initialValue: widget.initialVal,
              obscureText: widget.obscureText ?? false,
              onChanged: (val) =>
                  widget.onChanged != null ? widget.onChanged!(val) : null,
              onTap: widget.onTap,
              decoration: InputDecoration(
                focusColor: Colors.black,
                hoverColor: Colors.black,
                suffixIcon: widget.suffixIcon,
                counterText: widget.counterText,
                prefixIcon: widget.prefixIcon,
                // suffixText: widget.suffixText,

                hintStyle: TextStyle(color: widget.primaryColor ?? null),
                suffixIconConstraints:
                    BoxConstraints(minWidth: 0, minHeight: 0),
                prefixIconConstraints:
                    BoxConstraints(minWidth: 0, minHeight: 0),
                // prefixIcon: widget.initValue != null
                //     ? Text(
                //         widget.initValue.toString(),
                //         style: TextStyle(fontSize: 17.0, color: Colors.black87),
                //       )
                //     : null,
                contentPadding: EdgeInsets.symmetric(
                    vertical: widget.vertical ?? 10.0,
                    horizontal: widget.horizontal ?? 10),
                isDense: true,
                hintText: widget.hint,
                border: InputBorder.none,
                filled: true,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                /* focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: widget.primaryColor ?? redColor, width: 1.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: widget.primaryColor ?? Colors.grey, width: 1.0),
                  ),
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: widget.primaryColor ?? Colors.grey, width: 1.0))*/
              ),
            ),
          ),
        ],
      ),
    );
  }
}
