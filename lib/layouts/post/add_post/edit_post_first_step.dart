import 'dart:convert';

import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../global/global.dart';
import '../../../models/view_publicpost_model.dart';
import '../../navigationbar/navigation_bar.dart';
import 'create_post_first_step.dart';

class EditPostFirstStep extends StatefulWidget {
  final String? userimage;
  final String? userName;
  final String? postType;
  final String? postId;

  EditPostFirstStep(
      {Key? key, this.userimage, this.userName, this.postType, this.postId})
      : super(key: key);

  @override
  _EditPostFirstStepState createState() => _EditPostFirstStepState();
}

class _EditPostFirstStepState extends State<EditPostFirstStep> {
  CreatePostFirstStepModel firstStepData = CreatePostFirstStepModel();

  PublicPostModel? publicPost;
  final TextEditingController postText = TextEditingController();

  _getPost() async {
    var uri = Uri.parse('${baseUrl()}/get_post_details');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    print(uri.path);
    request.headers.addAll(headers);
    request.fields['user_id'] = userID ?? '';
    request.fields['post_id'] = widget.postId ?? '';
    print(request.fields);

    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    setState(() {
      publicPost = PublicPostModel.fromJson(userData);
    });
    setPostData();
    print(responseData);
  }

  setPostData() {
    postText.text = publicPost?.post?.text ?? '';
    if (publicPost?.post?.missingData != null) {
      firstStepData.postType = 'missing';
      setMissingData();
    } else if (publicPost?.post?.deadData != null) {
      firstStepData.postType = 'dead';
      setDeadData();
    } else if (publicPost?.post?.foundData != null) {
      firstStepData.postType = 'found';
      setFoundData();
    }
  }

  @override
  void initState() {
    super.initState();
    firstStepData.postType = widget.postType;
    _getPost();
  }

  setMissingData() {
    MissingData missingData = publicPost!.post!.missingData!;
    setState(() {
      firstStepData.nameCon.text = missingData.fullName ?? '';
      firstStepData.fatherNameCon.text = missingData.fatherName ?? '';
      firstStepData.gender = missingData.gender?.capitalize() ?? '';
      firstStepData.ageCon.text = missingData.age ?? '';
      firstStepData.height.text = missingData.height ?? '';
      firstStepData.bodyMark.text = missingData.bodyMark ?? '';
      firstStepData.remarks.text = missingData.remarks ?? '';
      firstStepData.firDdNumber.text = missingData.firDdNumber ?? '';
      firstStepData.dateOfFIR.text = missingData.dateOfFir ?? '';
      firstStepData.policeStation.text = missingData.policeStation ?? '';
      firstStepData.policeStationAdd.text =
          missingData.policeStationLocation ?? '';
      firstStepData.contactNumber.text = missingData.contactNumber ?? '';
      firstStepData.policeStationNo.text = missingData.policeStationNo ?? '';
      firstStepData.recendencePlaceCon.text = missingData.resendencePlace ?? '';
      firstStepData.nativePlaceCon.text = missingData.nativePlace ?? '';
      firstStepData.dateMissingCon.text = missingData.dateMissing ?? '';
      firstStepData.placeMissingCon.text = missingData.placeMissing ?? '';
      firstStepData.selectedState = missingData.state ?? '';
      firstStepData.selectedDistrict = missingData.district ?? '';
      firstStepData.policeIOName.text = missingData.policeIo ?? '';
      firstStepData.pincodeCon.text = missingData.pincode ?? '';
    });
  }

  setDeadData() {
    DeadData? deadData = publicPost!.post!.deadData!;
    setState(() {
      firstStepData.nameCon.text = deadData.fullName ?? '';
      firstStepData.fatherNameCon.text = deadData.fatherName ?? '';
      firstStepData.gender = deadData.gender?.capitalize() ?? '';
      firstStepData.ageCon.text = deadData.age ?? '';
      firstStepData.height.text = deadData.height ?? '';
      firstStepData.bodyMark.text = deadData.bodyMark ?? '';
      firstStepData.remarks.text = deadData.remarks ?? '';
      firstStepData.firDdNumber.text = deadData.firDdNumber ?? '';
      firstStepData.dateOfFIR.text = deadData.dateOfFir ?? '';
      firstStepData.policeStation.text = deadData.policeStation ?? '';
      firstStepData.contactNumber.text = deadData.contactNumber ?? '';
      firstStepData.policeStationNo.text = deadData.policeStationNo ?? '';
      firstStepData.recendencePlaceCon.text = deadData.resendencePlace ?? '';
      firstStepData.nativePlaceCon.text = deadData.nativePlace ?? '';
      firstStepData.dateFoundCon.text = deadData.dateFound ?? '';
      firstStepData.placeFoundCon.text = deadData.placeFound ?? '';
      firstStepData.selectedState = deadData.state ?? '';
      firstStepData.selectedDistrict = deadData.district ?? '';
      firstStepData.policeIOName.text = deadData.policeIo ?? '';
      firstStepData.pincodeCon.text = deadData.pincode ?? '';
    });
  }

