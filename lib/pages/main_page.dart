import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:suraksha/library/curved_navigation_bar.dart' as prefix0;
import 'package:suraksha/main.dart';
import 'package:suraksha/models/user.dart';
import 'package:suraksha/pages/appointments.dart';
import 'package:suraksha/pages/branch_locator.dart';
import 'package:suraksha/pages/health_package/select_health_package.dart';
import 'package:suraksha/pages/login/login.dart';
import 'package:suraksha/pages/map_demo.dart';
import 'package:suraksha/pages/my_family.dart';
import 'package:suraksha/pages/profile.dart';
import 'package:suraksha/pages/reports.dart';
import 'package:suraksha/pages/rewards.dart';
import 'package:suraksha/pages/test/sample.dart';
import 'package:suraksha/pages/upload_prescription.dart';
import 'package:suraksha/resource/shared_preference_helper.dart';
import 'package:suraksha/values/gradients.dart';

import 'home.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  SharedPrefsHelper _sharedPrefsHelper = new SharedPrefsHelper();
  User testuser;
  String testToken;
  bool infoLoaded = false;
  Widget selectedPage;


  @override
  void initState() {
    // TODO: implement initState
    selectedPage=Home();

    if (_sharedPrefsHelper.getToken() != null) {
      testToken = _sharedPrefsHelper.getToken();

      print("TOKEN AT INIT: " + testToken);
    }
    if (_sharedPrefsHelper.getUserId() != null) {
      infoLoaded = true;
      testuser = User(
          id: _sharedPrefsHelper.getUserId(),
          mobile: _sharedPrefsHelper.getMobile(),
          first_name: _sharedPrefsHelper.getFirstName(),
          age: _sharedPrefsHelper.getAge(),
          email: _sharedPrefsHelper.getEmail(),
          gender: _sharedPrefsHelper.getGender());

      print("USER AT INTI: " + testuser.toJson().toString());
    }
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(

          leading: GestureDetector(
            onTap: () {
              print("On tap pressed");
              _scaffoldKey.currentState.openDrawer();
            },
            child: Container(
              padding: EdgeInsets.all(15),
              child: SvgPicture.asset('assets/svg/home/hamburger.svg'),
            ),
          ),
          backgroundColor: Color.fromRGBO(236, 31, 39, 1),
          iconTheme: new IconThemeData(
            color: Colors.grey[700],
          ),
          elevation: 0,
          actions: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 20),
              child: SvgPicture.asset(
                'assets/svg/utilities/cart.svg',
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 20),
              child: SvgPicture.asset('assets/svg/utilities/bell.svg'),
            )
          ],
        ),
      ),
      drawer: _sideMenu(),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height
              - (MediaQuery.of(context).padding.top+MediaQuery.of(context).padding.bottom),
          color: Color.fromRGBO(236, 31, 39, 1),
          child: Stack(
            children: <Widget>[
              selectedPage,
              Positioned(
                bottom: 0,
                child:
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
//                  color: Colors.green,
                  child: prefix0.CurvedNavigationBar(
                    index: 2,
                    height: 50,
                    animationDuration: Duration(milliseconds: 300),
                    animationCurve: Curves.bounceInOut,
                    items: <Widget>[

                      Container(
                        child: SvgPicture.asset(
                          'assets/svg/utilities/branchLocator.svg',fit: BoxFit.contain,
                        ),
                      ),
                      Container(
                        child: SvgPicture.asset(
                          'assets/svg/utilities/appointment.svg',fit: BoxFit.fill,
                        ),
                      ),
                      SvgPicture.asset(
                        'assets/svg/utilities/home.svg',fit: BoxFit.fill,
                      ),
                      SvgPicture.asset(
                        'assets/svg/utilities/wallet.svg',fit: BoxFit.fill,
                      ),
                      SvgPicture.asset(
                        'assets/svg/utilities/report.svg',fit: BoxFit.fill,
                      )

                    ],
                    onTap: (index){
                      setState(() {
                        switch(index){
                          case 0: selectedPage=BranchLocator();
                          break;

                          case 1: selectedPage=Appointment();
                          break;

                          case 2: selectedPage=Home();
                          break;

                          case 3: selectedPage=Rewards();
                          break;

                          case 4: selectedPage=Report();
                          break;
                        }
                      });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  infoload() {
    print('INFOLOADED: ' + infoLoaded.toString());
    if (testuser != null) {
      print(('TESTUSER: ' + testuser.toJson().toString()));
    } else
      print("TEST USER NULL");
    if (infoLoaded && testuser != null && testuser.id != null) {

      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start ,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 20),

              child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 40,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 60,
                  )
              ),
            ),
            testuser.first_name != null
                ? Container(
              padding: EdgeInsets.only(left: 30,top: 10),
              child: Text(
                testuser.first_name,
                style: TextStyle(color: Colors.black),
              ),
            )
                : Container(),

            Container(
              child: testuser.email != null
                  ? Container(
                  padding: EdgeInsets.only(left: 30,top: 10),
                  child:Text(
                    testuser.email,
                    style: TextStyle(color: Colors.black),
                  ))
                  : Container(),
            ),

            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
//                      color: Colors.red,
                      child: Divider(
                        height: 26,
                        color: Colors.grey[200],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );


//      return UserAccountsDrawerHeader(
//        accountName: testuser.first_name != null
//            ? Container(
//          padding: EdgeInsets.only(left: 20),
////          color: Colors.blue,
//                child: Container(
//                  padding: EdgeInsets.only(top: 20),
//                  child: Text(
//                    testuser.first_name,
//                    style: TextStyle(color: Colors.black),
//                  ),
//                ),
//              )
//            : Container(),
//        accountEmail: testuser.email != null
//            ? Text(
//                testuser.email,
//                style: TextStyle(color: Colors.black),
//              )
//            : Container(),
//        currentAccountPicture: Container(
////          padding: EdgeInsets.all(10),
//            height: 30,
//            width: 30,
//            decoration:
//                BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
//            child: Icon(
//              Icons.person,
//              color: Colors.white,
//              size: 60,
//            )),
//        decoration: BoxDecoration(color: Colors.white),
//      );
    } else {
      return Container();
    }
  }

  _sideMenu() {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            infoload(),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
              onTap: () {
                if (testuser != null && testuser.id != null) {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => Profile(tab: 1,)));
                } else {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => Login()));
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.wc),
              title: Text('My Family'),
              onTap: () {
                if (testuser != null && testuser.id != null) {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => Profile(tab: 2,)));
                } else {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => Login()));
                }

              },
            ),
            ListTile(
              leading: Icon(Icons.receipt),
              title: Text('Test Report'),
              onTap: () {
              },
            ),
            ListTile(
              leading: Icon(Icons.note_add),
              title: Text('My Appointment'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.monetization_on),
              title: Text('Payment History'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.local_hospital),
              title: Text('My Health Packages'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text('My Wallet'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.my_location),
              title: Text('Branch Locator'),
              onTap: () {
//                Navigator.pushNamed(context, '/map');
                Navigator.of(context).pop();
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => MapDemo()));
              },
            ),
            ListTile(
              leading: Icon(Icons.feedback),
              title: Text('Feedback'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Suraksha support'),
              onTap: () {},
            ),
            testToken != null
                ? ListTile(
              leading: Icon(Icons.power_settings_new),
              title: Text('Sign out'),
              onTap: () {
                setState(() {
                  clearSharedPreferences();
                  print("CLEARING!!!!");
                  if (_sharedPrefsHelper.getToken() == null) {
                    print("All clear");
                  }
                  Navigator.pushReplacement(context,
                      CupertinoPageRoute(builder: (context) => MainPage()));
                });
              },
            )
                : Container()
          ],
        ),
      ),
    );
  }

  _tile(String tilename) {
    return Expanded(
      child: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[200],
                    offset: Offset(5, 10),
                    spreadRadius: 0,
                    blurRadius: 15),
                BoxShadow(
                    color: Colors.grey[200],
                    offset: Offset(-5, 10),
                    spreadRadius: 0,
                    blurRadius: 15)
              ]),
          child: Container(
//          height: 55,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  getImage(tilename),
                  Expanded(
                    flex: 8,
                    child: Text(
                      tilename,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        onTap: (){
          switch(tilename){
            case 'Book Home Collection': Navigator.push(context, CupertinoPageRoute(builder: (context)=>MyFamily()));
            break;
            case 'Book a test': Navigator.push(context, CupertinoPageRoute(builder: (context)=>MyFamily()));break;
            case 'Book Health Packages': Navigator.push(context, CupertinoPageRoute(builder: (context)=>SelectHealthPackage()));break;

          }
        },
      ),
    );
  }

  _getTiles() {
    return Expanded(
      flex: 2,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            _tile('Book Home Collection'),
            SizedBox(
              height: 10,
            ),
            _tile('Book a test'),
            SizedBox(
              height: 10,
            ),
            _tile('Book Health Packages'),
            SizedBox(
              height: 10,
            ),
            _tile('Book Doctor appointment'),
            SizedBox(
              height: 10,
            ),
            _tile('My reports'),
          ],
        ),
      ),
    );
  }

  getImage(String tileName) {
    Widget image;
    switch (tileName) {
      case "Book Home Collection":
        image = SvgPicture.asset(
          'assets/svg/home/home.svg',
          fit: BoxFit.contain,
        );
        break;
      case "Book a test":
        image =
            SvgPicture.asset('assets/svg/home/test.svg', fit: BoxFit.contain);
        break;
      case "Book Health Packages":
        image = SvgPicture.asset('assets/svg/home/package.svg',
            fit: BoxFit.contain);
        break;
      case "Book Doctor appointment":
        image =
            SvgPicture.asset('assets/svg/home/doctor.svg', fit: BoxFit.contain);
        break;
      case "My reports":
        image =
            SvgPicture.asset('assets/svg/home/report.svg', fit: BoxFit.contain);
        break;
    }
    return Expanded(
      flex: 2,
      child: Container(
          padding: EdgeInsets.all(0), height: 30, width: 30, child: image),
    );
  }

  _getHealthPackages() {
    List<Widget> widgetList = [];
    int num = 3;
    for (int i = 0; i < num; i++) {
      Widget widget = Container(
        width: 250,
        decoration: BoxDecoration(
            gradient: Gradients.pinkGradient,
            borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: <Widget>[
            Container(
                alignment: Alignment.centerRight,
                child: SvgPicture.asset("assets/svg/home/checkup.svg")),
            Container(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Full body Checkup',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Family Health Package',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              left: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Rs. 9999',
                    style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.lineThrough,
                        fontWeight: FontWeight.w300,
                        fontSize: 12),
                  ),
                  Text(
                    'Rs. 8999',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            )
          ],
        ),
      );
      widgetList.add(widget);
      widgetList.add(SizedBox(
        width: 10,
      ));
    }

    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 10, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Popular Health Packages',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  InkResponse(
                    child: Text(
                      'View All',
                      style: TextStyle(color: Colors.pink),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(

                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: widgetList,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getOrganTile(String organ) {
    Widget organImage;

    switch (organ) {
      case "Liver":
        organImage = Container(
          height: 50,
          width: 50,
          child: SvgPicture.asset(
            'assets/svg/home/liver.svg',
            fit: BoxFit.contain,
          ),
        );
        break;
      case "Lungs":
        organImage = Container(
            height: 50,
            width: 50,
            child: SvgPicture.asset('assets/svg/home/lungs.svg',
                fit: BoxFit.contain));
        break;
      case "Heart":
        organImage = Container(
            height: 50,
            width: 50,
            child: SvgPicture.asset('assets/svg/home/heart.svg',
                fit: BoxFit.contain));
        break;
    }

    return Container(
      padding: EdgeInsets.all(10),
      width: 100,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey[200],
                offset: Offset(5, 10),
                spreadRadius: 0,
                blurRadius: 15),
            BoxShadow(
                color: Colors.grey[200],
                offset: Offset(-5, 10),
                spreadRadius: 0,
                blurRadius: 15)
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          organImage,
          Text(
            organ,
            style: TextStyle(fontWeight: FontWeight.w800),
          )
        ],
      ),
    );
  }

  _getOrganList() {
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 10, 0, 10),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 10, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Popular Health Packages',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  InkResponse(
                    child: Text(
                      'View All',
                      style: TextStyle(color: Colors.pink),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
//                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    getOrganTile("Liver"),
                    SizedBox(
                      width: 15,
                    ),
                    getOrganTile("Lungs"),
                    SizedBox(
                      width: 15,
                    ),
                    getOrganTile("Heart"),
                    SizedBox(
                      width: 15,
                    ),
//                getOrganTile("Liver"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
