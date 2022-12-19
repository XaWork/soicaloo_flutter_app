import 'dart:async';
import 'dart:convert';

import 'package:blur/blur.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share/share.dart';
import 'package:socialoo/global/global.dart';
import 'package:socialoo/layouts/chat/chat.dart';
import 'package:socialoo/layouts/filter/searchpostmodel.dart';
import 'package:socialoo/layouts/user/google_sign_in.dart';
import 'package:socialoo/layouts/user/publicProfile.dart';
import 'package:socialoo/models/intrest_model.dart';
import 'package:socialoo/models/postFollowModal.dart';
import 'package:socialoo/models/search_user_model.dart';
import 'package:socialoo/models/unFollowModal.dart';
import 'package:timeago/timeago.dart';

import '../../models/followerPostModal.dart';
import '../../models/likeModal.dart';
import '../../models/unlikeModal.dart';
import '../post/comments.dart';
import '../post/viewPublicPost.dart';
import '../user/profile.dart';
import '../videoview/videoViewFix.dart';
import '../widgets/pdf_widget.dart';

class FilterView extends StatefulWidget {
  @override
  _FilterViewState createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController controller = new TextEditingController();

  // ignore: unused_field
  String? _categoryValue;
  String? categoryName;
  IntrestModel? intrestModel;
  bool isSearch = false;

  int? page = 1;
  bool pageloader = false;

  // bool isSearchData = false;
  bool clearData = false;
  String? stateValue;
  String? cityValue;
  String? gender;
  final TextEditingController fromDateCon = TextEditingController();
  final TextEditingController toDateCon = TextEditingController();
  String? fromDate;
  String? toDate;
  var gender1 = [
    'Male',
    'Female',
    'Other',
  ];

  double? _height, _width, _fixedPadding;

  // String? dropDownSelectedUser;
  // var dropDownUserList = ['People', 'User'];
  String? formType;
  var formTypeList = ['Found', 'Missing', 'Dead', 'People'];
  var formTypeList2 = [
    'Unclaimed Found Person',
    'Missing Person',
    'Unclaimed Dead Body',
    'User / Organization',
  ];

  double startAge = 0;
  double endAge = 100;
  RangeValues _age = RangeValues(0, 100);

  bool isLoading = false;

  // var userData;
  Map<String, dynamic>? serchedUserData;
  late FollowModal followModal;
  late UnfollowModal unfollowModal;

  // List userList = [];

  @override
  void initState() {
    // _getintrest();

    super.initState();
    // dropDownSelectedUser = dropDownUserList[0];
    formType = formTypeList[1];
    searchedPost();
  }

  // _getTopUser() async {
  //   setState(() {
  //     isSearch = true;
  //   });
  //   var uri = Uri.parse('${baseUrl()}/get_all_users');
  //   var request = new http.MultipartRequest("POST", uri);
  //   Map<String, String> headers = {
  //     "Accept": "application/json",
  //   };
  //   request.headers.addAll(headers);
  //   request.fields['user_id'] = userID!;
  //   var response = await request.send();
  //   print(response.statusCode);
  //   String responseData = await response.stream.transform(utf8.decoder).join();
  //   userData = json.decode(responseData);
  //   print('???????????');
  //   print(userData);
  //
  //   setState(() {
  //     isSearch = false;
  //   });
  // }
  List<Post> allPost = <Post>[];
  FollowerPostModal? modal;

  SearchUserModel userData = SearchUserModel();
  var homedata = true;

  // List<SearchUserModel> usersList = <SearchUserModel>[];
  int pageNum = 1;
  bool isPageLoading = false;
  List<SearchPost> dataList = [];
  ScrollController _scrollController = ScrollController();
  int totalRecord = 0;

  Future<List<SearchPost>> searchedPost() async {
    setState(() {
      isSearch = true;
      homedata = false;
    });

    log("searching post");
    try {
      final response = await client
          .post(Uri.parse('${baseUrl()}/search_post?skip=0&limit=10'), body: {
        'user_id': userID ?? '',
        'search_type': formType?.toLowerCase() ?? '',
        'text': controller.text,
        'name': (formType == 'Missing' ||
                formType == 'People' ||
                formType == 'Dead')
            ? controller.text
            : '',
        'gender': gender ?? '',
        'date_from': fromDate ?? '',
        'date_to': toDate ?? '',
        'country': 'india',
        'state': stateValue ?? '',
        'city': cityValue ?? '',
        "age": '${startAge.round().toString()}-${endAge.round().toString()}'
      });
      print(response.body);
      if (response.statusCode == 200) {
        print("success");
        dataList.clear();
        print("cleared");
        final data = jsonDecode(response.body)['post'];
        print("decoded");
        for (var each in data) {
          dataList.add(SearchPost.fromJson(each));
        }
        print(data[1]);
        print("data added");
        print(dataList);
        print(dataList.length);
      } else {
        log(response..statusCode.toString());
      }
      print("saved data");
    } catch (e) {
      log("unable to fetch post");
    }
    setState(() {
      isSearch = false;
    });
    return dataList;
  }

