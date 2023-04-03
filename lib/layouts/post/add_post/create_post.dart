// ignore_for_file: unnecessary_null_comparison, unnecessary_brace_in_string_interps

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as imageLib;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:photofilters/photofilters.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:socialoo/Helper/sizeConfig.dart';
import 'package:socialoo/global/global.dart';
import 'package:socialoo/layouts/menu/comming_soon_page.dart';
import 'package:socialoo/layouts/navigationbar/navigation_bar.dart';
import 'package:socialoo/layouts/post/add_post/addvideoPost.dart';
import 'package:socialoo/layouts/post/add_post/upload_pdf.dart';
import 'package:socialoo/layouts/post/add_post/upload_photo_screen.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

import 'create_post_first_step.dart';

class PhotoScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState>? parentScaffoldKey;
  final String? userimage;
  final String? userName;
  final CreatePostFirstStepModel firstStepData;

  PhotoScreen(
      {Key? key,
      this.userimage,
      this.userName,
      this.parentScaffoldKey,
      required this.firstStepData})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _MyHomePageState extends State<PhotoScreen> {
  AppState? state;
  File? imageFile;
  File? pdffile;

  bool selectPhoto = false;
  bool showmenu = false;
  bool selectPdf = false;
  bool selectVideo = false;
  bool isLoading = false;
  File? _video;

  late VideoPlayerController _videoPlayerController;

  // ignore: unused_field
  VideoPlayerController? _cameraVideoPlayerController;

  List<File?> alldata = [];

  var savedimageUrls = [];

  // TextEditingController captionController = TextEditingController();
  late var _locationController;
  var _captionController;

  final dio = new Dio();

  // Position _currentPosition;
  String? _currentAddress;

  @override
  void initState() {
    super.initState();
    state = AppState.free;
    _locationController = TextEditingController();
    _captionController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _locationController?.dispose();
    _captionController?.dispose();
  }

  // apiCall() async {
  //   LoaderDialog().showIndicator(context);
  //   var url = '${baseUrl()}/add_post';
  //
  //   print(url);
  //
  //   FormData formData = FormData();
  //
  //   formData = FormData.fromMap({
  //     'user_id': userID,
  //     'text': _captionController.text,
  //     'location': _locationController.text,
  //     //////////
  //     'form_type': widget.firstStepData.postType ?? '',
  //     "full_name": widget.firstStepData.nameCon.text,
  //     "father_name": widget.firstStepData.fatherNameCon.text,
  //     "gender": widget.firstStepData.gender ?? '',
  //     "age": widget.firstStepData.ageCon.text.toString(),
  //     'height': widget.firstStepData.height.text,
  //     'body_mark': widget.firstStepData.bodyMark.text,
  //     'remarks': widget.firstStepData.remarks.text,
  //     "resendence_place": widget.firstStepData.recendencePlaceCon.text,
  //     "native_place": widget.firstStepData.nativePlaceCon.text,
  //     if (widget.firstStepData.postType == 'missing')
  //       "date_missing": widget.firstStepData.dateMissingCon.text,
  //     if (widget.firstStepData.postType == 'missing')
  //       "place_missing": widget.firstStepData.placeMissingCon.text,
  //     if (widget.firstStepData.postType == 'dead' ||
  //         widget.firstStepData.postType == 'found')
  //       "date_found": widget.firstStepData.dateFoundCon.text,
  //     if (widget.firstStepData.postType == 'dead' ||
  //         widget.firstStepData.postType == 'found')
  //       "place_found": widget.firstStepData.placeFoundCon.text,
  //     'fir_dd_number': widget.firstStepData.firDdNumber.text,
  //     'date_of_fir': widget.firstStepData.dateOfFIR.text,
  //     'police_station': widget.firstStepData.policeStation.text,
  //     'police_station_no': widget.firstStepData.policeStationNo.text,
  //     if (widget.firstStepData.postType != 'missing') "country": 'India',
  //     if (widget.firstStepData.postType != 'missing')
  //       "state": widget.firstStepData.selectedState ?? '',
  //     if (widget.firstStepData.postType != 'missing')
  //       "district": widget.firstStepData.selectedDistrict ?? '',
  //     'police_io_name': widget.firstStepData.policeIOName.text,
  //     'contact_number': widget.firstStepData.contactNumber.text,
  //     if (widget.firstStepData.postType == 'found')
  //       'ngo_or_username': widget.firstStepData.ngoOrUsername.text,
  //   });
  //   print(formData.fields);
  //
  //   dio.options.contentType = Headers.jsonContentType;
  //
  //   final response = await dio.post(url,
  //       data: formData,
  //       options: Options(method: 'POST', responseType: ResponseType.json));
  //   print(response.statusCode);
  //   print(response.data.toString());
  //
  //   LoaderDialog().hideIndicator(context);
  //   Navigator.pushAndRemoveUntil(
  //     context,
  //     MaterialPageRoute(builder: (context) => NavBar()),
  //     (Route<dynamic> route) => false,
  //   );
  // }

  apiCall() async {
    LoaderDialog().showIndicator(context);
    var uri = Uri.parse('${baseUrl()}/add_post');
    print(uri.path);
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields.addAll({
      'user_id': userID ?? '',
      'text': _captionController.text,
      'location': _locationController.text,
      //////////
      'form_type': widget.firstStepData.postType ?? '',
      "full_name": widget.firstStepData.nameCon.text,
      "father_name": widget.firstStepData.fatherNameCon.text,
      "gender": widget.firstStepData.gender ?? '',
      "age": widget.firstStepData.ageCon.text.toString(),
      'height': widget.firstStepData.height.text,
      'body_mark': widget.firstStepData.bodyMark.text,
      'remarks': widget.firstStepData.remarks.text,
      "resendence_place": widget.firstStepData.recendencePlaceCon.text,
      "native_place": widget.firstStepData.nativePlaceCon.text,
      if (widget.firstStepData.postType == 'missing')
        "date_missing": widget.firstStepData.dateMissingCon.text,
      if (widget.firstStepData.postType == 'missing')
        "place_missing": widget.firstStepData.placeMissingCon.text,
      if (widget.firstStepData.postType == 'dead' ||
          widget.firstStepData.postType == 'found')
        "date_found": widget.firstStepData.dateFoundCon.text,
      if (widget.firstStepData.postType == 'dead' ||
          widget.firstStepData.postType == 'found')
        "place_found": widget.firstStepData.placeFoundCon.text,
      'fir_dd_number': widget.firstStepData.firDdNumber.text,
      'date_of_fir': widget.firstStepData.dateOfFIR.text,
      'police_station': widget.firstStepData.policeStation.text,
      if (widget.firstStepData.postType == 'missing')
        'police_station_location': widget.firstStepData.policeStationAdd.text,
      'police_station_no': widget.firstStepData.policeStationNo.text,
      "country": widget.firstStepData.selectCountry ?? '',
      "state": widget.firstStepData.selectedState ?? '',
      "district": widget.firstStepData.selectedDistrict ?? '',
      if (widget.firstStepData.postType == 'found')
        'police_io_name': widget.firstStepData.policeIOName.text
      else
        'police_io': widget.firstStepData.policeIOName.text,
      'contact_number': widget.firstStepData.contactNumber.text,
      if (widget.firstStepData.postType == 'found')
        'ngo_or_username': widget.firstStepData.ngoOrUsername.text,
    });
    print(request.fields);

    var response = await request.send();
    String responseData = await response.stream.transform(utf8.decoder).join();
    print(response.statusCode);
    print(responseData);
    var userData = json.decode(responseData);
    print(userData);

    if (userData['response_code'] == "1") {
      LoaderDialog().hideIndicator(context);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => NavBar()),
        (Route<dynamic> route) => false,
      );
    }
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
        actions: [
          selectPhoto == true || selectVideo == true
              ? Container(
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
                    'Next',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ).onTap(() {
                  if (alldata.length > 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UploadPhotoScreen(
                                caption: _captionController.text,
                                image: alldata,
                                userName: widget.userName,
                                userimage: widget.userimage,
                                firstStepData: widget.firstStepData,
                              )),
                    );
                  } else if (_video != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UploadVideoScreen(
                            caption: _captionController.text,
                            video: _video,
                            userName: widget.userName,
                            userimage: widget.userimage,
                            firstStepData: widget.firstStepData),
                      ),
                    );

                    setState(() {
                      _videoPlayerController.setVolume(0);
                      _videoPlayerController.pause();
                    });
                  }
                })
              : Container(
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
                    'Share',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ).onTap(() {
                  if (_captionController.text != '' &&
                      (selectPhoto == true || selectVideo == true)) {
                    setState(() {
                      isLoading = true;
                    });

                    apiCall();
                  } else {
                    _captionController.text == ''
                        ? socialootoast("Error", "Write something", context)
                        : socialootoast("Error",
                            "Please select atleast one document", context);
                  }
                })
        ],
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: widget.userimage == null || widget.userimage!.isEmpty
                  ? Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF003a54),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Image.asset(
                        'assets/images/defaultavatar.png',
                        height: 55.0,
                        width: 55,
                      ),
                    )
                  : CachedNetworkImage(
                      imageUrl: widget.userimage!,
                      height: 55.0,
                      width: 55.0,
                      fit: BoxFit.cover,
                    ),
            ),
            title: Text(
              widget.userName!.capitalize(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: (_currentAddress != null)
                ? Text('at ${_currentAddress}')
                : const Text(''),
          ),
          Center(
            child: Column(
              children: <Widget>[
                Padding(
                    padding:
                        const EdgeInsets.only(top: 60, left: 12.0, right: 8.0),
                    child: TextField(
                      controller: _captionController,
                      onTap: () {
                        setState(() {
                          showmenu = true;
                        });
                      },
                      maxLines: 2,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          hintText: 'What\'s on your mind',
                          border: InputBorder.none,
                          fillColor: transparentColor,
                          filled: true),
                    )),
                selectPhoto == true
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 0, top: 50),
                          child: alldata.length > 0
                              ? Container(
                                  height: MediaQuery.of(context).size.height,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      alldata.length > 0 
                                          ? Expanded(
                                              child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemCount: alldata.length,
                                                  itemBuilder:
                                                      (BuildContext ctxt,
                                                          int index) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Stack(
                                                        children: [
                                                          Container(
                                                            width:
                                                                double.infinity,
                                                            decoration:
                                                                new BoxDecoration(
                                                              color: Colors
                                                                  .grey[300],
                                                              borderRadius:
                                                                  new BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    8.0),
                                                              ),
                                                            ),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              child: Image.file(
                                                                alldata[index]!,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    alldata.remove(
                                                                        alldata[
                                                                            index]);
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .black45,
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      border: Border.all(
                                                                          color:
                                                                              Colors.white)),
                                                                  child: Icon(
                                                                    Icons.close,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 20,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topRight,
                                                              child: InkWell(
                                                                onTap: () {
                                                                  getImage(
                                                                    context,
                                                                    alldata[
                                                                        index],
                                                                  );
                                                                },
                                                                child: Chip(
                                                                  label: Text(
                                                                    "Apply Filter",
                                                                    // style: TextStyle(
                                                                    //     fontSize:
                                                                    //         SizeConfig.screenHeight! *
                                                                    //             3.5),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                            )
                                          : Container()
                                    ],
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    "Select photo or video",
                                    style: TextStyle(
                                      color: appColor,
                                    ),
                                  ),
                                ),
                        ),
                      )
                    : Expanded(
                        child: Padding(
                        padding: const EdgeInsets.only(bottom: 20, top: 50),
                        child: _video != null
                            ? _videoPlayerController.value.isInitialized
                                ? Center(
                                    child: AspectRatio(
                                      aspectRatio: _videoPlayerController
                                          .value.aspectRatio,
                                      child:
                                          VideoPlayer(_videoPlayerController),
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      "Select photo or video",
                                      style: TextStyle(
                                        color: appColor,
                                      ),
                                    ),
                                  )
                            : Center(
                                child: Text(
                                  "Select photo or video",
                                  style: TextStyle(
                                    color: appColor,
                                  ),
                                ),
                              ),
                      )),
                selectPhoto == true || showmenu == true
                    ? SizedBox(
                        height: 40.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  selectPhoto = true;
                                  selectVideo = false;
                                });
                                selectImageSource();
                              },
                              icon: Image.asset(
                                "assets/images/photo_add.png",
                                width: 20,
                              ),
                              label: Text(
                                '',
                                style: Theme.of(context).textTheme.button,
                              ),
                            ),
                            const VerticalDivider(width: 8.0),
                            TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  selectPhoto = false;
                                  selectVideo = true;
                                });

                                selectVideoSource();
                              },
                              icon: Image.asset(
                                "assets/images/video_add.png",
                                width: 20,
                              ),
                              label: Text(
                                '',
                                style: Theme.of(context).textTheme.button,
                              ),
                            ),
                            const VerticalDivider(width: 8.0),
                            TextButton.icon(
                              onPressed: () => selectPDFFile(),
                              icon: Image.asset(
                                "assets/images/pdf_add.png",
                                width: 20,
                              ),
                              label: Text(
                                '',
                                style: Theme.of(context).textTheme.button,
                              ),
                            ),
                            const VerticalDivider(width: 8.0),
                            TextButton.icon(
                              onPressed: () => print('location'),
                              //  _getCurrentLocation(),
                              icon: Image.asset(
                                "assets/images/location.png",
                                width: 20,
                              ),
                              label: Text(
                                '',
                                style: Theme.of(context).textTheme.button,
                              ),
                            ),
                            const VerticalDivider(width: 8.0),
                            TextButton.icon(
                              onPressed: () => print('gif'),
                              icon: Image.asset(
                                "assets/images/gif.png",
                                width: 20,
                              ),
                              label: Text(
                                '',
                                style: Theme.of(context).textTheme.button,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          const Divider(height: 1.0, thickness: 0.5),
                          _getActionMenu(
                            'Photo',
                            "assets/images/photo_add.png",
                            () {
                              setState(() {
                                selectPhoto = true;
                                selectVideo = false;
                              });
                              selectImageSource();
                            },
                          ),
                          const Divider(height: 1.0, thickness: 0.5),
                          _getActionMenu(
                            'Video',
                            "assets/images/video_add.png",
                            () {
                              setState(() {
                                selectPhoto = false;
                                selectVideo = true;
                              });

                              selectVideoSource();
                            },
                          ),
                          const Divider(height: 1.0, thickness: 0.5),
                          _getActionMenu(
                            'Pdf',
                            "assets/images/pdf_add.png",
                            () => selectPDFFile(),
                          ),
                          const Divider(height: 1.0, thickness: 0.5),
                          _getActionMenu(
                            "Check in",
                            "assets/images/location.png",
                            () => print('location'),
                          ),
                          const Divider(height: 1.0, thickness: 0.5),
                          _getActionMenu(
                            "GIF",
                            "assets/images/gif.png",
                            () async {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => CommimgSoon(),
                                ),
                              );
                            },
                          ),
                          const Divider(height: 1.0, thickness: 0.5),
                          _getActionMenu(
                            "Background Color",
                            "assets/images/text.png",
                            () => Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => CommimgSoon(),
                              ),
                            ),
                          ),
                          const Divider(height: 1.0, thickness: 0.5),
                        ],
                      ),
              ],
            ),
          ),
          isLoading
              ? Center(
                  child: loader(context),
                )
              : Container()
        ],
      ),
    );
  }

  ListTile _getActionMenu(String text, String icon, Function() onTap) {
    return ListTile(
      leading: Image.asset(
        icon,
        width: 20,
      ),
      title: Text(
        text,
        style: Theme.of(context).textTheme.button,
      ),
      onTap: onTap,
      minLeadingWidth: 1,
    );
  }

  Future getImageFromGallery() async {
    // ignore: deprecated_member_use
    final imageFile = await ImagePicker().pickImage(
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
      } else {
        debugPrint('error in compressing video from camera');
      }
    }
  }

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
      if (result != null) {
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
                caption: _captionController.text,
                userName: widget.userName,
                userimage: widget.userimage,
                file: pdffile,
                pdfpath: path,
                pdfname: fileName,
                pdfsize: pdfsize,
                firstStepData: widget.firstStepData)));
      } else {
        // print('No image selected.');
      }
    });
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
                                getImageFromCamera();
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
                                // getCropImageFile(ImageSource.gallery);
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

  // Future getCropImageFile(ImageSource source) async {
  //   // File croppedFile;
  //   // String img64;
  //   var image = await ImagePicker().pickImage(
  //     source: source /*ImageSource.camera*/,
  //     imageQuality: 50,
  //   );
  //   if (image != null) {
  //     indicatorDialog(context);
  //     final dir = await getTemporaryDirectory();
  //     final targetPath = dir.absolute.path +
  //         "/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
  //
  //     await FlutterImageCompress.compressAndGetFile(
  //       image.path,
  //       targetPath,
  //       quality: 30,
  //     ).then((value) async {
  //       Navigator.pop(context);
  //       setState(() {
  //         // isLoading = false;
  //         // imageFile = value;
  //         // alldata.add(imageFile);
  //         // state = AppState.picked;
  //       });
  //     });
  //
  //     // PickedFile selectedImage = await ImagePicker().getImage(source: source);
  //     if (image != null) {
  //       File? croppedFile = await ImageCropper().cropImage(
  //           sourcePath: targetPath,
  //           aspectRatioPresets: Platform.isAndroid
  //               ? [
  //                   CropAspectRatioPreset.square,
  //                   CropAspectRatioPreset.ratio3x2,
  //                   CropAspectRatioPreset.original,
  //                   CropAspectRatioPreset.ratio4x3,
  //                   CropAspectRatioPreset.ratio16x9
  //                 ]
  //               : [
  //                   CropAspectRatioPreset.original,
  //                   CropAspectRatioPreset.square,
  //                   CropAspectRatioPreset.ratio3x2,
  //                   CropAspectRatioPreset.ratio4x3,
  //                   CropAspectRatioPreset.ratio5x3,
  //                   CropAspectRatioPreset.ratio5x4,
  //                   CropAspectRatioPreset.ratio7x5,
  //                   CropAspectRatioPreset.ratio16x9
  //                 ],
  //           androidUiSettings: AndroidUiSettings(
  //               toolbarTitle: '',
  //               toolbarColor: appColor,
  //               toolbarWidgetColor: Colors.white,
  //               statusBarColor: appColor,
  //               initAspectRatio: CropAspectRatioPreset.original,
  //               lockAspectRatio: false),
  //           iosUiSettings: IOSUiSettings(
  //             title: '',
  //           ));
  //       if (croppedFile != null) {
  //         setState(() {
  //           imageFile = croppedFile;
  //           alldata.add(imageFile);
  //           state = AppState.cropped;
  //         });
  //       }
  //     }
  //   }
  // }

  Future getImageFromCamera() async {
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
        if (value != null) {
          File? croppedFile = await ImageCropper().cropImage(
              sourcePath: value.path,
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
              imageFile = croppedFile;
              alldata.add(imageFile);
              state = AppState.cropped;
            });
          }
        }

        // setState(() {

        // isLoading = false;
        // imageFile = value;
        // alldata.add(imageFile);
        // state = AppState.picked;
        // });
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
        if (value != null) {
          File? croppedFile = await ImageCropper().cropImage(
              sourcePath: value.path,
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
              imageFile = croppedFile;
              alldata.add(imageFile);
              state = AppState.cropped;
            });
          }
        }
        // setState(() {
        //   imageFile = value;
        //   alldata.add(imageFile);
        //   state = AppState.picked;
        // });
      });
    }
  }

  // Future getCropImageFile(ImageSource source, logo) async {
  //   File croppedFile;
  //   // String img64;
  //   XFile selectedImage = await ImagePicker().pickImage(source: source);
  //
  //   // PickedFile selectedImage = await ImagePicker().getImage(source: source);
  //
  //   if (selectedImage != null) {
  //     croppedFile = await ImageCropper().cropImage(
  //       sourcePath: selectedImage.path,
  //       aspectRatioPresets: [
  //         CropAspectRatioPreset.square,
  //         CropAspectRatioPreset.ratio3x2,
  //         CropAspectRatioPreset.original,
  //         CropAspectRatioPreset.ratio4x3,
  //         CropAspectRatioPreset.ratio16x9
  //       ],
  //       androidUiSettings: AndroidUiSettings(
  //           toolbarTitle: 'Cropper',
  //           toolbarColor: themeDarkBlueColor,
  //           toolbarWidgetColor: Colors.white,
  //           activeControlsWidgetColor: themeOrangeColor,
  //           initAspectRatio: logo == 1
  //               ? CropAspectRatioPreset.ratio3x2
  //               : CropAspectRatioPreset.square,
  //           lockAspectRatio: false),
  //       iosUiSettings: IOSUiSettings(
  //         minimumAspectRatio: 1.0,
  //       ),
  //     );
  //     if (croppedFile != null) {
  //       File compressedFile = await FlutterNativeImage.compressImage(
  //           croppedFile.path,
  //           quality: 50,
  //           percentage: 50);
  //       print(compressedFile.lengthSync());
  //       return compressedFile;
  //     }
  //   }
  // }

  /* filter preset */

  List<Filter> filters = presetFiltersList;
  late String fileName;

  Future getImage(context, image2) async {
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

/* filter preset */
}
