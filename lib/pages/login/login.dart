import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suraksha/models/user.dart';
import 'package:suraksha/pages/home.dart';
import 'package:suraksha/pages/login/register.dart';
import 'package:suraksha/pages/login/verify_otp.dart';
import 'package:suraksha/services/otp_service.dart';
import 'package:suraksha/values/gradients.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}


class _LoginState extends State<Login> {

  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;

  var safePadding;

  bool buttonPressed=false;

  final mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height -
                  (MediaQuery.of(context).padding.top +
                  MediaQuery.of(context).padding.bottom),
              color: Colors.grey,
              child: Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height-(MediaQuery.of(context).padding.top+MediaQuery.of(context).padding.bottom),
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset('assets/background/background.png',fit: BoxFit.fill,),
                  ),
                  Column(
                    children: <Widget>[title(), inputForm()],
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget first() {
    safePadding = MediaQuery.of(context).padding.top;

    return Container(
      height: MediaQuery.of(context).size.height - safePadding,
      child: Column(
        children: <Widget>[
          title(),
          inputForm(),
        ],
      ),
    );
  }

  Widget title() {
    return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.only(top: 10),
        alignment: Alignment.center,
        child: (Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 20),
//                child: Image.asset('assets/login/bitmap.png'),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        'Suraksha',
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 4,
                            fontSize: 35,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    Container(
                      child: Text(
                        'DIAGNOSTICS',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(

                

                  child: SvgPicture.asset(
                "assets/svg/login/login.svg",
//                fit: BoxFit.fill,
              ),
//color: Colors.blue,
//padding: EdgeInsets.all(30),
//              width: MediaQuery.of(context).size.width,
              ),
            ),
          ],
        )),
      ),
    );
  }

  Widget inputForm() {
    return Expanded(
      flex: 1,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(45), topRight: Radius.circular(45)),
            color: Colors.white),
        child: Form(
          key: _key,
          autovalidate: _validate,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Container(
                  padding:
                      EdgeInsets.only(left: 40, right: 40, bottom: 0, top: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      TextFormField(
                        controller: mobileController,
                        validator: validateMobile,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Mobile",
                          labelStyle: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 17.0,
                              letterSpacing: 1.0),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)),
                        ),
                      ),
                      logInButton(context),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: signUpRow(),
              )
            ],
          ),
        ),
      ),
    );
  }

  String validateMobile(String value) {
    if (value.length != 10)
      return 'Mobile Number must be 10 digit';
    else
      return null;
  }

  Widget logInButton(BuildContext context) {
    return InkResponse(
      child: Container(
        padding: EdgeInsets.all(15),
//        height: 70,
        width: MediaQuery.of(context).size.width - 120,
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          gradient: Gradients.redGradient,
          borderRadius: BorderRadius.all(Radius.circular(35)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Login with OTP",
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
        if (!buttonPressed) {
          if (_key.currentState.validate()) {
            buttonPressed = true;
            final user = User(mobile: '+91' + mobileController.text);
            final result = await OtpService.sendOtp(user);

            if (result != null) {
              if (result.statusCode == 200) {
                buttonPressed=false;
//                print(result.data.mobile);
                print(result.message);

//                Navigator.of(context).pop();
                Navigator.push(
                    context, CupertinoPageRoute (builder: (context) => VerifyOtp(mobileController.text)));


              } else if (result.statusCode == 404) {
                print('show toast');
                buttonPressed=false;
                showDialog(
                    context: context,
                    builder: (context) {
                      return Container(
                        child: AlertDialog(
                          title: Center(
                              child: Text(
                            'User not registered',
                            style: TextStyle(
                                color: Color.fromRGBO(55, 121, 248, 1)),
                          )),
                          content: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.all(30),
                                    child: SvgPicture.asset('assets/svg/utilities/error.svg')),
                                Container(
                                  padding: EdgeInsets.all(20),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'This number is not registered with us. Please register.',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              ],
                            ),
                          ),
                          backgroundColor: Colors.white,
                        ),
                      );
                    });
              }

            }
          } else {
            print('error in validation');
            //error in validation
            setState(() {
              _validate = true;
            });
          }
        }else{
          print("button pressed already");
        }
      },
    );
  }

  Widget signUpRow() {
    return Container(
      padding: EdgeInsets.only(left: 60,right: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkResponse(
            onTap: () {

              Navigator.push(
                  context, CupertinoPageRoute (builder: (context) => Register()));
//              Navigator.pushNamed(context, '/signUp');
            },
            child: Text(
              'Sign Up',
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink[700]),
            ),
          ),
          InkResponse(
            onTap: () {
              Navigator.pushReplacement(
                  context, CupertinoPageRoute (builder: (context) => Home()));
            },

            /*
           Navigator.push(
    context, CupertinoPageRoute(builder: (context) => Screen2()))
  );
             */
            child: Text(
              'Skip Login',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700]),
            ),
          )
        ],
      ),
    );
  }
}