  _getserchedPost() async {
    print('asdfgjhgfd');
    setState(() {
      isSearch = true;
    });
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    var request =
        http.MultipartRequest('POST', Uri.parse('${baseUrl()}/search_post'));
    request.fields.addAll({
      'user_id': userID ?? '',
      'search_type': formType?.toLowerCase() ?? '',
      'text': controller.text,
      'name': (formType == 'Missing' || formType == 'People')
          ? controller.text
          : '',
      'gender': gender ?? '',
      'date_from': fromDate ?? '',
      'date_to': toDate ?? '',
      'country': 'india',
      'state': stateValue ?? '',
      'city': cityValue ?? '',
      "age": '${startAge.round().toString()}-${endAge.round().toString()}'
    });
    print(request.fields);

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print(response.statusCode);

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      // serchedUserData = json.decode(await response.stream.bytesToString());
      modal = FollowerPostModal.fromJson(
          json.decode(await response.stream.bytesToString()));
      // print(modal!.post!.length);
      print('asdfgjhgfd');

      setState(() {
        isSearch = false;
        print('asdfgjhgfd');
        print(allPost.length);
        for (int i = 0; i < modal!.post!.length; i++) {
          allPost.add(modal!.post![i]);
        }
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  // void func(page1) async {
  //   int? value = page1 + 10;
  //   int noValue = page1;
  //   if (modal!.responseCode != '0') {
  //     print('if');
  //     setState(() {
  //       page = value;
  //       pageloader = true;
  //     });
  //   } else {
  //     setState(() {
  //       page = noValue;
  //       pageloader = false;
  //     });
  //   }
  // }

  _getserchedUser() async {
    closeKeyboard();
    setState(() {
      isSearch = true;
      homedata = true;
    });
    var uri = Uri.parse('${baseUrl()}/users_filter');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    // request.fields['interests_id'] =
    //     _categoryValue != null ? _categoryValue.toString() : '';
    request.fields['name'] = controller.text.toLowerCase();
    request.fields['country'] = 'India';
    request.fields['age'] =
        '${startAge.round().toString()},${endAge.round().toString()}';
    request.fields['gender'] = gender != null ? gender! : '';
    request.fields['state'] = stateValue != null ? stateValue! : '';
    request.fields['city'] = cityValue ?? '';
    request.fields['from_date'] = fromDate ?? '';
    request.fields['to_date'] = toDate ?? '';
    print(request.fields);
    var response = await request.send();

    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    serchedUserData = json.decode(responseData);
    print(serchedUserData);
    if (serchedUserData!['response_code'] == '1') {
      userData = SearchUserModel.fromJson(serchedUserData!);
      // usersList.addAll(List<SearchUserModel>.from(serchedUserData!['users']
      //     .map((item) => SearchUserModel.fromJson(item))));
    }

    setState(() {
      isSearch = false;
    });
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
      initialDate: DateTime(now.year, now.month, now.day - 1),
      firstDate: DateTime(now.year - 72),
      lastDate: DateTime(now.year, now.month, now.day - 1),
    );
    if (picked != null) {
      _dateTime = picked;
      dateString = '${myFormat.format(_dateTime).substring(0, 10)}';
      return dateString;
    }
    return null;
  }

  Future selectToDate(BuildContext context) async {
    final now = DateTime.now();
    DateTime _dateTime = DateTime(now.year, now.month, now.day);
    DateTime firstDate = DateTime(
      int.parse(fromDate!.substring(6, 10)),
      int.parse(fromDate!.substring(3, 5)),
      int.parse(fromDate!.substring(0, 2)),

      // int.parse(fromDate!.substring(0, 4)),
      // int.parse(fromDate!.substring(5, 7)),
      // int.parse(fromDate!.substring(8, 10))
    );
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
      initialDate: DateTime(
        int.parse(fromDate!.substring(6, 10)),
        int.parse(fromDate!.substring(3, 5)),
        int.parse(fromDate!.substring(0, 2)),
      ),
      firstDate: firstDate /*DateTime(now.year - 2)*/,
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
    // SizeConfig().init(context);
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0.5,
          title: Text(
            "Search",
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
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    filterWidget(context),
                    isSearch == true
                        ? SizedBox(
                            height: 100,
                            child: Center(child: CupertinoActivityIndicator()))
                        : homedata
                            ? _serachuser()
                            : searchBody(),
                  ],
                ),
              ));
  }

  Widget searchBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          primary: false,
          itemCount: dataList.length,
          itemBuilder: ((context, index) {
            return Card(
              child: Container(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      print('asdfghjsdfg');
                      if (userID == dataList[index].userId) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Profile(back: true)),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PublicProfile(
                                    peerId: dataList[index].userId,
                                    peerUrl: dataList[index].profilePic,
                                    peerName: dataList[index].username,
                                  )),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: dataList[index].profilePic == null ||
                                        dataList[index].profilePic!.isEmpty
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF003a54),
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        child: Image.asset(
                                          'assets/images/defaultavatar.png',
                                          width: 55,
                                          height: 55,
                                        ),
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: dataList[index]
                                            .profilePic
                                            .toString(),
                                        height: 55.0,
                                        width: 55.0,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              SizedBox(
                                width:
                                    (MediaQuery.of(context).size.width / 100) *
                                        2,
                              ),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        dataList[index].username.toString(),
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                int.parse(dataList[index]
                                                    .createDate!)),
                                            locale: 'en_short'),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .copyWith(
                                              fontSize: 12.0,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 05),
                            child: Column(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    reportPostData = null;
                                    reportSheet(
                                      context,
                                      dataList[index].postId,
                                      dataList[index].bookmark,
                                      dataList[index].userId,
                                    );
                                  },
                                  icon: Icon(Icons.more_horiz),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  dataList[index].text != ""
                      ? Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text('${dataList[index].text}'))
                      : Container(),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ViewPublicPost(id: dataList[index].postId)),
                      );
                    },
                    child: Container(
                      // height: (MediaQuery.of(context).size.height / 100) * 40,
                      width: MediaQuery.of(context).size.width,
                      child: dataList[index].deadData != null
                          ? CachedNetworkImage(
                              imageUrl: dataList[index].allImage![0],
                              placeholder: (context, url) => Center(
                                child: Container(
                                    child: CircularProgressIndicator()),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ).blurred(blur: 20)
                          : CachedNetworkImage(
                              imageUrl: dataList[index].allImage![0],
                              placeholder: (context, url) => Center(
                                child: Container(
                                    child: CircularProgressIndicator()),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                    ),
                  ),
                  SizedBox(height: 10),
                  if (dataList[index].missingData != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        'Missing Person ${dataList[index].missingData?.fullName ?? ''}, ${dataList[index].missingData?.gender ?? ''}, ${dataList[index].missingData?.age ?? ''} Year old, ${dataList[index].missingData?.dateMissing ?? ''}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  if (dataList[index].deadData != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        'Dead Person ${dataList[index].deadData?.fullName ?? ''}, ${dataList[index].deadData?.gender ?? ''}, ${dataList[index].deadData?.age ?? ''} Year old, ${dataList[index].deadData?.dateFound ?? ''}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  if (dataList[index].foundData != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        'Found Person ${dataList[index].foundData?.fullName ?? ''}, ${dataList[index].foundData?.gender ?? ''}, ${dataList[index].foundData?.age ?? ''} Year old, ${dataList[index].foundData?.date ?? ''}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  '${dataList[index].totalLikes.toString()} Likes',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                ),
                                const SizedBox(width: 5.0),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                GestureDetector(
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          int? commentL = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CommentsScreen(
                                                        postID: dataList[index]
                                                            .postId)),
                                          );
                                          if (commentL != null) {
                                            setState(() {
                                              dataList[index].totalComments =
                                                  commentL;
                                            });
                                          }
                                        },
                                        child: Text(
                                          dataList[index]
                                                  .totalComments
                                                  .toString() +
                                              " Comments",
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 5.0),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              dataList[index].isLikes == "true"
                                  ? InkWell(
                                      onTap: () {
                                        setState(() {
                                          dataList[index].isLikes = "false";
                                          dataList[index].totalLikes =
                                              dataList[index].totalLikes! - 1;
                                          _unlikePost(dataList[index].postId!);
                                        });
                                        print("Unlike Post");
                                      },
                                      child: Icon(
                                        CupertinoIcons.heart_fill,
                                        size: 20,
                                        color: Colors.red,
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        print("Like Post");
                                        setState(() {
                                          dataList[index].totalLikes =
                                              dataList[index].totalLikes! + 1;
                                          dataList[index].isLikes = "true";
                                          _likePost(dataList[index].postId!);
                                        });
                                      },
                                      child: Icon(
                                        CupertinoIcons.heart,
                                        color:
                                            Theme.of(context).iconTheme.color,
                                        size: 20,
                                      ),
                                    ),
                              SizedBox(
                                width: 5,
                              ),
                              CustomTextStyle1(
                                title: ' Like',
                                weight: FontWeight.w500,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              SizedBox(width: 5.0),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              GestureDetector(
                                  onTap: () async {
                                    int? commentL = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CommentsScreen(
                                              postID: dataList[index].postId)),
                                    );

                                    if (commentL != null) {
                                      setState(() {
                                        dataList[index].totalComments =
                                            commentL;
                                      });
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/images/comment.svg",
                                        height: 20,
                                        color:
                                            Theme.of(context).iconTheme.color,
                                      ),
                                      const SizedBox(width: 5.0),
                                      Text('Comment',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                          )),
                                    ],
                                  )),
                              const SizedBox(width: 5.0),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  chooseShareOption(context, dataList[index]);
                                },
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/share.svg",
                                      height: 20,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    const SizedBox(width: 5.0),
                                    Text(
                                      'Share',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color:
                                            Theme.of(context).iconTheme.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 5.0),
                            ],
                          )
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(bottom: 10.0))
                    ],
                  )
                ],
              )),
            );
          })),
    );
  }

  Widget _serachuser() {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          if (serchedUserData?['users'] != null &&
              formType == 'People' &&
              userData.users.isNotEmpty)
            ListView.builder(
              primary: false,
              // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //     crossAxisCount: 2,
              //     // childAspectRatio: 200 / 200,
              //     crossAxisSpacing: 5),
              itemCount: userData.users.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, int index) {
                return allUserWidget(userData.users[index]);
              },
            )
          else if (allPost.length > 0)
            new ListView.builder(
              itemCount: allPost.length,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, index) {
                return Card(
                  child: _bodyData(allPost[index]),
                );
              },
            )
          else
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Center(
                child: Text("No search found"),
              ),
            )
        ],
      ),
    );
  }

  Widget allUserWidget(Users user) {
    print(user.coverPic);
    print(user.profilePic);
    return user.id == userID
        ? Container()
        : Padding(
            padding: const EdgeInsets.only(bottom: 12.0, left: 10, right: 10),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PublicProfile(
                            peerId: user.id,
                            peerUrl: user.profilePic,
                            peerName: user.username)));
              },
              child: Row(
                children: [
                  user.profilePic != null && user.profilePic != ''
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(45.0),
                          child: CachedNetworkImage(
                            imageUrl: user.profilePic ?? '',
                            height: 90.0,
                            width: 90.0,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF003a54),
                            borderRadius: BorderRadius.circular(45.0),
                          ),
                          child: Image.asset(
                            'assets/images/defaultavatar.png',
                            width: 90,
                          ),
                        ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.username?.toString().capitalize() ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(fontSize: 18),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        if (user.country != null && user.country != '' ||
                            user.state != null && user.state != '' ||
                            user.city != null && user.city != '')
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              "${user.city ?? ''}, ${user.state ?? ''}, ${user.country ?? ''}",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        Row(
                          children: [
                            Expanded(
                              child: globleFollowing.contains(user.id)
                                  ? Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent[700],
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(5.0),
                                        ),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Unfollow',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 12,
                                            letterSpacing: 0.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ).onTap(() {
                                      unfollowApiCall(user);
                                    })
                                  : Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF0D56F2),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(5.0),
                                        ),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Follow',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 12,
                                            letterSpacing: 0.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ).onTap(() {
                                      followApiCall(user);
                                    }),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: Color(0xffE5E6EB),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Message',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      letterSpacing: 0.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ).onTap(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Chat(
                                      peerID: user.id,
                                      peerUrl: user.profilePic,
                                      peerName: user.username,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget filterWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "Age:  ${startAge.round().toString()}-${endAge.round().toString()}",
                      style: TextStyle(fontSize: 12),
                    ),
                    SliderTheme(
                      data: SliderThemeData(
                          showValueIndicator: ShowValueIndicator.always),
                      child: RangeSlider(
                        values: _age,
                        min: 0,
                        max: 100,
                        labels: RangeLabels('${_age.start.round()}' + " yrs",
                            '${_age.end.round()}' + " yrs"),
                        inactiveColor: Colors.grey,
                        activeColor: Color(0xFF0D56F2),
                        onChanged: (RangeValues values) {
                          setState(() {
                            _age = values;
                            startAge = _age.start;
                            endAge = _age.end;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(height: 0),
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
                            enabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
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
                                const EdgeInsets.fromLTRB(10, 8, 10, 8),
                            filled: true,
                            fillColor: Color(0xFFEAF1F6),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              isExpanded: true,
                              value: formType,
                              isDense: true,
                              hint: Padding(
                                padding: const EdgeInsets.only(top: 0),
                                child: Text(
                                  'Form Type',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 13),
                                ),
                              ),
                              icon: Icon(Icons.keyboard_arrow_down_sharp),
                              onChanged: (String? newValue) {
                                setState(() {
                                  formType = newValue;
                                  state.didChange(newValue);
                                });
                              },
                              items: formTypeList.map((item) {
                                return new DropdownMenuItem(
                                  child: new Text(
                                    formTypeList2[formTypeList.indexOf(item)],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 13),
                                  ),
                                  value: item,
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
          SizedBox(height: 5),
          Row(
            children: [
              if ((formType == 'Missing' ||
                  formType == 'People' ||
                  formType == 'Dead'))
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Container(
                      height: 43,
                      child: TextField(
                        controller: controller,
                        style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                            fontSize: 13),
                        decoration: InputDecoration(
                          hintText: "Search by Name",
                          hintStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1),
                          ),
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.fromLTRB(16, 12, 16, 12),
                          filled: true,
                          fillColor: Color(0xFFEAF1F6),
                        ),
                      ),
                    ),
                  ),
                ),
              // Container(width: 10),
              Expanded(
                child: Container(
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
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1),
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
                                      const EdgeInsets.fromLTRB(10, 8, 10, 8),
                                  filled: true,
                                  fillColor: Color(0xFFEAF1F6),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    value: gender,
                                    isDense: true,
                                    hint: Padding(
                                      padding: const EdgeInsets.only(top: 0),
                                      child: Text(
                                        'Gender',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 13),
                                      ),
                                    ),
                                    icon: Icon(Icons.keyboard_arrow_down_sharp),
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
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13),
                                        ),
                                        value: item,
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
              ),
            ],
          ),
          Container(height: 5),
          clearData == false
              ? CSCPicker(
                  flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
                  showCities: true,
                  showStates: true,
                  defaultCountry: DefaultCountry.India,
                  disableCountry: true,
                  cityDropdownLabel: 'District',
                  dropdownItemStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black
                        : Colors.black,
                    fontSize: 13,
                  ),
                  dropdownHeadingStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                  selectedItemStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                  ),
                  disabledDropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color(0xFFEAF1F6),
                      border: Border.all(color: Colors.grey, width: 1)),
                  dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Color(0xFFEAF1F6)
                          : Color(0xFFEAF1F6),
                      border: Border.all(color: Colors.grey, width: 1)),
                  onStateChanged: (value) {
                    setState(() {
                      stateValue = value;
                    });
                  },
                  onCityChanged: (value) {
                    setState(() {
                      cityValue = value;
                    });
                  },
                )
              : Container(
                  height: 43,
                  child: Center(child: const CupertinoActivityIndicator()),
                ),
          Container(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 43,
                  child: TextField(
                    controller: fromDateCon,
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 13),
                    readOnly: true,
                    onTap: () async {
                      String? date = await selectDate(context);
                      if (date != null) {
                        fromDateCon.text = date;
                        fromDate = date;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "From Date",
                      hintStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      filled: true,
                      fillColor: Color(0xFFEAF1F6),
                    ),
                  ),
                ),
              ),
              Container(width: 10),
              Expanded(
                child: Container(
                  height: 43,
                  child: TextField(
                    controller: toDateCon,
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 13),
                    readOnly: true,
                    onTap: () async {
                      if (fromDate != null && fromDate != '') {
                        String? date = await selectToDate(context);
                        if (date != null) {
                          toDateCon.text = date;
                          toDate = date;
                        }
                      } else {
                        socialootoast(
                            "Error", "Please select from date first", context);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "To Date",
                      hintStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      filled: true,
                      fillColor: Color(0xFFEAF1F6),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 43,
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
                    'Search',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ).onTap(
                  () {
                    if (formType == 'People') {
                      setState(() {
                        isSearch = true;
                        userData = SearchUserModel();
                      });
                      _getserchedUser();
                    } else {
                      // if (controller.text != '' &&
                      //     gender != null &&
                      //     gender != '' &&
                      //     stateValue != null &&
                      //     stateValue != '' &&
                      //     cityValue != null &&
                      //     cityValue != '' &&
                      //     toDate != null &&
                      //     toDate != '' &&
                      //     fromDate != null &&
                      //     fromDate != '') {
                      //_getserchedPost(page);
                      searchedPost();
                      // } else {
                      //   socialootoast(
                      //       "Error", "All fields are mandatory", context);
                      // }
                    }
                  },
                ),
              ),
              Container(width: 10),
              Expanded(
                child: Container(
                  height: 43,
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
                    'Clear Filters',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ).onTap(
                  () {
                    setState(() {
                      clearData = true;
                      // isSearchData = false;
                      isSearch = true;
                      _age = RangeValues(18, 99);
                      startAge = 18;
                      endAge = 99;
                      controller.clear();
                      gender = null;
                      stateValue = null;
                      cityValue = null;
                      // dropDownSelectedUser = dropDownUserList[0];
                      formType = formTypeList[0];
                    });
                    startTime();
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 0, right: 20, top: 10, bottom: 5),
            child: Container(
              height: 1,
              color: Colors.grey[400],
            ),
          )
        ],
      ),
    );
  }

  startTime() async {
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, navigationPage);
  }

  navigationPage() {
    setState(() {
      isSearch = false;
      clearData = false;
    });
  }

  followApiCall(Users user) async {
    var uri = Uri.parse('${baseUrl()}/follow_user');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['from_user'] = userID!;
    request.fields['to_user'] = user.id ?? '';
    var response = await request.send();
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    followModal = FollowModal.fromJson(userData);
    if (followModal.responseCode == "1") {
      setState(() {
        globleFollowing.add(user.id);
      });
    }
  }

  unfollowApiCall(Users user) async {
    var uri = Uri.parse('${baseUrl()}/unfollow_user');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['from_user'] = userID!;
    request.fields['to_user'] = user.id ?? '';
    var response = await request.send();
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    unfollowModal = UnfollowModal.fromJson(userData);
    if (unfollowModal.responseCode == "1") {
      setState(() {
        globleFollowing.remove(user.id);
      });
    }
  }

  //////////////////

  var reportPostData;

  Widget _bodyData(Post post) {
    return post.postReport != 'true' && post.profileBlock != 'true'
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  print('asdfghjsdfg');
                  if (userID == post.userId) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Profile(back: true)),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PublicProfile(
                                peerId: post.userId,
                                peerUrl: post.profilePic,
                                peerName: post.username,
                              )),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30.0),
                            child: post.profilePic == null ||
                                    post.profilePic!.isEmpty
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF003a54),
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: Image.asset(
                                      'assets/images/defaultavatar.png',
                                      width: 55,
                                      height: 55,
                                    ),
                                  )
                                : CachedNetworkImage(
                                    imageUrl: post.profilePic!,
                                    height: 55.0,
                                    width: 55.0,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          SizedBox(
                            width:
                                (MediaQuery.of(context).size.width / 100) * 2,
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    post.username == ""
                                        ? "No name"
                                        : post.username!.capitalize(),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            int.parse(post.createDate!)),
                                        locale: 'en_short'),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                          fontSize: 12.0,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 05),
                        child: Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                reportPostData = null;
                                reportSheet(
                                  context,
                                  post.postId,
                                  post.bookmark,
                                  post.userId,
                                );
                              },
                              icon: Icon(Icons.more_horiz),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              post.text != ""
                  ? Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text('${post.text}'))
                  : Container(),
              SizedBox(height: 10),
              postContentWidget(post),
              SizedBox(height: 10),
              if (post.missingData != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    'Missing Person ${post.missingData?.fullName ?? ''}, ${post.missingData?.gender ?? ''}, ${post.missingData?.age ?? ''} Year old, ${post.missingData?.dateMissing ?? ''}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              if (post.deadData != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    'Dead Person ${post.deadData?.fullName ?? ''}, ${post.deadData?.gender ?? ''}, ${post.deadData?.age ?? ''} Year old, ${post.deadData?.dateFound ?? ''}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              if (post.foundData != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    'Found Person ${post.foundData?.fullName ?? ''}, ${post.foundData?.gender ?? ''}, ${post.foundData?.age ?? ''} Year old, ${post.foundData?.date ?? ''}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

              // if (post.missingData != null)
              //   Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 10.0),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Text('${post.missingData?.fullName ?? ''}',
              //             style: TextStyle(
              //                 fontSize: 14,
              //                 color: Theme.of(context).iconTheme.color)),
              //         Text(
              //             '${post.missingData?.age} Y / ${post.missingData?.gender}',
              //             style: TextStyle(
              //                 fontSize: 14,
              //                 color: Theme.of(context).iconTheme.color)),
              //       ],
              //     ),
              //   ),

              // if (post.deadData != null)
              //   Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 10.0),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Text('${post.deadData?.fullName ?? ''}',
              //             style: TextStyle(
              //                 fontSize: 14,
              //                 color: Theme.of(context).iconTheme.color)),
              //         Text('${post.deadData?.age} Y / ${post.deadData?.gender}',
              //             style: TextStyle(
              //                 fontSize: 14,
              //                 color: Theme.of(context).iconTheme.color)),
              //       ],
              //     ),
              //   ),
              // if (post.missingData != null)
              //   Padding(
              //     padding: const EdgeInsets.only(left: 10.0, top: 10),
              //     child: Text('${post.missingData?.dateMissing ?? ''}',
              //         style: TextStyle(
              //             fontSize: 14,
              //             color: Theme.of(context).iconTheme.color)),
              //   ),
              // if (post.deadData != null)
              //   Padding(
              //     padding: const EdgeInsets.only(left: 10.0, top: 10),
              //     child: Text('${post.deadData?.dateFound ?? ''}',
              //         style: TextStyle(
              //             fontSize: 14,
              //             color: Theme.of(context).iconTheme.color)),
              //   ),
              // if (post.missingData != null || post.deadData != null)
              //   const Divider(height: 30.0),
              SizedBox(height: 10),
              footerWidget(post),
            ],
          )
        : Container();
  }

  late LikeModal likeModal;

  _likePost(String postid) async {
    var uri = Uri.parse('${baseUrl()}/like_post');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['post_id'] = postid;
    request.fields['user_id'] = userID!;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    likeModal = LikeModal.fromJson(userData);
    print(responseData);

    if (likeModal.responseCode == "1") {
      likedPost = [];
      setState(() {
        likedPost.add(postid);
      });
    }
  }

  postContentWidget(post) {
    bool isimage = post.allImage!.length > 0;
    bool isvideo = post.video != "";
    bool ispdf = post.pdf != "";
    bool istext = post.video == "" &&
        post.pdf == "" &&
        post.allImage!.length == 0 &&
        post.text != "";
    if (isimage) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewPublicPost(id: post.postId)),
          );
          print('tapped');
        },
        onDoubleTap: () {
          if (post.isLikes == "false") {
            setState(() {
              post.dataV = true;
              post.isLikes = "true";
              post.totalLikes = post.totalLikes! + 1;
              _likePost(post.postId!);
            });
            var _duration = new Duration(milliseconds: 500);
            Timer(_duration, () {
              post.dataV = false;
            });
            print('dataV : ${post.dataV}');
          }
        },
        child: Stack(
          children: [
            Container(
              // height: (MediaQuery.of(context).size.height / 100) * 40,
              width: MediaQuery.of(context).size.width,
              child: post.deadData != null
                  ? CachedNetworkImage(
                      imageUrl: post.allImage![0],
                      placeholder: (context, url) => Center(
                        child: Container(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ).blurred(blur: 20)
                  : CachedNetworkImage(
                      imageUrl: post.allImage![0],
                      placeholder: (context, url) => Center(
                        child: Container(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
              // child: Swiper.children(
              //   autoplay: false,
              //   pagination: const SwiperPagination(
              //       margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
              //       builder: DotSwiperPaginationBuilder(
              //           color: Colors.white30,
              //           activeColor: Colors.white,
              //           size: 20.0,
              //           activeSize: 20.0)),
              //   children: post.allImage!.map((it) {
              //     return ClipRRect(
              //       child: ZoomOverlay(
              //         twoTouchOnly: true,
              //         child: CachedNetworkImage(
              //           imageUrl: it,
              //           imageBuilder: (context, imageProvider) => Container(
              //             decoration: BoxDecoration(
              //               image: DecorationImage(
              //                 image: imageProvider,
              //                 fit: BoxFit.contain,
              //               ),
              //             ),
              //           ),
              //           placeholder: (context, url) => Center(
              //             child:
              //                 Container(child: CircularProgressIndicator()),
              //           ),
              //           errorWidget: (context, url, error) =>
              //               Icon(Icons.error),
              //           fit: BoxFit.cover,
              //         ),
              //       ),
              //     );
              //   }).toList(),
              // ),
            ),
            post.dataV == true
                ? Positioned.fill(
                    child: AnimatedOpacity(
                        opacity: post.dataV! ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 700),
                        child: Icon(
                          CupertinoIcons.heart_fill,
                          color: Colors.red,
                          size: 100,
                        )))
                : Container(),
          ],
        ),
      );
    } else if (isvideo) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewPublicPost(id: post.postId)),
          );
          print('tapped');
        },
        child: VideoViewFix(
            url: post.video, play: true, id: post.postId, mute: false),
      );
    } else if (ispdf) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewPublicPost(id: post.postId)),
          );
          print('tapped');
        },
        child: PdfWidget(
          pdf: post.pdf,
          pdfName: post.pdf_name,
          pdfSize: post.pdf_size,
        ),
      );
    } else if (istext) {
      return Container();
    }
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ViewPublicPost(id: post.postId)),
        );
        print('tapped');
      },
      child: Container(
          height: 230,
          width: double.infinity,
          color: Colors.grey[200],
          child: Icon(
            Icons.image,
            size: 200,
            color: Colors.grey[600],
          )),
    );
  }

  late UnlikeModal unlikeModal;

  _unlikePost(String postid) async {
    var uri = Uri.parse('${baseUrl()}/unlike_post');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['post_id'] = postid;
    request.fields['user_id'] = userID!;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    unlikeModal = UnlikeModal.fromJson(userData);
    print(responseData);

    if (unlikeModal.responseCode == "1") {
      likedPost = [];
      setState(() {
        likedPost.add(postid);
      });
    }
  }

  footerWidget(post) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    '${post.totalLikes.toString()} Likes',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  const SizedBox(width: 5.0),
                ],
              ),
              Row(
                children: <Widget>[
                  GestureDetector(
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            int? commentL = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CommentsScreen(postID: post.postId)),
                            );
                            if (commentL != null) {
                              setState(() {
                                post.totalComments = commentL;
                              });
                            }
                          },
                          child: Text(
                            post.totalComments.toString() + " Comments",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5.0),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 25.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                post.isLikes == "true"
                    ? InkWell(
                        onTap: () {
                          setState(() {
                            post.isLikes = "false";
                            post.totalLikes = post.totalLikes! - 1;
                            _unlikePost(post.postId!);
                          });
                          print("Unlike Post");
                        },
                        child: Icon(
                          CupertinoIcons.heart_fill,
                          size: 20,
                          color: Colors.red,
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          print("Like Post");
                          setState(() {
                            post.totalLikes = post.totalLikes! + 1;
                            post.isLikes = "true";
                            _likePost(post.postId!);
                          });
                        },
                        child: Icon(
                          CupertinoIcons.heart,
                          color: Theme.of(context).iconTheme.color,
                          size: 20,
                        ),
                      ),
                SizedBox(
                  width: 5,
                ),
                CustomTextStyle1(
                  title: ' Like',
                  weight: FontWeight.w500,
                  color: Theme.of(context).iconTheme.color,
                ),
                SizedBox(width: 5.0),
              ],
            ),
            Row(
              children: <Widget>[
                GestureDetector(
                    onTap: () async {
                      int? commentL = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CommentsScreen(postID: post.postId)),
                      );

                      if (commentL != null) {
                        setState(() {
                          post.totalComments = commentL;
                        });
                      }
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/images/comment.svg",
                          height: 20,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        const SizedBox(width: 5.0),
                        Text('Comment',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Theme.of(context).iconTheme.color,
                            )),
                      ],
                    )),
                const SizedBox(width: 5.0),
              ],
            ),
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    chooseShareOption(context, post);
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/images/share.svg",
                        height: 20,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      const SizedBox(width: 5.0),
                      Text(
                        'Share',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5.0),
              ],
            )
          ],
        ),
        const Padding(padding: EdgeInsets.only(bottom: 10.0))
      ],
    );
  }

  chooseShareOption(BuildContext context, post) {
    showModalBottomSheet(
      isScrollControlled: true,
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
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 10),
              Center(
                  child: Text(
                'Choose Option',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(fontWeight: FontWeight.bold),
              )),
              SizedBox(height: 10),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true)
                            .pop("Discard");
                        sharePost(post.postId, post.userId);
                      },
                      title: new Text(
                        "Share to your own profile",
                        style: new TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15.0),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true)
                            .pop("Discard");
                        _onShare(context, post.video, post.image, post.text,
                            post.pdf);
                        // _reportPost(
                        //     postId, reportType, 'I just don\'t like it');
                      },
                      title: new Text(
                        "Share to other media",
                        style: new TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15.0),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
      },
    );
  }

  sharePost(postID, postOwnerId) async {
    var uri = Uri.parse('${baseUrl()}/share_post');
    print(uri.path);
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    request.headers.addAll(headers);
    // request.fields['user_id'] = id;
    request.fields.addAll({
      'user_id': userID ?? '',
      'post_id': postID,
      'post_owner_id': postOwnerId
    });
    print(request.fields);

    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    Map<String, dynamic> userData = json.decode(responseData);

    if (userData['response_code'] == '1') {
      Fluttertoast.showToast(msg: userData['message']);
    } else {
      socialootoast("Error", userData['message'], context);
    }
    print(userData);
  }

  _onShare(BuildContext context, video, image, text, pdf) async {
    bool isPhoto = image?.isNotEmpty == true;
    bool isvideo = video?.isNotEmpty == true;
    bool ispdf = pdf?.isNotEmpty == true;
    final RenderBox? box = context.findRenderObject() as RenderBox?;

    if (isPhoto) {
      await Share.share(image[0],
          subject: text,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    } else if (isvideo) {
      await Share.share(video,
          subject: text,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    } else if (ispdf) {
      await Share.share(pdf,
          subject: text,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    }
  }

  bool stackLoader = false;

  TextEditingController _textFieldController = TextEditingController();

  _reportPost(postId, status, reportTxt) async {
    print(status);
    setState(() {
      stackLoader = true;
    });

    var uri = Uri.parse('${baseUrl()}/posts_report');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['blockedByUserId'] = userID!;
    request.fields['blockedPostsId'] = postId;
    request.fields['status'] = status;
    request.fields['report_text'] = reportTxt;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    reportPostData = json.decode(responseData);
    if (reportPostData['response_code'] == '1') {
      setState(() {
        stackLoader = false;
        _textFieldController.clear();
      });

      allPost.removeWhere((item) => item.postId == postId);
    } else {
      allPost.removeWhere((item) => item.postId == postId);
      setState(() {
        stackLoader = false;
      });

      print('REPORT RESPONSE FAIL');
      debugPrint('${reportPostData['response_code']}');
    }
    openHideSheet(context, status);
    // deleteStoryModal = DeleteStoryModal.fromJson(userData);
    print(responseData);

    setState(() {
      stackLoader = false;
    });
  }

  _blockUser(blockedUserId) async {
    print(blockedUserId);
    setState(() {
      stackLoader = true;
    });

    var uri = Uri.parse('${baseUrl()}/profile_block');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['blockedByUserId'] = userID!;
    request.fields['blockedUserId'] = blockedUserId;

    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var reportPostData = json.decode(responseData);
    if (reportPostData['response_code'] == '1') {
      setState(() {
        stackLoader = false;
      });
      allPost.removeWhere((item) => item.userId == blockedUserId);

      Fluttertoast.showToast(
          msg: 'User Blocked', toastLength: Toast.LENGTH_LONG);
    } else {
      Fluttertoast.showToast(msg: 'Fail to block');
    }

    print(responseData);

    setState(() {
      stackLoader = false;
    });
  }

  _addBookmark(String postid) async {
    var uri = Uri.parse('${baseUrl()}/bookmark_post');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['post_id'] = postid;
    request.fields['user_id'] = userID!;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);

    print(responseData);

    if (userData['response_code'] == "1") {
      addedBookmarks = [];
      setState(() {
        addedBookmarks.add(postid);
      });
    }
  }

  _removeBookmark(String postid) async {
    var uri = Uri.parse('${baseUrl()}/delete_bookmark_post');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['post_id'] = postid;
    request.fields['user_id'] = userID!;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);

    print(responseData);

    if (userData['response_code'] == "1") {
      addedBookmarks = [];
      setState(() {
        addedBookmarks.remove(postid);
      });
    }
  }

  reportSheet(BuildContext context, postId, bookmark, postUserId) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).canvasColor,
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
                  height: postUserId != userID ? 250 : 150,
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop("Discard");
                                openBottmSheet(context, 'report', postId);
                              },
                              title: new Text(
                                "Report",
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),
                              ),
                            ),
                            postUserId != userID
                                ? ListTile(
                                    onTap: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop("Discard");

                                      _reportPost(postId, 'hide', '');
                                    },
                                    title: new Text(
                                      "Hide",
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15.0),
                                    ),
                                  )
                                : ListTile(
                                    onTap: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop("Discard");

                                      _reportPost(postId, 'hide', '');
                                    },
                                    title: new Text(
                                      "Delete",
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15.0),
                                    ),
                                  ),
                            postUserId != userID
                                ? ListTile(
                                    onTap: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop("Discard");
                                      _blockUser(postUserId);
                                    },
                                    title: new Text(
                                      "Block User",
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15.0),
                                    ),
                                  )
                                : Container(),
                            postUserId != userID
                                ? bookmark == "true"
                                    ? ListTile(
                                        onTap: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop("Discard");
                                          setState(() {
                                            bookmark = "false";
                                            _removeBookmark(postId);
                                          });
                                        },
                                        title: new Text(
                                          "Remove Post",
                                          style: new TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15.0),
                                        ),
                                      )
                                    : ListTile(
                                        onTap: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop("Discard");
                                          setState(() {
                                            bookmark = "true";
                                            _addBookmark(postId);
                                          });
                                        },
                                        title: new Text(
                                          "Save Post",
                                          style: new TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15.0),
                                        ),
                                      )
                                : Container(),
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

  openBottmSheet(BuildContext context, String reportType, String? postId) {
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
                  height: 700,
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                          child: Text(
                        'Report',
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
                            Text(
                              'Why are you reporting this post?',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop("Discard");
                                _reportPost(postId, reportType,
                                    'Nudity or sexual activity');
                              },
                              title: new Text(
                                "Nudity or sexual activity",
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop("Discard");
                                _reportPost(postId, reportType,
                                    'I just don\'t like it');
                              },
                              title: new Text(
                                "I just don\'t like it",
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop("Discard");
                                _reportPost(postId, reportType,
                                    'Hate speech or symbol');
                              },
                              title: new Text(
                                "Hate speech or symbol",
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop("Discard");
                                _reportPost(postId, reportType,
                                    'Bullying or harassment');
                              },
                              title: new Text(
                                "Bullying or harassment",
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop("Discard");
                                _reportPost(postId, reportType,
                                    'Violence or dangerous organisation');
                              },
                              title: new Text(
                                "Violence or dangerous organisation",
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop("Discard");
                                _displayTextInputDialog(
                                    context, postId, reportType);
                              },
                              title: new Text(
                                "Something else",
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
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

  Future<void> _displayTextInputDialog(BuildContext context, id, type) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                    onChanged: (value) {},
                    maxLines: 5,
                    controller: _textFieldController,
                    decoration: InputDecoration.collapsed(
                        hintText: "Enter your text here")),
              ),
            ),
            actions: <Widget>[
              TextButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop("Discard");
                  }),
              TextButton(
                  child: Text('Submit'),
                  onPressed: () {
                    if (_textFieldController.text.isNotEmpty) {
                      Navigator.of(context, rootNavigator: true).pop("Discard");
                      _reportPost(id, type, _textFieldController.text);
                    } else {
                      Fluttertoast.showToast(
                          msg: 'Please enter text to continue..');
                    }
                  })
            ],
          );
        });
  }

  openHideSheet(BuildContext context, String reportType) {
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
                  height: 700,
                  child: Container(
                      child: reportPostData != null &&
                              reportPostData['response_code'] == '1'
                          ? Container(
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/images/Done-pana.png',
                                    height: 300,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                  reportType == 'hide'
                                      ? Column(
                                          children: [
                                            Text(
                                              'Post Hidden successfully',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  reportType == 'report'
                                      ? Column(
                                          children: [
                                            Text(
                                              'Thanks for letting us know',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                                'Your feedback is important in helping us keep the community safe.',
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption!
                                                    .copyWith(fontSize: 15)),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      // background color
                                      backgroundColor: appColor,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 10),
                                      textStyle: const TextStyle(fontSize: 15),
                                    ),
                                    child: const Text('Continue'),
                                    onPressed: () {
                                      debugPrint('Button clicked!');
                                      Navigator.of(context, rootNavigator: true)
                                          .pop("Discard");
                                    },
                                  ),
                                ],
                              ),
                            )
                          : reportPostData != null &&
                                  reportPostData['response_code'] == '0'
                              ? Container(
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        'assets/images/Done-pana.png',
                                        height: 300,
                                        width:
                                            MediaQuery.of(context).size.width,
                                      ),
                                      reportPostData['status'] != 'fail'
                                          ? Text(
                                              'This post is already reorted',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            )
                                          : Text(
                                              'Fail to submit',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Fail to submit your report please try again',
                                        textAlign: TextAlign.center,
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          // background color
                                          backgroundColor: appColor,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30, vertical: 10),
                                          textStyle:
                                              const TextStyle(fontSize: 15),
                                        ),
                                        child: const Text('Continue'),
                                        onPressed: () {
                                          debugPrint('Button clicked!');
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop("Discard");
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              : Container())),
            ),
          );
        });
      },
    );
  }
}
