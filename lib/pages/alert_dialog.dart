import 'package:flutter/material.dart';
import 'package:suraksha/models/family_member.dart';
import 'package:suraksha/resource/shared_preference_helper.dart';
import 'package:suraksha/services/profile_service.dart';
import 'package:suraksha/values/gradients.dart';

class MyDialog extends StatefulWidget {
  final ValueChanged<FamilyMember> familymember;
  final ValueChanged<FamilyMember> updatedFamilyMember;
  String token;
  FamilyMember existingFamilyMember;

  MyDialog({this.familymember, this.token, this.existingFamilyMember,this.updatedFamilyMember});

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  bool addMemberButtonPressed = true;
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  SharedPrefsHelper _sharedPrefsHelper = new SharedPrefsHelper();
  String userId;
  String dropdownValue;

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();
  final relationController = TextEditingController();

  @override
  void initState() {
    userId = _sharedPrefsHelper.getUserId();
    if (widget.existingFamilyMember != null) {
      nameController.text = widget.existingFamilyMember.firstName;
      ageController.text = widget.existingFamilyMember.age.toString();
      dropdownValue = widget.existingFamilyMember.gender;
      relationController.text = widget.existingFamilyMember.relationshipName;
    }
    // TODO: implement initState
    super.initState();
  }

  _getDropDown() {
    return DropdownButton<String>(
      value: dropdownValue,
      hint: Container(
        padding: EdgeInsets.only(bottom: 20),
        width: MediaQuery.of(context).size.width - 209,
        child: Text(
          'Gender',
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
        print('drop down value changed');
        setState(() {
          dropdownValue = newValue;
          print('after: ' + dropdownValue);
        });
      },
      items: <String>['Male', 'Female', 'Others', '']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  _inputFields() {
    String validateName(String value) {
      if (value.length == 0)
        return 'Mandatory element';
      else
        return null;
    }

    String validateAge(String value) {
      if (value.length == 0)
        return 'Mandatory element';
      else
        return null;
    }

    String validateRelation(String value) {
      if (value.length == 0)
        return 'Mandatory element';
      else
        return null;
    }

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 30, bottom: 30),
        child: Column(
          children: <Widget>[
            Form(
              key: _key,
              autovalidate: _validate,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Colors.white),
                padding: EdgeInsets.fromLTRB(40, 0, 40, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: TextFormField(
                        controller: nameController,
                        validator: validateName,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          labelText: "Name",
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
                    Container(
                      padding: EdgeInsets.only(bottom: 20),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: ageController,
                        validator: validateAge,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          labelText: "Age",
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
                    _getDropDown(),
                    Container(
                      padding: EdgeInsets.only(bottom: 20),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: relationController,
                        validator: validateRelation,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          labelText: "Relation",
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
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
//            color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(35, 10, 35, 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(35)),
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
                        borderRadius: BorderRadius.all(Radius.circular(35)),
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
                    onTap: () async {
                      if (_key.currentState.validate()) {
                        if (addMemberButtonPressed) {
                          addMemberButtonPressed = false;

                          if (widget.existingFamilyMember != null) {
                            addMemberButtonPressed = true;
                            final member = FamilyMember(
                                id: widget.existingFamilyMember.id,
                                firstName: nameController.text,
                                age: int.parse(ageController.text),
                                gender: dropdownValue,
                                relationshipName: relationController.text);

                            final result =
                                await ProfileService.updateFamilyMember(
                                    widget.token, member);
                            if (result != null) {
                              print("Result not null "+result.toString());
//                              setState(() {
                                widget.updatedFamilyMember(result.data);
//                              });

                              addMemberButtonPressed = true;
                              Navigator.pop(context, widget.updatedFamilyMember);
                            }
                          } else {
                            final member = FamilyMember(
                                firstName: nameController.text,
                                age: int.parse(ageController.text),
                                gender: dropdownValue,
                                relationshipName: relationController.text);

                            final result = await ProfileService.addFamilyMember(
                                member, widget.token);
                            if (result != null) {
                              setState(() {
                                widget.familymember(result.data);
                              });
                              addMemberButtonPressed = true;
                              Navigator.pop(context);
                            }
                          }
                        }
                      } else {
                        print('error in validation');
                        //error in validation
                        setState(() {
                          _validate = true;
                        });
                      }
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Center(
            child: Text(
          'Add New Member',
          style: TextStyle(color: Color.fromRGBO(55, 121, 248, 1)),
        )),
        content: _inputFields(),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)));
  }
}
