import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
// import 'package:socialoo/Helper/sizeConfig.dart';
import 'package:socialoo/global/global.dart';
import 'package:socialoo/layouts/navigationbar/navigation_bar.dart';

import 'create_post_first_step.dart';

// ignore: must_be_immutable
class UploadPhotoScreen extends StatefulWidget {
  final String? caption;
  List? image;
  final String? userimage;
  final String? userName;
  final CreatePostFirstStepModel firstStepData;

  UploadPhotoScreen({
    this.caption,
    this.image,
    this.userimage,
    this.userName,
    required this.firstStepData,
  });

  @override
  _UploadPhotoScreenState createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  var _locationController;
  var _captionController;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _locationController = TextEditingController();
    _captionController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _locationController?.dispose();
    _captionController?.dispose();
  }

  bool _visibility = true;

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
        title: Text(
          'Create Photo Post',
          style: Theme.of(context).textTheme.headline5!.copyWith(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        elevation: 1.0,
        actions: <Widget>[
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
              'Share',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ).onTap(() {
            apiCall(widget.image as List<File?>);
          })
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        primary: true,
        children: <Widget>[
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: widget.userimage == null || widget.userimage!.isEmpty
                  ? Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF003a54),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Image.asset(
                        'assets/images/defaultavatar.png',
                        width: 50,
                      ),
                    )
                  : CachedNetworkImage(
                      imageUrl: widget.userimage!,
                      height: 50.0,
                      width: 50.0,
                      fit: BoxFit.cover,
                    ),
            ),
            title: Text(
              widget.userName!.capitalize(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            // height: SizeConfig.screenHeight! - 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.image!.length > 0
                    ? Expanded(
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: widget.image!.length,
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      decoration: new BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: new BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          widget.image![index],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      )
                    : Container()
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                  child: TextField(
                    controller: _captionController,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: (widget.caption != null)
                          ? '${widget.caption}'
                          : 'Write a caption...',
                    ),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: 'Add location',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Offstage(
              child: CircularProgressIndicator(),
              offstage: _visibility,
            ),
          )
        ],
      ),
    );
  }

  apiCall(List<File?> files) async {
    LoaderDialog().showIndicator(context);
    var uri = Uri.parse('${baseUrl()}/add_post');

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    for (var file in files) {
      String fileName = file!.path.split("/").last;
      // ignore: deprecated_member_use
      var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
      var length = await file.length(); //imageFile is your image file
      var multipartFileSign =
          new http.MultipartFile('image[]', stream, length, filename: fileName);

      request.files.add(multipartFileSign);
    }

    Map<String, String> headers = {
      "Accept": "application/json",
    };

    //add headers
    request.headers.addAll(headers);

    //adding params
    request.fields['user_id'] = userID!;
    request.fields['text'] = (widget.caption != null)
        ? '${widget.caption}'
        : _captionController.text;
    request.fields['location'] = _locationController.text;
    //////////
    request.fields['form_type'] = widget.firstStepData.postType ?? '';
    request.fields['full_name'] = widget.firstStepData.nameCon.text;
    request.fields['father_name'] = widget.firstStepData.fatherNameCon.text;
    request.fields['gender'] = widget.firstStepData.gender ?? '';
    request.fields['age'] = widget.firstStepData.ageCon.text.toString();
    request.fields['height'] = widget.firstStepData.height.text;
    request.fields['body_mark'] = widget.firstStepData.bodyMark.text;
    request.fields['remarks'] = widget.firstStepData.remarks.text;
    request.fields['resendence_place'] =
        widget.firstStepData.recendencePlaceCon.text;
    request.fields['native_place'] = widget.firstStepData.nativePlaceCon.text;
    if (widget.firstStepData.postType == 'missing')
      request.fields['date_missing'] = widget.firstStepData.dateMissingCon.text;
    if (widget.firstStepData.postType == 'missing')
      request.fields['place_missing'] =
          widget.firstStepData.placeMissingCon.text;
    if (widget.firstStepData.postType == 'dead' ||
        widget.firstStepData.postType == 'found')
      request.fields['date_found'] = widget.firstStepData.dateFoundCon.text;
    if (widget.firstStepData.postType == 'dead' ||
        widget.firstStepData.postType == 'found')
      request.fields['place_found'] = widget.firstStepData.placeFoundCon.text;
    request.fields['fir_dd_number'] = widget.firstStepData.firDdNumber.text;
    request.fields['date_of_fir'] = widget.firstStepData.dateOfFIR.text;
    request.fields['police_station'] = widget.firstStepData.policeStation.text;
    if (widget.firstStepData.postType == 'missing')
      request.fields['police_station_location'] =
          widget.firstStepData.policeStationAdd.text;
    request.fields['police_station_no'] =
        widget.firstStepData.policeStationNo.text;
    request.fields["country"] = 'India';
    request.fields['state'] = widget.firstStepData.selectedState ?? '';
    request.fields['district'] = widget.firstStepData.selectedDistrict ?? '';
    if (widget.firstStepData.postType == 'found')
      request.fields['police_io_name'] = widget.firstStepData.policeIOName.text;
    else
      request.fields['police_io'] = widget.firstStepData.policeIOName.text;
    request.fields['contact_number'] = widget.firstStepData.contactNumber.text;
    if (widget.firstStepData.postType == 'found')
      request.fields['ngo_or_username'] =
          widget.firstStepData.ngoOrUsername.text;
    ///////////

    print(request.fields);
    print(request.files.length);

    // send
    var response = await request.send();

    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    print(responseData);
    var userData = json.decode(responseData);
    print(userData);

    LoaderDialog().showIndicator(context);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => NavBar()),
      (Route<dynamic> route) => false,
    );
  }
}
