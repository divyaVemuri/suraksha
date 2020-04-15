import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suraksha/models/health_package.dart';
import 'package:suraksha/models/test_category.dart';
import 'package:suraksha/pages/health_package/health_package_details.dart';
import 'package:suraksha/services/health_package_service.dart';
import 'package:suraksha/services/test_category_service.dart';
import 'package:suraksha/values/gradients.dart';

class SelectHealthPackage extends StatefulWidget {
  @override
  _SelectHealthPackageState createState() => _SelectHealthPackageState();
}

class _SelectHealthPackageState extends State<SelectHealthPackage> {
  String tabPosition;
  List<TestCategory> testCategoryList = [];
  List<HealthPackage> healthPackageList=[];

  @override
  void initState() {
    // TODO: implement initState
    _getTestCategories();
    _getHealthPackages();
    super.initState();
  }

  _getHealthPackages() async {
    final result = await HealthPacakgeService.getHealthPackageList('36796f14-eaa8-4755-a62c-d62fa4d170c2', 'f779425f-e3e3-419a-b756-3d8e7ac0762d');
    if (result != null) {
      setState(() {
        result.data.forEach((healthPackage) {
          healthPackageList.add(healthPackage);
        });
      });
    } else {
      print('no test centres');
    }
  }
  
  _getTestCategories() async {
    final result = await TestCategoryService.getTestCenterList();
    if (result != null) {
      setState(() {
        result.data.forEach((testCategory) {
          if(testCategory.order==1){
            tabPosition=testCategory.id;
          }
          testCategoryList.add(testCategory);
          print('test centre list: ' + testCategory.toJson().toString());
        });
      });
    } else {
      print('no test centres');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                      children: <Widget>[_getAppBar(), _getBody()],
                    ),
//                  _getBody(),
                    search()
                  ],
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
          (2 / 13),
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
          (11 / 13),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          color: Colors.white),
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[_getCategories(), _getPackages()],
          ),
        ),
      ),
    );
  }

  _getCategory(TestCategory testCategory) {
    return Container(
      padding: EdgeInsets.only(right: 40),
      child: InkResponse(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                testCategory.name,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    letterSpacing: 1,
                    fontWeight: tabPosition == testCategory.id
                        ? FontWeight.bold
                        : FontWeight.w300),
              ),
              tabPosition == testCategory.id
                  ? Container(
                      margin: EdgeInsets.all(3),
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                          color: Colors.black, shape: BoxShape.circle),
                    )
                  : Container(
                      margin: EdgeInsets.all(3),
                      height: 8,
                      width: 8,
                    )
            ],
          ),
        ),
        onTap: () {
          setState(() {
            tabPosition = testCategory.id;
          });
        },
      ),
    );
  }

  _getCategories() {

    List<Widget> widgetList=[];

    testCategoryList.forEach((testCategory){
      widgetList.add(_getCategory(testCategory));
    });


    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: widgetList
            ),
      ),
    );
  }

  Widget search() {
    return Positioned(
      top: ((MediaQuery.of(context).size.height -
                  (MediaQuery.of(context).padding.top +
                      MediaQuery.of(context).padding.bottom)) *
              (2 / 13)) -
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
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
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

  _getPackages() {

    List<Widget> widgetList=[];
    healthPackageList.forEach((healthPackage){
      widgetList.add(_getPackage(healthPackage));
    });
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      child: Column(
        children: widgetList,
      ),
    );
  }

  _getPackage(HealthPackage healthPackage) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey[200],
                offset: Offset(5, 10),
                spreadRadius: 0,
                blurRadius: 5),
            BoxShadow(
                color: Colors.grey[200],
                offset: Offset(-5, 10),
                spreadRadius: 0,
                blurRadius: 5)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 15),
            child: Row(
              children: <Widget>[
                Text(
                  healthPackage.name,
                  style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Container(
            child: Text(
              healthPackage.description,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 15, bottom: 5),
            child: Text(
              'PREPARATION',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          Text(
            'Do not eat or drink anything (except Water) 8-10 hours before the test ',
            style:
                TextStyle(color: Colors.grey, fontSize: 11, letterSpacing: 0.7),
          ),
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 10),
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: '${healthPackage.price}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black.withOpacity(0.5),
                      decoration: TextDecoration.lineThrough,
                    )),
                TextSpan(
                    text: ' ${healthPackage.finalPrice}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ))
              ]),
            ),
          ),
          Divider(
            height: 20,
            thickness: 1,
          ),
          Container(
            padding: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.all(Radius.circular(35)),
                    ),
                    padding: EdgeInsets.only(
                        left: 20, top: 7.5, right: 20, bottom: 7.5),
                    child: Text(
                      'Explore',
                      style: TextStyle(
                          color: Color.fromRGBO(219, 32, 40, 1), fontSize: 12),
                    ),
                  ),
                  onTap: (){
                    Navigator.push(context, CupertinoPageRoute(
                      builder: (context)=>HealthPackageDetails(healthPackage: healthPackage,)
                    ));
                  },
                ),
                Container(
                  child: InkResponse(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 20, top: 7.5, right: 20, bottom: 7.5),
                      decoration: BoxDecoration(
                        gradient: Gradients.redGradient,
                        borderRadius: BorderRadius.all(Radius.circular(35)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Add to Cart",
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
    );
  }
}
