import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:socialoo/Helper/sizeConfig.dart';
import 'package:socialoo/global/global.dart';
import 'package:socialoo/models/changpassModal.dart';

class ChnagePassScreen extends StatefulWidget {
  @override
  _ChnagePassState createState() => _ChnagePassState();
}

class _ChnagePassState extends State<ChnagePassScreen> {
  final TextEditingController _oldpassController = TextEditingController();
  final TextEditingController _newpassController = TextEditingController();
  final TextEditingController _cpassController = TextEditingController();

  bool isLoading = false;
  late ChangePassModal modal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
        shape: Border(
          bottom: BorderSide(
            color: Theme.of(context).shadowColor,
            width: 1.0,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: Icon(
              Icons.arrow_back_ios,
            )),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  "Change Password",
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white),
                ),
              ],
            ),
          ],
        ),
        actions: [],
        elevation: 0.0,
      ),
      // appBar: AppBar(
      //   title: Text(
      //     "Change Password",
      //     style: TextStyle(
      //         fontSize: 16,
      //         color: appColorBlack,
      //         fontWeight: FontWeight.bold),
      //   ),
      //   centerTitle: true,
      //   automaticallyImplyLeading: false,
      //   leading: IconButton(
      //       onPressed: () {
      //         Navigator.pop(context);
      //       },
      //       icon: Icon(Icons.arrow_back_ios)),
      // ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          _loginForm(context),
          isLoading
              ? Center(
                  child: loader(context),
                )
              : Container()
        ],
      ),
    );
  }

  Widget _loginForm(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      shrinkWrap: true,
      children: [
        _emailTextfield(context),
        Container(height: SizeConfig.blockSizeVertical * 2),
        _newTextfield(context),
        Container(height: SizeConfig.blockSizeVertical * 2),
        _cpassTextfield(context),
        Container(height: 40),
        _loginButton(context),
      ],
    );
  }

  Widget _emailTextfield(BuildContext context) {
    // return TextField(
    //   controller: _oldpassController,
    //   keyboardType: TextInputType.emailAddress,
    //   decoration: InputDecoration(hintText: 'Enter  old password'),
    // );

    return ChangePassTxtField(
      validator: onlyRequiredValidate,
      controller: _oldpassController,
      onChanged: (input) {},
      labelText: 'Old password',
      hint: 'Enter old password',
    );
  }

  //
  Widget _newTextfield(BuildContext context) {
    //   return TextField(
    //     controller: _newpassController,
    //     keyboardType: TextInputType.emailAddress,
    //     decoration: InputDecoration(hintText: 'Enter new password'),
    //   );
    return ChangePassTxtField(
      validator: onlyRequiredValidate,
      controller: _newpassController,
      onChanged: (input) {},
      labelText: 'New password',
      hint: 'Enter new password',
    );
  }

  //
  Widget _cpassTextfield(BuildContext context) {
    //   return TextField(
    //     controller: _cpassController,
    //     keyboardType: TextInputType.emailAddress,
    //     decoration: InputDecoration(hintText: 'Enter Confirm password'),
    //   );
    return ChangePassTxtField(
      validator: onlyRequiredValidate,
      controller: _cpassController,
      onChanged: (input) {},
      labelText: 'Confirm password',
      hint: 'Enter Confirm password',
    );
  }

  onlyRequiredValidate(value) {
    if (value.isEmpty)
      return 'Field is required';
    else
      return null;
  }

  Widget _loginButton(BuildContext context) {
    return InkWell(
      onTap: () {
        _changePassAPICall();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
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
          'Change Password',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  _changePassAPICall() async {
    setState(() {
      isLoading = true;
    });
    var uri = Uri.parse('${baseUrl()}/change_password');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['user_id'] = userID!;
    request.fields['password'] = _oldpassController.text;
    request.fields['npassword'] = _newpassController.text;
    request.fields['cpassword'] = _cpassController.text;
    print(request.fields);
    var response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      String responseData =
          await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responseData);
      modal = ChangePassModal.fromJson(userData);
      if (modal.responseCode == "1") {
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
                    modal.message.toString(),
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 4),
                  ),
                  Container(height: 30.0),
                  SizedBox(
                    height: 45,
                    width: MediaQuery.of(context).size.width - 100,
                    // ignore: deprecated_member_use
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(),
                      // borderSide: BorderSide(color: appColor, width: 1.0),
                      // focusColor: Colors.white,
                      // highlightedBorderColor: appColor,
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        // Navigator.pop(context);
                      },
                      child: Text(
                        "OK",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      } else {
        errorDialog(context, modal.message.toString());
      }
    } else {
      socialootoast("Error", "Some error occurred", context);
    }

    setState(() {
      isLoading = false;
    });
  }
}

class ChangePassTxtField extends StatefulWidget {
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

  ChangePassTxtField({
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
  _ChangePassTxtFieldState createState() => _ChangePassTxtFieldState();
}

class _ChangePassTxtFieldState extends State<ChangePassTxtField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
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
