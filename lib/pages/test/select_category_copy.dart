//import 'dart:async';
//
//import 'package:dotted_border/dotted_border.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
//import 'package:flutter_svg/flutter_svg.dart';
//import 'package:suraksha/pages.commons/app_bar.dart';
//import 'package:suraksha/constants/asset_constants.dart';
//import 'package:suraksha/models/test_category.dart';
//import 'package:suraksha/pages/select_test.dart';
//import 'package:suraksha/pages/upload_prescription.dart';
//
//class SelectTestCategory extends StatefulWidget {
//  @override
//  _SelectTestCategoryState createState() => _SelectTestCategoryState();
//}
//
//class _SelectTestCategoryState extends State<SelectTestCategory> with SingleTickerProviderStateMixin {
//
//
//  StreamController<bool> isSidebarOpenedStreamController;
//  Stream<bool> isSidebarOpenedStream;
//  StreamSink<bool> isSidebarOpenedSink;
//
//  List<TestCategory> testCategoryList = [];
//  List<TestCategory> filteredCategoryList = [];
//  bool showCartPressed;
//  Widget cartWidget;
//
//  AnimationController _animationController;
//  final _animationDuration = Duration(milliseconds: 300);
//
//  @override
//  void initState() {
//    _animationController =
//        AnimationController(vsync: this, duration: _animationDuration);
//    showCartPressed=false;
//    // TODO: implement initState
//    TestCategory liver =
//    TestCategory(id: 1, name: 'Liver', path: AssetConstants.test_liver);
//    TestCategory kidney =
//    TestCategory(id: 1, name: 'Kidney', path: AssetConstants.test_kidney);
//    TestCategory heart =
//    TestCategory(id: 1, name: 'Heart', path: AssetConstants.test_heart);
//    TestCategory diabetes = TestCategory(
//        id: 1, name: 'Diabetes', path: AssetConstants.test_diabetes);
//    TestCategory thyroid =
//    TestCategory(id: 1, name: 'Thyroid', path: AssetConstants.test_thyroid);
//    TestCategory infertility = TestCategory(
//        id: 1, name: 'Infertility', path: AssetConstants.test_infertility);
//    TestCategory vitamins = TestCategory(
//        id: 1, name: 'Vitamins', path: AssetConstants.test_vitamins);
//    TestCategory joints =
//    TestCategory(id: 1, name: 'Joints', path: AssetConstants.test_joints);
//    TestCategory bones =
//    TestCategory(id: 1, name: 'Bones', path: AssetConstants.test_bones);
//    TestCategory obesity =
//    TestCategory(id: 1, name: 'Obesity', path: AssetConstants.test_obesity);
//    TestCategory hormones = TestCategory(
//        id: 1, name: 'Hormones', path: AssetConstants.test_hormones);
//    TestCategory digestion = TestCategory(
//        id: 1, name: 'Digestion', path: AssetConstants.test_digestion);
//
//    testCategoryList.add(liver);
//    testCategoryList.add(kidney);
//    testCategoryList.add(heart);
//    testCategoryList.add(diabetes);
//    testCategoryList.add(thyroid);
//    testCategoryList.add(infertility);
//    testCategoryList.add(vitamins);
//    testCategoryList.add(joints);
//    testCategoryList.add(bones);
//    testCategoryList.add(obesity);
//    testCategoryList.add(hormones);
//    testCategoryList.add(digestion);
//
//    filteredCategoryList = testCategoryList;
//    super.initState();
//  }
//
////  void onIconPressed() {
////    final animationStatus = _animationController.status;
////    final isAnimationCompleted = animationStatus == AnimationStatus.completed;
////
////    if (isAnimationCompleted) {
////      widget.cartClosed(true);
////      widget.isSidebarOpenedSink.add(false);
////      widget.animationController.reverse();
////    } else {
////      widget.cartClosed(true);
////      widget.isSidebarOpenedSink.add(true);
////      widget.animationController.forward();
////    }
////  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: SafeArea(
//        child: SingleChildScrollView(
//          child: Stack(
//            children: <Widget>[
//              Container(
//                height: MediaQuery.of(context).size.height -
//                    (MediaQuery.of(context).padding.top +
//                        MediaQuery.of(context).padding.bottom),
//                width: MediaQuery.of(context).size.width,
//                child: Image.asset(
//                  'assets/profile/background.png',
//                  fit: BoxFit.fill,
//                ),
//              ),
//              Container(
//                height: (MediaQuery.of(context).size.height -
//                    (MediaQuery.of(context).padding.top +
//                        MediaQuery.of(context).padding.bottom)),
//                child: Column(
//                  children: <Widget>[_getAppBar(), _body()],
//                ),
//              ),
//              showCartPressed?Container(
//                height: (MediaQuery.of(context).size.height -
//                    (MediaQuery.of(context).padding.top +
//                        MediaQuery.of(context).padding.bottom)),
//
//                color: Colors.black.withOpacity(0.7),
//              ):Container(),
//              showCartPressed?
//
//              cartWidget
//                  :Container()
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//
//  _getAppBar() {
//    return Expanded(
//        flex: 1,
//        child:MyAppBar(animationController:_animationController,buttonPressed: (buttonPressed){
//          setState(() {
//            print("Got response back for cart pressed");
//            showCartPressed=buttonPressed;
//          });
//        },cartWidget: (widget){
//          setState(() {
//            print("Got wiget back for cart pressed");
//
//            cartWidget=widget;
//
//          });
//        },)
////      child: Container(
////        padding: EdgeInsets.only(right: 15),
////        child: Row(
////          mainAxisAlignment: MainAxisAlignment.spaceBetween,
////          children: <Widget>[
////            IconButton(
////              icon: Icon(
////                Icons.arrow_back,
////                color: Colors.white,
////              ),
////              onPressed: () {
////                Navigator.pop(context);
////              },
////            ),
////            Row(
////              children: <Widget>[
////                InkResponse(
////                  child: Container(
////                      padding: EdgeInsets.only(left: 10, right: 10),
////                      child: Container(
////                          padding: EdgeInsets.only(left: 10, right: 10),
////                          child: SvgPicture.asset(
////                              'assets/svg/utilities/cart.svg'))),
////                  onTap: (){
////
////
////                    setState(() {
//////                      showCartPressed=true;
////
////                    });
////                  },
////                ),
////                SizedBox(
////                  width: 10,
////                ),
////                InkResponse(
////                  child: SvgPicture.asset('assets/svg/utilities/bell.svg'),
////                )
////              ],
////            )
////          ],
////        ),
////      ),
//    );
//  }
//
//  Widget _body() {
//    return Expanded(
//      flex: 10,
//      child: Container(
//        width: MediaQuery.of(context).size.width,
//        padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
//        decoration: BoxDecoration(
//            borderRadius: BorderRadius.only(
//                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
//            color: Colors.white),
//        child: Container(
//          child: Column(
//            children: <Widget>[_fixed(), scrollable()],
//          ),
//        ),
//      ),
//    );
//  }
//
//  _fixed() {
//    return Expanded(
//      flex: 3,
//      child: Container(
////        color: Colors.green,
//        child: Column(
//          children: <Widget>[
//            uploadPrescription(),
//            Center(
//                child:
//                Container(padding: EdgeInsets.all(10), child: Text('Or'))),
//            search(),
//            _caption()
//          ],
//        ),
//      ),
//    );
//  }
//
//  Widget uploadPrescription() {
//    return Expanded(
//      flex: 1,
//      child: Container(
////        color: Colors.green,
//        alignment: Alignment.center,
//        child: GestureDetector(
//          child: Container(
////            color: Colors.deepOrange,
//            height: 35,
//            padding: EdgeInsets.only(left: 20, right: 20),
//            child: DottedBorder(
//              padding: EdgeInsets.all(2),
//              borderType: BorderType.RRect,
//              radius: Radius.circular(10),
//              strokeWidth: 1,
//              dashPattern: [4],
//              color: Color.fromRGBO(55, 121, 248, 1),
//              child: ClipRRect(
//                borderRadius: BorderRadius.all(Radius.circular(10)),
//                child: Container(
//                  height: 80,
//                  decoration: BoxDecoration(
//                      color: Color.fromRGBO(244, 246, 248, 1),
//                      borderRadius: BorderRadius.all(Radius.circular(10))),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      Icon(
//                        Icons.file_upload,
//                        color: Color.fromRGBO(55, 121, 248, 1),
//                      ),
//                      Text(
//                        'Upload Prescription',
//                        style: TextStyle(
//                            color: Color.fromRGBO(55, 121, 248, 1),
//                            fontWeight: FontWeight.bold,
//                            letterSpacing: 1),
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//            ),
//          ),
//          onTap: (){
//            Navigator.push(context,
//                CupertinoPageRoute(builder: (context) =>UploadPrescription()));
//          },
//        ),
//
//      ),
//    );
//  }
//
//
//  Widget search() {
//    return Expanded(
//      flex: 1,
//      child: Container(
//        alignment: Alignment.center,
//        child: Container(
//          height: 35,
//          padding: EdgeInsets.only(left: 20, right: 20),
//          margin: EdgeInsets.only(left: 20, right: 20),
//          decoration: BoxDecoration(
//              color: Color.fromRGBO(250, 246, 246, 1),
//              borderRadius: BorderRadius.all(Radius.circular(15))),
//
//          child: TextField(
//            decoration: InputDecoration(
//                border: InputBorder.none,
//                icon: Icon(
//                  Icons.search,
//                  color: Colors.grey,
//                ),
//                hintText: 'Search doctors by name/ center',
//                hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w300)),
//            onChanged: (string) {
//              print(string);
//              setState(() {
//                filteredCategoryList = testCategoryList
//                    .where((u) => (u.name
//                    .toLowerCase()
//                    .contains(string.toLowerCase())))
//                    .toList();
//              });
//            },
//          ),
//        ),
//      ),
//    );
//  }
//
//  Widget search2() {
//    return Expanded(
//      flex: 1,
//      child: Container(
//        height: 75,
//        color: Colors.pink,
//        child: Container(
//          height: 75,
//          padding: EdgeInsets.only(left: 20, right: 20),
//          margin: EdgeInsets.only(left: 20, right: 20),
//          decoration: BoxDecoration(
//              color: Color.fromRGBO(250, 246, 246, 1),
//              borderRadius: BorderRadius.all(Radius.circular(15))),
//          child: Row(
//            children: <Widget>[
//              Icon(Icons.search),
//              Text('Search Tests, Symptoms etc')
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//
//  Widget _caption() {
//    return Expanded(
//      flex: 1,
//      child: Container(
//        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
//        child: Row(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          children: <Widget>[
//            Text(
//              'Select Test Category',
//              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//            ),
//            InkResponse(
//              child: Text(
//                'View Less',
//                style: TextStyle(
//                  //R:219, G:32, B:4
//                  color: Color.fromRGBO(219, 32, 4, 1),
//                ),
//              ),
//            )
//          ],
//        ),
//      ),
//    );
//  }
//
//  Widget scrollable() {
//    _getWidget(TestCategory testCategory) {
//      return GestureDetector(
//        child: Container(
//          decoration: BoxDecoration(
//              shape: BoxShape.rectangle,
//              borderRadius: BorderRadius.circular(15),
//              color: Colors.white,
//              boxShadow: [
//                BoxShadow(
//                    color: Colors.grey[200],
//                    offset: Offset(5, 10),
//                    spreadRadius: 0,
//                    blurRadius: 15),
//                BoxShadow(
//                    color: Colors.grey[200],
//                    offset: Offset(-5, 10),
//                    spreadRadius: 0,
//                    blurRadius: 15)
//              ]),
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              SvgPicture.asset(testCategory.path),
//              Text(testCategory.name)
//            ],
//          ),
//        ),
//        onTap: (){
//          Navigator.push(context,
//              CupertinoPageRoute(builder: (context) =>SelectTest()));
//        },
//      );
//    }
//
//    _getStaggeredTileCount() {
//      List<StaggeredTile> list = new List();
//      filteredCategoryList.forEach((testCategory) {
//        list.add(StaggeredTile.count(1, 1));
//      });
//      return list;
//    }
//
//    _getStaggeredTileWidgets() {
//      List<Widget> widgetList = [];
//      filteredCategoryList.forEach((testCategory) {
//        widgetList.add(_getWidget(testCategory));
//      });
//      return widgetList;
//    }
//
//    return Expanded(
//      flex: 7,
//      child: Container(
//        padding: EdgeInsets.all(20),
//        child: StaggeredGridView.count(
//          scrollDirection: Axis.vertical,
//          crossAxisCount: 3,
//          mainAxisSpacing: 25,
//          crossAxisSpacing: 25,
//          staggeredTiles: _getStaggeredTileCount(),
//          shrinkWrap: true,
//          children: _getStaggeredTileWidgets(),
//        ),
//      ),
//    );
//  }
//}
