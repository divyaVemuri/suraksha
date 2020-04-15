import 'package:flutter/material.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission/permission.dart';
import 'package:suraksha/models/test_center.dart';
import 'package:suraksha/models/user.dart';
import 'package:suraksha/resource/shared_preference_helper.dart';
import 'package:suraksha/services/profile_service.dart';
import 'package:suraksha/services/test_center_service.dart';
import 'package:suraksha/values/gradients.dart';

import 'dart:math' show cos, sqrt, asin;

import 'my_scroll_behaviour.dart';

class MapDemo extends StatefulWidget {

  final ValueChanged<TestCenter> centre;


  MapDemo({this.centre});

  @override
  _MapDemoState createState() => _MapDemoState();
}

class _MapDemoState extends State<MapDemo> {
  String selectedTile;
  String favouriteLocation;
  User user;
  User existingUser;
  String _token;
  SharedPrefsHelper _sharedPrefsHelper = new SharedPrefsHelper();

  final Set<Polyline> polyline = {};
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
    _getMyProfile();
    _getTestCenters();
    _getDistance();
    _getCurrentLocation();
  }

  _getMyProfile() async {
    print("GETTING EXISTING");
    final result = await ProfileService.getUserProfile(user.id, _token);
    if (result != null) {
      setState(() {
        print("EXISTING USER: "+result.data.toJson().toString());
        existingUser = result.data;
        print("EXISTING INITIALISED: "+existingUser.toJson().toString());
      });
    }
  }

  getSomePoints() async {
    routeCoords = await googleMapPolyline.getCoordinatesWithLocation(
        origin: LatLng(37.785834, -122.406417),
        destination: LatLng(37.7599, -122.4148),
        mode: RouteMode.driving);
  }

  _getTestCenters() async {
    final result = await TestCenterService.getTestCenterList();
    if (result != null) {
      setState(() {
        result.data.forEach((testCenter) {
          testCenterList.add(testCenter);
          print('test centre list: ' + testCenter.toJson().toString());
        });
      });
    } else {
      print('no test centres');
    }
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
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 150,
                          child: Opacity(
                            opacity: 1,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Colors.white10, Colors.white])),
                            ),
                          ),
                        ),
                      ),
                      _getCaption(),
                      _scrollableTile(),
                      saveLocationButton(context),
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
                    onTap: (){
                      Navigator.pop(context);
                    },
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
              LatLng(_currentPosition.latitude, _currentPosition.longitude),
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
            height: MediaQuery.of(context).size.height / 5,
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
        selectedTile=testCenter.id;
        favouriteLocation = testCenter.id;
        print("Favourite location selected: "+favouriteLocation);
        myController
            .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                target: LatLng(testCenter.latitude, testCenter.longitude),
//          tilt: 45,
                zoom: 12)));
        setState(() {
          _wait(testCenter);
          print('*****routes are*******');
          print(routeCoords);
          polyline.clear();
          polyline.add(Polyline(
              polylineId: PolylineId('route1'),
              visible: true,
              points: routeCoords,
              width: 2,
              color: Color.fromRGBO(212, 23, 54, 1),
              startCap: Cap.roundCap,
              endCap: Cap.buttCap));
        });
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        decoration: BoxDecoration(
          color: (selectedTile!=null && selectedTile==testCenter.id)?Colors.blueGrey[100]:Colors.white,
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
                  '1.5 Km',
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

  _getDistance() {
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
    for (var i = 0; i < data.length - 1; i++) {
      totalDistance += calculateDistance(data[i]["lat"], data[i]["lng"],
          data[i + 1]["lat"], data[i + 1]["lng"]);
    }
    distance = totalDistance;
    print("total distance:" + totalDistance.toString());
  }

  _getTiles() {
    List<Widget> widgetList = [];

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
      child: Stack(
        children: <Widget>[
          InkResponse(
            child: Container(
              alignment: Alignment.center,
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
            onTap: () async {
              if (favouriteLocation != null) {
                print("SAVE LOCATION PRESSED");
                print("FAV LOCATION: "+favouriteLocation);
                print("EXISTING USER: "+existingUser.toJson().toString());
                User newUser = User(gender: 'Female');

                existingUser.favouriteLocationId = favouriteLocation;
                final result =
                    await ProfileService.updateUser(_token, user, existingUser);

                if (result != null) {
                  if(result.statusCode==200){

                    print("Popped");
                    print(result.data.favouriteLocation);
//                    widget.address(result.data);
                      widget.centre(result.data.favouriteLocation);
                    Navigator.pop(context,result.data.favouriteLocation);
                  }
                }else {
                  print('*****NOPE*****');
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
