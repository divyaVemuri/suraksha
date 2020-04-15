import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:suraksha/models/address.dart';
import 'package:suraksha/models/family_member.dart';
import 'package:suraksha/models/user.dart';
import 'package:suraksha/pages/add_address.dart';
import 'package:suraksha/pages/my_scroll_behaviour.dart';
import 'package:suraksha/services/profile_service.dart';
import 'package:suraksha/values/gradients.dart';

class MyProfile extends StatefulWidget {
  String token;
  User user;

  MyProfile({this.token, this.user});

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  User user;

  int tabPosition;

  bool infoLoaded;

  bool addressExist;

  var addressList = <Address>[];
  var familyMembers = <FamilyMember>[];

  final nameController=TextEditingController();
  final ageController=TextEditingController();
  final genderController=TextEditingController();
  final relationController=TextEditingController();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabPosition = 1;
    _getMyProfile();
    _getAddress();
    _getFamilyMember();
  }

  _getFamilyMember() async{
    final result=await ProfileService.getFamilyMembers(widget.token);
    if(result!=null){
      setState(() {
        result.data.forEach((member){
          familyMembers.add(member);
          print('*****family members: '+member.toJson().toString());
        });
      });

    }else{
      print('*****NOPE*****');

    }
  }
  _getAddress() async {
    final result = await ProfileService.getAddresses2(
        widget.token); //getAddresses(widget.token);
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
    final result = await ProfileService.getUserProfile(
        widget.user.id,
        widget.token);
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
//                height: MediaQuery.of(context).size.height -
//                    MediaQuery.of(context).padding.top,
//                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'assets/background3.png',
                  fit: BoxFit.fill,
                ),
              ),
//              Container(
//                child: Column(
//                  children: <Widget>[
//                    _getProfile(),
//                    _getTabWidget(tabPosition)
//
//                  ],
//                ),
//              ),

            ],
          )
              : Container(
            child: Center(child: Text('Loading....')),
          ),
        ),
      ),

