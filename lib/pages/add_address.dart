import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission/permission.dart';
import 'package:suraksha/resource/shared_preference_helper.dart';
import 'package:suraksha/services/profile_service.dart';
import 'package:suraksha/models/address.dart' as model;
import 'package:suraksha/values/gradients.dart';

class AddressPage extends StatefulWidget {
  final ValueChanged<model.Address> address;

  AddressPage({this.address});

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  bool currentLocationPressed;
  SharedPrefsHelper _sharedPrefsHelper=new SharedPrefsHelper();
  String _token;
  String selectedRadio;
  GlobalKey<FormState> _key = new GlobalKey();

  bool _validate = false;

  String dropdownValue;

  final pinCodeController = TextEditingController();
  final houseController = TextEditingController();
  final areaController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final landmarkController = TextEditingController();
  final addressTypeController = TextEditingController();

  @override
  void initState() {
    currentLocationPressed=true;
    // TODO: implement initState
    super.initState();
    selectedRadio = null;
    _token=_sharedPrefsHelper.getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[_getBackground(), _getPage()],
          ),
        ),
      ),
    );
  }

  String validatePincode(String value) {
    if (value.length != 6)
      return 'Pincode must be six digits';
    else
      return null;
  }

  String validateHouse(String value) {
    if (value.length == 0)
      return 'Mandatory element';
    else
      return null;
  }

  String validateArea(String value) {
    if (value.length == 0)
      return 'Mandatory element';
    else
      return null;
  }

  String validateCity(String value) {
    if (value.length == 0)
      return 'Mandatory element';
    else
      return null;
  }

  String validateState(String value) {
    if (value.length == 0)
      return 'Mandatory element';
    else
      return null;
  }

  _getCurrentLocation() async {
    print('Requested location');
    String currentAddress;

    var permission =
        await Permission.getPermissionsStatus([PermissionName.Location]);
    if (permission[0].permissionStatus == PermissionStatus.notAgain) {
      var askpermissions =
          await Permission.requestPermissions([PermissionName.Location]);
    } else {

      Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((Position position) async {
            currentLocationPressed=true;
//        final coordinates = Coordinates(12.9759225,77.6016568);
        final coordinates = Coordinates(position.latitude, position.longitude);
        var addresses =
            await Geocoder.local.findAddressesFromCoordinates(coordinates);

        var first = addresses.first;

        currentAddress = '${first.addressLine}, ';

        print('first: ' + first.toString());
        return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Center(
                    child: Text(
                  'Update with these details?',
                  style: TextStyle(color: Colors.black),
                )),
                content: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 20,bottom: 20,left: 30,right: 30),
                        alignment: Alignment.center,
                        child: Text(
                          currentAddress,
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                        ),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Divider(
                                  height: 36,
                                  color: Colors.grey[400],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                              child: Container(
                                padding: EdgeInsets.fromLTRB(35, 10, 35, 10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),

                                  borderRadius:
                                      BorderRadius.all(Radius.circular(35)),

                                ),
                                child: Text(
                                  "Cancel",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: "Avenir Next",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              onTap: () {
//                                  currentLocationPressed=true;
                                Navigator.of(context).pop();
                              },
                            ),
                            GestureDetector(
                              child: Container(
                                padding: EdgeInsets.fromLTRB(35, 10, 35, 10),
                                decoration: BoxDecoration(
                                  gradient: Gradients.redGradient,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(35)),
                                ),
                                child: Text(
                                  "Confirm",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Avenir Next",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              onTap: () {
                                setState(() {
//                                  currentLocationPressed=true;
                                  pinCodeController.text =
                                      first.postalCode != null
                                          ? first.postalCode
                                          : "";
                                  cityController.text = first.locality != null
                                      ? first.locality
                                      : "";
                                  dropdownValue = first.adminArea != null
                                      ? first.adminArea
                                      : "";
                                  houseController.text =
                                      first.featureName != null
                                          ? first.featureName
                                          : "";
                                  areaController.text =
                                      first.thoroughfare != null
                                          ? first.thoroughfare
                                          : "" + first.subLocality != null
                                              ? first.subLocality
                                              : "";
//                                      '${first.thoroughfare} ,${first.subLocality}';
                                });
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  )
              );
            });
      });
    }
  }

  _getBackground() {
    return Container(
        height: MediaQuery.of(context).size.height -
            (MediaQuery.of(context).padding.top +
                MediaQuery.of(context).padding.bottom),
        color: Colors.black,
        child: Image.asset(
          "assets/background2.png",
          fit: BoxFit.fill,
        ));
  }

  _getPage() {
    return Container(
      child: Column(
        children: <Widget>[_getAppBar(), _inputFields()],
      ),
    );
  }

  setSelectedRadio(String val) {
    setState(() {
      selectedRadio = val;
    });
  }

  _getDropDown() {
    return DropdownButton<String>(

      value: dropdownValue,
      hint: Container(
        width: MediaQuery.of(context).size.width - 80,
        child: Text(
          'State *',
          style: TextStyle(
              color: Colors.grey[500], fontSize: 15.0, letterSpacing: 1.0),
        ),
      ),
      underline: Container(
        height: 0.4,
        color: Colors.grey,
      ),
      iconSize: 0,
      style: TextStyle(color: Colors.black),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>[
        "Andhra Pradesh",
        "Arunachal Pradesh ",
        "Assam",
        "Bihar",
        "Chhattisgarh",
        "Goa",
        "Gujarat",
        "Haryana",
        "Himachal Pradesh",
        "Jammu and Kashmir ",
        "Jharkhand",
        "Karnataka",
        "Kerala",
        "Madhya Pradesh",
        "Maharashtra",
        "Manipur",
        "Meghalaya",
        "Mizoram",
        "Nagaland",
        "Odisha",
        "Punjab",
        "Rajasthan",
        "Sikkim",
        "Tamil Nadu",
        "Telangana",
        "Tripura",
        "Uttar Pradesh",
        "Uttarakhand",
        "West Bengal",
        "Andaman and Nicobar Islands",
        "Chandigarh",
        "Dadra and Nagar Haveli",
        "Daman and Diu",
        "Lakshadweep",
        "National Capital Territory of Delhi",
        "Puducherry"
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  String validateDD(String value) {
    print("validatingdd");
    if (value==null || value.length == 0){
      return 'Mandatory element';}
    else
      return null;

  }
  _getDropDown2() {
    return Form(

      autovalidate: _validate,
      key: _key,
      child: DropdownButtonFormField<String>(

        value: dropdownValue,
        validator: validateDD,
        hint: Container(
          width: MediaQuery.of(context).size.width - 80,
          child: Text(
            'State *',
            style: TextStyle(
                color: Colors.grey[500], fontSize: 15.0, letterSpacing: 1.0),
          ),
        ),
//      underline: Container(
//        height: 0.4,
//        color: Colors.grey,
//      ),
//      iconSize: 0,
//      style: TextStyle(color: Colors.black),
        onChanged: (String newValue) {
          setState(() {
            dropdownValue = newValue;
          });
        },
        items: <String>[
          "Andhra Pradesh",
          "Arunachal Pradesh ",
          "Assam",
          "Bihar",
          "Chhattisgarh",
          "Goa",
          "Gujarat",
          "Haryana",
          "Himachal Pradesh",
          "Jammu and Kashmir ",
          "Jharkhand",
          "Karnataka",
          "Kerala",
          "Madhya Pradesh",
          "Maharashtra",
          "Manipur",
          "Meghalaya",
          "Mizoram",
          "Nagaland",
          "Odisha",
          "Punjab",
          "Rajasthan",
          "Sikkim",
          "Tamil Nadu",
          "Telangana",
          "Tripura",
          "Uttar Pradesh",
          "Uttarakhand",
          "West Bengal",
          "Andaman and Nicobar Islands",
          "Chandigarh",
          "Dadra and Nagar Haveli",
          "Daman and Diu",
          "Lakshadweep",
          "National Capital Territory of Delhi",
          "Puducherry"
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  _getAppBar() {
    return Container(
//        height: 400,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
//                  Navigator.push(context, MaterialPageRoute(
//                      builder: (context)=>MyProfile()
//                  ));
                },
              ),
              Row(
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                        padding: EdgeInsets.only(left: 10, right: 20),
                        child: SvgPicture.asset('assets/svg/utilities/cart.svg')),
                    onTap: () {},
                  ),
                  GestureDetector(
                    child: Container(
                        padding: EdgeInsets.only(left: 20, right: 10),
                        child: SvgPicture.asset('assets/svg/utilities/bell.svg')),
                    onTap: () {},
                  ),
                ],
              )
            ],
          ),
          Container(
              padding: EdgeInsets.all(20),
              child: Text(
                'Add New Address',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ))
        ],
      ),
    );
  }

  _inputFields() {
    return Form(
      autovalidate: _validate,
      key: _key,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: Colors.white),
//          color: Colors.black,
        padding: EdgeInsets.fromLTRB(40, 0, 40, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _getCurrentLocationButton(),

            Text(
              'Tap to auto fill the address fields',
              style: TextStyle(color: Colors.grey),
            ),
            Container(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: TextFormField(
                controller: pinCodeController,
                validator: validatePincode,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  labelText: "Pincode *",
                  labelStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 15.0,
                      letterSpacing: 1.0),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 0.5, color: Colors.grey[400]),
                  ),
                ),
              ),
            ),
