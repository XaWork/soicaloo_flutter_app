import 'dart:io';

import 'package:csc_picker/csc_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as imageLib;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:photofilters/filters/filters.dart';
import 'package:photofilters/filters/preset_filters.dart';
import 'package:photofilters/widgets/photo_filter.dart';
import 'package:socialoo/layouts/post/add_post/upload_pdf.dart';
import 'package:socialoo/layouts/post/add_post/upload_photo_screen.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

import '../../../global/global.dart';
import 'addvideoPost.dart';
import 'create_post.dart';

class CreatePostFirstStepModel {
  final TextEditingController nameCon = TextEditingController();
  final TextEditingController fatherNameCon = TextEditingController();
  final TextEditingController genderCon = TextEditingController();
  final TextEditingController ageCon = TextEditingController();
  final TextEditingController bodyMark = TextEditingController();
  final TextEditingController remarks = TextEditingController();
  final TextEditingController firDdNumber = TextEditingController();
  final TextEditingController dateOfFIR = TextEditingController();
  final TextEditingController policeStation = TextEditingController();
  final TextEditingController policeStationAdd = TextEditingController();
  final TextEditingController contactNumber = TextEditingController();
  final TextEditingController height = TextEditingController();
  final TextEditingController policeStationNo = TextEditingController();
  final TextEditingController recendencePlaceCon = TextEditingController();
  final TextEditingController nativePlaceCon = TextEditingController();
  final TextEditingController dateMissingCon = TextEditingController();
  final TextEditingController dateFoundCon = TextEditingController();
  final TextEditingController placeMissingCon = TextEditingController();
  final TextEditingController placeFoundCon = TextEditingController();
  final TextEditingController pincodeCon = TextEditingController();
  final TextEditingController policeIOName = TextEditingController();
  final TextEditingController ngoOrUsername = TextEditingController();
  String? gender;
  String? selectedState;
  String? selectedDistrict;
  String? postType;
}

class CreatePostFirstStep extends StatefulWidget {
  final GlobalKey<ScaffoldState>? parentScaffoldKey;
  final String? userimage;
  final String? userName;
  final String? postType;
  final int? isStory;

  CreatePostFirstStep(
      {Key? key,
      this.userimage,
      this.userName,
      this.postType,
      this.isStory,
      this.parentScaffoldKey})
      : super(key: key);

  @override
  _CreatePostFirstStepState createState() => _CreatePostFirstStepState();
}

class _CreatePostFirstStepState extends State<CreatePostFirstStep> {
  // full_name
  // father_name
  // gender
  // age
  // resendence_place
  // native_place
  // date_missing (when form_type is missing)
  // date_found (when form_type is dead)
  // place_missing (when form_type is missing)
  // place_found (when form_type is dead)
  // state
  // district
  // pincode
  // String? cityValue;
  // String? countryValue;
  // String? stateValue;

  CreatePostFirstStepModel firstStepData = CreatePostFirstStepModel();

  @override
  void initState() {
    super.initState();
    firstStepData.postType = widget.postType;
    ////////////
    state = AppState.free;
  }

  // Widget _entryField(
  //   String title,
  //   TextEditingController controller, /*  TextInputAction textInputAction,*/ {
  //   bool isPassword = false,
  //   TextInputType? keyBoard,
  // }) {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(vertical: 10),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         Text(
  //           title,
  //           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
  //         ),
  //         const SizedBox(
  //           height: 10,
  //         ),
  //         TextField(
  //             // textInputAction: textInputAction,
  //             controller: controller,
  //             obscureText: isPassword,
  //             keyboardType: keyBoard ?? TextInputType.text,
  //             decoration: InputDecoration(
  //                 border: InputBorder.none,
  //                 fillColor: Theme.of(context).inputDecorationTheme.fillColor,
  //                 filled: true))
  //       ],
  //     ),
  //   );
  // }

