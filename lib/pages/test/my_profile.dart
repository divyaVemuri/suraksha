import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suraksha/main.dart';
import 'package:suraksha/models/address.dart';
import 'package:suraksha/models/family_member.dart';
import 'package:suraksha/models/user.dart';
import 'package:suraksha/pages/add_address.dart';
import 'package:suraksha/pages/alert_dialog.dart';
import 'package:suraksha/pages/home.dart';
import 'package:suraksha/resource/shared_preference_helper.dart';
import 'package:suraksha/services/profile_service.dart';
import 'package:suraksha/values/gradients.dart';

class MyProfile extends StatefulWidget {
  Address address;

  MyProfile({this.address});

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  SharedPrefsHelper _sharedPrefsHelper = new SharedPrefsHelper();
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;

  String _token;
  User user;

  User loggedInUser;

  int tabPosition;

  bool infoLoaded = false;

  bool addressExist;

  String dropdownValue;

  var addressList = <Address>[];
  static var familyMembers = <FamilyMember>[];

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();
  final relationController = TextEditingController();

  User testUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _token = _sharedPrefsHelper.getToken();
//    getToken().then((token){
//      _token=token;
//    });

    testUser = User(
      id: _sharedPrefsHelper.getUserId(),
      mobile: _sharedPrefsHelper.getMobile(),
      email: _sharedPrefsHelper.getEmail(),
      age: _sharedPrefsHelper.getAge(),
      gender: _sharedPrefsHelper.getGender(),
      first_name: _sharedPrefsHelper.getFirstName(),
    );

//    getUser().then((user){
    print('USER FROM SHARED: ' + testUser.toJson().toString());
//      testUser=user;
    _getMyProfile();
    tabPosition = 1;
    _getAddress();
    _getFamilyMember();
    _getUser();

//    });
  }

  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  }

  _getFamilyMember() async {
    print('getting family members');
    final result = await ProfileService.getFamilyMembers(_token);
    if (result != null) {
      setState(() {
        result.data.forEach((member) {
          familyMembers.add(member);
          print('*****family members: ' + member.toJson().toString());
        });
      });
    } else {
      print('*****NOPE*****');
    }
  }

  _getAddress() async {
    final result = await ProfileService.getAddresses2(
        _token); //getAddresses(widget.token);
    if (result != null) {
      setState(() {
        addressExist = true;
        result.data.forEach((address) {
          addressList.add(address);
        });
      });
    } else {
      print('List empty');
    }
  }

  _getMyProfile() async {
    print("AT GET USER PROFILE: " + testUser.toJson().toString());
    final result = await ProfileService.getUserProfile(testUser.id, _token);
    if (result != null) {
      setState(() {
        infoLoaded = true;
        user = result.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: infoLoaded == true
              ? Stack(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top,
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset(
                        'assets/background3.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          _getProfile(),
                          _getTabWidget(tabPosition)
                        ],
                      ),
                    ),
                  ],
                )
              : Container(
                  child: Center(child: Image.asset('assets/gif/loader.gif')),

//                  child: Center(child: Text('Loading....')),
                ),
        ),
      ),
    );
  }

  _getProfile() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _getAppBar(),
          _getCaption(),
          _getDetails(),
          _getTab()
        ],
      ),
    );
  }

  _getCaption() {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'My',
            style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                letterSpacing: 3.0,
                fontWeight: FontWeight.bold),
          ),
          Text(
            'Profile',
            style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                letterSpacing: 3.0,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  _getDetails() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Container(
              child: Icon(
            Icons.person,
            color: Colors.white,
            size: 60,
          )),
//          CircleAvatar(
//            backgroundImage: NetworkImage('https://i.pravatar.cc/300'),radius: 40,
//          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 5),
            child: Text(
              user.first_name,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'PID: 2343SFSVS2',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  _getTab() {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkResponse(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Personal Info',
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1,
                        fontWeight: tabPosition == 1
                            ? FontWeight.bold
                            : FontWeight.w300),
                  ),
                  tabPosition == 1
                      ? Container(
                          margin: EdgeInsets.all(3),
                          height: 8,
                          width: 8,
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                        )
                      : Container(
                          margin: EdgeInsets.all(3),
                          height: 8,
                          width: 8,
                        )
                ],
              ),
            ),
            onTap: () {
              setState(() {
                tabPosition = 1;
              });
            },
          ),
          InkResponse(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Family',
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1,
                        fontWeight: tabPosition == 2
                            ? FontWeight.bold
                            : FontWeight.w300),
                  ),
                  tabPosition == 2
                      ? Container(
                          margin: EdgeInsets.all(3),
                          height: 8,
                          width: 8,
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                        )
                      : Container(
                          margin: EdgeInsets.all(3),
                          height: 8,
                          width: 8,
                        )
                ],
              ),
            ),
            onTap: () {
              setState(() {
                tabPosition = 2;
              });
            },
          ),
          InkResponse(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Vitals',
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1,
                        fontWeight: tabPosition == 3
                            ? FontWeight.bold
                            : FontWeight.w300),
                  ),
                  tabPosition == 3
                      ? Container(
                          margin: EdgeInsets.all(3),
                          height: 8,
                          width: 8,
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                        )
                      : Container(
                          margin: EdgeInsets.all(3),
                          height: 8,
                          width: 8,
                        )
                ],
              ),
            ),
            onTap: () {
              setState(() {
                tabPosition = 3;
              });
            },
          )
        ],
      ),
    );
  }

  _getAppBar() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                  context, CupertinoPageRoute(builder: (context) => Home()));
            },
          ),
          Row(
            children: <Widget>[
              InkResponse(
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 20),
                  child: SvgPicture.asset(
                    'assets/svg/utilities/cart.svg',
                  ),
                ),
              ),
              InkResponse(
                child: Container(
                    padding: EdgeInsets.only(right: 20),
                    child: SvgPicture.asset('assets/svg/utilities/bell.svg')),
              )
            ],
          )
        ],
      ),
    );
  }

  _getTabWidget(var tabPosition) {
    var fun;
    switch (tabPosition) {
      case 1:
        fun = _getPersonalInfoTab();
        break;
      case 2:
        fun = _getFamilyTab();
        break;
      case 3:
        fun = _getVitals();
        break;
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: fun,
    );
  }

  _getAddressInfo() {
    print("Address list in function " + addressList.toString());

    List<Widget> widgetList = [];
    addressList.forEach((address) {
      String fullAddress =
          (address.houseDetails != null ? address.houseDetails + ", " : "") +
              (address.areaDetails != null ? address.areaDetails + ", " : "") +
              (address.landmark != null ? address.landmark + ", " : "") +
              (address.city != null ? address.city + ", " : "") +
              (address.state != null ? address.state + ", " : "") +
              (address.pincode.toString() != null
                  ? address.pincode.toString() + " "
                  : "");

      Widget widget = Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                address.addressType != null
                    ? address.addressType == 'Home Address'
                        ? Icon(
                            Icons.home,
                            size: 18,
                          )
                        : Icon(
                            Icons.work,
                            size: 18,
                          )
                    : Container(),
                SizedBox(
                  width: 5,
                ),
                Text(
                  address.houseDetails,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(
                fullAddress,
                style: TextStyle(color: Colors.grey),
              ),
            )
          ],
        ),
      );
      widgetList.add(widget);
    });
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey[200],
                offset: Offset(5, 10),
                spreadRadius: 0,
                blurRadius: 10),
            BoxShadow(
                color: Colors.grey[200],
                offset: Offset(-5, 10),
                spreadRadius: 0,
                blurRadius: 10)
          ]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.location_on,
                    color: Colors.grey,
                  ),
                  Text(
                    'Address',
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
              InkResponse(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.add_circle_outline,
                        color: Color.fromRGBO(51, 121, 248, 1),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Add New',
                        style:
                            TextStyle(color: Color.fromRGBO(51, 121, 248, 1)),
                      )
                    ],
                  ),
                ),
                onTap: () async {
                  /*
                  return MyDialog(
                token: widget.token,
                familymember: (newMember) {
                  setState(() {
                    familyMembers.add(newMember);
                  });
                },
              );
                   */

                  await Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => AddressPage(
                                address: (newAddress) {
                                  setState(() {
                                    addressList.add(newAddress);
                                  });
                                },
                              )));
                },
              )
            ],
          ),
          ...widgetList
        ],
      ),
    );
  }

  _getPersonalInfoTab() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        children: <Widget>[
          _getAddressInfo(),
          Container(
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width - 40,
            margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
            padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[200],
                      offset: Offset(5, 10),
                      spreadRadius: 0,
                      blurRadius: 10),
                  BoxShadow(
                      color: Colors.grey[200],
                      offset: Offset(-5, 10),
                      spreadRadius: 0,
                      blurRadius: 10)
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.phone_android,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Mobile',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, top: 10),
                  child: Text(
                    user.mobile,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 40,
            margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
            padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[200],
                      offset: Offset(5, 10),
                      spreadRadius: 0,
                      blurRadius: 10),
                  BoxShadow(
                      color: Colors.grey[200],
                      offset: Offset(-5, 10),
                      spreadRadius: 0,
                      blurRadius: 10)
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.mail_outline,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Email',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, top: 5),
                  child: user.email != null
                      ? Text(user.email,
                          style: TextStyle(fontWeight: FontWeight.w500))
                      : Container(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _getFamilyTab() {
    _getStaggeredTileCount() {
      List<StaggeredTile> list = new List();
      list.add(StaggeredTile.fit(1));

      familyMembers.forEach((member) {
        list.add(StaggeredTile.fit(1));
      });

      list.add(StaggeredTile.fit(2));

      return list;
    }

    Widget getPatientTile(bool primary, String name, String relation) {
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/testCategory');
        },
        child: Container(
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
            padding: EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                primary
                    ? Column(
                        children: <Widget>[
                          Icon(Icons.person),
                        ],
                      )
                    : Container(),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    name,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  child: primary == true
                      ? Container(
                          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                          decoration: BoxDecoration(
                            gradient: Gradients.redGradient,
                            borderRadius: BorderRadius.all(Radius.circular(35)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                relation,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Avenir Next",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Text(
                          relation, //236, G:31, B:39
                          style: TextStyle(
                              fontSize: 12,
                              color: Color.fromRGBO(236, 31, 39, 1)),
                        ),
                )
              ],
            ),
          ),
        ),
      );
    }

    _getStaggeredTileWidgets() {
      List<Widget> widgetList = [];

      widgetList.add(getPatientTile(true, testUser.first_name, 'Myself'));
      familyMembers.forEach((member) {
        widgetList.add(
            getPatientTile(false, member.firstName, member.relationshipName));
      });
      widgetList.add(_getAdd());
      return widgetList;
    }

    return Container(
        margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: StaggeredGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                staggeredTiles: _getStaggeredTileCount(),
                shrinkWrap: true,
                children: _getStaggeredTileWidgets(),
              ),
            ),
          ],
        ));
  }

  _getAdd() {
    return InkResponse(
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        padding: EdgeInsets.fromLTRB(30, 10, 30, 20),
        decoration: BoxDecoration(
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
          ],
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.add_circle_outline,
              color: Color.fromRGBO(55, 121, 248, 1),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Add a Member",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(55, 121, 248, 1),
                fontFamily: "Avenir Next",
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        print('printing fam before');
        familyMembers.forEach((fam) {
          print(fam.toJson().toString());
        });
        showDialog(
            context: context,
            builder: (context) {
              return MyDialog(
                token: _token,
                familymember: (newMember) {
                  setState(() {
                    familyMembers.add(newMember);
                  });
                },
              );
            });
      },
    );
  }

  _getDropDown() {
    return DropdownButton<String>(
      value: dropdownValue,
      hint: Container(
        width: MediaQuery.of(context).size.width - 209,
        child: Text(
          'State',
          style: TextStyle(
              color: Colors.grey[500], fontSize: 15.0, letterSpacing: 1.0),
        ),
      ),
      underline: Container(
        height: 0.4,
        color: Colors.grey,
      ),
      iconSize: 0,
      style: TextStyle(color: Colors.black),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>[
//        "Andhra Pradesh",
//        "Arunachal Pradesh ",
        "Assam",
        "Bihar",
//        "Chhattisgarh",
        "Goa",
        "Guja",
        "Har",
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  _getDropDown2() {
    return DropdownButton<String>(
      value: dropdownValue,
      hint: Container(
        padding: EdgeInsets.only(bottom: 20),
        width: MediaQuery.of(context).size.width - 209,
        child: Text(
          'Gender',
          style: TextStyle(
              color: Colors.grey[500], fontSize: 15.0, letterSpacing: 1.0),
        ),
      ),
      underline: Container(
        height: 0.4,
        color: Colors.grey,
      ),
      iconSize: 0,
      style: TextStyle(color: Colors.black),
      onChanged: (String newValue) {
        print('drop down value changed');
        setState(() {
          print('before: ' + dropdownValue);
          dropdownValue = newValue;
          print('after: ' + dropdownValue);
        });
      },
      items: <String>['Male', 'Female', 'Others']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  _getVitals() {
    Widget getPatientTile(bool primary, String name, String relation) {
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/testCategory');
        },
        child: Container(
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[100],
                      offset: Offset(5, 10),
                      spreadRadius: 0,
                      blurRadius: 15),
                  BoxShadow(
                      color: Colors.grey[100],
                      offset: Offset(-5, 10),
                      spreadRadius: 0,
                      blurRadius: 15)
                ]),
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                primary
                    ? Column(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage('https://i.pravatar.cc/300'),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      )
                    : Container(),
                Text(
                  name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  relation,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                )
              ],
            ),
          ),
        ),
      );
    }

    Widget getTile({String tile, dynamic value, String unit}) {
      String image;
      switch (tile) {
        case "Gender":
          image = "assets/svg/profile/gender.svg";
          break;
        case "Age":
          image = "assets/svg/profile/age.svg";
          break;
        case "Height":
          image = "assets/svg/profile/height.svg";
          break;
        case "Glucose":
          image = "assets/svg/profile/glucose.svg";
          break;
        case "BMI":
          image = "assets/svg/profile/bmi.svg";
          break;
      }

      return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[100],
                  offset: Offset(5, 10),
                  spreadRadius: 0,
                  blurRadius: 10),
              BoxShadow(
                  color: Colors.grey[100],
                  offset: Offset(-5, 10),
                  spreadRadius: 0,
                  blurRadius: 10)
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(5),
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 223, 227, 1),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Container(
                    margin: EdgeInsets.all(4),
                    child: SvgPicture.asset(
                      image,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Text(tile)
              ],
            ),
            value != null
                ? RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: value,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        unit != null
                            ? TextSpan(
                                text: ' ' + unit,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 14))
                            : TextSpan()
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.all(20),
      child: StaggeredGridView.count(
        crossAxisCount: 6,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        staggeredTiles: [
          StaggeredTile.count(2, 2),
          StaggeredTile.count(2, 2),
          StaggeredTile.count(2, 2),
          StaggeredTile.count(3, 2),
          StaggeredTile.count(3, 2),
        ],
        shrinkWrap: true,
        children: <Widget>[
          getTile(tile: 'Gender', value: user.gender),
          getTile(tile: 'Age', value: user.age, unit: 'Years'),
          getTile(tile: 'Height', value: '5.8', unit: 'feet'),
          getTile(tile: 'Glucose', value: '108', unit: 'mg/dl'),
          getTile(tile: 'BMI', value: '18.5'),
        ],
      ),
    );
  }
}
