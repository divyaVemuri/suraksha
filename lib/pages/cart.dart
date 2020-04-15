import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:suraksha/pages/select_address.dart';
import 'package:suraksha/pages/select_test.dart';
import 'package:suraksha/values/gradients.dart';

class Cart extends StatefulWidget {
  int type; //home=1, test=2
  final ValueChanged<bool> cartClosed;
  final ValueChanged<bool> buttonPressed;
  Stream<bool> isSidebarOpenedStream;
  AnimationController animationController;
    StreamSink<bool> isSidebarOpenedSink;


  Cart({this.type, this.isSidebarOpenedStream, this.animationController,
      this.isSidebarOpenedSink,this.buttonPressed,this.cartClosed}); //  Cart({this.buttonPressed, this.type});

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
//  AnimationController _animationController;
//
//  StreamController<bool> isSidebarOpenedStreamController;
//  Stream<bool> isSidebarOpenedStream;
//  StreamSink<bool> isSidebarOpenedSink;
//
  final _animationDuration = Duration(milliseconds: 700);

//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    _animationController =
//        AnimationController(vsync: this, duration: _animationDuration);
//    isSidebarOpenedStreamController = PublishSubject<bool>();
//    isSidebarOpenedStream = isSidebarOpenedStreamController.stream;
//    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;
//  }
//
//  @override
//  void dispose() {
//    // TODO: implement dispose
//    widget.isSidebarOpenedSink.close();
//    widget.animationController.dispose();
//    super.dispose();
//  }

  void onIconPressed() {
    final animationStatus = widget.animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;

    if (isAnimationCompleted) {
      widget.cartClosed(true);
      widget.isSidebarOpenedSink.add(false);
      widget.animationController.reverse();
    } else {
      widget.cartClosed(true);
      widget.isSidebarOpenedSink.add(true);
      widget.animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<bool>(
        initialData: true,
        stream: widget.isSidebarOpenedStream,
        builder: (context, isSideBarOpenedAsync) {
          return Stack(
            children: <Widget>[
              AnimatedPositioned(
                duration: _animationDuration,
                top: 0,
                bottom: 0,
                left: isSideBarOpenedAsync.data
                    ? 0
                    : MediaQuery.of(context).size.width - 50,
                right: isSideBarOpenedAsync.data ? 0 : -(MediaQuery.of(context).size.width - 50),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        onIconPressed();
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
                                MediaQuery.of(context).padding.bottom) -
                            25,
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
              ),
            ],
          );
        },
      ),
    );
//      Scaffold(
//      body:
//      Positioned(
//
//
//        child: Stack(
//          children: <Widget>[
//
//            Positioned(
////              top: 0,bottom: 0,left: 0,right: 0,
//              child: Container(
//                height: MediaQuery.of(context).size.height-
//                    (MediaQuery.of(context).padding.top+MediaQuery.of(context).padding.bottom)-25,
//                width: MediaQuery.of(context).size.width,
//                color: Colors.black.withOpacity(0.8),
//              ),
//            ),
//            Positioned(
//              right: 0,
//              child: Container(
//                height: MediaQuery.of(context).size.height-
//                    (MediaQuery.of(context).padding.top+MediaQuery.of(context).padding.bottom)-25,
//                width: MediaQuery.of(context).size.width-40,
//
//                  decoration: BoxDecoration(
//                      borderRadius: BorderRadius.only(
//                          topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
//                      color: Colors.white),
//
//                child: Column(
//                  children: <Widget>[
//                  Container(
//                    padding: EdgeInsets.only(top: 40),
//                    child: CircleAvatar(
//                      //R:255, G:242, B:242
//                      backgroundColor: Color.fromRGBO(255, 242, 242, 1),
//                      radius: 40,
//                      child: Icon(
//                        Icons.shopping_cart,
//                        color: Color.fromRGBO(193, 0, 0, 1),
//                        size: 40,
//                      ),
//                    ),
//                  ),
//                    Container(
//                      padding: EdgeInsets.all(20),
//                      child: Text(
//                        'Your Cart',
//                        style: TextStyle(
//                          fontWeight: FontWeight.bold,
//                          fontSize: 20,
//                          color: Colors.black,
//                        ),
//                      ),
//                    ),
//                    Container(
//                      child: _getCartItems(),
//                    ),
//                    _getCheckOutButton()
//                  ],
////        ),
//              ),
//    ),
//            ),
//          ],
//        ),
//      );
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

  _getCheckOutButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
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
              if (widget.type == 2) {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => SelectAddress()));
              }

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


class CustomMenuClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Paint paint=Paint();
    paint.color=Colors.white;

    final width=size.width;
    final height=size.height;


    Path path=new Path();
    path.moveTo(width, 0);

    path.quadraticBezierTo(width-0, 8, width-10, 16);
    path.quadraticBezierTo(-1, height/2-20, 0, height/2);
    path.quadraticBezierTo(1, height/2+20, width-10, height-16);
    path.quadraticBezierTo(width, height-8, width, height);


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