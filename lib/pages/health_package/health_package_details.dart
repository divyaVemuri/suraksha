import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suraksha/models/health_package.dart';
import 'package:suraksha/models/test.dart';
import 'package:suraksha/values/gradients.dart';

class HealthPackageDetails extends StatefulWidget {
  HealthPackage healthPackage;

  HealthPackageDetails({this.healthPackage});

  @override
  _HealthPackageDetailsState createState() => _HealthPackageDetailsState();
}

class _HealthPackageDetailsState extends State<HealthPackageDetails> {
  Map<String, bool> seeMoreOption=<String, bool>{};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.healthPackage.includedHealthTests.forEach((test){
      seeMoreOption[test.id]=false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
//                height: MediaQuery.of(context).size.height -
//                    (MediaQuery.of(context).padding.top +
//                        MediaQuery.of(context).padding.bottom),
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'assets/profile/healthPackage3.jpg',
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                height: (MediaQuery.of(context).size.height -
                    (MediaQuery.of(context).padding.top +
                        MediaQuery.of(context).padding.bottom)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[_getAppBar(), _getBody()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getAppBar() {
    return Container(
      height: (MediaQuery.of(context).size.height -
              (MediaQuery.of(context).padding.top +
                  MediaQuery.of(context).padding.bottom)) *
          (4 / 11),
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
                        child:
                            SvgPicture.asset('assets/svg/utilities/cart.svg'))),
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

  _getBody() {
    return Container(
      height: (MediaQuery.of(context).size.height -
              (MediaQuery.of(context).padding.top +
                  MediaQuery.of(context).padding.bottom)) *
          (7 / 11),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          color: Colors.white),
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  '${widget.healthPackage.name}',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Text(
                  '${widget.healthPackage.description}',
                  style: TextStyle(
                    color: Colors.grey,
//                  letterSpacing: 0.6
                  ),
                ),
              ),
              _getAllTests(),
              _getBottomBar()
            ],
          ),
        ),
      ),
    );
  }

  _getTestTile(Test test) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.grey[200],
              offset: Offset(0, 10),
              spreadRadius: 0,
              blurRadius: 15),
        ],
        color: Colors.white, // Color.fromRGBO(250, 246, 246, 1),
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  //R:255, G:223, B:227

                  backgroundColor: Color.fromRGBO(255, 223, 227, 1), radius: 15,
                ),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${test.name}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '8 Tests',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${test.description}',overflow: seeMoreOption[test.id]?null:TextOverflow.ellipsis,
                    maxLines: seeMoreOption[test.id]?null:2,

                    style: TextStyle(
                      height: 1.4,
                      fontSize: 14,
                      color: Colors.grey,
                    )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        child: Text(seeMoreOption[test.id]?'See Less':'See More',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),),
                      ),
                      onTap: (){
                        setState(() {
                          seeMoreOption[test.id]=!seeMoreOption[test.id];
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
//          Container(
//            padding: EdgeInsets.only(top: 10, bottom: 10),
//            child: RichText(
//              maxLines: 2,
//              overflow: TextOverflow.ellipsis,
//              text: TextSpan(children: [
//                TextSpan(
////                    text: '${test.description} ',
//                    text: 'qwertyuiop;lkjhgfresdxcfgvhjlkjhgfdfghjklkjhgfdxcvbnm,nhgfdfcghjkl.,mnhgfdszxkjhgfdxcvbjhkl,mnhgfdsxcvhbjkpoiuytrewqwertyuiolkjhgfdcfghjkjhgfvcbnmnbvcv bnm,.mnbv',
//                    style: TextStyle(
//                      fontSize: 14,
//                      color: Colors.grey,
////                      decoration: TextDecoration.lineThrough,
//                    )),
//                TextSpan(
//                    text: ' See More',
//                    style: TextStyle(
//                      fontSize: 14,
//                      color: Colors.red,
//                      fontWeight: FontWeight.w500,
//                    ),
//                    recognizer: new TapGestureRecognizer()
//                      ..onTap = () {
//                        setState(() {});
//                      })
//              ]),
//            ),
//          )
        ],
      ),
    );
  }

  _getAllTests() {
    List<Widget> widgetList = [];
    widget.healthPackage.includedHealthTests.forEach((test) {
      widgetList.add(_getTestTile(test));
    });
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 20),
      child: Column(
        children: widgetList,
      ),
    );
  }

  _getBottomBar() {
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
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Rs. ${widget.healthPackage.finalPrice}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Row(
                  children: <Widget>[
                    Text('Rs. ${widget.healthPackage.price}',
                        style: TextStyle(
                            color: Colors.grey.withOpacity(0.7),
                            decoration: TextDecoration.lineThrough)),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      padding: EdgeInsets.only(
                          top: 5, bottom: 5, left: 10, right: 10),
//                      padding: EdgeInsets.fromLTRB(35, 10, 35, 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.all(Radius.circular(35)),
                      ),
                      child: Text(
                        "${widget.healthPackage.discountPercentage}% Off",
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
                padding:
                    EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
                decoration: BoxDecoration(
                  gradient: Gradients.redGradient,
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/svg/utilities/cart.svg'),
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
              onTap: () async {},
            ),
          )
        ],
      ),
    );
  }
}