  var gender1 = ['Male', 'Female', 'Other'];
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Widget genderWidget(Function validator) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Gender",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
                          child: DropdownButtonFormField(
                              value: firstStepData.gender,
                              isDense: true,
                              hint: Padding(
                                padding: const EdgeInsets.only(top: 0),
                                child: Text(
                                  'Select Gender',
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 14),
                                ),
                              ),
                              validator: (value) => validator(value),
                              icon: Padding(
                                padding:
                                    const EdgeInsets.only(right: 0, top: 5),
                                child: Icon(
                                  Icons.arrow_drop_down, // Add this
                                  color: appColorBlack, // Add this
                                ),
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
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  value: item,
                                );
                              }).toList(),
                              decoration:
                                  InputDecoration(border: InputBorder.none)),
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

  Future selectDate(BuildContext context) async {
    final now = DateTime.now();
    DateTime _dateTime = DateTime(now.year, now.month, now.day);
    var myFormat = DateFormat('dd-MM-yyyy') /*.add_yMd()*/;
    String dateString;
    final DateTime? picked = await showDatePicker(
      // builder: (BuildContext context, Widget? child) {
      //   return Theme(
      //     data: ThemeData.light().copyWith(
      //       colorScheme: ColorScheme.light(primary: themeBlueColor),
      //     ),
      //     child: child,
      //   );
      // },
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(now.year - 72),
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
                  'Create Post',
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
      // form_type = missing/dead
      // full_name
      // father_name
      // gender
      // age
      // resendence_place
      // native_place
      // date_missing (when form_type is missing)
      // date_found (when form_type is dead)
      // place_missing (when form_type is missing)
      // place_found (when form_type is dead)
      // state
      // district
      // pincode
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          children: [
            EditTextField(
              validator:
                  widget.postType == 'missing' ? onlyRequiredValidate : null,
              controller: firstStepData.nameCon,
              onChanged: (input) {},
              maxLines: 1,
              labelText: 'Full Name',
              hint: 'Enter full name',
            ),
            EditTextField(
              controller: firstStepData.fatherNameCon,
              onChanged: (input) {},
              maxLines: 1,
              labelText: 'Father Name',
              hint: 'Enter father name',
            ),
            SizedBox(height: 10),
            Text(
              "Gender",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            InputDecorator(
              decoration: InputDecoration(
                hintText: "Gender",
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                hintStyle: TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide(color: Colors.transparent, width: 0),
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
              labelText: 'Age',
              hint: 'Enter age',
            ),
            EditTextField(
              validator: onlyRequiredValidate,
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
            if (widget.postType == 'dead' || widget.postType == 'found')
              Column(
                children: [
                  EditTextField(
                    validator: onlyRequiredValidate,
                    controller: firstStepData.dateFoundCon,
                    // onChanged: (input) {},
                    maxLines: 1,
                    labelText: 'Found Date',
                    // onChanged: (input) {},
                    readOnly: true,
                    onTap: () async {
                      String? date = await selectDate(context);
                      if (date != null) firstStepData.dateFoundCon.text = date;
                    },
                    hint: 'Enter found date',
                  ),
                  EditTextField(
                    validator: onlyRequiredValidate,
                    controller: firstStepData.placeFoundCon,
                    onChanged: (input) {},
                    maxLines: 1,
                    labelText: 'Found Place',
                    hint: 'Enter found place',
                  ),
                ],
              ),
            EditTextField(
              // validator: onlyRequiredValidate,
              controller: firstStepData.recendencePlaceCon,
              onChanged: (input) {},
              maxLines: 1,
              labelText: 'Residence Place',
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
            if (widget.postType == 'missing')
              Column(
                children: [
                  EditTextField(
                    // validator: onlyRequiredValidate,
                    controller: firstStepData.dateMissingCon,
                    // onChanged: (input) {},
                    maxLines: 1,
                    readOnly: true,
                    labelText: 'Missing Date',
                    onTap: () async {
                      // firstStepData.dateMissingCon.text =
                      String? date = await selectDate(context);
                      if (date != null)
                        firstStepData.dateMissingCon.text = date;
                    },
                    hint: 'Enter missing date',
                  ),
                  EditTextField(
                    // validator: onlyRequiredValidate,
                    controller: firstStepData.placeMissingCon,
                    onChanged: (input) {},
                    maxLines: 1,
                    labelText: 'Missing Place',
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
              readOnly: true,
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
                labelText: 'Police Station Address',
                hint: 'Enter police station address',
              ),
            EditTextField(
              //validator: validateMobile,
              controller: firstStepData.policeStationNo,
              onChanged: (input) {},
              maxLines: 1,
              keyBoard: TextInputType.number,
              inputFormatterData: digitsInputFormatter(),
              labelText: 'Police Station Contact No',
              hint: 'Enter police station contact number',
            ),
            SizedBox(height: 10),
            // if (widget.postType != 'missing')
            CSCPicker(
              flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
              defaultCountry: DefaultCountry.India,
              disableCountry: true,
              currentCity: firstStepData.selectedDistrict,
              currentState: firstStepData.selectedState,
              cityDropdownLabel: 'District',
              disabledDropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                  border: Border.all(color: Colors.transparent, width: 1)),
              dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                  border: Border.all(color: Colors.transparent, width: 1)),
              // onCountryChanged: (value) {
              //   setState(() {
              //     countryValue = value;
              //   });
              // },
              onStateChanged: (value) {
                setState(() {
                  firstStepData.selectedState = value ?? '';
                });
              },
              onCityChanged: (value) {
                setState(() {
                  firstStepData.selectedDistrict = value ?? '';
                });
              },
            ),
            EditTextField(
              //validator:
              //  widget.postType == 'found' ? null : onlyRequiredValidate,
              controller: firstStepData.policeIOName,
              onChanged: (input) {},
              labelText: widget.postType == 'found'
                  ? 'Police IO'
                  : 'Police IO / Your Name',
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
              //validator: validateMobile,
              controller: firstStepData.contactNumber,
              onChanged: (input) {},
              maxLines: 1,
              keyBoard: TextInputType.number,
              inputFormatterData: digitsInputFormatter(),
              labelText: 'Contact No',
              hint: 'Enter contact number',
            ),

// body_mark
// remarks
// fir_dd_number
// date_of_fir
// police_station
// contact_number
// height
// police_station_no

            // EditTextField(
            //   validator: onlyRequiredValidate,
            //   controller: firstStepData.stateCon,
            //   onChanged: (input) {},
            //   maxLines: 1,
            //   labelText: 'State',
            //   hint: 'Enter state',
            // ),
            // EditTextField(
            //   validator: onlyRequiredValidate,
            //   controller: firstStepData.districtCon,
            //   onChanged: (input) {},
            //   maxLines: 1,
            //   labelText: 'District',
            //   hint: 'Enter district',
            // ),
            // EditTextField(
            //   validator: pincodeValidation,
            //   controller: firstStepData.pincodeCon,
            //   onChanged: (input) {},
            //   maxLines: 1,
            //   inputFormatterData: digitsInputFormatter(size: 6),
            //   keyBoard: TextInputType.number,
            //   labelText: 'Pincode',
            //   hint: 'Enter pincode',
            // ),

            SizedBox(height: 25),
            InkWell(
              onTap: () {
                if (formKey.currentState!.validate()) {
                  if (widget.postType == 'missing') {
                    if (widget.isStory == 1) {
                      selectImageSource();
                    } else if (widget.isStory == 2) {
                      selectVideoSource();
                    } else if (widget.isStory == 3) {
                      selectPDFFile();
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PhotoScreen(
                                    userName: widget.userName,
                                    userimage: widget.userimage,
                                    firstStepData: firstStepData,
                                    // postType: widget.postType,
                                  )));
                    }
                  } else {
                    if (firstStepData.selectedState != null &&
                        firstStepData.selectedState != '' &&
                        firstStepData.selectedDistrict != null &&
                        firstStepData.selectedDistrict != '') {
                      if (widget.isStory == 1) {
                        selectImageSource();
                      } else if (widget.isStory == 2) {
                        selectVideoSource();
                      } else if (widget.isStory == 3) {
                        selectPDFFile();
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PhotoScreen(
                                      userName: widget.userName,
                                      userimage: widget.userimage,
                                      firstStepData: firstStepData,
                                      // postType: widget.postType,
                                    )));
                      }
                    } else {
                      if (firstStepData.selectedState == null ||
                          firstStepData.selectedState == '')
                        socialootoast(
                            "Error", "Please select state first", context);
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
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFF1246A5), Color(0xFF1e3c72)],
                  ),
                ),
                child: const Text(
                  'NEXT',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

///////////////////////////////////////////////

  AppState? state;
  File? imageFile;
  File? pdffile;

  bool selectPhoto = false;

  bool selectVideo = false;
  bool isLoading = false;
  File? _video;
  final ImagePicker _picker = ImagePicker();
  late VideoPlayerController _videoPlayerController;

  // VideoPlayerController? _cameraVideoPlayerController;
  List<File?> alldata = [];

  Future selectPDFFile() async {
    final navigator = Navigator.of(context);
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) return;
    final path = result.files.single.path;

    String fileName = result.files.first.name;

    setState(() async {
      pdffile = File(path!);
      // if (result != null) {
      pdffile = File(path);
      int size = pdffile!.lengthSync();
      String pdfsize = "$size";
      double sizeInMb = size / (1024 * 1024);
      if (sizeInMb > 5) {
        socialootoast("", "File Size is larger then 5mb", context);
        return;
      }
      await navigator.push(MaterialPageRoute(
          builder: (context) => UploadPdfScreen(
                userName: widget.userName,
                userimage: widget.userimage,
                file: pdffile,
                pdfpath: path,
                pdfname: fileName,
                pdfsize: pdfsize,
                firstStepData: firstStepData,
              )));
      // } else {
      //   // print('No image selected.');
      // }
    });
  }

  Future pickImageFromGallery() async {
    // ignore: deprecated_member_use
    final imageFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (imageFile != null) {
      setState(() {
        state = AppState.picked;
      });
    }
  }

  // ignore: unused_element
  Future<Null> _cropImage() async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: '',
            toolbarColor: appColor,
            toolbarWidgetColor: Colors.white,
            statusBarColor: appColor,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: '',
        ));
    if (croppedFile != null) {
      imageFile = croppedFile;
      setState(() {
        state = AppState.cropped;
      });
    }
  }

  // ignore: unused_element
  void _clearImage() {
    imageFile = null;
    setState(() {
      state = AppState.free;
    });
  }

  _pickVideo() async {
    var video = await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (video != null) {
      indicatorDialog(context);
      await VideoCompress.setLogLevel(0);

      final compressedVideo = await VideoCompress.compressVideo(
        video.path,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false,
        includeAudio: true,
      );

      if (compressedVideo != null) {
        Navigator.pop(context);

        setState(() {
          _video = File(compressedVideo.path!);
        });
        _videoPlayerController =
            VideoPlayerController.file(File(compressedVideo.path!))
              ..initialize().then((_) {
                setState(() {
                  _videoPlayerController.play();
                });
              });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UploadVideoScreen(
              video: _video,
              userName: widget.userName,
              userimage: widget.userimage,
              firstStepData: firstStepData,
            ),
          ),
        );
      } else {
        debugPrint('error in compressing video from gallery');
      }
    }
  }

  _pickVideoFromCamera() async {
    var video = await ImagePicker().pickVideo(source: ImageSource.camera);

    if (video != null) {
      indicatorDialog(context);
      await VideoCompress.setLogLevel(0);

      final compressedVideo = await VideoCompress.compressVideo(
        video.path,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false,
        includeAudio: true,
      );

      if (compressedVideo != null) {
        Navigator.pop(context);
        setState(() {
          _video = File(compressedVideo.path!);
        });

        _videoPlayerController =
            VideoPlayerController.file(File(compressedVideo.path!))
              ..initialize().then((_) {
                setState(() {
                  _videoPlayerController.play();
                });
              });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UploadVideoScreen(
              video: _video,
              userName: widget.userName,
              userimage: widget.userimage,
              firstStepData: firstStepData,
            ),
          ),
        );
      } else {
        debugPrint('error in compressing video from camera');
      }
    }
  }

  selectVideoSource() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext context,
            StateSetter setState /*You can rename this!*/) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                  height: 250,
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                          child: Text(
                        'Pick Video',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                      )),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                _pickVideoFromCamera();
                              },
                              leading: Icon(
                                Icons.camera,
                                size: 20,
                              ),
                              title: new Text(
                                "Camera",
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                _pickVideo();
                              },
                              leading: Icon(
                                Icons.image,
                                size: 20,
                              ),
                              title: new Text(
                                "Gallery",
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          );
        });
      },
    );
  }

  selectImageSource() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext context,
            StateSetter setState /*You can rename this!*/) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                  height: 250,
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                          child: Text(
                        'Pick Image',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                      )),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                pickImageFromCamera();
                              },
                              leading: Icon(
                                Icons.camera,
                                size: 20,
                              ),
                              title: new Text(
                                "Camera",
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                chooseFromGallery();
                              },
                              leading: Icon(
                                Icons.image,
                                size: 20,
                              ),
                              title: new Text(
                                "Gallery",
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          );
        });
      },
    );
  }

  Future pickImageFromCamera() async {
    var image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (image != null) {
      indicatorDialog(context);
      final dir = await getTemporaryDirectory();
      final targetPath = dir.absolute.path +
          "/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";

      await FlutterImageCompress.compressAndGetFile(
        image.path,
        targetPath,
        quality: 30,
      ).then((value) async {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UploadPhotoScreen(
              userName: userName,
              userimage: userImage,
              image: alldata,
              firstStepData: firstStepData,
            ),
          ),
        );
      });
    }
  }

  Future chooseFromGallery() async {
    var image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (image != null) {
      indicatorDialog(context);
      final dir = await getTemporaryDirectory();
      final targetPath = dir.absolute.path +
          "/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";

      await FlutterImageCompress.compressAndGetFile(
        image.path,
        targetPath,
        quality: 40,
      ).then((value) async {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UploadPhotoScreen(
              userName: userName,
              userimage: userImage,
              image: alldata,
              firstStepData: firstStepData,
            ),
          ),
        );
        setState(() {
          imageFile = value;
          alldata.add(imageFile);
          state = AppState.picked;
        });
      });
    }
  }

  List<Filter> filters = presetFiltersList;
  late String fileName;

  Future pickImage(context, image2) async {
    fileName = path.basename(image2.path);
    var image = imageLib.decodeImage(image2.readAsBytesSync())!;
    image = imageLib.copyResize(image, width: 600);
    Map? imagefile = await Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => Container(
          child: new PhotoFilterSelector(
            title: Text(
              "Photo Customization",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Poppins-Medium",
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
            image: image,
            filters: presetFiltersList,
            filename: fileName,
            loader: Center(
                child: CircularProgressIndicator(
                    strokeWidth: 3.0,
                    valueColor:
                        AlwaysStoppedAnimation<Color?>(Colors.grey[400]))),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );

    if (imagefile != null && imagefile.containsKey('image_filtered')) {
      setState(() {
        isLoading = false;

        var finalimage = imagefile['image_filtered'];
        alldata.add(finalimage);
        alldata.remove(image2);
      });
      print(image2.path);
    }
  }

//////////////////////////////////////////////

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

// class DropDownDes extends StatefulWidget {
//   const DropDownDes({Key? key}) : super(key: key);
//
//   @override
//   _DropDownDesState createState() => _DropDownDesState();
// }
//
// class _DropDownDesState extends State<DropDownDes> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

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

  // final String? initValue;
  final bool? obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? initialVal;
  final Color? primaryColor;

  // final String? suffixText;

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
    // this.initValue,
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
