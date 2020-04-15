import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:suraksha/pages/cart.dart';
import 'package:suraksha/pages/test_details.dart';
import 'package:suraksha/values/gradients.dart';

class SelectTest extends StatefulWidget {


  @override
  _SelectTestState createState() => _SelectTestState();
}

class _SelectTestState extends State<SelectTest> {

  bool showCartPressed;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showCartPressed=false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height -
                  (MediaQuery.of(context).padding.top +
                      MediaQuery.of(context).padding.bottom),
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/profile/background.png',
                fit: BoxFit.fill,
              ),
            ),
            Container(
              height: (MediaQuery.of(context).size.height -
                  (MediaQuery.of(context).padding.top +
                      MediaQuery.of(context).padding.bottom)),
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _getAppBar(),
                      _getBody()
                    ],
                  ),
//                  _getBody(),
                  search()
                ],
              ),
            ),
            showCartPressed?

            Cart(type:2,buttonPressed: (res){
              setState(() {
                showCartPressed=res;
              });
            },)
                :Container()
          ],
        ),
      ),
    );
  }

  _getAppBar() {
    return Expanded(
      flex: 2,
      child: Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.only(right: 15, top: 10),
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
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: SvgPicture.asset(
                              'assets/svg/utilities/cart.svg'))),
                  onTap: (){
                    setState(() {
                      showCartPressed=true;

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
      ),
    );
  }

  _getBody() {
    return Expanded(
      flex: 11,
//      top: (MediaQuery.of(context).size.height -
//              (MediaQuery.of(context).padding.top +
//                  MediaQuery.of(context).padding.bottom)) /
//          6.5,
      child: Container(
//          height: (MediaQuery.of(context).size.height -
//                  (MediaQuery.of(context).padding.top +
//                      MediaQuery.of(context).padding.bottom)) -
//              ((MediaQuery.of(context).size.height -
//                      (MediaQuery.of(context).padding.top +
//                          MediaQuery.of(context).padding.bottom)) /
//                  6.5),
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            color: Colors.white),
        child: Container(
          padding: EdgeInsets.only(top: 20),
          child: SingleChildScrollView(
            child: _getTilesList(),
          )
        ),
      ),
    );
  }

  Widget search() {
    return Positioned(
      top: (MediaQuery.of(context).size.height -
                  (MediaQuery.of(context).padding.top +
                      MediaQuery.of(context).padding.bottom)) /
              11 +
          20,
      child: Container(
        alignment: Alignment.center,
        child: Container(
          height: 45,
          width: MediaQuery.of(context).size.width - 40,
          padding: EdgeInsets.only(left: 20, right: 20),
          margin: EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[200],
                    offset: Offset(0, 10),
                    spreadRadius: 0,
                    blurRadius: 15),
              ],
              color: Colors.white, // Color.fromRGBO(250, 246, 246, 1),
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                hintText: 'Search doctors by name/ center',
                hintStyle:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w300)),
            onChanged: (string) {
//
            },
          ),
        ),
      ),
    );
  }

  _getCaption() {
    return Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment.topLeft,
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'Select',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    letterSpacing: 1,
                  )),
              TextSpan(
                  text: ' Test',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: 1,
                  ))
            ],
          ),
        ));
  }

  _getTilesList(){

    List<Widget> widgetList=[];
    for(int i=0;i<5;i++){
      widgetList.add(_getTestTiles());
    }

    return Container(
      padding: EdgeInsets.only(left: 10,right: 10,top: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: widgetList,
        ),
      ),
    );
  }
  _getTestTiles() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20,top: 10, bottom: 10),
      padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.grey[300],
              offset: Offset(0, 10),
              spreadRadius: 0,
              blurRadius: 15),
//          BoxShadow(
//              color: Colors.grey[300],
//              offset: Offset(-5, 10),
//              spreadRadius: 0,
//              blurRadius: 15)
        ],
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Thyroid Profile',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Also known as',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
//                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          'Thyroid Profile Total Blood',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
//                            letterSpacing: 1,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10),
                    child: SvgPicture.asset('assets/svg/utilities/cart2.svg'),
                  )
                ],
              ),
            ),
            Divider(
              height: 25,
              thickness: 1,
              color: Colors.grey[300],
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.only(left: 20,top: 7.5,right: 20,bottom: 7.5),

                      child: Text(
                        'View Details',
                        style: TextStyle(
                            color: Color.fromRGBO(219, 32, 40, 1), fontSize: 12),
                      ),
                    ),
                    onTap: (){
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (context) =>TestDetails()));
                    },
                  ),
                  Container(
                    child: InkResponse(
                      child: Container(
                        padding: EdgeInsets.only(left: 20,top: 7.5,right: 20,bottom: 7.5),
                        decoration: BoxDecoration(
                          gradient: Gradients.redGradient,
                          borderRadius: BorderRadius.all(Radius.circular(35)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Book Now",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                letterSpacing: 1,
                                color: Colors.white,
                                fontFamily: "Avenir Next",
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () async {},
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
