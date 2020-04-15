import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rxdart/rxdart.dart';
import 'package:suraksha/pages/cart.dart';
import 'package:suraksha/pages/test/cart_test.dart';

class MyAppBarTest extends StatefulWidget {

  @override
  _MyAppBarTestState createState() => _MyAppBarTestState();
}

class _MyAppBarTestState extends State<MyAppBarTest>
{



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Container(
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
                    CartTest();
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
      ),
    );
  }
}
