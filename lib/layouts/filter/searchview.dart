import 'dart:async';
import 'dart:convert';

import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../global/global.dart';
import 'searchpostmodel.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  String? formType;
  var formTypeList = ['found', 'missing', 'dead', 'people'];
  var formTypeList2 = [
    'Unclaimed Found Person',
    'Missing Person',
    'Unclaimed Dead Body',
    'User / Organization',
  ];
  double startAge = 0;
  double endAge = 100;
  String? gender;
  String? stateValue;
  String? cityValue;
  bool clearData = false;
  var gender1 = [
    'Male',
    'Female',
    'Other',
  ];
  RangeValues _age = RangeValues(0, 100);
  final TextEditingController fromDateCon = TextEditingController();
  final TextEditingController toDateCon = TextEditingController();
  TextEditingController controller = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool isSearch = false;
  String? fromDate;
  String? toDate;
  bool homedata = true;

  List<SearchPost> dataList = [];

  Future<List<SearchPost>> searchedPost() async {
    setState(() {
      isSearch = true;
      homedata = false;
    });

    log("searching post");
    try {
      final response =
          await client.post(Uri.parse('${baseUrl()}/search_post'), body: {
        'user_id': userID ?? '',
        'search_type': formType ?? '',
        'text': nameController.text,
        'name': (formType == 'missing' ||
                formType == 'people' ||
                formType == 'dead')
            ? nameController.text
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
        print(data);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
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
      body: CustomScrollView(
        primary: true,
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.transparent,
            expandedHeight: 400,
            elevation: 0,
            leading: SizedBox.shrink(),
            flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: filterWidget(context)),
          ),
          SliverToBoxAdapter(
              child: Wrap(
            runSpacing: 0,
            children: [],
          ))
        ],
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
              if ((formType == 'missing' ||
                  formType == 'people' ||
                  formType == 'dead'))
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Container(
                      height: 43,
                      child: TextField(
                        controller: nameController,
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
                    searchedPost();
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

  Future selectDate(BuildContext context) async {
    final now = DateTime.now();
    DateTime _dateTime = DateTime(now.year, now.month, now.day);
    var myFormat = DateFormat('dd-MM-yyyy') /*.add_yMd()*/;
    String dateString;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year, now.month, now.day - 1),
      firstDate: DateTime(now.year - 2),
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
    );
    var myFormat = DateFormat('dd-MM-yyyy') /*.add_yMd()*/;
    String dateString;
    final DateTime? picked = await showDatePicker(
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
}
