import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../global/global.dart';
import '../../models/adsToShow.dart';

class MyAds extends StatefulWidget {
  const MyAds({Key? key}) : super(key: key);

  @override
  _MyAdsState createState() => _MyAdsState();
}

class _MyAdsState extends State<MyAds> {
  List<AdsToShow> adsList = <AdsToShow>[];

  _getMyAdsToShow() async {
    var uri = Uri.parse('${baseUrl()}/getads?user_id=$userID');
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
    if (mounted)
      setState(() {
        if (userData['response_code'] == '1') {
          adsList.addAll(List<AdsToShow>.from(
              userData['ads'].map((item) => AdsToShow.fromJson(item))));
        }
      });
    print(responseData);
    print('irshad');

    print(json.encode(adsList));
  }

  startAd(adId) async {
    LoaderDialog().showIndicator(context);
    var uri = Uri.parse('${baseUrl()}/start_ad?ad_id=$adId&user_id=$userID');

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
        if (userData['response_code'] == '1') {
          for (AdsToShow ad in adsList) {
            if (adId == ad.adId) {
              ad.status = '1';
            }
          }
        }
      });
    print(responseData);
    print('irshad');
  }

  stopAd(adId) async {
    LoaderDialog().showIndicator(context);
    var uri = Uri.parse('${baseUrl()}/stop_ad?ad_id=$adId&user_id=$userID');

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
        if (userData['response_code'] == '1') {
          for (AdsToShow ad in adsList) {
            if (adId == ad.adId) {
              ad.status = '0';
            }
          }
        }
      });
    print(responseData);
    print('irshad');
  }

  // void launchURL(url) async =>
  // await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  @override
  void initState() {
    super.initState();
    _getMyAdsToShow();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0.5,
        title: Text(
          "My Ads",
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
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          Column(
            children: List.generate(adsList.length, (index) {
              AdsToShow ad = adsList[index];
              return Card(
                child: Stack(
                  children: [
                    InkWell(
                      // onTap: ad.mobileNumber != null && ad.mobileNumber != ''
                      //     ? () => launchURL("tel:" + ad.mobileNumber!)
                      //     : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (ad.image != null && ad.image != '')
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(6),
                                  topLeft: Radius.circular(6)),
                              child: CachedNetworkImage(
                                imageUrl: ad.image!,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                height: 80,
                                width: double.infinity,
                                placeholder: (context, url) => Center(
                                  child: Container(
                                      child: CircularProgressIndicator()),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                            )
                          else
                            Container(
                                height: 80,
                                width: double.infinity,
                                color: Colors.grey[200],
                                child: Icon(
                                  Icons.image,
                                  size: 35,
                                  color: Colors.grey[600],
                                )),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              children: [
                                SizedBox(height: 10.0),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 70,
                                      child: Text('Location',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(context)
                                                  .iconTheme
                                                  .color,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Flexible(
                                      child: Text(ad.locationNames ?? '',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(context)
                                                  .iconTheme
                                                  .color)),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 70,
                                      child: Text('Message',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(context)
                                                  .iconTheme
                                                  .color,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Flexible(
                                      child: Text(ad.text ?? '',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(context)
                                                  .iconTheme
                                                  .color)),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 70,
                                      child: Text('Status',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(context)
                                                  .iconTheme
                                                  .color,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Flexible(
                                      child: Text(
                                          ad.status == '1' ? "START" : 'STOP',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(context)
                                                  .iconTheme
                                                  .color)),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.8),
                                blurRadius: 2,
                                offset: Offset(-0.1, -0.1)),
                          ],
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () => startAd(ad.adId),
                              child: Container(
                                width: 45,
                                height: 22,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: ad.status == '1'
                                      ? Theme.of(context)
                                          .appBarTheme
                                          .backgroundColor
                                      : Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(3),
                                    bottomLeft: Radius.circular(3),
                                  ),
                                ),
                                child: Text(
                                  'START',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: ad.status == '1'
                                          ? Colors.white
                                          : null),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => stopAd(ad.adId),
                              child: Container(
                                width: 45,
                                height: 22,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: ad.status == '0'
                                      ? Theme.of(context)
                                          .appBarTheme
                                          .backgroundColor
                                      : Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(3),
                                    bottomRight: Radius.circular(3),
                                  ),
                                ),
                                child: Text(
                                  'STOP',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: ad.status == '0'
                                          ? Colors.white
                                          : null),
                                ),
                              ),
                            ),
                            // tglBtnTxt(context, 'OPEN',
                            //     txtColor: ad.status == '1'
                            //         ? null
                            //         : Theme.of(context)
                            //             .appBarTheme
                            //             .iconTheme!
                            //             .color,
                            //     backColor: ad.status == '1' ? null : null,
                            //     onTap: () {
                            //   if (ad.status == '1') {}
                            //   // widget.model.onOffFood(context, food.dishId!,
                            //   //     '1', index, widget.sellerId, 2);
                            // }),
                            // tglBtnTxt(context, 'CLOSE',
                            //     txtColor: ad.status == '1' ? null : null,
                            //     backColor: ad.status == '1' ? null : null,
                            //     onTap: () async {
                            //   if (ad.status == '1') {}
                            //   // widget.model.onOffFood(context, food.dishId!,
                            //   //     '0', index, widget.sellerId, 2);
                            // }),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// Widget tglBtnTxt(context, title,
//     {dynamic onTap, Color? backColor, Color? txtColor}) {
//   return InkWell(
//     onTap: onTap,
//     child: Container(
//       width: 45,
//       height: 22,
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         color: backColor ?? Theme.of(context).appBarTheme.backgroundColor,
//         borderRadius: BorderRadius.only(
//           topRight: Radius.circular(title == 'OPEN' ? 3 : 0),
//           bottomRight: Radius.circular(title == 'OPEN' ? 3 : 0),
//           topLeft: Radius.circular(title == 'CLOSE' ? 3 : 0),
//           bottomLeft: Radius.circular(title == 'CLOSE' ? 3 : 0),
//         ),
//       ),
//       child: Text(
//         title,
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           fontSize: 13,
//           color: txtColor,
//         ),
//       ),
//     ),
//   );
// }
