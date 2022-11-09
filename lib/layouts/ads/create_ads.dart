import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:socialoo/models/adsToShow.dart';

import '../../global/global.dart';
import '../navigationbar/navigation_bar.dart';

class CreateAds extends StatefulWidget {
  const CreateAds({Key? key}) : super(key: key);

  @override
  _CreateAdsState createState() => _CreateAdsState();
}

class _CreateAdsState extends State<CreateAds> {
  AdsToShow adsToShow = AdsToShow();
  AdsLocationModel selectedLocation = AdsLocationModel();
  final TextEditingController dateController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  File? imageFile;

  List<AdsLocationModel> adsLocationList = <AdsLocationModel>[];

  Razorpay? razorPay;

  _getAdsLocation() async {
    var uri = Uri.parse('${baseUrl()}/getadlocations');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['user_id'] = userID!;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    Map userData = json.decode(responseData);
    setState(() {
      if (userData['response_code'] == '1') {
        adsLocationList.addAll(List<AdsLocationModel>.from(userData['locations']
            .map((item) => AdsLocationModel.fromJson(item))));
      }
    });
    print('???????????');
    print(userData);
  }

  handleAdsLocation(value, context) {
    adsLocationList.forEach((element) {
      if (element.id == value) {
        setState(() {
          selectedLocation = element;
        });
      }
    });
  }