//              Text("*",style: TextStyle(color: Colors.red),),

            Container(
              padding: EdgeInsets.only(bottom: 20),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: houseController,
                validator: validateHouse,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  labelText: "House No., Building Name *",
                  labelStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 15.0,
                      letterSpacing: 1.0),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 0.5, color: Colors.grey[400]),
                  ),
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.only(bottom: 20),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: areaController,
                validator: validateArea,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  labelText: "Road Name, Area, Colony *",
                  labelStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 15.0,
                      letterSpacing: 1.0),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 0.5, color: Colors.grey[400]),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 20),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: cityController,
                validator: validateCity,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  labelText: "City *",
                  labelStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 15.0,
                      letterSpacing: 1.0),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 0.5, color: Colors.grey[400]),
                  ),
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.only(bottom: 20),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 0.5,
                      color: Colors.grey[400]
                    )
                  )
                ),
                value: dropdownValue,
                validator: validateDD,
                hint: Container(

//                  width: MediaQuery.of(context).size.width - 120,
                  child: Text(
                    'State *',
                    style: TextStyle(
                        color: Colors.grey[500], fontSize: 15.0, letterSpacing: 1.0),
                  ),
                ),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items: <String>[
                  "Andhra Pradesh",
                  "Arunachal Pradesh ",
                  "Assam",
                  "Bihar",
                  "Chhattisgarh",
                  "Goa",
                  "Gujarat",
                  "Haryana",
                  "Himachal Pradesh",
                  "Jammu and Kashmir ",
                  "Jharkhand",
                  "Karnataka",
                  "Kerala",
                  "Madhya Pradesh",
                  "Maharashtra",
                  "Manipur",
                  "Meghalaya",
                  "Mizoram",
                  "Nagaland",
                  "Odisha",
                  "Punjab",
                  "Rajasthan",
                  "Sikkim",
                  "Tamil Nadu",
                  "Telangana",
                  "Tripura",
                  "Uttar Pradesh",
                  "Uttarakhand",
                  "West Bengal",
                  "Andaman and Nicobar Islands",
                  "Chandigarh",
                  "Dadra and Nagar Haveli",
                  "Daman and Diu",
                  "Lakshadweep",
                  "National Capital Territory of Delhi",
                  "Puducherry"
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
//            Container(
//              padding: EdgeInsets.only(bottom: 20),
//              child: _getDropDown(),
//            ),

            Container(
              child: Flexible(
                fit: FlexFit.loose,
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(bottom: 20),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: landmarkController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      labelText: "Landmark (Optional)",
                      labelStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 15.0,
                          letterSpacing: 1.0),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 0.5, color: Colors.grey[400]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _getAddressType(),
            _getSaveButton()
          ],
        ),
      ),
    );
  }

  _getSaveButton() {
    return InkResponse(
      child: Container(
        padding: EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width - 120,
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        decoration: BoxDecoration(
          gradient: Gradients.redGradient,
          borderRadius: BorderRadius.all(Radius.circular(35)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Save",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Avenir Next",
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
      onTap: () async {
        if (_key.currentState.validate()) {
          print('Add address pressed');
          final address = model.Address(
              pincode: int.parse(pinCodeController.text),
              state: dropdownValue,
              city: cityController.text,
              landmark: landmarkController.text,
              houseDetails: houseController.text,
              areaDetails: areaController.text,
              addressType: selectedRadio);

          final result = await ProfileService.addAddress(address, _token);

          if (result != null) {
            widget.address(result.data);
            Navigator.pop(context, result.data);
          }
        } else {
          setState(() {
            _validate = true;
          });
        }
      },
    );
  }

  _getCurrentLocationButton() {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(top: 15, bottom: 15),
        padding: EdgeInsets.all(15),
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
        child: Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.my_location,
                color: Color.fromRGBO(40, 115, 241, 1),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Use My Current Location',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(40, 115, 241, 1)),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        print('get location pressed');

        if(currentLocationPressed) {
          currentLocationPressed=false;

          var address = _getCurrentLocation();
        }

//        String currentAddress=' ${address.locality}, ${address.adminArea},${address.subLocality}, ${address.subAdminArea},${address.addressLine}, ${address.featureName},${address.thoroughfare}, ${address.subThoroughfare}';

//        print('priting curr add: '+currentAddress);
//        createDialog(address);
      },
    );
  }

  createDialog(var add) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
                child: Text(
              'Update with these details?',
              style: TextStyle(color: Colors.black, letterSpacing: 1),
            )),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
