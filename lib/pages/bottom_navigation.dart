import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:suraksha/pages/login/login.dart';

class Page extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height-
                (MediaQuery.of(context).padding.top+MediaQuery.of(context).padding.bottom)-50,
            color: Colors.green,
            child: Column(
              children: <Widget>[
                Expanded(child: Text('hi',style: TextStyle(fontSize: 30),)),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        index: 0,
        animationCurve: Curves.ease,
        animationDuration: Duration(milliseconds: 300),
        color: Colors.grey[100],
        backgroundColor: Colors.white,
        //R:191, G:0, B:36
        buttonBackgroundColor: Color.fromRGBO(191, 0, 36, 1),
        items: <Widget>[
          Icon(
            Icons.location_on,
            size: 20,
          ),
          Icon(
            Icons.calendar_today,
            size: 20,
          ),
          Icon(
            Icons.home,
            size: 20,
          ),
          Icon(
            Icons.account_balance_wallet,
            size: 20,
          ),
          Icon(
            Icons.receipt,
            size: 20,
          )
        ],
      ),
    );
  }
}
