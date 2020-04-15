//
//import 'package:flutter/material.dart';
//import 'package:google_map_polyline/google_map_polyline.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:geolocator/geolocator.dart';
//import 'package:permission/permission.dart';
//import 'package:suraksha/models/test_center.dart';
//import 'package:suraksha/pages/my_scroll_behaviour.dart';
//import 'package:suraksha/services/test_center_service.dart';
//import 'package:suraksha/values/gradients.dart';
//
//import 'dart:math' show cos, sqrt, asin;
//
////import 'my_scroll_behaviour.dart';
//
//class MapDemo extends StatefulWidget {
//  @override
//  _MapDemoState createState() => _MapDemoState();
//}
//
//class _MapDemoState extends State<MapDemo> {
//  final Set<Polyline> polyline = {};
//  double distance;
//  List<LatLng> routeCoords;
//
//  List<TestCenter> testCenterList = [];
//
//  GoogleMapController myController;
//
//  List<Marker> markers = [];
//
//  Position _currentPosition;
//
//  GoogleMapPolyline googleMapPolyline =
//  new GoogleMapPolyline(apiKey: "AIzaSyBb88FeQ05-gerOLaz6YszD-EF9WNDn670");
//
//  @override
//  void initState() {
//    super.initState();
//    _getCurrentLocation();
//
//    _getTestCenters();
//
//
//  }
//
//  getSomePoints() async {
//    routeCoords = await googleMapPolyline.getCoordinatesWithLocation(
//        origin: LatLng(37.785834, -122.406417),
//        destination: LatLng(37.7599, -122.4148),
//        mode: RouteMode.driving);
//  }
//
//  _getTestCenters() async {
//
//    Geolocator()
//        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
//        .then((Position position) async{
//      final result = await TestCenterService.getTestCenterList();
//      if (result != null) {
//        setState(() {
//          result.data.forEach((testCenter) {
//
//            double distance;
//            print("EACH TEST CENTRE: "+testCenter.toJson().toString());
//            getSomePolyPoints2(LatLng(testCenter.latitude,testCenter.longitude),position).then((value){
//              distance=_getDistance(value);
//              testCenter.distance=distance;
//              testCenterList.add(testCenter);
//              print('test centre list: ' + testCenter.toJson().toString());
//            });
//
//          });
//        });
//      } else {
//        print('no test centres');
////      }
//      }
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return SafeArea(
//      child: Scaffold(
//          body: _currentPosition == null
//              ? Container(
//            child: Center(
//                child: Image.asset('assets/gif/loader.gif')
//            ),
//          )
//              : Container(
//            child: Stack(
//              children: <Widget>[
//                _getMap(),
//                _getCaption(),
//                _scrollableTile(),
//                saveLocationButton(context)
//              ],
//            ),
//          )),
//    );
//  }
//
//  _getCaption() {
//    return Container(
//      width: MediaQuery.of(context).size.width,
//      decoration: BoxDecoration(
//          color: Colors.white.withOpacity(0.9),
//          borderRadius: BorderRadius.only(
//              bottomRight: Radius.circular(35),
//              bottomLeft: Radius.circular(35))),
//      child: Column(
//        mainAxisSize: MainAxisSize.min,
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          Container(
//            alignment: Alignment.topRight,
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                IconButton(
//                  icon: Icon(
//                    Icons.arrow_back_ios,
//                    color: Colors.black,
//                  ),
//                  onPressed: () {
//                    Navigator.pop(context);
//                  },
//                ),
//                Padding(
//                  padding: const EdgeInsets.all(20.0),
//                  child: InkResponse(
//                    child: Text(
//                      "Skip",
//                      style: TextStyle(
//                          color: Colors.red,
//                          decoration: TextDecoration.underline,
//                          fontSize: 16,
//                          fontWeight: FontWeight.bold,
//                          letterSpacing: 1),
//                    ),
//                  ),
//                ),
//              ],
//            ),
//          ),
//          Padding(
//            padding: const EdgeInsets.only(left: 30.0),
//            child: Text(
//              'Select Favourite',
//              style: TextStyle(
//                  color: Colors.black,
//                  fontSize: 22,
//                  fontWeight: FontWeight.bold),
//            ),
//          ),
//          Padding(
//            padding: const EdgeInsets.only(left: 30.0),
//            child: Text(
//              'Location',
//              style: TextStyle(
//                  color: Colors.black,
//                  fontSize: 22,
//                  fontWeight: FontWeight.bold),
//            ),
//          ),
//          SizedBox(
//            height: 30,
//          )
//        ],
//      ),
//    );
//  }
//
//  _getMap() {
//    return Container(
//      height: MediaQuery.of(context).size.height,
//      width: double.infinity,
//      child: GoogleMap(
//        onMapCreated: onMapCreated,
//        mapType: MapType.normal,
//        initialCameraPosition: _currentPosition != null
//            ? CameraPosition(
//            target: LatLng(
//                _currentPosition.latitude, _currentPosition.longitude),
//            zoom: _currentPosition != null ? 10 : 10)
//            : null,
//        markers: _currentPosition != null ? Set.from(markers) : null,
//        polylines: polyline,
//      ),
//    );
//  }
//
//  void onMapCreated(GoogleMapController controller) {
//    setState(() {
//      myController = controller;
//    });
//  }
//
//  _getCurrentLocation() async {
//    print('Requested location');
//    Geolocator()
//        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
//        .then((Position position) {
//      setState(() {
//        print('Got location ');
//        print(position);
//        _currentPosition = position;
//        markers.add(Marker(
//          icon: BitmapDescriptor.fromAsset('assets/location/current_location2.png'),
//          markerId: MarkerId('myMarker'),
//          draggable: true,
//          onTap: () {
//            print('Marker tapped');
//          },
//          position:
//          LatLng(_currentPosition.latitude,_currentPosition.longitude),
//        ));
//
//        testCenterList.forEach((testCenter){
//          markers.add(Marker(
//            icon: BitmapDescriptor.fromAsset('assets/location/testCenter2.png'),
//
//            markerId: MarkerId(testCenter.name),
//            draggable: false,
//            position: LatLng(testCenter.latitude,testCenter.longitude),
//          ));
//        });
//      });
//    });
//  }
//
//  _getCurrentLocation2() async {
//    print('Requested location');
//    Geolocator()
//        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
//        .then((Position position) {
//      setState(() {
//        print('Got location ');
//        print(position);
//        _currentPosition = position;
//        markers.add(Marker(
//          icon: BitmapDescriptor.fromAsset('assets/location/current_location2.png'),
//          markerId: MarkerId('myMarker'),
//          draggable: true,
//          onTap: () {
//            print('Marker tapped');
//          },
//          position:
//          LatLng(_currentPosition.latitude,_currentPosition.longitude),
//        ));
//
//        testCenterList.forEach((testCenter){
//          markers.add(Marker(
//            icon: BitmapDescriptor.fromAsset('assets/location/testCenter2.png'),
//
//            markerId: MarkerId(testCenter.name),
//            draggable: false,
//            position: LatLng(testCenter.latitude,testCenter.longitude),
//          ));
//        });
//      });
//    });
//  }
//
//  _scrollableTile() {
//    return Positioned(
//      bottom: 80,
//      left: 25,
//      right: 25,
//      child: Stack(
//        children: <Widget>[
//          Container(
//            height: MediaQuery.of(context).size.height / 6,
//            child: ScrollConfiguration(
//              behavior: MyScrollBehavior(),
//              child: ListView(
//                  scrollDirection: Axis.vertical, children: _getTiles()),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//
//  getSomePolyPoints(LatLng destination) async {
//
//    var permission=await Permission.getPermissionsStatus([PermissionName.Location]);
//    if(permission[0].permissionStatus==PermissionStatus.notAgain){
//      var askpermissions=
//      await Permission.requestPermissions([PermissionName.Location]);
//    }else{
//      print('Getting polylines route coords');
//
//      routeCoords = await googleMapPolyline.getCoordinatesWithLocation(
//          origin: LatLng(_currentPosition.latitude, _currentPosition.longitude),
//          destination: destination,
//          mode: RouteMode.driving);
//
//      print('poly points set!!' + routeCoords.toString());
//    }
//  }
//
//  Future<List<LatLng>> getSomePolyPoints2(LatLng destination, Position position) async {
//    List<LatLng> routeCoords5;
//    var permission=await Permission.getPermissionsStatus([PermissionName.Location]);
//    if(permission[0].permissionStatus==PermissionStatus.notAgain){
//      var askpermissions=
//      await Permission.requestPermissions([PermissionName.Location]);
//    }else{
//      print('Getting polylines route coords');
//
//      routeCoords5 = await googleMapPolyline.getCoordinatesWithLocation(
//          origin: LatLng(position.latitude, position.longitude),
//          destination: destination,
//          mode: RouteMode.driving);
//
//      print('poly points set!!' + routeCoords.toString());
//    }
//    return routeCoords5;
//
//
//  }
//
//  _wait(TestCenter testCenter) async {
//    routeCoords= await getSomePolyPoints(LatLng(testCenter.latitude, testCenter.longitude));
//  }
//
//  _getTile(TestCenter testCenter) {
//
////    double distance;
////    getSomePolyPoints2(LatLng(testCenter.latitude,testCenter.longitude)).then((value){
////      distance=_getDistance(value);
////
////
////    });
//
//    return GestureDetector(
//      onTap: () {
//        myController
//            .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//            target: LatLng(testCenter.latitude, testCenter.longitude),
////          tilt: 45,
//            zoom: 12)));
//        setState(() {
//          _wait(testCenter);
//          print('*****routes are*******');
//          print(routeCoords);
//          polyline.clear();
//          polyline.add(Polyline(
//              polylineId: PolylineId('route1'),
//              visible: true,
//              points: routeCoords,
//              width: 2,
//              color: Color.fromRGBO(212, 23, 54, 1),
//              startCap: Cap.roundCap,
//              endCap: Cap.buttCap));
//        });
//
//      },
//      child: Container(
//        padding: EdgeInsets.fromLTRB(0,10,0,10),
//        decoration: BoxDecoration(
//          color: Colors.white,
//          borderRadius: BorderRadius.circular(15),
//        ),
//        width: MediaQuery.of(context).size.width - 50,
//        child: Center(
//          child: ListTile(
//            leading: Container(
//                child: Image.asset('assets/location/testCenter2.png',fit: BoxFit.fill,)
//            ),
//            title: Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                Text(
//                  testCenter.name,
//                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//                ),
//                SizedBox(
//                  height: 3,
//                ),
//                Text(
//                  testCenter.address,
//                  style: TextStyle(fontSize: 12),
//                ),
//                SizedBox(
//                  height: 3,
//                ),
//                Text(
//                  '$distance Km',
//                  style: TextStyle(fontSize: 12, color: Colors.grey),
//                )
//              ],
//            ),
//            trailing: Text(
//              '12 mins',
//              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//            ),
//          ),
//        ),
//      ),
//    );
//
//
//  }
//  _getDistance(List<LatLng> list){
//
//    double calculateDistance(lat1, lon1, lat2, lon2){
//      var p = 0.017453292519943295;
//      var c = cos;
//      var a = 0.5 - c((lat2 - lat1) * p)/2 +
//          c(lat1 * p) * c(lat2 * p) *
//              (1 - c((lon2 - lon1) * p))/2;
//      return 12742 * asin(sqrt(a));
//    }
//
//    List<dynamic> data = [
//      {
//        "lat": 13.0214252,
//        "lng": 77.6412593
//      },{
//        "lat": 12.9787986,
//        "lng": 77.667015
//      }
//    ];
//    double totalDistance = 0;
//    for(var i = 0; i < list.length-1; i++){
//      totalDistance += calculateDistance(list[i].latitude, list[i].longitude, list[i+1].latitude, list[i+1].longitude);
//    }
//    distance=totalDistance;
//    print("TOTAL DISTANCE:" +totalDistance.toString());
//    return distance;
//  }
//
//
//
//  _getTiles() {
//    List<Widget> widgetList = [];
//    print("gettign tile");
//
//    testCenterList.forEach((testCenter){
//      print("tile present");
//
//      Widget wigdet=_getTile(testCenter);
//      widgetList.add(wigdet);
//      widgetList.add(SizedBox(height: 10,));
//
//
//    });
//
//    return widgetList;
//  }
//
//  Widget saveLocationButton(BuildContext context) {
//    return Positioned(
//      bottom: 15,
//      left: 60,
//      right: 60,
//      child: InkResponse(
//        child: Container(
//          height: 50,
//          margin: EdgeInsets.symmetric(horizontal: 5),
//          decoration: BoxDecoration(
//            gradient: Gradients.redGradient,
//            borderRadius: BorderRadius.all(Radius.circular(25)),
//          ),
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: [
//              Text(
//                "Save Location",
//                textAlign: TextAlign.center,
//                style: TextStyle(
//                  color: Color.fromARGB(255, 255, 255, 255),
//                  fontFamily: "Avenir Next",
//                  fontWeight: FontWeight.w600,
//                  fontSize: 16,
//                ),
//              ),
//            ],
//          ),
//        ),
//        onTap: () {},
//      ),
//    );
//  }
//}
//
