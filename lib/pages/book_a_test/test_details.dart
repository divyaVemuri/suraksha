import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suraksha/models/test.dart';
import 'package:suraksha/values/gradients.dart';

class TestDetails extends StatefulWidget {
  Test test;

  TestDetails({this.test});

  @override
  _TestDetailsState createState() => _TestDetailsState();
}

class _TestDetailsState extends State<TestDetails> {
  List<bool> select=[];
  List<String> dropdownValue=[];
  bool val;
//  bool detailsSelected, preparationSelected, resultSelected;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    select.insert(0, false);
    select.insert(1, false);
    select.insert(2, false);
    dropdownValue.insert(0, widget.test.description);
    dropdownValue.insert(1, widget.test.testAwareness);
    dropdownValue.insert(2, widget.test.understandingTestResults);
    val=false;


//    detailsSelected = false;
//    preparationSelected = false;
//    resultSelected = false;
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
                child: Container(
                  child: Column(
                    children: <Widget>[_getAppBar(), _getBody()],
                  ),
                )),
            val?Container(
              color: Colors.blue.withOpacity(0.5),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  )
                ],
              ),
            ):Container()

          ],
        ),
      ),
    );
  }

  _getAppBar() {
    return Expanded(
      flex: 3,
      child: Container(
        alignment: Alignment.topLeft,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
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
                            val=true;
                          });
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkResponse(
                        child: Container(
                            padding: EdgeInsets.only(right: 15),
                            child: SvgPicture.asset(
                                'assets/svg/utilities/bell.svg')),
                      )
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Location',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            'Howrah',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Gender',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            widget.test.gender,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Price',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                           '${widget.test.price}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _getBody() {
    return Expanded(
      flex: 11,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            color: Colors.white),
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _getTestName(),
                _getTestDescription(),
                _getile('What is this test',0),
                _getile('Test Preparation',1),
                _getile('Understanding Test Results',2),
                _getPackages(),
                _getBottomBar()
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getTestName() {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
      alignment: Alignment.topLeft,
      child: Text(
        'Thyroid Profile',
        style: TextStyle(
            letterSpacing: 1, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  _getTestDescription() {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
      child: Text(
        'Thyroid Function Test panel measures the levels of total thyroxine T-4, total triiodothyronine T-3 and thyroid stimulating hormone (TSH) in blood.',
        style: TextStyle(
            color: Colors.grey[600],
            letterSpacing: 0.5,
            wordSpacing: 0.5,
            height: 1.5),
      ),
    );
  }

  _getile(String text, int index) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 20, top: 10, bottom: 0),
      padding: EdgeInsets.only(left: 20, right: 10, top: 0, bottom: 0),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.grey[200],
                offset: Offset(0, 10),
                spreadRadius: 5,
                blurRadius: 15),
          ],
          color: Colors.white, // Color.fromRGBO(250, 246, 246, 1),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Container(
          child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      text,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      child: IconButton(
                        icon: select[index]?
                        Icon(
                          Icons.keyboard_arrow_up,
                          color: Colors.black,

                        )
                            :Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            select[index] = !select[index];
                          });
                        },
                      ),
                    )
                  ],
                ),
                select[index]
                    ? Column(
                  children: <Widget>[
                    Divider(
                      thickness: 1,
//                    height: 40,
                      color: Colors.grey[300],
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: 20,bottom: 20,right: 10),
                      child: Text(
                        dropdownValue[index],
                        style: TextStyle(
                            color: Colors.grey[600],
                            letterSpacing: 0.5,
                            wordSpacing: 0.5,
                            fontSize: 13,
                            height: 1.2),
                      ),
                    )
                  ],
                )
                    : Container(),

              ])),
    );
  }

  _getPackage(){
    return Container(
      height: 140,
      margin: EdgeInsets.only(left: 10,top: 10,bottom: 20),
      padding: EdgeInsets.only(left: 10,top: 15,right: 10,bottom: 10),
      decoration: BoxDecoration(
//        boxShadow: [
//          BoxShadow(
//              color: Colors.grey[300],
//              offset: Offset(0, 10),
//              spreadRadius: 0,
//              blurRadius: 15),
//          BoxShadow(
//              color: Colors.grey[300],
//              offset: Offset(-5, 10),
//              spreadRadius: 0,
//              blurRadius: 15)
//        ],
        color: Colors.grey[500],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Family Health',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    letterSpacing: 1,
                    height: 1
                ),),
              Text('Family Health Package',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 10,height: 1.5
                ),)
            ],
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: 'Rs. 9999',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      decoration: TextDecoration.lineThrough)),
              TextSpan(
                  text: ' Rs. 8999',
                  style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500))
            ]),
          )
        ],
      ),
    );
  }
  _getPackages(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10,top: 20,bottom: 20),
            child: Text(
              'Packages included in this test',
              style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 1
              ),
            ),
          ),

          Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    _getPackage(),_getPackage(),_getPackage(),_getPackage()
                  ],
                ),
              )

          )
        ],
      ),
    );
  }

  _getBottomBar(){
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.grey[400],
              offset: Offset(5, 10),
              spreadRadius: 0,
              blurRadius: 15),
          BoxShadow(
              color: Colors.grey[400],
              offset: Offset(-5, 10),
              spreadRadius: 0,
              blurRadius: 15)
        ],
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
//          bottomLeft: Radius.circular(15),
//          bottomRight: Radius.circular(15),
        ),
      ),      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Rs. ${widget.test.finalPrice}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                ),),
              Row(
                children: <Widget>[
                  Text('Rs. ${widget.test.price}',style: TextStyle(
                      color: Colors.grey.withOpacity(0.7),
                      decoration: TextDecoration.lineThrough)),


                  Container(
                    margin: EdgeInsets.only(left: 10),
                    padding: EdgeInsets.only(top: 5,bottom: 5,left: 10,right: 10),
//                      padding: EdgeInsets.fromLTRB(35, 10, 35, 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.all(Radius.circular(35)),
                    ),
                    child: Text(
                      "${widget.test.discountPercentage}% Off",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.red,
                        fontFamily: "Avenir Next",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        Container(
          child: InkResponse(
            child: Container(
              padding: EdgeInsets.only(left: 20,top: 10,right: 20,bottom: 10),
              decoration: BoxDecoration(
                gradient: Gradients.redGradient,
                borderRadius: BorderRadius.all(Radius.circular(35)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                      'assets/svg/utilities/cart.svg'),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      "Add to Cart",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        letterSpacing: 1,
                        color: Colors.white,
                        fontFamily: "Avenir Next",
//                                fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onTap: ()  {

            },
          ),
        )
      ],
    ),
    );
  }
}
