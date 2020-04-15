import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:suraksha/models/address.dart';
import 'package:suraksha/models/family_member.dart';
import 'package:suraksha/models/user.dart';
import 'package:suraksha/pages/add_address.dart';
import 'package:suraksha/pages/alert_dialog.dart';
import 'package:suraksha/resource/shared_preference_helper.dart';
import 'package:suraksha/services/profile_service.dart';
import 'package:suraksha/values/gradients.dart';

class Profile extends StatefulWidget {
  int tab;


  Profile({this.tab});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool addMemberButton;
  SharedPrefsHelper _sharedPrefsHelper = new SharedPrefsHelper();
  static var familyMembers = <FamilyMember>[];
  User testUser;

  int tabPosition;
  var addressList = <Address>[];
  String _token;

  @override
  void initState() {
    addMemberButton=true;
    _token = _sharedPrefsHelper.getToken();

    tabPosition = widget.tab;
    _getAddress();
    _getFamilyMember();
    testUser = User(
      id: _sharedPrefsHelper.getUserId(),
      mobile: _sharedPrefsHelper.getMobile(),
      email: _sharedPrefsHelper.getEmail(),
      age: _sharedPrefsHelper.getAge(),
      gender: _sharedPrefsHelper.getGender(),
      first_name: _sharedPrefsHelper.getFirstName(),
    );

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/background3.png',
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              bottom: 0,
              height: (MediaQuery.of(context).size.height -
                          (MediaQuery.of(context).padding.top +
                              MediaQuery.of(context).padding.bottom)) *
                      (0.66) +
                  25,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/background4.png',
                fit: BoxFit.fill,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              height: (MediaQuery.of(context).size.height -
                  (MediaQuery.of(context).padding.top +
                      MediaQuery.of(context).padding.bottom)),
              child: Column(
                children: <Widget>[
                  _getAppBar(),
                  _getCaption(),
                  _getTabBar(),
                  _getBody(tabPosition)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _getAppBar() {
    double total_height = MediaQuery.of(context).size.height;
    double top_padding = MediaQuery.of(context).padding.top;
    double bottom_padding = MediaQuery.of(context).padding.bottom;
    double total_height_no_padding =
        total_height - (top_padding + bottom_padding);
    double height_of_white_space = total_height_no_padding * 0.66;

    print("total_height: " + total_height.toString());
    print("top_padding: " + top_padding.toString());
    print("bottom_padding: " + bottom_padding.toString());
    print("total_height_no_padding: " + total_height_no_padding.toString());
    print("height_of_white_space: " + height_of_white_space.toString());

    return Expanded(
      flex: 1,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Row(
              children: <Widget>[
                InkResponse(
                  child: Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: SvgPicture.asset(
                              'assets/svg/utilities/cart.svg'))),
                ),
                SizedBox(
                  width: 10,
                ),
                InkResponse(
                  child: SvgPicture.asset('assets/svg/utilities/bell.svg'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  _getCaption() {
    return Expanded(
      flex: 2,
      child: Container(
        padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
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
                  fontWeight: FontWeight.w500),
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
      ),
    );
  }

  _getTabBar() {
    return Expanded(
      flex: 4,
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 0,
              top: 40,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[100],
                        offset: Offset(0, 10),
                        spreadRadius: 0,
                        blurRadius: 5),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                width: MediaQuery.of(context).size.width - 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              child: Text(
                                testUser.first_name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    letterSpacing: 1),
                              ),
                              alignment: Alignment.center,
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text('PID: 234HJK989'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: InkResponse(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.grey[100])),
                                  child: Center(
                                    child: Container(
                                      child: Text(
                                        'Personal Info',
                                        style: TextStyle(
                                            fontWeight: tabPosition == 1
                                                ? FontWeight.bold
                                                : FontWeight.w300),
                                      ),
//                                      padding: EdgeInsets.all(20),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    tabPosition = 1;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: InkResponse(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.grey[100])),
                                  child: Center(
                                    child: Container(
                                      child: Text(
                                        'Family',
                                        style: TextStyle(
                                            fontWeight: tabPosition == 2
                                                ? FontWeight.bold
                                                : FontWeight.w300),
                                      ),
//                                      padding: EdgeInsets.all(20),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    tabPosition = 2;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: InkResponse(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.grey[100])),
                                  child: Center(
                                    child: Container(
                                      child: Text(
                                        'Vitals',
                                        style: TextStyle(
                                            fontWeight: tabPosition == 3
                                                ? FontWeight.bold
                                                : FontWeight.w300),
                                      ),
//                                      padding: EdgeInsets.all(20),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    tabPosition = 3;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: (MediaQuery.of(context).size.width / 2) - 65,
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  child: Center(
                    child: CircleAvatar(
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.grey[200],
//                  backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
                      radius: 40,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getBody(var tabPosition) {
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

    return Expanded(
      flex: 7,
      child: Container(
        padding: EdgeInsets.only(top: 10),
        child: fun,
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

    Widget getPatientTile(
        int count, bool primary, String name, String relation) {
      print("PRINT COUNT: " + count.toString());
      print("res: " + (count % 2 == 0).toString());
      return Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[100],
                  offset: Offset(5, 10),
                  spreadRadius: 0,
                  blurRadius: 5),
              BoxShadow(
                  color: Colors.grey[100],
                  offset: Offset(-5, 10),
                  spreadRadius: 0,
                  blurRadius: 5)
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
                          fontSize: 12, color: Color.fromRGBO(236, 31, 39, 1)),
                    ),
            )
          ],
        ),
      );
    }

    _floatingActionButton() {

      return Container(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          elevation: 3,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
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
        ),
      );
    }

    _getAdd() {
      return InkResponse(
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
          padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
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
//                fontSize: 22,
                ),
              ),
            ],
          ),
        ),
        onTap: () {
//          createDialog(context);
        },
      );
    }

    _getStaggeredTileWidgets() {
      int count = 0;
      List<Widget> widgetList = [];

      widgetList
          .add(getPatientTile(count, true, testUser.first_name, 'Myself'));
      count++;
      familyMembers.forEach((member) {
        widgetList.add(getPatientTile(
            count, false, member.firstName, member.relationshipName));
        count++;
      });
      widgetList.add(_floatingActionButton());
      return widgetList;
    }

    return Container(
//      color: Colors.red,
//          margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
//        margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
        child: Container(
//            color: Colors.blue,
//                      padding: EdgeInsets.fromLTRB(10, 10, 10, 5),

          child: StaggeredGridView.count(
            scrollDirection: Axis.vertical,
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 5,
            staggeredTiles: _getStaggeredTileCount(),
            shrinkWrap: true,
            children: _getStaggeredTileWidgets(),
          ),
        ));
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
//      margin: EdgeInsets.all(20),
      margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
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
          getTile(
              tile: 'Gender',
              value: (testUser.gender != null) ? testUser.gender : ""),
          getTile(
              tile: 'Age',
              value: testUser.age != null ? testUser.age : "",
              unit: 'Years'),
          getTile(tile: 'Height', value: '5.8', unit: 'feet'),
          getTile(tile: 'Glucose', value: '108', unit: 'mg/dl'),
          getTile(tile: 'BMI', value: '18.5'),
        ],
      ),
    );
  }

  _getPersonalInfoTab() {
    _getAddressInfo() {
      print("Address list in function " + addressList.toString());

      List<Widget> widgetList = [];
      addressList.forEach((address) {
        String fullAddress = (address.houseDetails != null
                ? address.houseDetails + ", "
                : "") +
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
                      : Icon(
                    Icons.location_on,size: 18,
                  ),
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

    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _getAddressInfo(),
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
              padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              alignment: Alignment.centerLeft,
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
                      testUser.mobile,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ),
            Container(
//              width: MediaQuery.of(context).size.width - 40,
              margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
              padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
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
                    child: //Text('email@email.com'),
                        testUser.email != null
                            ? Text(testUser.email,
                                style: TextStyle(fontWeight: FontWeight.w500))
                            : Container(),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _getAddress() async {
    final result = await ProfileService.getAddresses2(
        _token); //getAddresses(widget.token);
    if (result != null) {
      setState(() {
        result.data.forEach((address) {
          addressList.add(address);
        });
      });
    } else {
      print('List empty');
    }
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
}
