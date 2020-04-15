import 'package:flutter/material.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission/permission.dart';
import 'package:suraksha/models/test_center.dart';
import 'package:suraksha/models/user.dart';
import 'package:suraksha/pages/my_scroll_behaviour.dart';
import 'package:suraksha/resource/shared_preference_helper.dart';
import 'package:suraksha/services/profile_service.dart';
import 'package:suraksha/services/test_center_service.dart';
import 'package:suraksha/values/gradients.dart';

import 'dart:math' show cos, sqrt, asin;


class MapDemo3 extends StatefulWidget {
  @override
  _MapDemo3State createState() => _MapDemo3State();
}

class _MapDemo3State extends State<MapDemo3> {
  final Set<Polyline> polyline = {};

  Map<String, List<LatLng>> map=new Map();

User  user;
String _token;

  SharedPrefsHelper _sharedPrefsHelper = new SharedPrefsHelper();

  bool testcentersloaded;
  double distance;
  List<LatLng> routeCoords;

  List<TestCenter> testCenterList = [];

  GoogleMapController myController;

  List<Marker> markers = [];

  Position _currentPosition;

  GoogleMapPolyline googleMapPolyline =
  new GoogleMapPolyline(apiKey: "AIzaSyBb88FeQ05-gerOLaz6YszD-EF9WNDn670");

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
    super.initState();
    print("INIT 1");
    funct();

