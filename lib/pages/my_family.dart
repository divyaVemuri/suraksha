import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suraksha/models/family_member.dart';
import 'package:suraksha/models/test_category.dart';
import 'package:suraksha/models/user.dart';
import 'package:suraksha/pages/alert_dialog.dart';
import 'package:suraksha/pages/book_a_test/test_category.dart' as prefix0;
import 'package:suraksha/pages/map_demo.dart';
import 'package:suraksha/pages/test_category.dart';
import 'package:suraksha/pages/upload_prescription.dart';
import 'package:suraksha/resource/shared_preference_helper.dart';
import 'package:suraksha/services/profile_service.dart';
import 'package:suraksha/values/gradients.dart';

class MyFamily extends StatefulWidget {
  String type;

  MyFamily({this.type});

  @override
  _MyFamilyState createState() => _MyFamilyState();
}

class _MyFamilyState extends State<MyFamily> {
  FamilyMember updatedFamilyMember;

  SharedPrefsHelper _sharedPrefsHelper = new SharedPrefsHelper();
  User user;
  User existingUser;
  String favLocation;
  static var familyMembers = <FamilyMember>[];
  String _token;

  @override
  void initState() {
    _token = _sharedPrefsHelper.getToken();
    user = User(
      id: _sharedPrefsHelper.getUserId(),
      mobile: _sharedPrefsHelper.getMobile(),
      email: _sharedPrefsHelper.getEmail(),
      age: _sharedPrefsHelper.getAge(),
      gender: _sharedPrefsHelper.getGender(),
      first_name: _sharedPrefsHelper.getFirstName(),
    );
    _getFamilyMember();
    _getMyProfile();
    // TODO: implement initState
    super.initState();
  }