//      backgroundColor: Colors.red,
    );
  }

  _getProfile() {
    return Container(
//        height: 500,
//        color: Colors.red,
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
//        color: Colors.white,
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage('https://i.pravatar.cc/300'),radius: 40,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10,20,10,5),
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
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          Row(
//            mainAxisAlignment: ,
            children: <Widget>[
              InkResponse(
                child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Image.asset('assets/cartP.png'))),
              ),
              InkResponse(
                child: Image.asset('assets/bell.png'),
              )
//              IconButton(
//                icon: Icon(
//                  Icons.shopping_cart,
//                  color: Colors.white,
//                ),
//              ),
//              IconButton(
//                icon: Icon(
//                  Icons.notifications,
//                  color: Colors.white,
//                ),
//              )
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
                    : Icon(Icons.work,size: 18,)
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

//              margin: EdgeInsets.fromLTRB(10,10,10,10),
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
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddressPage(

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
//          color: Colors.gr,
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),

      child: Column(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _getAddressInfo(),
//          Expanded(
//            flex: 5,
//            child: Container(
//              margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
//              padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
//              decoration: BoxDecoration(
//                  shape: BoxShape.rectangle,
//                  borderRadius: BorderRadius.circular(15),
//                  color: Colors.white,
//                  boxShadow: [
//                    BoxShadow(
//                        color: Colors.grey[200],
//                        offset: Offset(5, 10),
//                        spreadRadius: 0,
//                        blurRadius: 10),
//                    BoxShadow(
//                        color: Colors.grey[200],
//                        offset: Offset(-5, 10),
//                        spreadRadius: 0,
//                        blurRadius: 10)
//                  ]),
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Text(
//                    'Address',
//                    style: TextStyle(color: Colors.grey, fontSize: 12),
//                  ),
//                  Container(
////                    color: Colors.orange,
//                    padding: EdgeInsets.all(0),
////                    color: Colors.red,
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                        Row(
//                          children: <Widget>[
//                            Container(
//                                color: Colors.white,
//                                child: Icon(
//                                  Icons.home,
//                                  color: Colors.black,
//                                )),
//                            Container(
////                              color: Colors.blue,
//                              padding: EdgeInsets.only(left: 5),
//                              child: Text(
//                                'Terra Signature',
//                                style: TextStyle(
//                                    letterSpacing: 1,
//                                    fontWeight: FontWeight.bold,
//                                    fontSize: 12),
//                              ),
//                            ),
//                          ],
//                        ),
//                        Container(
////                          color: Colors.green,
//                          height: 30,
//                          width: 30,
//                          child: IconButton(
//                            icon: Icon(
//                              Icons.edit,
//                              color: Colors.black,
//                              size: 18,
//                            ),
//                          ),
//                        )
//                      ],
//                    ),
//                  ),
//                  Container(
////                    color: Colors.grey,
//                    margin: EdgeInsets.fromLTRB(10, 0, 20, 0),
//
//                    child: Text(
//                      "414, 7th Main Rd, lkjyhgfdghjkjl;'kjhgfdcgvhjkl;jhgfdcgvhjlk;jhgfcvvbjkljhgvc bnmk.,mnbv m,.HRBR Layout 1st Block, HRBR Layout, Kalyan Nagar, Bengaluru,Karnataka 560043",
//                      style: TextStyle(color: Colors.grey, fontSize: 12),
//                    ),
//                  ),
//                  InkResponse(
//                    child: Container(
//                      margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
//                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
//                      decoration: BoxDecoration(
//                        color: Colors.grey[200],
//                        borderRadius: BorderRadius.all(Radius.circular(15)),
//                      ),
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: [
//                          Icon(
//                            Icons.add_circle_outline,
//                            color: Color.fromRGBO(55, 121, 248, 1),
//                          ),
//                          Text(
//                            "Add New Address",
//                            textAlign: TextAlign.center,
//                            style: TextStyle(
//                              color: Color.fromRGBO(55, 121, 248, 1),
//                              fontFamily: "Avenir Next",
//                              fontWeight: FontWeight.w600,
////                fontSize: 22,
//                            ),
//                          ),
//                        ],
//                      ),
//                    ),
//                    onTap: () {
//                      Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) => AddressPage(
//                                    token: widget.token,
//                                  )));
//                    },
//                  )
//                ],
//              ),
//            ),
//          ),
          Container(
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width - 40,
            margin: EdgeInsets.fromLTRB(10, 10, 10, 5),

//              margin: EdgeInsets.all(10),
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

//              margin: EdgeInsets.fromLTRB(10,10,10,10),
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

//      list.add(StaggeredTile.count(1, 1));

      familyMembers.forEach((member){
        list.add(StaggeredTile.fit(1));
      });

      list.add(StaggeredTile.fit(2));

//      list.add(StaggeredTile.count(2,0.5));
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
                    CircleAvatar(
                      backgroundImage:
                      NetworkImage('https://i.pravatar.cc/300'),
                    ),
//                    SizedBox(
//                      height: 10,
//                    )
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
//                SizedBox(
//                  height: 5,
//                ),
                Container(
                  child: primary==true?
                  Container(
                    padding: EdgeInsets.fromLTRB(15,5,15,5),
//                    width: MediaQuery.of(context).size.width - 120,
//                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
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
                      :Text(
                    relation, //236, G:31, B:39
                    style: TextStyle(
                        fontSize: 12, color: Color.fromRGBO(236, 31, 39, 1)),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    _getStaggeredTileWidgets(){
      List<Widget> widgetList=[];

      /*
      getPatientTile(true, widget.user.first_name, 'Myself'),
                    getPatientTile(false, 'Jane Doe', 'Wife'),
                    getPatientTile(false, 'Joel Doe', 'Son'),
                    getPatientTile(false, 'Janet Doe', 'Daughter'),
                    _getAdd()
       */

      widgetList.add(getPatientTile(true, widget.user.first_name, 'Myself'));
      familyMembers.forEach((member){
        widgetList.add(getPatientTile(false, member.firstName, member.relationshipName));
      });
      widgetList.add(_getAdd());
      return widgetList;
    }

    return ScrollConfiguration(
      behavior: MyScrollBehavior(),
      child: Container(
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
          )),
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
        createDialog(context);
      },
    );
  }

  createDialog(BuildContext context){
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Center(child: Text('Add New Member',style: TextStyle(color:  Color.fromRGBO(55, 121, 248, 1)),)),
            content: _inputFields(),
            backgroundColor: Colors.white,

            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(35,10,35,10),
//                    width: MediaQuery.of(context).size.width - 120,
//                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      decoration: BoxDecoration(
//                      gradient: Gradients.redGradient,
                        borderRadius: BorderRadius.all(Radius.circular(35)),
                      ),
                      child: Text(
                        "Cancel",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: "Avenir Next",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(35,10,35,10),
                      decoration: BoxDecoration(
                        gradient: Gradients.redGradient,
                        borderRadius: BorderRadius.all(Radius.circular(35)),
                      ),
                      child: Text(
                        "Save",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Avenir Next",
                          fontWeight: FontWeight.w600,
//                        fontSize: 22,
                        ),
                      ),
                    ),
                    onTap: () async {
                      final member=FamilyMember(
                          firstName: nameController.text,
                          age: int.parse(ageController.text),
                          gender: genderController.text,
                          relationshipName: relationController.text
                      );

                      final result=await ProfileService.addFamilyMember(member, widget.token);
                      if(result!=null){
                        Navigator.pop(context,(){
                          setState(() {

                          });
                        });
                      }
/*
{
        print('Add address pressed');
        final address=model.Address(
            pincode: int.parse(pinCodeController.text),
            state: dropdownValue,
            city: cityController.text,
            landmark: landmarkController.text,
            houseDetails: houseController.text,
            areaDetails: areaController.text,
            addressType: selectedRadio
        );

        final result=await ProfileService.addAddress(address, widget.token);

        if(result!=null){
          Navigator.pop(context,() {
            setState(() {});
          });
        }
      },
 */
                    },
                  )
                ],
              )

//              Container(width: 200,
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: <Widget>[
//                    Container(
////                    padding: EdgeInsets.all(15),
////                    width: MediaQuery.of(context).size.width - 120,
////                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
//                      decoration: BoxDecoration(
//                        gradient: Gradients.redGradient,
//                        borderRadius: BorderRadius.all(Radius.circular(35)),
//                      ),
//                      child: Column(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: [
//                          Text(
//                            "Save",
//                            textAlign: TextAlign.center,
//                            style: TextStyle(
//                              color: Colors.white,
//                              fontFamily: "Avenir Next",
//                              fontWeight: FontWeight.w600,
//                              fontSize: 22,
//                            ),
//                          ),
//                        ],
//                      ),
//                    ),
//                    Container(
////                    padding: EdgeInsets.all(15),
////                    width: MediaQuery.of(context).size.width - 120,
////                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
//                      decoration: BoxDecoration(
//                        gradient: Gradients.redGradient,
//                        borderRadius: BorderRadius.all(Radius.circular(35)),
//                      ),
//                      child: Column(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: [
//                          Text(
//                            "Save",
//                            textAlign: TextAlign.center,
//                            style: TextStyle(
//                              color: Colors.white,
//                              fontFamily: "Avenir Next",
//                              fontWeight: FontWeight.w600,
//                              fontSize: 22,
//                            ),
//                          ),
//                        ],
//                      ),
//                    )
//                  ],
//                ),
//              )

//              FlatButton(
//                child: Text('yes'),
//                onPressed: (){
////                  Navigator.pushNamed(context, '/verifyOtp',
////                      arguments: {'number': mobileController.text});
//                },
//              )
            ],
          );
        }
    );
  }

  _inputFields() {
    return Form(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: Colors.white),
//          color: Colors.black,
        padding: EdgeInsets.fromLTRB(40, 0, 40, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[

            Container(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: TextFormField(
                controller: nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  labelText: "Name",
                  labelStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 15.0,
                      letterSpacing: 1.0),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                    BorderSide(width: 0.5, color: Colors.grey[400]),
                  ),
                ),
              ),
            ),
//              Text("*",style: TextStyle(color: Colors.red),),

            Container(
              padding: EdgeInsets.only(bottom: 20),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: ageController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  labelText: "Age",
                  labelStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 15.0,
                      letterSpacing: 1.0),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                    BorderSide(width: 0.5, color: Colors.grey[400]),
                  ),
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.only(bottom: 20),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: genderController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  labelText: "Gender",
                  labelStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 15.0,
                      letterSpacing: 1.0),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                    BorderSide(width: 0.5, color: Colors.grey[400]),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 20),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: relationController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  labelText: "Relation",
                  labelStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 15.0,
                      letterSpacing: 1.0),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                    BorderSide(width: 0.5, color: Colors.grey[400]),
                  ),
                ),
              ),
            ),






          ],
        ),
      ),
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
          image = "assets/profile/gender.png";
          break;
        case "Age":
          image = "assets/profile/age.png";
          break;
        case "Height":
          image = "assets/profile/height.png";
          break;
        case "Glucose":
          image = "assets/profile/glucose.png";
          break;
        case "BMI":
          image = "assets/profile/bmi.png";
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
                    child: Image.asset(
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