    print("INIT 5");
//    _getCurrentLocation();
    print("INIT 6");
  }

  funct() async {
    var permission =
    await Permission.getPermissionsStatus([PermissionName.Location]);
    if (permission[0].permissionStatus == PermissionStatus.notAgain) {
      var askpermissions =
      await Permission.requestPermissions([PermissionName.Location]);
    } else {
      Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((Position position) {
        print("INIT 2");
        _getTestCenters(position);

        testCenterList.forEach((testcenter) {
          print("INTI 3 TESTCENTER: " + testcenter.toJson().toString());
        });
        print("INIT 4");
      });
    }
  }

  Future<List<LatLng>> getSomePoints(
      Position currentLocation, TestCenter testCenter) async {
    print('Getting polylines route coords');

//      routeCoords = await googleMapPolyline.getCoordinatesWithLocation(
//          origin: LatLng(_currentPosition.latitude, _currentPosition.longitude),
//          destination: destination,
//          mode: RouteMode.driving);

//    print('poly points set!!' + routeCoords.toString());

    return await googleMapPolyline.getCoordinatesWithLocation(
        origin: LatLng(currentLocation.latitude, currentLocation.longitude),
        destination: LatLng(testCenter.latitude, testCenter.longitude),
        mode: RouteMode.driving);
//    }
  }

  _getTestCenters(Position position) async {
    final result = await TestCenterService.getTestCenterList();
    if (result != null) {
      int count = 0;
      setState(() {
        result.data.forEach((testCenter) {
          double dist;
          count++;
          getSomePoints(position, testCenter).then((latlnglist) {
            map[testCenter.id]=latlnglist;

            dist = _getDistance(latlnglist);
            testCenter.distance = distance;
            print("DISTANCE BETWEEN IS: " + dist.toString());
            testCenterList.add(testCenter);
            print('test centre list: ' + testCenter.toJson().toString());
          });
        });
        if (count == result.data.length) {
          print("LIST FILLED");
//          setState(() {});
          setState(() {
            print('Got location ');
            print(position);
            _currentPosition = position;
            markers.add(Marker(
              icon: BitmapDescriptor.fromAsset('assets/location/current_location2.png'),
              markerId: MarkerId('myMarker'),
              draggable: true,
              onTap: () {
                print('Marker tapped');
              },
              position:
              LatLng(_currentPosition.latitude, _currentPosition.longitude),
            ));


            result.data.forEach((testCenter) {
              markers.add(Marker(
                icon: BitmapDescriptor.fromAsset('assets/location/testCenter2.png'),
                markerId: MarkerId(testCenter.name),
                draggable: false,
                position: LatLng(testCenter.latitude, testCenter.longitude),
              ));
            });
          });
        }
      });
    } else {
      print('no test centres');
    }
  }

  _getDistance(List<LatLng> list) {
    double calculateDistance(lat1, lon1, lat2, lon2) {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((lat2 - lat1) * p) / 2 +
          c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
      return 12742 * asin(sqrt(a));
    }

    List<dynamic> data = [
      {"lat": 13.0214252, "lng": 77.6412593},
      {"lat": 12.9787986, "lng": 77.667015}
    ];
    double totalDistance = 0;
    for (var i = 0; i < list.length - 1; i++) {
      totalDistance += calculateDistance(list[i].latitude, list[i].longitude,
          list[i + 1].latitude, list[i + 1].longitude);
    }
    distance = totalDistance;
    print("TOTAL DISTANCE:" + totalDistance.toString());
    return distance;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: _currentPosition == null
              ? Container(
            child: Center(child: Image.asset('assets/gif/loader.gif')),
          )
              : Container(
            child: Stack(
              children: <Widget>[
                _getMap(),
                _getCaption(),
                _scrollableTile(),
                saveLocationButton(context)
              ],
            ),
          )),
    );
  }

  _getCaption() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(35),
              bottomLeft: Radius.circular(35))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: InkResponse(
                    child: Text(
                      "Skip",
                      style: TextStyle(
                          color: Colors.red,
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Text(
              'Select Favourite',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Text(
              'Location',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }

  _getMap() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: GoogleMap(
        onMapCreated: onMapCreated,
        mapType: MapType.normal,
        initialCameraPosition: _currentPosition != null
            ? CameraPosition(
            target: LatLng(
                _currentPosition.latitude, _currentPosition.longitude),
            zoom: _currentPosition != null ? 10 : 10)
            : null,
        markers: _currentPosition != null ? Set.from(markers) : null,
        polylines: polyline,
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      myController = controller;
    });
  }

  _getCurrentLocation() async {
    print('Requested location');
    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        print('Got location ');
        print(position);
        _currentPosition = position;
        markers.add(Marker(
          icon: BitmapDescriptor.fromAsset(
              'assets/location/current_location2.png'),
          markerId: MarkerId('myMarker'),
          draggable: true,
          onTap: () {
            print('Marker tapped');
          },
          position:
          LatLng(position.latitude, position.longitude),
        ));

        testCenterList.forEach((testCenter) {
          markers.add(Marker(
            icon: BitmapDescriptor.fromAsset('assets/location/testCenter2.png'),
            markerId: MarkerId(testCenter.name),
            draggable: false,
            position: LatLng(testCenter.latitude, testCenter.longitude),
          ));
        });
      });
    });
  }

  _scrollableTile() {
    return Positioned(
      bottom: 80,
      left: 25,
      right: 25,
      child: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 6,
            child: ScrollConfiguration(
              behavior: MyScrollBehavior(),
              child: ListView(
                  scrollDirection: Axis.vertical, children: _getTiles()),
            ),
          ),
        ],
      ),
    );
  }

  getSomePolyPoints(LatLng destination) async {
    var permission =
    await Permission.getPermissionsStatus([PermissionName.Location]);
    if (permission[0].permissionStatus == PermissionStatus.notAgain) {
      var askpermissions =
      await Permission.requestPermissions([PermissionName.Location]);
    } else {
      print('Getting polylines route coords');

      routeCoords = await googleMapPolyline.getCoordinatesWithLocation(
          origin: LatLng(_currentPosition.latitude, _currentPosition.longitude),
          destination: destination,
          mode: RouteMode.driving);

      print('poly points set!!' + routeCoords.toString());
    }
  }

  _wait(TestCenter testCenter) async {
    await getSomePolyPoints(LatLng(testCenter.latitude, testCenter.longitude));
  }

  _getTile(TestCenter testCenter) {
    return GestureDetector(
      onTap: () {
        myController
            .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(testCenter.latitude, testCenter.longitude),
//          tilt: 45,
            zoom: 12)));
        setState(() {
//          _wait(testCenter);
//          print('*****routes are*******');
//          print('*****routes are*******');
//          print(routeCoords);
          polyline.clear();
          polyline.add(Polyline(
              polylineId: PolylineId('route1'),
              visible: true,
              points: map[testCenter.id],
              width: 2,
              color: Color.fromRGBO(212, 23, 54, 1),
              startCap: Cap.roundCap,
              endCap: Cap.buttCap));
        });
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
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
    print("TRYING TO GET SCROLL TILES: " + testCenterList.toString());
    testCenterList.forEach((testCenter) {
      Widget wigdet = _getTile(testCenter);
      widgetList.add(wigdet);
      widgetList.add(SizedBox(
        height: 10,
      ));
    });

    return widgetList;
  }

  Widget saveLocationButton(BuildContext context) {
    return Positioned(
      bottom: 15,
      left: 60,
      right: 60,
      child: InkResponse(
        child: Container(
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            gradient: Gradients.redGradient,
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Save Location",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontFamily: "Avenir Next",
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          print("SAVE LOCATION PRESSED");
          setState(() async{
            User newUser=User(
              gender: 'Female'
            );
            final result = await ProfileService.updateUser(_token, user, newUser);


            if (result != null) {
              if(result.statusCode==200){
              Navigator.pop(context);
            } }else {
              print('*****NOPE*****');
            }
          });
        },
      ),
    );
  }
}