//                  Container(
//                    padding: EdgeInsets.all(20),
//                    alignment: Alignment.center,
//                    child: Text(
//                      '',
//                      style: TextStyle(color: Colors.grey),
//                    ),
//                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(35, 10, 35, 10),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(35)),
                            ),
                            child: Text(
                              "Cancel",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: "Avenir Next",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(35, 10, 35, 10),
                            decoration: BoxDecoration(
                              gradient: Gradients.redGradient,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(35)),
                            ),
                            child: Text(
                              "Save",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Avenir Next",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          onTap: () {},
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            backgroundColor: Colors.white,
          );
        });
  }

  _getAddressType() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Address Type',
            style: TextStyle(color: Colors.grey),
          ),
          ListTile(
            dense: true,
            title: Text('Home Address'),
            leading: Container(
//                color: Colors.orange,
              child: Radio(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: 'Home Address',
                groupValue: selectedRadio,
                activeColor: Colors.black,
                onChanged: (val) {
                  print('selected $val');
                  setSelectedRadio(val);
                },
              ),
            ),
          ),
          ListTile(
            dense: true,
            title: Text('Work/Office Address'),
            leading: Radio(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: 'Work/Office Address',
              groupValue: selectedRadio,
              activeColor: Colors.black,
              onChanged: (val) {
                print('selected $val');

                setSelectedRadio(val);
              },
            ),
          )
        ],
      ),
    );
  }
}