  setFoundData() {
    FoundData? foundData = publicPost!.post!.foundData!;
    setState(() {
      firstStepData.nameCon.text = foundData.fullName ?? '';
      firstStepData.fatherNameCon.text = foundData.fatherName ?? '';
      firstStepData.gender = foundData.gender?.capitalize() ?? '';
      firstStepData.ageCon.text = foundData.age ?? '';
      firstStepData.height.text = foundData.height ?? '';
      firstStepData.bodyMark.text = foundData.bodyMark ?? '';
      firstStepData.remarks.text = foundData.remarks ?? '';
      firstStepData.firDdNumber.text = foundData.ddFir ?? '';
      firstStepData.dateOfFIR.text = foundData.ddFirDate ?? '';
      firstStepData.policeStation.text = foundData.policeStation ?? '';
      firstStepData.contactNumber.text = foundData.contactNumber ?? '';
      firstStepData.policeStationNo.text = foundData.policePhone ?? '';
      firstStepData.recendencePlaceCon.text = foundData.residencePlace ?? '';
      firstStepData.nativePlaceCon.text = foundData.nativePlace ?? '';
      firstStepData.dateFoundCon.text = foundData.date ?? '';
      firstStepData.placeFoundCon.text = foundData.place ?? '';
      firstStepData.selectedState = foundData.state ?? '';
      firstStepData.selectedDistrict = foundData.district ?? '';
      firstStepData.policeIOName.text = foundData.policeIoName ?? '';
      firstStepData.ngoOrUsername.text = foundData.ngoOrUsername ?? '';
    });
  }

