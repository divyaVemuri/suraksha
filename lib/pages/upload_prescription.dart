import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:suraksha/constants/asset_constants.dart';
import 'package:suraksha/date_picker/date_picker_timeline.dart';
import 'package:suraksha/models/address.dart';
import 'package:suraksha/pages/my_date_picker.dart';
import 'package:suraksha/pages/select_test.dart';
import 'package:suraksha/resource/shared_preference_helper.dart';
import 'package:suraksha/services/profile_service.dart';
import 'package:suraksha/values/gradients.dart';

class UploadPrescription extends StatefulWidget {
  @override
  _UploadPrescriptionState createState() => _UploadPrescriptionState();
}

class _UploadPrescriptionState extends State<UploadPrescription> {
  DateTime dateTime;

  bool uploadedPrescription;
  int tabPosition;
  int slotSelected;
  String selectedAddress;
  var addressList = <Address>[];
  String _token;
  SharedPrefsHelper _sharedPrefsHelper = new SharedPrefsHelper();
  List<File> _image = [];

  File _path;
  File _path2;

  Map<String, String> _paths;
  String _extensions;
  FileType _pickType;
  bool _multiPick = false;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
//    ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image.add(image);
//      print('image: $image');
    });
  }

  openFileExplorer() async {
    try {
      _path = null;
      if (_multiPick) {
        _paths = await FilePicker.getMultiFilePath(
            type: _pickType, fileExtension: _extensions);
      } else {
        _path = await FilePicker.getFile(
            type: _pickType, fileExtension: _extensions);
      }
    } on PlatformException catch (e) {
      print('Unsupported Operation ' + e.toString());
    }

    setState(() {
      _path2 = _path;
      print('path2: $_path2');
    });
  }

  @override
  void initState() {
    uploadedPrescription = false;
    // TODO: implement initState
    tabPosition = 1;
    dateTime = DateTime.now();
    _pickType = FileType.ANY;
    _token =
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiYjVlNTBiMWUtN2Y0ZC00YmUxLWE5YjgtZWIyNmQxODVhZjE2IiwidXNlcm5hbWUiOiIrOTE4OTUxODMxNTMxIiwiZXhwIjoxNTkxNzE5NTUzLCJtb2JpbGUiOiIrOTE4OTUxODMxNTMxIiwib3JpZ19pYXQiOjE1ODM5NDM1NTN9.vEzGFoMAhJ6L4TUB6AG_BmmoEyfKhYI9TOnBxyW4Kfs'; //_sharedPrefsHelper.getToken();
    _getAddress();
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
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height -
                  (MediaQuery
                      .of(context)
                      .padding
                      .top +
                      MediaQuery
                          .of(context)
                          .padding
                          .bottom),
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Image.asset(
                'assets/profile/background.png',
                fit: BoxFit.fill,
              ),
            ),
            Container(
              height: (MediaQuery
                  .of(context)
                  .size
                  .height -
                  (MediaQuery
                      .of(context)
                      .padding
                      .top +
                      MediaQuery
                          .of(context)
                          .padding
                          .bottom)),
              child: Column(
                children: <Widget>[_getAppBar(), _getBody()],
              ),
            )
          ],
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
      flex: 10,
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            color: Colors.white),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                _getPrescription(),
//                _getTab(),
                _getAddressBar(),
                _getDate(),
                _getTimeSlot(),
                _getLogInButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget uploadPrescription() {
    if (_image != null && _image.length > 0) {
//      ListView.builder(
//        itemCount: _allPages.length,
//        itemBuilder: (_, int index) => ListTile(
//          leading: _allPages[index].leading,
//          title: Text(_allPages[index].title),
//          onTap: () => _pushPage(context, _allPages[index]),
//        ),
//      ),



      return Container(
        child: ListView.builder(shrinkWrap:true,itemCount:_image.length,itemBuilder: (context, int index) {
          print('***********${_image.length}');
          return Container(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              children: <Widget>[
                Container(
                  height: 80,
                  width: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      _image[index],
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 20,right: 30),
                    child: Text(_image[index].path.split('/').last,
                    style: TextStyle(
                    color: Colors.grey[800],
                      fontWeight: FontWeight.w400
                    ),),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    child: Text('Remove',
                      style: TextStyle(
                          color: Colors.grey, fontSize: 12),),
                  ),
                  onTap: (){
                    setState(() {
                      _image.removeAt(index);

                    });
                  },
                )
              ],
            ),
          );
        }),
      );
      return Column(
        children: <Widget>[
          Container(
            height: 80,
            width: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.file(
                _image[0],
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      );
    } else {
      return Container(
        padding: EdgeInsets.only(top: 20),
//        color: Colors.green,
        alignment: Alignment.center,
        child: GestureDetector(
          child: Container(
//            color: Colors.deepOrange,
            height: 35,
            padding: EdgeInsets.only(left: 20, right: 20),
            child: DottedBorder(
              padding: EdgeInsets.all(2),
              borderType: BorderType.RRect,
              radius: Radius.circular(10),
              strokeWidth: 1,
              dashPattern: [4],
              color: Color.fromRGBO(55, 121, 248, 1),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(244, 246, 248, 1),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.file_upload,
                        color: Color.fromRGBO(55, 121, 248, 1),
                      ),
                      Text(
                        'Upload Prescription',
                        style: TextStyle(
                            color: Color.fromRGBO(55, 121, 248, 1),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          onTap: () {
            getImage();
          },
        ),
      );
    }
  }

  _getTab() {
    return Container(
//      color: Colors.blueGrey,
      padding: EdgeInsets.only(left: 20, right: 20),
//      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: InkResponse(
              child: Container(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Home Collection',
                      style: TextStyle(
                          color: tabPosition == 1 ? Colors.black : Colors.grey,
                          letterSpacing: 1,
                          fontWeight: tabPosition == 1
                              ? FontWeight.bold
                              : FontWeight.w500,
                          fontSize: 16),
                    ),
                    tabPosition == 1
                        ? Container(
                      margin: EdgeInsets.all(3),
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
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
                  tabPosition = 1;
                });
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: InkResponse(
              child: Container(
                alignment: Alignment.topRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Visit Center',
                      style: TextStyle(
                          color: tabPosition == 2 ? Colors.black : Colors.grey,
                          letterSpacing: 1,
                          fontWeight: tabPosition == 2
                              ? FontWeight.bold
                              : FontWeight.w500,
                          fontSize: 16),
                    ),
                    tabPosition == 2
                        ? Container(
                      margin: EdgeInsets.all(3),
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
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
                  tabPosition = 2;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  _getAddressBar() {
    List<Widget> widgetList = [];

    addressList.forEach((address) {
      Widget widget = GestureDetector(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10),
          width: 150,
          height: 120,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color:
                    selectedAddress != null && selectedAddress == address.id
                        ? Colors.grey[300]
                        : Colors.grey[100],
                    offset: Offset(5, 10),
                    spreadRadius: 0,
                    blurRadius: 10),
                BoxShadow(
                    color:
                    selectedAddress != null && selectedAddress == address.id
                        ? Colors.grey[300]
                        : Colors.grey[100],
                    offset: Offset(-5, 10),
                    spreadRadius: 0,
                    blurRadius: 10)
              ]),
          child: Column(
//          mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              address.addressType != null
                  ? address.addressType == 'Home Address'
                  ? Icon(
                Icons.home,
                size: selectedAddress != null &&
                    selectedAddress == address.id
                    ? 22
                    : 20,
                color: selectedAddress != null &&
                    selectedAddress == address.id
                    ? Color.fromRGBO(223, 35, 35, 1)
                    : Colors.black,
              )
                  : Icon(
                Icons.work,
                size: selectedAddress != null &&
                    selectedAddress == address.id
                    ? 22
                    : 20,
                color: selectedAddress != null &&
                    selectedAddress == address.id
                    ? Color.fromRGBO(223, 35, 35, 1)
                    : Colors.black,
              )
                  : Icon(
                Icons.location_on,
                size: selectedAddress != null &&
                    selectedAddress == address.id
                    ? 22
                    : 20,
                color: selectedAddress != null &&
                    selectedAddress == address.id
                    ? Color.fromRGBO(223, 35, 35, 1)
                    : Colors.black,
              ),
              Container(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Text(
                  address.houseDetails,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize:
                    selectedAddress != null && selectedAddress == address.id
                        ? 15
                        : 14,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  '${address.areaDetails}, ${address.landmark}, ${address
                      .city}, ${address.state}, ${address.pincode}',
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: selectedAddress != null &&
                          selectedAddress == address.id
                          ? 12
                          : 11),
                ),
              )
            ],
          ),
        ),
        onTap: () {
          setState(() {
            selectedAddress = address.id;
          });
        },
      );

      widgetList.add(widget);
      widgetList.add(SizedBox(
        width: 10,
      ));
    });

    return Container(
      padding: EdgeInsets.only(top: 35),
//      height: 160,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Address',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        fontSize: 18,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      child: Text(
                        'This is your sample pickup address',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    )
                  ],
                ),
                GestureDetector(
                  child: Text(
                    'Add New',
                    style: TextStyle(
                        color: Color.fromRGBO(219, 32, 40, 1), fontSize: 12),
                  ),
                )
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Row(
                children: widgetList,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _getDate() {
    DateTime currentTime = DateTime.now();
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Select date',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              fontSize: 18,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.chevron_left,
                  ),
                  onPressed: () {
                    setState(() {
                      if (dateTime.year >= currentTime.year &&
                          dateTime.month > currentTime.month) {
                        dateTime = DateTime(
                            dateTime.year, dateTime.month - 1, dateTime.day);
                      }
                      if (dateTime.year == currentTime.year &&
                          dateTime.month == currentTime.month) {
                        dateTime = DateTime(
                            dateTime.year, dateTime.month, dateTime.day);
                      }

                      print("PRESSED PREV: " + dateTime.toString());
                    });
                  },
                ),
                Text(
                  new DateFormat("MMMM").format(dateTime),
                  style: TextStyle(fontWeight: FontWeight.w600), // Month
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      dateTime = DateTime(dateTime.year, dateTime.month + 1, 1);
                    });
                    print("PRESSED AFTER: " + dateTime.toString());
                  },
                )
              ],
            ),
          ),
          MyDatePicker(
            dateTime: dateTime,
          )
