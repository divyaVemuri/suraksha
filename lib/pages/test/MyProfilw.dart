import 'package:flutter/material.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
            child: Stack(
          children: <Widget>[
            Container(
//              height: MediaQuery.of(context).size.height -
//                  MediaQuery.of(context).padding.top,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/background3.png',
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              bottom: 0,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/background4.png',
                fit: BoxFit.fill,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[_getAppBar(), _getCaption(), _getTabBar()],
              ),
            )
          ],
        )),
      ),
    );
  }

  _getAppBar() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Row(
//            mainAxisAlignment: ,
            children: <Widget>[
              InkResponse(
                child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Image.asset('assets/cartP.png'))),
              ),
              SizedBox(
                width: 10,
              ),
              InkResponse(
                child: Image.asset('assets/bell.png'),
              )
            ],
          )
        ],
      ),
    );
  }

  _getCaption() {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'My',
            style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                letterSpacing: 3.0,
                fontWeight: FontWeight.w500),
          ),
          Text(
            'Profile',
            style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                letterSpacing: 3.0,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  _getTabBar() {
    return Container(
      padding: EdgeInsets.all(10),
      height: 200,
//      color: Colors.green,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 160,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[500],
                      offset: Offset(5, 10),
                      spreadRadius: 0,
                      blurRadius: 15),
                  BoxShadow(
                      color: Colors.grey[500],
                      offset: Offset(-5, 10),
                      spreadRadius: 0,
                      blurRadius: 15)
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
            ),
          ),
          Positioned(
//            top: 0,
//            left: MediaQuery.of(context).size.width/2-40,
//            child: CircleAvatar(
//              backgroundImage: NetworkImage('https://i.pravatar.cc/300'),radius: 40,

            child: Container(
              width: MediaQuery.of(context).size.width - 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
                    radius: 40,
                  ),
                  Container(
                    child: Text('Divya Vemuri'),
                  ),
                  Container(
                    child: Text('PID: 234HJK989'),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                         Container(
                             child: Text('Personal Info'),padding: EdgeInsets.all(20),),

                        Container(child: Text('Family'),padding: EdgeInsets.all(20),),

                        Container(child: Text('Vitals'),padding: EdgeInsets.all(20),),

                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
