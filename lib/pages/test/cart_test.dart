import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:suraksha/pages/book_a_test/test_category.dart';
import 'package:suraksha/values/gradients.dart';

import '../select_address.dart';

class CartTest extends StatefulWidget {
  @override
  _CartTestState createState() => _CartTestState();
}

class _CartTestState extends State<CartTest>
    with SingleTickerProviderStateMixin<CartTest> {
  AnimationController _animationController;
  StreamController<bool> isSidebarOpenedStreamController;
  Stream<bool> isSidebarOpenedStream;
  StreamSink<bool> isSidebarOpenedSink;
  final _animationDuration = const Duration(milliseconds: 1500);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int iconPressed;

  @override
  void initState() {
    iconPressed = 1;
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSidebarOpenedStream = isSidebarOpenedStreamController.stream;
    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;
  }

  @override
  void dispose() {
    _animationController.dispose();
    isSidebarOpenedStreamController.close();
    isSidebarOpenedSink.close();
    super.dispose();
  }

  void onIconPressed() {
    final animationStatus = _animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;

    if (isAnimationCompleted) {
      isSidebarOpenedSink.add(false);
      _animationController.reverse();
    } else {
      isSidebarOpenedSink.add(true);
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.pink,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                setState(() {
                  iconPressed=1;
                  _scaffoldKey.currentState.openEndDrawer();
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                setState(() {
                  iconPressed=2;
                  _scaffoldKey.currentState.openEndDrawer();
                });
              },
            ),
          ],
        ),
        endDrawer: iconPressed == 1 ? Container(
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
//                  onIconPressed();
                },
                child: ClipPath(
                  clipper: CustomMenuClipper(),
                  child: Container(
                      width: 25,
                      height: 110,
                      color: Colors.white,
                      alignment: Alignment.center,
                      child: Icon(Icons.arrow_forward_ios)
                  ),
                ),
              ),

              Expanded(
                child: Container(
//                  color: Colors.blue,
                  height: MediaQuery.of(context).size.height -
                      (MediaQuery.of(context).padding.top +
                          MediaQuery.of(context).padding.bottom) ,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30)),
                      color: Colors.white
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 40),
                        child: CircleAvatar(
                          //R:255, G:242, B:242
                          backgroundColor: Color.fromRGBO(255, 242, 242, 1),
                          radius: 40,
                          child: Icon(
                            Icons.shopping_cart,
                            color: Color.fromRGBO(193, 0, 0, 1),
                            size: 40,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Your Cart',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        child: _getCartItems(),
                      ),
                      _getCheckOutButton()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ): Container(
          height: MediaQuery.of(context).size.height,
          width: 200,
          color: Colors.white,
          child: Center(
            child: Text(
              'notification'
            ),
          ),
        ),
//        endDrawer: StreamBuilder<bool>(
//          initialData: true,
//          stream: isSidebarOpenedStream,
//          builder: (context, isSideBarOpenedAsync) {
//            return Stack(
//              children: <Widget>[
////                SelectTestCategory(),
//                Container(
//                  height: MediaQuery.of(context).size.height,
//                  width: MediaQuery.of(context).size.width,
//                  color: Colors.black.withOpacity(0.5),
//                ),
//                AnimatedPositioned(
//                  duration: _animationDuration,
//                  top: 0,
//                  bottom: 0,
//                  left: isSideBarOpenedAsync.data
//                      ? 0
//                      : MediaQuery.of(context).size.width - 50,
//                  right: isSideBarOpenedAsync.data ? 0 : -(MediaQuery.of(context).size.width - 50),
//                  child: Row(
//                    children: <Widget>[
//                      GestureDetector(
//                        onTap: () {
//                          onIconPressed();
//                        },
//                        child: ClipPath(
//                          clipper: CustomMenuClipper(),
//                          child: Container(
//                              width: 25,
//                              height: 110,
//                              color: Colors.white,
//                              alignment: Alignment.center,
//                              child: Icon(Icons.arrow_forward_ios)
//                          ),
//                        ),
//                      ),
//
//                      Expanded(
//                        child: Container(
////                  color: Colors.blue,
//                          height: MediaQuery.of(context).size.height -
//                              (MediaQuery.of(context).padding.top +
//                                  MediaQuery.of(context).padding.bottom) -
//                              25,
//                          decoration: BoxDecoration(
//                              borderRadius: BorderRadius.only(
//                                  topLeft: Radius.circular(30),
//                                  bottomLeft: Radius.circular(30)),
//                              color: Colors.white
//                          ),
//                          child: Column(
//                            children: <Widget>[
//                              Container(
//                                padding: EdgeInsets.only(top: 40),
//                                child: CircleAvatar(
//                                  //R:255, G:242, B:242
//                                  backgroundColor: Color.fromRGBO(255, 242, 242, 1),
//                                  radius: 40,
//                                  child: Icon(
//                                    Icons.shopping_cart,
//                                    color: Color.fromRGBO(193, 0, 0, 1),
//                                    size: 40,
//                                  ),
//                                ),
//                              ),
//                              Container(
//                                padding: EdgeInsets.all(20),
//                                child: Text(
//                                  'Your Cart',
//                                  style: TextStyle(
//                                    fontWeight: FontWeight.bold,
//                                    fontSize: 20,
//                                    color: Colors.black,
//                                  ),
//                                ),
//                              ),
//                              Container(
//                                child: _getCartItems(),
//                              ),
//                              _getCheckOutButton()
//                            ],
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              ],
//            );
//          },
//        ),
      ),
    );
  }

  _getCartItems() {
    return Container(
      child: Column(
        children: <Widget>[
          _getItem('Thyroid Profile', 800),
          _getItem('Lipid Profile', 1200)
        ],
      ),
    );
  }

  _getItem(String name, int price) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
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
      child: Column(children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              'Home Visit',
              style: TextStyle(
                  color: Colors.blueAccent, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Text(
                'Rs $price',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
              )
            ],
          ),
        )
      ]),
    );
  }

  _getCheckOutButton() {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
//      color: Colors.blue,
      padding: EdgeInsets.only(bottom: 30),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkResponse(
            child: Container(
              padding: EdgeInsets.only(top: 8, bottom: 8, left: 60, right: 60),
//        height: 70,
//              width: MediaQuery.of(context).size.width - 120,
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                gradient: Gradients.redGradient,
                borderRadius: BorderRadius.all(Radius.circular(35)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Check Out",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      letterSpacing: 1,
                      color: Colors.white,
                      fontFamily: "Avenir Next",
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "Rs. 2000",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      letterSpacing: 1,
                      color: Colors.white,
                      fontFamily: "Avenir Next",
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
//              if (widget.type == 2) {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => SelectAddress()));
//              }

//          Navigator.push(context,
//              CupertinoPageRoute(builder: (context) =>SelectTest()));

//              widget.buttonPressed(false);
            },
          ),
        ],
      ),
    );
  }

}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;


    Path path = new Path();
    path.moveTo(width, 0);

    path.quadraticBezierTo(width - 0, 8, width - 10, 16);
    path.quadraticBezierTo(-1, height / 2 - 20, 0, height / 2);
    path.quadraticBezierTo(1, height / 2 + 20, width - 10, height - 16);
    path.quadraticBezierTo(width, height - 8, width, height);


//    path.quadraticBezierTo(0, 8, 10, 16);
//    path.quadraticBezierTo(width-1,height/2-20,width,height/2);
//    path.quadraticBezierTo(width+1, height/2+20, 10, height-16);
//    path.quadraticBezierTo(0, height-8, 0, height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }

}