  var gender1 = ['Male', 'Female', 'Other'];
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  apiCall() async {
    LoaderDialog().showIndicator(context);
    var uri = Uri.parse('${baseUrl()}/edit_post');
    print(uri.path);
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields.addAll({
      'user_id': userID ?? '',
      'text': postText.text,
      'post_id': widget.postId ?? '',
      //////////
      'form_type': firstStepData.postType ?? '',
      "full_name": firstStepData.nameCon.text,
      "father_name": firstStepData.fatherNameCon.text,
      "gender": firstStepData.gender ?? '',
      "age": firstStepData.ageCon.text.toString(),
      'height': firstStepData.height.text,
      'body_mark': firstStepData.bodyMark.text,
      'remarks': firstStepData.remarks.text,
      "resendence_place": firstStepData.recendencePlaceCon.text,
      "native_place": firstStepData.nativePlaceCon.text,
      if (firstStepData.postType == 'missing')
        "date_missing": firstStepData.dateMissingCon.text,
      if (firstStepData.postType == 'missing')
        "place_missing": firstStepData.placeMissingCon.text,
      if (firstStepData.postType == 'dead' || firstStepData.postType == 'found')
        "date_found": firstStepData.dateFoundCon.text,
      if (firstStepData.postType == 'dead' || firstStepData.postType == 'found')
        "place_found": firstStepData.placeFoundCon.text,
      'fir_dd_number': firstStepData.firDdNumber.text,
      'date_of_fir': firstStepData.dateOfFIR.text,
      'police_station': firstStepData.policeStation.text,
      if (firstStepData.postType == 'missing')
        'police_station_location': firstStepData.policeStation.text,
      'police_station_no': firstStepData.policeStationNo.text,
      "country": firstStepData.selectCountry ?? '',
      "state": firstStepData.selectedState ?? '',
      "district": firstStepData.selectedDistrict ?? '',
      if (firstStepData.postType == 'found')
        'police_io_name': firstStepData.policeIOName.text
      else
        'police_io': firstStepData.policeIOName.text,
      'contact_number': firstStepData.contactNumber.text,
      if (firstStepData.postType == 'found')
        'ngo_or_username': firstStepData.ngoOrUsername.text,
    });
    print(request.fields);

    var response = await request.send();
    String responseData = await response.stream.transform(utf8.decoder).join();
    print(response.statusCode);
    print(responseData);
    var userData = json.decode(responseData);
    print(userData);
    LoaderDialog().hideIndicator(context);
    if (userData['response_code'] == "1") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => NavBar()),
        (Route<dynamic> route) => false,
      );
    }
  }

  Future selectDate(BuildContext context) async {
    final now = DateTime.now();
    DateTime _dateTime = DateTime(now.year, now.month, now.day);
    var myFormat = DateFormat('dd-MM-yyyy') /*.add_yMd()*/;
    String dateString;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(now.year - 2),
      lastDate: _dateTime,
    );
    if (picked != null) {
      _dateTime = picked;
      dateString = '${myFormat.format(_dateTime).substring(0, 10)}';
      return dateString;
    }
    return null;
  }

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
                  'Edit Your Post',
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
      body: publicPost == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              autovalidateMode: AutovalidateMode.always,
              key: formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                children: [
                  EditTextField(
                    validator: publicPost!.post!.missingData != null
                        ? onlyRequiredValidate
                        : null,
                    controller: firstStepData.nameCon,
                    onChanged: (input) {},
                    maxLines: 1,
                    labelText: publicPost!.post!.missingData != null
                        ? 'Name *'
                        : 'Name',
                    hint: 'Enter full name',
                  ),
                  EditTextField(
                    validator: publicPost!.post!.missingData != null
                        ? onlyRequiredValidate
                        : null,
                    controller: firstStepData.fatherNameCon,
                    onChanged: (input) {},
                    maxLines: 1,
                    labelText: publicPost!.post!.missingData != null
                        ? 'Father Name *'
                        : 'Father Name',
                    hint: 'Enter father name',
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Gender *",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  InputDecorator(
                    decoration: InputDecoration(
                      hintText: "Gender",
                      fillColor:
                          Theme.of(context).inputDecorationTheme.fillColor,
                      hintStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(
                            color: Theme.of(context).shadowColor, width: 0),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      filled: true,
                      // fillColor: Color(0xFFEAF1F6),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        style: TextStyle(color: Colors.black),
                        value: firstStepData.gender,
                        isDense: true,
                        hint: Text(
                          'Select Gender',
                        ),
                        icon: Icon(
                          Icons.arrow_drop_down, // Add this
                          color: appColorBlack, // Add this
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            firstStepData.gender = newValue;
                            // state.didChange(newValue);
                          });
                        },
                        items: gender1.map((item) {
                          return new DropdownMenuItem(
                            child: new Text(
                              item,
                              textAlign: TextAlign.center,
                            ),
                            value: item,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  EditTextField(
                    validator: onlyRequiredValidate,
                    controller: firstStepData.ageCon,
                    onChanged: (input) {},
                    maxLines: 1,
                    keyBoard: TextInputType.number,
                    inputFormatterData: digitsInputFormatter(size: 3),
                    labelText: 'Age *',
                    hint: 'Enter age',
                  ),
                  EditTextField(
                    //validator: onlyRequiredValidate,
                    controller: firstStepData.height,
                    onChanged: (input) {},
                    maxLines: 1,
                    keyBoard: TextInputType.number,
                    inputFormatterData: priceInputFormatter(size: 4),
                    labelText: 'Height',
                    hint: 'Enter height in feet',
                  ),
                  EditTextField(
                    // validator: onlyRequiredValidate,
                    controller: firstStepData.bodyMark,
                    onChanged: (input) {},
                    labelText: 'Body Mark',
                    hint: 'Enter body mark',
                  ),
                  EditTextField(
                    // validator: onlyRequiredValidate,
                    controller: firstStepData.remarks,
                    onChanged: (input) {},
                    labelText: 'Remarks',
                    hint: 'Enter remarks',
                  ),
                  if (publicPost!.post!.deadData != null ||
                      publicPost!.post!.foundData != null)
                    Column(
                      children: [
                        EditTextField(
                          validator: onlyRequiredValidate,
                          controller: firstStepData.dateFoundCon,
                          // onChanged: (input) {},
                          maxLines: 1,
                          labelText: 'Found Date *',
                          // onChanged: (input) {},
                          readOnly: true,
                          onTap: () async {
                            String? date = await selectDate(context);
                            if (date != null)
                              firstStepData.dateFoundCon.text = date;
                          },
                          hint: 'Enter found date',
                        ),
                        EditTextField(
                          //validator: onlyRequiredValidate,
                          controller: firstStepData.placeFoundCon,
                          onChanged: (input) {},
                          maxLines: 1,
                          labelText: 'Found Place',
                          hint: 'Enter found place',
                        ),
                      ],
                    ),
                  EditTextField(
                    validator: publicPost!.post!.missingData != null
                        ? onlyRequiredValidate
                        : null,
                    controller: firstStepData.recendencePlaceCon,
                    onChanged: (input) {},
                    maxLines: 1,
                    labelText: publicPost!.post!.missingData != null
                        ? 'Residence Place *'
                        : 'Residence Place',
                    hint: 'Enter residence place',
                  ),
                  EditTextField(
                    // validator: onlyRequiredValidate,
                    controller: firstStepData.nativePlaceCon,
                    onChanged: (input) {},
                    maxLines: 1,
                    labelText: 'Native Place',
                    hint: 'Enter native place',
                  ),
                  if (publicPost!.post!.missingData != null)
                    Column(
                      children: [
                        EditTextField(
                          validator: onlyRequiredValidate,
                          controller: firstStepData.dateMissingCon,
                          // onChanged: (input) {},
                          maxLines: 1,
                          readOnly: true,
                          labelText: 'Missing Date *',
                          onTap: () async {
                            // firstStepData.dateMissingCon.text =
                            String? date = await selectDate(context);
                            if (date != null)
                              firstStepData.dateMissingCon.text = date;
                          },
                          hint: 'Enter missing date',
                        ),
                        EditTextField(
                          validator: onlyRequiredValidate,
                          controller: firstStepData.placeMissingCon,
                          onChanged: (input) {},
                          maxLines: 1,
                          labelText: 'Missing Place *',
                          hint: 'Enter missing place',
                        ),
                      ],
                    ),
                  EditTextField(
                    //validator: onlyRequiredValidate,
                    controller: firstStepData.firDdNumber,
                    onChanged: (input) {},
                    labelText: 'FIR / DD / Complaint No',
                    hint: 'Enter fir dd number',
                  ),
                  EditTextField(
                    //validator: onlyRequiredValidate,
                    controller: firstStepData.dateOfFIR,
                    onChanged: (input) {},
                    onTap: () async {
                      String? date = await selectDate(context);
                      if (date != null) firstStepData.dateOfFIR.text = date;
                    },
                    inputFormatterData: digitsInputFormatter(size: 3),
                    labelText: 'FIR / DD / Complaint Date',
                    hint: 'Tap to select date',
                  ),
                  EditTextField(
                    //validator: onlyRequiredValidate,
                    controller: firstStepData.policeStation,
                    onChanged: (input) {},
                    labelText: 'Police Station',
                    hint: 'Enter police station',
                  ),
                  if (widget.postType == 'missing')
                    EditTextField(
                      //validator: onlyRequiredValidate,
                      controller: firstStepData.policeStationAdd,
                      onChanged: (input) {},
                      labelText: 'Police Station Location',
                      hint: 'Enter police station location',
                    ),
                  EditTextField(
                    //validator: onlyRequiredValidate,
                    controller: firstStepData.policeStationNo,
                    onChanged: (input) {},
                    maxLines: 1,
                    keyBoard: TextInputType.number,
                    inputFormatterData: digitsInputFormatter(),
                    labelText: 'Police Station Contact No',
                    hint: 'Enter police station contact number',
                  ),
                  SizedBox(height: 10),
                  CSCPicker(
                    flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
                    currentCity: firstStepData.selectedDistrict,
                    defaultCountry: CscCountry.India,
                    currentState: firstStepData.selectedState,
                    disableCountry: false,
                    cityDropdownLabel: 'District',
                    disabledDropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Theme.of(context).inputDecorationTheme.fillColor,
                        border:
                            Border.all(color: Colors.transparent, width: 1)),
                    dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Theme.of(context).inputDecorationTheme.fillColor,
                        border:
                            Border.all(color: Colors.transparent, width: 1)),
                    onStateChanged: (value) {
                      setState(() {
                        firstStepData.selectedState = value ?? '';
                      });
                    },
                    onCountryChanged: (value) {
                      setState(() {
                        firstStepData.selectCountry = value ?? '';
                      });
                    },
                    onCityChanged: (value) {
                      setState(() {
                        firstStepData.selectedDistrict = value ?? '';
                      });
                    },
                  ),
                  EditTextField(
                    validator: onlyRequiredValidate,
                    controller: firstStepData.policeIOName,
                    onChanged: (input) {},
                    labelText: 'Police IO / Your Name *',
                    hint: widget.postType == 'found'
                        ? 'Enter police io'
                        : 'Enter police io or your name',
                  ),
                  if (widget.postType == 'found')
                    EditTextField(
                      //validator: onlyRequiredValidate,
                      controller: firstStepData.ngoOrUsername,
                      onChanged: (input) {},
                      labelText: 'NGO / Your Name',
                      hint: 'Enter ngo or your name',
                    ),
                  EditTextField(
                    validator: onlyRequiredValidate,
                    controller: firstStepData.contactNumber,
                    onChanged: (input) {},
                    maxLines: 1,
                    keyBoard: TextInputType.number,
                    inputFormatterData: digitsInputFormatter(),
                    labelText: 'Contact No *',
                    hint: 'Enter contact number',
                  ),
                  EditTextField(
                    //validator: onlyRequiredValidate,
                    controller: postText,
                    onChanged: (input) {},
                    maxLines: 5,
                    labelText: 'Post Text',
                    hint: "What\'s on your mind",
                  ),
                  SizedBox(height: 25),
                  InkWell(
                    onTap: () {
                      print(firstStepData.selectedDistrict);
                      if (formKey.currentState!.validate()) {
                        if (widget.postType == 'missing') {
                          apiCall();
                        } else {
                          if (firstStepData.selectedState != null &&
                              firstStepData.selectedState != '' &&
                              firstStepData.selectedDistrict != null &&
                              firstStepData.selectedDistrict != '') {
                            apiCall();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => NavBar()),
                              (Route<dynamic> route) => false,
                            );
                          } else {
                            if (firstStepData.selectedState == null ||
                                firstStepData.selectedState == '')
                              socialootoast("Error",
                                  "Please select state first", context);
                            if (firstStepData.selectedDistrict == null ||
                                firstStepData.selectedDistrict == '')
                              socialootoast(
                                  "Error", "Please select city first", context);
                          }
                        }
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFF1246A5), Color(0xFF1e3c72)],
                        ),
                      ),
                      child: const Text(
                        'SUBMIT',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

List<TextInputFormatter> priceInputFormatter({int? size}) {
  return [
    FilteringTextInputFormatter(RegExp(r'^(\d+)?\.?\d{0,2}'), allow: true),
    LengthLimitingTextInputFormatter(size != null ? size : 10),
  ];
}

List<TextInputFormatter> digitsInputFormatter({int? size}) {
  return [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(size ?? 10),
  ];
}

onlyRequiredValidate(value) {
  if (value.isEmpty)
    return 'Field is required';
  else
    return null;
}

pincodeValidation(value) {
  if (value.isEmpty)
    return 'Pincode is required';
  else if (value.toString().length < 6)
    return 'Enter valid pincode';
  else
    return null;
}

class EditTextField extends StatefulWidget {
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
  final bool? obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? initialVal;
  final Color? primaryColor;

  EditTextField({
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
    this.obscureText,
    this.suffixIcon,
    this.prefixIcon,
    this.initialVal,
    this.primaryColor,
  });

  @override
  _EditTextFieldState createState() => _EditTextFieldState();
}

class _EditTextFieldState extends State<EditTextField> {
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
                hintStyle: TextStyle(color: widget.primaryColor ?? null),
                suffixIconConstraints:
                    BoxConstraints(minWidth: 0, minHeight: 0),
                prefixIconConstraints:
                    BoxConstraints(minWidth: 0, minHeight: 0),
                contentPadding: EdgeInsets.symmetric(
                    vertical: widget.vertical ?? 10.0,
                    horizontal: widget.horizontal ?? 10),
                isDense: true,
                hintText: widget.hint,
                border: InputBorder.none,
                filled: true,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
