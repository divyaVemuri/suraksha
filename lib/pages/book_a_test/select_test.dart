import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:suraksha/models/test.dart';
import 'package:suraksha/models/user.dart';
import 'package:suraksha/pages/book_a_test/test_details.dart' as prefix0;
import 'package:suraksha/pages/book_a_test/view_available_centers.dart';
import 'package:suraksha/pages/cart.dart';
import 'package:suraksha/pages/commons/app_bar.dart';
import 'package:suraksha/pages/map_demo.dart';
import 'package:suraksha/pages/test_details.dart';
import 'package:suraksha/services/profile_service.dart';
import 'package:suraksha/services/test_service.dart';
import 'package:suraksha/values/gradients.dart';

class SelectTest extends StatefulWidget {
  @override
  _SelectTestState createState() => _SelectTestState();
}

class _SelectTestState extends State<SelectTest> {
  bool showCartPressed;
  User existingUser;
  User user;
  String favLocation;
  List<Test> testList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showCartPressed = false;
    _getMyProfile();
  }

  _getMyProfile() async {
    print("GETTING EXISTING");
    final result = await ProfileService.getUserProfile(
        "b5e50b1e-7f4d-4be1-a9b8-eb26d185af16",
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiYjVlNTBiMWUtN2Y0ZC00YmUxLWE5YjgtZWIyNmQxODVhZjE2IiwidXNlcm5hbWUiOiIrOTE4OTUxODMxNTMxIiwiZXhwIjoxNTkzNjI2MDE3LCJtb2JpbGUiOiIrOTE4OTUxODMxNTMxIiwib3JpZ19pYXQiOjE1ODU4NTAwMTd9.R8EICjrVpGZuwceEMCBT5pyCAZkRSfh6yozGciMnXNI");
    if (result != null) {
      setState(() {
//        print("EXISTING USER: " + result.data.toJson().toString());
        existingUser = result.data;
        if (existingUser.favouriteLocation != null) {
          favLocation = existingUser.favouriteLocation.name;
          _getAllTests(
              '6b4ee016-9309-4093-80ec-fe677d47599a',
//              existingUser.favouriteLocation.id,
              '66140f76-66a9-44f7-a77f-5619b7390bd7');
        }

//        print("EXISTING INITIALISED: " + existingUser.toJson().toString());
      });
    }
  }

  _getAllTests(String testCenter, String category) async {
    final result = await TestService.getTestList(testCenter, category);
    if (result != null) {
      setState(() {
        testList = result.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height -
                    (MediaQuery.of(context).padding.top +
                        MediaQuery.of(context).padding.bottom),
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'assets/profile/background.png',
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                height: (MediaQuery.of(context).size.height -
                    (MediaQuery.of(context).padding.top +
                        MediaQuery.of(context).padding.bottom)),
                child: Stack(
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[_getAppBar(), _getBody()],
                    ),
//                  _getBody(),
                    search()
                  ],
                ),
              ),
              showCartPressed
                  ? Cart(
                      type: 2,
                      buttonPressed: (res) {
                        setState(() {
                          showCartPressed = res;
                        });
                      },
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  _getAppBar() {
    return Container(
      height: (MediaQuery.of(context).size.height -
              (MediaQuery.of(context).padding.top +
                  MediaQuery.of(context).padding.bottom)) *
          (1 / 5),
      child: Column(
        children: <Widget>[
          Expanded(
            child: MyAppBar(),
          ),
          _selectLocationBar()
        ],
      ),
    );
  }

  _selectLocationBar() {
    return Expanded(
      child: Container(
        child: existingUser != null && existingUser.favouriteLocation != null
            ? Container(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    favLocation != null
                        ? Row(
                            children: <Widget>[
                              Opacity(
                                child: Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                opacity: 0.6,
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: favLocation,
                                      style: TextStyle(
                                        color: Colors.white,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    InkResponse(
                      child: Text(
                        favLocation != null
                            ? 'Change'
                            : "Select a preferred location",
                        style: TextStyle(
                            letterSpacing: 1, fontWeight: FontWeight.w500),
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => MapDemo(
                              centre: (changedTestCentre) {
                                setState(
                                  () {
                                    print("fav loc set");
                                    favLocation = changedTestCentre.name;
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              )
            : Container(
                padding: EdgeInsets.only(left: 20, bottom: 25),
                alignment: Alignment.topRight,
                child: InkResponse(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Opacity(
                        child: Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 18,
                        ),
                        opacity: 0.6,
                      ),
                      Text(
                        "Select a preferred location",
                        style: TextStyle(letterSpacing: 1, color: Colors.white),
                      ),
                    ],
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => MapDemo(
                          centre: (changedTestCentre) {
                            setState(() {
                              print("fav loc set");
                              favLocation = changedTestCentre.name;
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }

  _getBody() {
    return Container(
      height: (MediaQuery.of(context).size.height -
              (MediaQuery.of(context).padding.top +
                  MediaQuery.of(context).padding.bottom)) *
          (4 / 5),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          color: Colors.white),
      child: Column(
        children: <Widget>[
          _getCaption(),
          Expanded(
            child: Container(
//              color: Colors.grey,
                padding: EdgeInsets.only(
                  top: 10,
                ),
                child: SingleChildScrollView(
                  child: _getTilesList(),
                )),
          ),
        ],
      ),
    );
  }

  Widget search() {
    return Positioned(
      top: (MediaQuery.of(context).size.height -
                  (MediaQuery.of(context).padding.top +
                      MediaQuery.of(context).padding.bottom)) /
              5 -
          20,
      child: Container(
        alignment: Alignment.center,
        child: Container(
          height: 45,
          width: MediaQuery.of(context).size.width - 40,
          padding: EdgeInsets.only(left: 20, right: 20),
          margin: EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[200],
                  offset: Offset(0, 10),
                  spreadRadius: 0,
                  blurRadius: 15),
            ],
            color: Colors.white, // Color.fromRGBO(250, 246, 246, 1),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                hintText: 'Search doctors by name/ center',
                hintStyle:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w300)),
            onChanged: (string) {
//
            },
          ),
        ),
      ),
    );
  }

  _getCaption() {
    return Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
        alignment: Alignment.topLeft,
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'Select',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    letterSpacing: 1,
                  )),
              TextSpan(
                  text: ' Test',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: 1,
                  ))
            ],
          ),
        ));
  }

  _getTilesList() {
    List<Widget> widgetList = [];
    testList.forEach((test) {
      print("test: ${test.toJson().toString()}");
      if (test.isAvailable)
        widgetList.add(_getTestTiles(test));
      else
        widgetList.add(_getUnavailableTestTiles(test));
    });

    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: widgetList,
        ),
      ),
    );
  }

  _getUnavailableTestTiles(Test test) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
      padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 10),
      decoration: BoxDecoration(
        boxShadow: [
//          BoxShadow(
//              color: Colors.grey[300],
//              offset: Offset(0, 10),
//              spreadRadius: 0,
//              blurRadius: 15),
//          BoxShadow(
//              color: Colors.grey[300],
//              offset: Offset(-5, 10),
//              spreadRadius: 0,
//              blurRadius: 15)
        ],
        color: Colors.grey[100],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          test.name,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              letterSpacing: 1,
                              color: Colors.black.withOpacity(0.2)),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Test not available in the chosen center',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.2),
                            fontSize: 12,
//                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Opacity(
                    opacity: 0.5,
                    child: Container(
                      padding: EdgeInsets.only(right: 10),
                      child: SvgPicture.asset('assets/svg/utilities/cart2.svg'),
                    ),
                  )
                ],
              ),
            ),
            Divider(
              height: 25,
              thickness: 1,
              color: Colors.grey[300],
            ),
            Container(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                child: Container(
                  child: Text(
                    'View Available Centers',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => ViewAvailableCenters(
                                testCenterList: test.testCenters,
                              )));
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  _getTestTiles(Test test) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
      padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.grey[300],
              offset: Offset(0, 10),
              spreadRadius: 0,
              blurRadius: 15),
//          BoxShadow(
//              color: Colors.grey[300],
//              offset: Offset(-5, 10),
//              spreadRadius: 0,
//              blurRadius: 15)
        ],
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          test.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Also known as',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
//                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          test.aliasName,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
//                            letterSpacing: 1,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10),
                    child: SvgPicture.asset('assets/svg/utilities/cart2.svg'),
                  )
                ],
              ),
            ),
            Divider(
              height: 25,
              thickness: 1,
              color: Colors.grey[300],
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 20, top: 7.5, right: 20, bottom: 7.5),
                      child: Text(
                        'View Details',
                        style: TextStyle(
                            color: Color.fromRGBO(219, 32, 40, 1),
                            fontSize: 12),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => prefix0.TestDetails(
                                    test: test,
                                  )));
                    },
                  ),
                  Container(
                    child: InkResponse(
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 20, top: 7.5, right: 20, bottom: 7.5),
                        decoration: BoxDecoration(
                          gradient: Gradients.redGradient,
                          borderRadius: BorderRadius.all(Radius.circular(35)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Book Now",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                letterSpacing: 1,
                                color: Colors.white,
                                fontFamily: "Avenir Next",
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () async {},
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