  _getMyProfile() async {
    print("GETTING EXISTING");
    final result = await ProfileService.getUserProfile(user.id, _token);
    if (result != null) {
      setState(() {
        print("EXISTING USER: " + result.data.toJson().toString());
        existingUser = result.data;
        if (existingUser.favouriteLocation != null) {
          favLocation = existingUser.favouriteLocation.name;
        }

        print("EXISTING INITIALISED: " + existingUser.toJson().toString());
      });
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
        {int count,
        bool primary,
        FamilyMember familyMember,
        String firstName}) {
      if(updatedFamilyMember!=null){
        print('->'+updatedFamilyMember.toJson().toString());
      }

      return GestureDetector(
        child: Container(
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
          padding: EdgeInsets.only(bottom: 10),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              primary
                  ? CircleAvatar(
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 50,
                      ),
                      radius: 35,
                      backgroundColor: Colors.grey[400],
                    )
                  : Container(),
              Container(
//              color: Colors.red,
                padding:
                    EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
                child: Column(
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.all(0),
                        alignment: Alignment.topRight,
                        child: InkResponse(
                          child: Container(
                            padding: EdgeInsets.only(right: 5),
                            child: Icon(
                              //R:102, G:158, B:238
                              Icons.edit,
                              size: 15,
                              color: Color.fromRGBO(102, 158, 238, 1),
                            ),
                          ),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return MyDialog(
                                    token: _token,
                                    existingFamilyMember: updatedFamilyMember!=null?updatedFamilyMember:familyMember,
                                    updatedFamilyMember: (updated) {
                                      print("AT MY FAMILY UPDATED DATA: "+updated.toJson().toString());
                                      setState(() {
                                        print("Calling getfamilymember from here");
                                        _getFamilyMember();

//                                      updatedFamilyMember = updated;

//                                      print("UPDATED FAMILY OBJECT: "+updatedFamilyMember.toJson().toString());
                                      });
                                    },
                                  );
                                });
                          },
                        )),
                    Text(
                      updatedFamilyMember != null
                          ? (updatedFamilyMember.firstName)
                          : (familyMember != null
                              ? familyMember.firstName
                              : firstName),
                      style: TextStyle(
                          letterSpacing: 1,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
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
                              'Myself',
                              style: TextStyle(
                                letterSpacing: 1,
                                color: Colors.white,
                                fontFamily: "Avenir Next",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Text(
                        updatedFamilyMember != null
                            ? updatedFamilyMember.relationshipName
                            : familyMember.relationshipName,
                        //236, G:31, B:39
                        style: TextStyle(
                            letterSpacing: 1,
                            fontSize: 13,
                            color: Color.fromRGBO(236, 31, 39, 1)),
                      ),
              ),
              familyMember != null
                  ? Container(
                      padding: EdgeInsets.fromLTRB(15, 5, 15, 0),
                      child: Text(
                        updatedFamilyMember != null
                            ? (updatedFamilyMember.gender != null
                                ? updatedFamilyMember.gender
                                : "" +
                                            ' - ' +
                                            updatedFamilyMember.age.toString() !=
                                        null
                                    ? updatedFamilyMember.age.toString()
                                    : "")
                            : (familyMember.gender != null
                                ? familyMember.gender
                                : "" + ' - ' + familyMember.age.toString() != null
                                    ? familyMember.age.toString()
                                    : ""),
                        style: TextStyle(
                            color: Colors.grey[400],
                            letterSpacing: 1,
                            fontSize: 13),
                      ))
                  : Container()
            ],
          ),
        ),
        onTap: (){
          if(widget.type=='BookATest'){
            print('BOOK A TEST');
            Navigator.pushReplacement(context, CupertinoPageRoute(
              builder: (context)=>prefix0.SelectTestCategory()
            ));
          }else if(widget.type=='HomeCollection') {
            Navigator.pushReplacement(context,
                CupertinoPageRoute(builder: (context) => SelectTestCategory()));
          }
        },
      );
    }

    _getAdd() {
      return InkResponse(
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
          padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
          decoration: BoxDecoration(
            color: Color.fromRGBO(244, 246, 248, 1),
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
//          createDialog(context);
        },
      );
    }

    _getStaggeredTileWidgets() {
      int count = 0;
      List<Widget> widgetList = [];
      widgetList.add(getPatientTile(
          count: count, primary: true, firstName: user.first_name));
      count++;
      familyMembers.forEach((member) {
        widgetList.add(
            getPatientTile(count: count, primary: false, familyMember: member));
        count++;
      });
      widgetList.add(_getAdd());
      return widgetList;
    }

    return Container(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Container(
          child: StaggeredGridView.count(
            scrollDirection: Axis.vertical,
            crossAxisCount: 2,
            mainAxisSpacing: 30,
            crossAxisSpacing: 5,
            staggeredTiles: _getStaggeredTileCount(),
            shrinkWrap: true,
            children: _getStaggeredTileWidgets(),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
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
//                    padding: EdgeInsets.all(10),
                    height: (MediaQuery.of(context).size.height -
                        (MediaQuery.of(context).padding.top +
                            MediaQuery.of(context).padding.bottom)),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                _getAppBar(),
                                _getCaption(),
                              ],
                            ),
                          ),
                        ),
                        inputForm()
//                        _getTabBar(),
//                        _getBody(tabPosition)
                      ],
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }

  _getAppBar() {
    return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.all(20),
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
            existingUser != null && existingUser.favouriteLocation != null
                ? Expanded(
                    flex: 1,
                    child: Container(
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
                              style: TextStyle(letterSpacing: 1),
                            ),
                            onTap: () async {
                              await Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => MapDemo(
                                            centre: (changedTestCentre) {
                                              setState(() {
                                                print("fav loc set");
                                                favLocation =
                                                    changedTestCentre.name;
                                              });
                                            },
                                          )));
                            },
                          )
                        ],
                      ),
                    ),
                  )
                : Container(
                    padding: EdgeInsets.only(bottom: 20),
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
                            style: TextStyle(
                                letterSpacing: 1, color: Colors.white),
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
                                    )));
                      },
                    )),
            Expanded(
              flex: 1,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'Select ',
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.5,
                            fontSize: 25)),
                    TextSpan(
                        text: 'Patient',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            letterSpacing: 1.5))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget inputForm() {
    return Expanded(
      flex: 3,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(45), topRight: Radius.circular(45)),
            color: Colors.white),
        child: Container(
          child: _getFamilyTab(),
        ),
      ),
    );
  }
}