  Future selectDate(BuildContext context) async {
    final now = DateTime.now();
    DateTime _dateTime = DateTime(now.year, now.month, now.day);
    var myFormat = DateFormat('dd-MM-yyyy') /*.add_yMd()*/;
    String dateString;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: now,
      lastDate: /*_dateTime*/ DateTime(now.year, now.month + 6, now.day),
    );
    if (picked != null) {
      _dateTime = picked;
      dateString = '${myFormat.format(_dateTime).substring(0, 10)}';
      return dateString;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _getAdsLocation();
    razorPay = Razorpay();
    razorPay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorPay!.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorPay!.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  void handlerPaymentSuccess(PaymentSuccessResponse response) {
    print("Payment success");
    String msg = "SUCCESS: " + response.paymentId!;
    Fluttertoast.showToast(msg: msg);
    createAd(response.paymentId ?? '', response.orderId ?? '');

    // navigationRemoveUntil(
    //     context, OrderSuccess(model.bag.order.dishOrderId ?? 0));
  }

  void handlerErrorFailure(PaymentFailureResponse response) {
    String msg = "ERROR: " +
        response.code.toString() +
        " - " +
        jsonDecode(response.message ?? '')['error']['description'];
    Fluttertoast.showToast(msg: msg);
  }

  void handlerExternalWallet(ExternalWalletResponse response) {
    String msg = "EXTERNAL_WALLET: " + response.walletName!;
    Fluttertoast.showToast(msg: msg);
  }

  // String? orderId;

  createOrder() async {
    LoaderDialog().showIndicator(context);
    var uri = Uri.parse(
        '${baseUrl()}/createOrder?user_id=$userID&amount=${selectedLocation.price}');
    // var url =
    //     '${baseUrl()}/createOrder?user_id=$userID&amount=${selectedLocation.price}';

    var request = new http.MultipartRequest("GET", uri);
    print(uri.toString());
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    request.headers.addAll(headers);
    // request.fields['user_id'] = userID;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    LoaderDialog().hideIndicator(context);
    if (mounted)
      setState(() {
        if (userData['response_code'] == '1' && userData['order'] != null) {
          Map data = userData['order'];
          // orderId = data['order_id'];
          openCheckout(data['amount_due'].toString(), data['order_id']);
        }
      });
    print(responseData);
    print('irshad');
  }

  void openCheckout(amount, orderId) {
    var options = {
      "key": "rzp_test_2wlA7A5Vpf1BDo",
      "amount": num.parse(amount),
      "order_id": orderId,
      // Convert Paisa to Rupees
      "name": "MPH",
      // "description": "This is a Test Payment",
      // "timeout": "180",
      "theme.color": "#F6343F",
      "currency": "INR",
      "prefill": {"contact": userPhone, "email": userEmail},
      // "external": {
      //   "wallets": ["paytm"]
      // },
      "options": {
        "checkout": {
          "method": {
            //here you have to specify
            "netbanking": "1",
            "card": "1",
            "upi": "0",
            "wallet": "0",
            "emi": "0",
            "paylater": "0"
          }
        }
      }
    };

    /*  var options = {
      "key": "rzp_test_Jtc2xZnPumcYcC",
      "amount": num.parse(amount),
      'name': 'Deposit',
      'description': 'Payment',
      'currency': "INR",
      'prefill': {
        "contact": bag.deliveryOrPickupDetails.deliveryOrPickupPhone!,
        "email": currentUser.value.email
      },
      "method": {
        "netbanking": true,
        "card": true,
        "upi": true,
        "wallet": false,
        "emi": false,
        "paylater": false
      }
    };*/

    try {
      razorPay!.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  // apiCall(String paymentId, String orderId) async {
  //   LoaderDialog().showIndicator(context);
  //   var url = '${baseUrl()}/add_post';
  //
  //   print(url);
  //
  //   FormData formData = new FormData();
  //
  //   formData = FormData.fromMap({
  //     'user_id': userID,
  //     'location': selectedLocation.id ?? '',
  //     'start_date': adsToShow.startDate ?? '',
  //     'days': adsToShow.days ?? '',
  //     'status': '1',
  //     'redirect_link': adsToShow.redirectLink ?? '',
  //     'text': adsToShow.text,
  //     'payment_status': '1',
  //     'payment_id': paymentId,
  //     'order_id': orderId,
  //     "image": imageFile != null
  //         ? await MultipartFile.fromFile(imageFile!.path,
  //             filename: imageFile!.path.split('/').last,
  //             contentType: MediaType(
  //                 lookupMimeType(imageFile?.path ?? '')!.split('/').first,
  //                 imageFile!.path.split('.').last))
  //         : '',
  //   });
  //
  //   Dio().options.contentType = Headers.jsonContentType;
  //
  //   final response = await Dio().post(url,
  //       data: formData,
  //       options: Options(method: 'POST', responseType: ResponseType.json));
  //   print(response.data.toString());
  //
  //   LoaderDialog().hideIndicator(context);
  //   Navigator.pushAndRemoveUntil(
  //     context,
  //     MaterialPageRoute(builder: (context) => NavBar()),
  //     (Route<dynamic> route) => false,
  //   );
  //   // Navigator.pushAndRemoveUntil(
  //   //   context,
  //   //   MaterialPageRoute(builder: (context) => NavBar()),
  //   //   (Route<dynamic> route) => false,
  //   // );
  // }

  createAd(String paymentId, String orderId) async {
    LoaderDialog().showIndicator(context);
    var url = '${baseUrl()}/addnewad';
    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.fields.addAll({
      'user_id': userID ?? '',
      'location': selectedLocation.id ?? '',
      'start_date': adsToShow.startDate ?? '',
      'days': adsToShow.days ?? '',
      'status': '1',
      'mobile_number': adsToShow.mobileNumber ?? '',
      'text': adsToShow.text ?? '',
      'payment_status': '1',
      'payment_id': paymentId,
      'order_id': orderId,
    });
    print(request.fields);

    if (imageFile != null)
      request.files.add(
        await http.MultipartFile.fromPath(
          "image",
          imageFile!.path,
          contentType: MediaType("image", imageFile!.path.split(".").last),
        ),
      );

    print(request.files.length);

    var response = await request.send();
    LoaderDialog().hideIndicator(context);
    var data = json.decode(await response.stream.bytesToString());
    print(data);
    if (response.statusCode == 200) {
      if (data['response_code'] == '1') {
        socialootoast("Success", data['message'], context);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => NavBar()),
          (Route<dynamic> route) => false,
        );
      } else {
        socialootoast("Error", data['message'], context);
        // ScaffoldMessenger.of(context).showSnackBar(snackBar(data['message']));

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0.5,
        title: Text(
          "Create Ads",
          style: Theme.of(context).textTheme.headline5!.copyWith(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).appBarTheme.iconTheme!.color,
        ),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            Container(
              height: 43,
              child: FormField<String>(
                builder: (FormFieldState<String> state) {
                  return Container(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          color: Colors.transparent,
                          child: InputDecorator(
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10),
                                isDense: true,
                                // border: InputBorder.none,
                                filled: true,
                                fillColor: Theme.of(context)
                                    .inputDecorationTheme
                                    .fillColor,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 1.0),
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0))),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                isExpanded: true,
                                value: selectedLocation.id,
                                isDense: true,
                                hint: Padding(
                                  padding: const EdgeInsets.only(top: 0),
                                  child: Text(
                                    'Select Location',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 13),
                                  ),
                                ),
                                icon: Icon(Icons.keyboard_arrow_down_sharp),
                                onChanged: (newValue) {
                                  handleAdsLocation(newValue, context);
                                },
                                items: adsLocationList
                                    .map((AdsLocationModel item) {
                                  return DropdownMenuItem(
                                    child: Text(
                                      item.location ?? '',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 13),
                                    ),
                                    value: item.id,
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
            ),
            AdsEditTextField(
              validator: onlyRequiredValidate,
              controller: dateController,
              maxLines: 1,
              labelText: 'Start Date',
              readOnly: true,
              onTap: () async {
                String? date = await selectDate(context);
                if (date != null) {
                  adsToShow.startDate = date;
                  dateController.text = date;
                }
              },
              hint: 'Tap to select date',
            ),
            AdsEditTextField(
              validator: onlyRequiredValidate,
              onChanged: (input) {
                adsToShow.days = input.toString();
              },
              maxLines: 1,
              inputFormatterData: digitsInputFormatter(size: 3),
              keyBoard: TextInputType.number,
              labelText: 'Days',
              hint: 'Enter days',
            ),
            AdsEditTextField(
              validator: validateMobile,
              /*(value) {
                if (value.isEmpty)
                  return 'Field is required';
                else if (!isURL(value)) {
                  return 'Please enter a valid URL';
                }
                return null;
              },*/

              onChanged: (input) {
                adsToShow.mobileNumber = input.toString();
              },
              keyBoard: TextInputType.number,
              inputFormatterData: digitsInputFormatter(),
              labelText: 'Mobile Number',
              hint: 'Enter mobile number',
            ),
            AdsEditTextField(
              validator: onlyRequiredValidate,
              onChanged: (input) {
                adsToShow.text = input;
              },
              maxLines: 4,
              labelText: 'Message',
              hint: 'Enter message',
            ),
            SizedBox(height: 25),
            if (imageFile == null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Select Image'),
                  IconButton(
                    onPressed: () {
                      selectImageSource();
                    },
                    icon: Icon(
                      Icons.add_circle_outline,
                      size: 30,
                    ),
                  )
                ],
              ),
            if (imageFile != null)
              Padding(
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
                          imageFile!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              imageFile = null;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black45,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white)),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 25),
            InkWell(
              onTap: () {
                if (formKey.currentState!.validate()) {
                  if (selectedLocation.id != null &&
                      selectedLocation.id != '' &&
                      imageFile != null) {
                    createOrder();
                  } else {
                    if (imageFile == null)
                      socialootoast(
                          "Error", "Please select image first", context);
                    else
                      socialootoast(
                          "Error", "Please select location first", context);
                  }
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFF1246A5), Color(0xFF1e3c72)],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: selectedLocation.price == null
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Create Ad',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    if (selectedLocation.price != null)
                      Text(
                        '\u20B9${double.parse(selectedLocation.price ?? '0') * int.parse(adsToShow.days ?? '1')}',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  validateMobile(String? val) {
    if (val == null || val.isEmpty)
      return 'Mobile Number is Required';
    else if (val.length < 10)
      return 'Mobile number should be 10 digits';
    else
      return null;
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

class AdsEditTextField extends StatefulWidget {
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

  AdsEditTextField({
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
  _AdsEditTextFieldState createState() => _AdsEditTextFieldState();
}

class _AdsEditTextFieldState extends State<AdsEditTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
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
                      vertical: widget.vertical ?? 13.0,
                      horizontal: widget.horizontal ?? 10),
                  isDense: true,
                  hintText: widget.hint,
                  // border: InputBorder.none,
                  filled: true,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: widget.primaryColor ?? Colors.grey, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: widget.primaryColor ?? Colors.grey, width: 1.0),
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: widget.primaryColor ?? Colors.grey,
                          width: 1.0))),
            ),
          ),
        ],
      ),
    );
  }
}
