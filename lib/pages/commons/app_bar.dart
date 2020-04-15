import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rxdart/rxdart.dart';
import 'package:suraksha/pages/cart.dart';

class MyAppBar extends StatefulWidget {
  final ValueChanged<bool> buttonPressed;
  final ValueChanged<Widget> cartWidget;

  AnimationController animationController;
  MyAppBar({this.buttonPressed,this.cartWidget,this.animationController});

  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar>
    with SingleTickerProviderStateMixin<MyAppBar> {


//  AnimationController _animationController;

  StreamController<bool> isSidebarOpenedStreamController;
  Stream<bool> isSidebarOpenedStream;
  StreamSink<bool> isSidebarOpenedSink;

//  final _animationDuration = Duration(milliseconds: 300);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    _animationController =
//        AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSidebarOpenedStream = isSidebarOpenedStreamController.stream;
    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    isSidebarOpenedSink.close();
    isSidebarOpenedStreamController.close();
    widget.animationController.dispose();
    super.dispose();
  }

  void onIconPressed() {
    final animationStatus = widget.animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;

    if (isAnimationCompleted) {
      isSidebarOpenedSink.add(false);
      widget.animationController.reverse();
    } else {
      isSidebarOpenedSink.add(true);
      widget.animationController.forward();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_back,
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
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: SvgPicture.asset('assets/svg/utilities/cart.svg'),
                  ),
                ),
                onTap: () {
                  onIconPressed();
                  setState(() {
                    print('cart icon pressed');
                    widget.buttonPressed(true);
//                    Cart(isSidebarOpenedStream: isSidebarOpenedStream,
//                      animationController: _animationController,
//                      isSidebarOpenedSink: isSidebarOpenedSink,);
                    widget.cartWidget(Cart(isSidebarOpenedStream: isSidebarOpenedStream,
                      animationController: widget.animationController,
                      isSidebarOpenedSink: isSidebarOpenedSink,cartClosed: (isCartClosed){
                        onIconPressed();

                        setState(() {

                        widget.buttonPressed(false);
                      });

                      },));

                  });
                },
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
    );
  }
}
