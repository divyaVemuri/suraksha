import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suraksha/models/address.dart';
import 'package:suraksha/pages/select_date_time.dart';
import 'package:suraksha/pages/cart.dart';
import 'package:suraksha/services/profile_service.dart';

class SelectAddress extends StatefulWidget {
  @override
  _SelectAddressState createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {
  String selectedRadio;
  bool showCartPressed;
  String _token =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiYjVlNTBiMWUtN2Y0ZC00YmUxLWE5YjgtZWIyNmQxODVhZjE2IiwidXNlcm5hbWUiOiIrOTE4OTUxODMxNTMxIiwiZXhwIjoxNTkxNzE5NTUzLCJtb2JpbGUiOiIrOTE4OTUxODMxNTMxIiwib3JpZ19pYXQiOjE1ODM5NDM1NTN9.vEzGFoMAhJ6L4TUB6AG_BmmoEyfKhYI9TOnBxyW4Kfs';
  var addressList = <Address>[];

  void initState() {
    _getAddress();
    showCartPressed=false;
    super.initState();
  }

  _getAddress() async {
    final result = await ProfileService.getAddresses2(
        _token); //getAddresses(widget.token);
    if (result != null) {
      setState(() {
        result.data.forEach((address) {
          addressList.add(address);
        });
      });
    } else {
      print('List empty');
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
                child: Column(
                  children: <Widget>[_getAppBar(), _body()],
                ),
              ), showCartPressed?

              Cart(type:2,buttonPressed: (res){
                setState(() {
                  showCartPressed=res;
                });
              },)
                  :Container()

            ],
          ),
        ),
      ),
    );
  }

  _getAppBar() {
    return Expanded(
      flex: 1,
      child: Container(
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

  Widget _body() {
    return Expanded(
      flex: 10,
      child: Container(
//          height: MediaQuery.of(context).size.height-
//              (MediaQuery.of(context).padding.top+MediaQuery.of(context).padding.bottom)/10,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
        decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            color: Colors.white),
        child: Container(
          height:( MediaQuery.of(context).size.height-
              (MediaQuery.of(context).padding.top+MediaQuery.of(context).padding.bottom))*(10/11)-30,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _getSelectedTest(),
                _getAddressSection(),
                _getNextButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getTestTile(String name, String description) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.check,
                      color: Colors.red,
                      size: 16,
                    )),
                Expanded(
                  flex: 10,
                  child: Container(
                    child: Text(
                      description,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _getSelectedTest() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'Selected Tests',
              style: TextStyle(
                  letterSpacing: 1, fontSize: 16, color: Colors.grey[700]),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20, top: 20, right: 20),
            child: Column(
              children: <Widget>[
                _getTestTile('Thyroid Profile',
                    'You can typically eat and drink normally before this test'),
                _getTestTile('Lipid Profile',
                    'You can\'t eat or drink anything but water for eight hours before your test.'),
              ],
            ),
          )
        ],
      ),
    );
  }

  _getAddressTile(Address address) {
    String fullAddress =
        (address.houseDetails != null ? address.houseDetails + ", " : "") +
            (address.areaDetails != null ? address.areaDetails + ", " : "") +
            (address.landmark != null ? address.landmark + ", " : "") +
            (address.city != null ? address.city + ", " : "") +
            (address.state != null ? address.state + ", " : "") +
            (address.pincode.toString() != null
                ? address.pincode.toString() + " "
                : "");

    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 15),
      padding: EdgeInsets.only(
        top: 0,
        bottom: 20,
      ),
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
              offset: Offset(0, 10),
              spreadRadius: 0,
              blurRadius: 5)
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.trip_origin,
              color: selectedRadio != null && selectedRadio == address.id
                  ? Colors.red
                  : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                selectedRadio = address.id;
              });
            },
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    address.houseDetails,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    fullAddress,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 13,
                      letterSpacing: 0.7,
//                    fontFamily: poppins
                    ),
                  )
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.black,
              size: 17,
            ),
          )
        ],
      ),
    );
  }

  _getAddressList() {
    List<Widget> widgetList = [];
    addressList.forEach((address) {
      widgetList.add(_getAddressTile(address));
    });
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      child: Column(
        children: widgetList,
      ),
    );
  }

  _getAddressSection() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20, top: 40, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Select Address',
                  style: TextStyle(
                      letterSpacing: 1,
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                InkResponse(
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.add_circle_outline,
                          color: Color.fromRGBO(51, 121, 248, 1),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Add New',
                          style:
                              TextStyle(color: Color.fromRGBO(51, 121, 248, 1)),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          _getAddressList()
        ],
      ),
    );
  }

  _getNextButton() {
    return GestureDetector(
      child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
//          borderRadius: BorderRadius.circular(10),
//          color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[400],
                  offset: Offset(0, 1),
                  spreadRadius: 0,
                  blurRadius: 5),
//            BoxShadow(
//                color: Colors.grey[900],
//                offset: Offset(0, 10),
//                spreadRadius: 0,
//                blurRadius: 5)
            ],
          ),
          padding: EdgeInsets.only(bottom: 20,top: 20),
          child: CircleAvatar(
            //R:191, G:0, B:36
            backgroundColor: Color.fromRGBO(191, 0, 36, 1),
            child: Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
          ),),
      onTap: (){
        Navigator.push(context,
            CupertinoPageRoute(builder: (context) =>SelectDateTime()));
      },
    );
  }
}
