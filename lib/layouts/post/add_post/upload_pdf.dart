import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialoo/global/global.dart';
import 'package:socialoo/layouts/navigationbar/navigation_bar.dart';

import 'create_post_first_step.dart';

// ignore: must_be_immutable
class UploadPdfScreen extends StatefulWidget {
  final String? caption;
  final String? userimage;
  final String? userName;
  File? file;
  String? pdfpath;
  String? pdfname;
  String? pdfsize;
  final CreatePostFirstStepModel firstStepData;

  UploadPdfScreen({
    this.caption,
    this.userimage,
    this.userName,
    this.file,
    this.pdfpath,
    this.pdfname,
    this.pdfsize,
    required this.firstStepData,
  });

  @override
  _UploadPdfScreenState createState() => _UploadPdfScreenState();
}

class _UploadPdfScreenState extends State<UploadPdfScreen> {
  var _locationController;
  var _captionController;

  final dio = new Dio();

  @override
  void initState() {
    // _pickVideo();
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
          'Upload PDF',
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
            apiCall(widget.pdfpath);
          })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
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
              alignment: Alignment.center,
              child: Center(
                child: Stack(
                  children: <Widget>[
                    (widget.file == null)
                        ? Container()
                        : Material(
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    border: Border.all(color: Colors.grey)),
                                child: ListTile(
                                  leading: SvgPicture.asset(
                                    'assets/images/pdf_file.svg',
                                    height: 40,
                                    color: Colors.grey,
                                  ),
                                  title: Text(
                                    widget.pdfname!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(fontSize: 16),
                                  ),
                                  subtitle: Text(filesize(widget.pdfsize)),
                                ))),
                  ],
                ),
              ),
              width: double.infinity,
              margin: const EdgeInsets.all(20.0),
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
      ),
    );
  }

  apiCall(String? value) async {
    print(value);

    LoaderDialog().showIndicator(context);
    var url = '${baseUrl()}/add_post';

    print(url);
    String name = DateTime.now().millisecondsSinceEpoch.toString();

    FormData formData = new FormData();

    formData = FormData.fromMap({
      'user_id': userID,
      'text': (widget.caption != null)
          ? '${widget.caption}'
          : _captionController.text,
      'location': _locationController.text,
      'pdf':
          MultipartFile.fromFileSync(widget.pdfpath!, filename: name + ".pdf"),
      'pdf_name': widget.pdfname,
      'pdf_size': filesize(widget.pdfsize),
      ////////
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
      "country": widget.firstStepData.selectCountry,
      "state": widget.firstStepData.selectedState,
      "district": widget.firstStepData.selectedDistrict,
      if (widget.firstStepData.postType == 'found')
        'police_io_name': widget.firstStepData.policeIOName.text
      else
        'police_io': widget.firstStepData.policeIOName.text,
      'contact_number': widget.firstStepData.contactNumber.text,
      if (widget.firstStepData.postType == 'found')
        'ngo_or_username': widget.firstStepData.ngoOrUsername.text,
    });

    dio.options.contentType = Headers.jsonContentType;

    final response = await dio.post(url,
        data: formData,
        options: Options(method: 'POST', responseType: ResponseType.json));
    print(response.data.toString());

    LoaderDialog().hideIndicator(context);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => NavBar()),
      (Route<dynamic> route) => false,
    );
  }
}
