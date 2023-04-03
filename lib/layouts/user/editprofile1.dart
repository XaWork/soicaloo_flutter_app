import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:socialoo/Helper/sizeConfig.dart';
import 'package:socialoo/global/global.dart';
import 'package:socialoo/layouts/widgets/multi_select.dart';
import 'package:socialoo/models/intrest_model.dart';

import '../chngPass.dart';

// extension StringExtension on String {
//   String capitalize() {
//     return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
//   }
// }

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool isLoading = false;
  TextEditingController controller = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController webController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  File? _image;
  File? _coverimage;

  Future<void> getCoverImage() async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      File? croppedFile = await ImageCropper().cropImage(
          sourcePath: image.path,
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
        setState(() {
          _coverimage = croppedFile;
          print('Image Path $_coverimage');
        });
      }
    }
    // setState(() {
    //   _coverimage = File(image!.path);
    //   print('Image Path $_coverimage');
    // });
  }

  // Future<void> pickImageGallery() async {
  //   var image = await ImagePicker()
  //       .pickImage(source: ImageSource.gallery, imageQuality: 50);
  //   setState(() {
  //     _image = File(image!.path);
  //     print('Image Path $_image');
  //   });
  // }

  // Future<void> pickImageFromCamera() async {
  //   var image = await ImagePicker()
  //       .pickImage(source: ImageSource.camera, imageQuality: 50);
  //   setState(() {
  //     _image = File(image!.path);
  //     print('Image Path $_image');
  //   });
  // }

  Future pickImageFromCamera() async {
    var image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (image != null) {
      File? croppedFile = await ImageCropper().cropImage(
          sourcePath: image.path,
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
        setState(() {
          _image = croppedFile;
        });
      }
    }
  }

  Future pickImageGallery() async {
    var image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (image != null) {
      File? croppedFile = await ImageCropper().cropImage(
          sourcePath: image.path,
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
        setState(() {
          _image = croppedFile;
        });
      }
    }
  }

  IntrestModel? intrestModel;
  List<String> selectedCat = [];

  String? gender;

  var gender1 = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    usernameController.text = userName ?? "";
    nameController.text = userfullname ?? '';
    bioController.text = userBio ?? '';
    emailController.text = userEmail ?? '';
    phoneController.text = userPhone ?? '';
    if (userGender != null && userGender != '') {
      gender = userGender!.capitalize();
    } else {
      gender = 'Male';
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
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
            elevation: 0.5,
            title: Text(
              "Edit Profile",
              style: Theme.of(context).textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
            ),
            // centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                )),
            actions: [
              Container(
                margin: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width * 0.25,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Colors.red.shade500, Colors.red.shade900])),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ).onTap(
                () async {
                  setState(() {
                    isLoading = true;
                  });

                  if (_image != null) {
                    final dir = await getTemporaryDirectory();
                    final targetPath = dir.absolute.path +
                        "/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";

                    await FlutterImageCompress.compressAndGetFile(
                      _image!.absolute.path,
                      targetPath,
                      quality: 20,
                    ).then((value) async {
                      print("Compressed");
                      _updateProfile(value, null);
                    });
                  } else if (_coverimage != null) {
                    final dir = await getTemporaryDirectory();
                    final targetPath = dir.absolute.path +
                        "/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";

                    await FlutterImageCompress.compressAndGetFile(
                      _coverimage!.absolute.path,
                      targetPath,
                      quality: 20,
                    ).then((value) async {
                      print("Compressed");
                      _updateProfile(null, value);
                    });
                  } else {
                    _updateProfile(null, null);
                  }
                },
              ),
              Container(width: 20)
            ],
          ),
          body: Stack(
            children: <Widget>[
              _userInfo2(),
              isLoading == true
                  ? Center(
                      child: loader(context),
                    )
                  : Container()
            ],
          )),
    );
  }

  Widget _userInfo2() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          height: 250,
                          child: Stack(
                            children: <Widget>[
                              (_coverimage == null)
                                  ? (userCoverImage != '' &&
                                          userCoverImage != null)
                                      ? Material(
                                          child: CachedNetworkImage(
                                            placeholder: (context, url) =>
                                                Container(
                                              child:
                                                  const CircularProgressIndicator(
                                                strokeWidth: 2.0,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.red),
                                              ),
                                              height: 200.0,
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                            ),
                                            imageUrl: userCoverImage!,
                                            width: double.infinity,
                                            height: 200.0,
                                            fit: BoxFit.cover,
                                          ),
                                          clipBehavior: Clip.hardEdge,
                                        )
                                      : Image.asset(
                                          'assets/images/defaultcover.png',
                                          alignment: Alignment.center,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          height: 200,
                                        )
                                  : Material(
                                      child: Image.file(
                                        _coverimage!,
                                        width: double.infinity,
                                        height: 200.0,
                                        fit: BoxFit.cover,
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                    ),
                              Positioned(
                                  bottom: 30,
                                  right: 10,
                                  child: Image.asset(
                                    "assets/images/camera.png",
                                    width: 40,
                                  ).onTap(() {
                                    getCoverImage();
                                  }))
                            ],
                          ),
                          width: double.infinity,
                        ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          child: Center(
                            child: Stack(
                              children: <Widget>[
                                (_image == null)
                                    ? (userImage != '' && userImage != null)
                                        ? Material(
                                            child: CachedNetworkImage(
                                              placeholder: (context, url) =>
                                                  Container(
                                                child:
                                                    const CircularProgressIndicator(
                                                  strokeWidth: 2.0,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          Colors
                                                              .deepPurpleAccent),
                                                ),
                                                width: 120.0,
                                                height: 120.0,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20.0),
                                              ),
                                              imageUrl: userImage!,
                                              width: 120.0,
                                              height: 120.0,
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(60.0)),
                                            clipBehavior: Clip.hardEdge,
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF003a54),
                                              borderRadius:
                                                  BorderRadius.circular(60.0),
                                            ),
                                            child: Image.asset(
                                              'assets/images/defaultavatar.png',
                                              width: 120,
                                            ),
                                          )
                                    : Material(
                                        child: Image.file(
                                          _image!,
                                          width: 120.0,
                                          height: 120.0,
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(60.0)),
                                        clipBehavior: Clip.hardEdge,
                                      ),
                                IconButton(
                                  alignment: Alignment.bottomRight,
                                  color: Colors.red,
                                  icon: Image.asset(
                                    "assets/images/camera.png",
                                    width: 40,
                                  ),
                                  onPressed: selectImageSource,
                                  padding: const EdgeInsets.all(0.0),
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.grey,
                                  iconSize: 130,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(height: 20),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  height: 50,
                  alignment: Alignment.centerLeft,
                  // color: Theme.of(context).shadowColor,
                  child: const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      'Profile Info',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                  ),
                ),
                const Divider(
                  thickness: 2,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextField(
                        controller: usernameController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Username",
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
                          contentPadding:
                              const EdgeInsets.fromLTRB(16, 12, 16, 12),
                          filled: true,
                          fillColor: Color(0xFFEAF1F6),
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextField(
                        controller: nameController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Name",
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
                          contentPadding:
                              const EdgeInsets.fromLTRB(16, 12, 16, 12),
                          filled: true,
                          fillColor: Color(0xFFEAF1F6),
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextField(
                        controller: bioController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Bio",
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
                          contentPadding:
                              const EdgeInsets.fromLTRB(16, 12, 16, 12),
                          filled: true,
                          fillColor: Color(0xFFEAF1F6),
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.all(5),
                        child: TextField(
                          controller: emailController,
                          readOnly: true,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                  color: Theme.of(context).shadowColor,
                                  width: 0),
                            ),
                            isDense: true,
                            contentPadding:
                                const EdgeInsets.fromLTRB(16, 12, 16, 12),
                            filled: true,
                            fillColor: Color(0xFFEAF1F6),
                          ),
                        )),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextField(
                        controller: phoneController,
                        // readOnly: true,
                        style: TextStyle(color: Colors.black),
                        /*inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                        ],*/
                        maxLength: 15,
                        decoration: InputDecoration(
                          hintText: "Phone",
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
                          contentPadding:
                              const EdgeInsets.fromLTRB(16, 12, 16, 12),
                          filled: true,
                          fillColor: Color(0xFFEAF1F6),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: FormField<String>(
                      builder: (FormFieldState<String> state) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: InputDecorator(
                            decoration: InputDecoration(
                              hintText: "Gender",
                              hintStyle: TextStyle(color: Colors.black),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                borderSide: BorderSide(
                                    color: Theme.of(context).shadowColor,
                                    width: 0),
                              ),
                              isDense: true,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(16, 12, 16, 12),
                              filled: true,
                              fillColor: Color(0xFFEAF1F6),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                style: TextStyle(color: Colors.black),
                                value: gender,
                                isDense: true,
                                hint: Padding(
                                  padding: const EdgeInsets.only(top: 0),
                                  child: Text(
                                    'Gender',
                                  ),
                                ),
                                icon: Container(),
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
                                    ),
                                    value: item,
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                Container(
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
                ).onTap(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChnagePassScreen()));
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  selectImageSource() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(height: 10.0),
              Text(
                "Pick Image",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Poppins-Medium",
                ),
              ),
              Container(height: 10.0),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  pickImageFromCamera();
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.camera_alt,
                      color: appColor,
                    ),
                    Container(width: 10.0),
                    Text('Camera',
                        style: TextStyle(fontFamily: "Poppins-Medium"))
                  ],
                ),
              ),
              Container(height: 15.0),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  pickImageGallery();
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.storage,
                      color: appColor,
                    ),
                    Container(width: 10.0),
                    Text('Gallery',
                        style: TextStyle(fontFamily: "Poppins-Medium"))
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget divider() {
    return Container(
      height: 0.5,
      color: Colors.grey[400],
    );
  }

  Future<void> _updateProfile(
    File? img,
    File? cover,
  ) async {
    closeKeyboard();
    try {
      setState(() {
        isLoading = true;
      });

      var uri = Uri.parse('${baseUrl()}/user_edit');
      var request = new http.MultipartRequest("POST", uri);
      Map<String, String> headers = {
        "Accept": "application/json",
      };
      request.fields.addAll({
        // 'id': '52',
        // 'username': 'kishan',
        // 'fullname': 'Kishan Lal',
        // 'email': 'kishan@gmail.com',
        // 'mobile_number': '9892839283',
        // 'gender': 'male',
        // 'interests_id': '1',
        // 'bio': 'hello'
        'id': userID ?? '',
        'username': usernameController.text,
        'fullname': nameController.text,
        'email': emailController.text,
        'mobile_number': phoneController.text,
        'gender': gender?.toLowerCase() ?? '',
        'interests_id': '1',
        'bio': bioController.text,
      });
      request.headers.addAll(headers);
      // request.fields['id'] = userID!;
      // request.fields['username'] = usernameController.text;
      // request.fields['fullname'] = nameController.text;
      // request.fields['interests_id'] = '1';
      // request.fields['bio'] = bioController.text;
      // request.fields['email'] = emailController.text;
      // request.fields['phone'] = phoneController.text;
      // request.fields['mobile_number'] = phoneController.text;
      // request.fields['gender'] = gender!;
      if (img != null) {
        request.files
            .add(await http.MultipartFile.fromPath('profile_pic', img.path));
      }
      if (cover != null) {
        request.files
            .add(await http.MultipartFile.fromPath('cover_pic', cover.path));
      }

      print(request.files.length);

      print(request.fields);

      var response = await request.send();
      print(response.statusCode);
      String responseData =
          await response.stream.transform(utf8.decoder).join();
      var dic = json.decode(responseData);

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });

        print(dic);

        if (dic['response_code'] == "1") {
          setState(() {
            isLoading = false;
            userName = usernameController.text;
            userfullname = nameController.text;
            userBio = bioController.text;
            userEmail = emailController.text;
            userPhone = phoneController.text;
            userGender = genderController.text;
            userImage = dic['user']['profile_pic'];
            userCoverImage = dic['user']['cover_pic'];
          });
          socialootoast("Success", "Update Successfully", context);
          print(userImage);
        } else {
          setState(() {
            isLoading = false;
          });
          socialootoast("Error", "Update Fail!", context);
        }
      } else {
        setState(() {
          isLoading = false;
        });
        socialootoast("Error", "Cannot communicate with server", context);
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      socialootoast("Error", e.toString(), context);
    }
  }

  // ignore: unused_element
  void _showMultiSelect(BuildContext context) async {
    final items = <MultiSelectDialogItem<int>>[
      MultiSelectDialogItem(1, 'Dog'),
      MultiSelectDialogItem(2, 'Cat'),
      MultiSelectDialogItem(3, 'Mouse'),
    ];

    final selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
          initialSelectedValues: [1, 3].toSet(),
        );
      },
    );

    print(selectedValues);
  }
}
