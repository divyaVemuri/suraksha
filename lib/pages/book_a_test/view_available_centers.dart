import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission/permission.dart';
import 'package:suraksha/models/test.dart';
import 'package:suraksha/models/test_center.dart';
import 'package:suraksha/models/user.dart';
import 'package:suraksha/pages/book_a_test/test_details.dart' as prefix0;
import 'package:suraksha/pages/cart.dart';
import 'package:suraksha/pages/commons/app_bar.dart';
import 'package:suraksha/pages/map_demo.dart';
import 'package:suraksha/pages/test_details.dart';
import 'package:suraksha/services/profile_service.dart';
import 'package:suraksha/services/test_service.dart';
import 'package:suraksha/values/gradients.dart';
import 'dart:math' show cos, sqrt, asin;

class ViewAvailableCenters extends StatefulWidget {

  List<TestCenter> testCenterList;

  ViewAvailableCenters({this.testCenterList});

  @override
  _ViewAvailableCentersState createState() => _ViewAvailableCentersState();
}

class _ViewAvailableCentersState extends State<ViewAvailableCenters> {
  bool showCartPressed;
  User existingUser;
  User user;
  String favLocation;
  List<Test> testList = [];
  bool infoloaded=false;

  GoogleMapPolyline googleMapPolyline =
  new GoogleMapPolyline(apiKey: "AIzaSyBb88FeQ05-gerOLaz6YszD-EF9WNDn670");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showCartPressed = false;
    funct();
  }

  funct() async {
    print("Getting distance: "+widget.testCenterList[0].toJson().toString());
    var permission =
    await Permission.getPermissionsStatus([PermissionName.Location]);
    if (permission[0].permissionStatus == PermissionStatus.notAgain) {
      var askpermissions =
      await Permission.requestPermissions([PermissionName.Location]);
    } else {
      Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((Position position) {

//        _getTestCenters(position);
        _getTestCenters(Position(latitude: 13.0214252,longitude:77.6412593));
        //13.0214252,77.6412593

      });
    }
  }

  _getTestCenters(Position position) async {
    int count=0;
    try {
        setState(() {
          print("current locations: " + position.toJson().toString());
          widget.testCenterList.forEach((testCenter) {
            print("current test center: "+testCenter.id);
            double dist;
            getSomePoints(position, testCenter).then((latlnglist) {
              count++;
              print("poly point here: " + latlnglist.toString());
              dist = _getDistance(latlnglist);
              testCenter.distance = dist;
              print("Test Centre details: " + testCenter.toJson().toString());

              if(count==widget.testCenterList.length){
                print("count is : "+count.toString() );
                setState(() {
                  infoloaded=true;

                });
              }
            });
          });
        });
    } catch (e) {
      print(e);
    }

  }

  _getDistance(List<LatLng> list) {
    if (list != null) {
      double calculateDistance(lat1, lon1, lat2, lon2) {
        var p = 0.017453292519943295;
        var c = cos;
        var a = 0.5 -
            c((lat2 - lat1) * p) / 2 +
            c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
        return 12742 * asin(sqrt(a));
      }

      double totalDistance = 0;
      for (var i = 0; i < list.length - 1; i++) {
        totalDistance += calculateDistance(list[i].latitude, list[i].longitude,
            list[i + 1].latitude, list[i + 1].longitude);
      }
      return totalDistance;
    } else {
      return 13.4;
    }
  }


  Future<List<LatLng>> getSomePoints(
      Position currentLocation, TestCenter testCenter) async {
    print('Getting polylines route coords');
    return await googleMapPolyline.getCoordinatesWithLocation(
      origin: LatLng(currentLocation.latitude, currentLocation.longitude),
      destination: LatLng(testCenter.latitude, testCenter.longitude),
      mode: RouteMode.driving,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: infoloaded?Stack(
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
          ):Container(
            child: Center(child: Image.asset('assets/gif/loader.gif')),
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
          (1 / 4),
      child: Column(

        children: <Widget>[
          Expanded(
            flex: 1,
            child: MyAppBar(),
          ),
          caption()
        ],
      ),
    );
  }

  caption() {
    return Expanded(
      flex: 2,
      child: Container(
        padding: EdgeInsets.only(left: 20,top: 10),
        alignment: Alignment.bottomLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                  'Available',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                letterSpacing: 1,
                fontWeight: FontWeight.w300,
              ),),
            ),
            Container(
              child: Text(
                  'Centers',
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 1,
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),),
            )
          ],
        ),
      ),
    );
  }

  Widget search() {
    return Positioned(
      top: (MediaQuery.of(context).size.height -
          (MediaQuery.of(context).padding.top +
              MediaQuery.of(context).padding.bottom)) /
          4 -
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
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                hintText: 'Search Center by location',
                hintStyle:
                TextStyle(fontSize: 14, fontWeight: FontWeight.w300)),
            onChanged: (string) {

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
          (3 / 4),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          color: Colors.white),
      child: Container(
        child:  Column(
          children: _getTiles(),
        )
      ),
    );
  }
  _getTile(TestCenter testCenter) {
    return GestureDetector(
      onTap: () {
      },
      child: Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
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
        width: MediaQuery.of(context).size.width - 50,
        child: Center(
          child: ListTile(
            leading: Container(
                child: Image.asset(
                  'assets/location/testCenter2.png',
                  fit: BoxFit.fill,
                )),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  testCenter.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  testCenter.address,
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  '${testCenter.distance.toStringAsFixed(2)} Km',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                )
              ],
            ),
            trailing: Text(
              '12 mins',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  _getTiles() {
    List<Widget> widgetList = [];
    widget.testCenterList.forEach((testCenter) {
      Widget wigdet = _getTile(testCenter);
      widgetList.add(wigdet);
      widgetList.add(SizedBox(
        height: 10,
      ));
    });

    return widgetList;
  }

}