//          DatePickerTimeline(dateTime,dateTime),
        ],
      ),
    );
  }

  _getTimeSlot() {
    return Container(
      padding: EdgeInsets.only(top: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Text(
              'Select Time Slot',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                fontSize: 18,
              ),
            ),
          ),
          Container(
//            height: 40,
            padding: EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
//                    height:40,
//                    width: 100,
                    child: GestureDetector(
                      child: (slotSelected != null && slotSelected == 1)
                          ? SvgPicture.asset(
                        AssetConstants.slot_morning_selected,
                      )
                          : SvgPicture.asset(
                        AssetConstants.slot_morning,
                      ),
                      onTap: () {
                        setState(() {
                          slotSelected = 1;
                        });
                      },
                    ),
                  ),
                  GestureDetector(
                    child: (slotSelected != null && slotSelected == 2)
                        ? SvgPicture.asset(
                        AssetConstants.slot_afternoon_selected)
                        : SvgPicture.asset(AssetConstants.slot_afternoon),
                    onTap: () {
                      setState(() {
                        slotSelected = 2;
                      });
                    },
                  ),
                  GestureDetector(
                    child: (slotSelected != null && slotSelected == 3)
                        ? SvgPicture.asset(AssetConstants.slot_evening_selected)
                        : SvgPicture.asset(AssetConstants.slot_evening),
                    onTap: () {
                      setState(() {
                        slotSelected = 3;
                      });
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _getPrescription() {
    if (!uploadedPrescription) {
      return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Prescription',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    fontSize: 18,
                  ),
                ),
                (_image != null && _image.length > 0)
                    ? GestureDetector(
                  child: Container(
                    child: Text(
                      'Add Another',
                      style: TextStyle(
//                            letterSpacing: 1,
                          color: Color.fromRGBO(219, 32, 40, 1),
                          fontSize: 12),
                    ),
                  ),
                  onTap: getImage,
                )
                    : Container()
              ],
            ),
            uploadPrescription()
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Prescription',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    fontSize: 18,
                  ),
                ),
                GestureDetector(
                  child: Text(
                    'Add New',
                    style: TextStyle(
                        color: Color.fromRGBO(219, 32, 40, 1), fontSize: 12),
                  ),
                )
              ],
            ),
            Container(
              height: 100,
            )
          ],
        ),
      );
    }
  }

  _getLogInButton() {
    return Container(
      padding: EdgeInsets.only(bottom: 30),
      child: InkResponse(
        child: Container(
          padding: EdgeInsets.all(15),
//        height: 70,
          width: MediaQuery
              .of(context)
              .size
              .width - 120,
          margin: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            gradient: Gradients.redGradient,
            borderRadius: BorderRadius.all(Radius.circular(35)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Confirm",
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 1,
                  color: Colors.white,
                  fontFamily: "Avenir Next",
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
        onTap: () {
//          Navigator.pushReplacement(context,
//              CupertinoPageRoute(builder: (context) =>SelectTest()));
        },
      ),
    );
  }
}
