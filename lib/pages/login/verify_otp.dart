import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suraksha/main.dart';
import 'package:suraksha/models/otp.dart';
import 'package:suraksha/models/user.dart';
import 'package:suraksha/pages/home.dart';
import 'package:suraksha/pages/login/timer.dart';
import 'package:suraksha/pages/main_page.dart';
import 'package:suraksha/resource/shared_preference_helper.dart';
import 'package:suraksha/services/otp_service.dart';
import 'package:suraksha/values/gradients.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class VerifyOtp extends StatefulWidget {
  String mobile;

  VerifyOtp(this.mobile);

  @override
  _VerifyOtpState createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp>
    with SingleTickerProviderStateMixin {
  SharedPrefsHelper _sharedPrefsHelper = new SharedPrefsHelper();

  int time = 30;

  int num1, num2, num3, num4, currentDigit;

  int n=1;

  AnimationController _controller;

  Timer timer;

//  int totalTimeInSeconds;
  bool _hideResendButton;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: time))
          ..addStatusListener((status) {
            if (status == AnimationStatus.dismissed) {
              setState(() {
                _hideResendButton = !_hideResendButton;
              });
            }
          });
    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);
    _startCountdown();
  }

  @override
  Widget build(BuildContext context) {
//    data = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(0),
                  height: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    'assets/register/background.png',
                    fit: BoxFit.fill,
                  )),
              Container(
                child: form(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget form() {
    return Container(
      height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          MediaQuery.of(context).padding.bottom,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          backButton(),
          _verifyOtpLabel,

          Expanded(
            flex: 2,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _otpTextField(num1,1),
                      SizedBox(
                        width: 10,
                      ),
                      _otpTextField(num2,2),
                      SizedBox(
                        width: 10,
                      ),
                      _otpTextField(num3,3),
                      SizedBox(
                        width: 10,
                      ),
                      _otpTextField(num4,4)
                    ],
                  ),
                  _otpResend()
                ],
              ),
            ),
          ),

//          _otpResend(),

          _otpGrid(),
        ],
      ),
    );
  }

  Widget backButton() {
    return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 26,
              ),
              onPressed: () {

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  get _verifyOtpLabel {
    return Expanded(
      flex: 2,
      child: Container(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Verify',
                  style: TextStyle(
                      fontSize: 22.0,
                      letterSpacing: 3.0,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'OTP',
                  style: TextStyle(
                      fontSize: 22.0,
                      letterSpacing: 3.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Please enter the verification code sent to ',
                  style: TextStyle(fontSize: 15.0, color: Colors.black),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  '+91'+widget.mobile,
//                  data['number'],
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      color: Colors.black),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _otpTextField(int digit, int nextPlace) {
    return new Container(
      width: 35.0,
      height: 45.0,
      alignment: Alignment.center,
      child: _fillText(digit),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        width: 1.0,
        color: nextPlace==n?Color.fromRGBO(231, 10, 10, 1):Colors.grey,
      ))),
    );
  }

  Widget _fillText(int digit) {
    if (digit != null) {
      return new Text(
        digit != null ? digit.toString() : "",
        style: new TextStyle(
          fontSize: 30.0,
          color: Colors.black,
        ),
      );
    } else {
      return Container(
          height: 10.0,
          width: 10.0,
          decoration:
              BoxDecoration(color: Colors.grey[350], shape: BoxShape.circle));
    }
  }

  Widget _otpKeyboardInputButton({String label, VoidCallback onPressed}) {
    return new Container(
      child: InkResponse(
        onTap: onPressed,
        child: Container(
//          color: Colors.grey,
//          padding: EdgeInsets.all(15),
          child: Center(
            child: Text(
              label,
              style: new TextStyle(fontSize: 28.0, color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  Widget _otpKeyboardActionButton({Widget label, VoidCallback onPressed}) {
    return new Container(
      child: InkResponse(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(40.0),
        child: Container(
          child: label,
        ),
      ),
    );
  }

  Widget _otpGrid() {
    return Expanded(
      flex: 4,
      child: Container(
//        color: Colors.pink,
//        padding: EdgeInsets.fromLTRB(20,20, 20, 20),
        child: Center(
          child: StaggeredGridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
//          mainAxisSpacing: 5,
//          crossAxisSpacing: 5,
            staggeredTiles: [
              StaggeredTile.count(1, 0.5),
              StaggeredTile.count(1, 0.5),
              StaggeredTile.count(1, 0.5),
              StaggeredTile.count(1, 0.5),
              StaggeredTile.count(1, 0.5),
              StaggeredTile.count(1, 0.5),
              StaggeredTile.count(1, 0.5),
              StaggeredTile.count(1, 0.5),
              StaggeredTile.count(1, 0.5),
              StaggeredTile.count(1, 0.5),
              StaggeredTile.count(1, 0.5),
              StaggeredTile.count(1, 0.5),
            ],
            children: <Widget>[
              _otpKeyboardInputButton(
                  label: '1',
                  onPressed: () {
                    _setCurrentDigit(1);
                  }),
              _otpKeyboardInputButton(
                  label: '2',
                  onPressed: () {
                    _setCurrentDigit(2);
                  }),
              _otpKeyboardInputButton(
                  label: '3',
                  onPressed: () {
                    _setCurrentDigit(3);
                  }),
              _otpKeyboardInputButton(
                  label: '4',
                  onPressed: () {
                    _setCurrentDigit(4);
                  }),
              _otpKeyboardInputButton(
                  label: '5',
                  onPressed: () {
                    _setCurrentDigit(5);
                  }),
              _otpKeyboardInputButton(
                  label: '6',
                  onPressed: () {
                    _setCurrentDigit(6);
                  }),
              _otpKeyboardInputButton(
                  label: '7',
                  onPressed: () {
                    _setCurrentDigit(7);
                  }),
              _otpKeyboardInputButton(
                  label: '8',
                  onPressed: () {
                    _setCurrentDigit(8);
                  }),
              _otpKeyboardInputButton(
                  label: '9',
                  onPressed: () {
                    _setCurrentDigit(9);
                  }),
              _otpKeyboardActionButton(
                  label: Container(
//                  padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                    child: Icon(Icons.backspace),
                  ),
                  onPressed: () {
                    setState(() {
                      if (num4 != null) {
                        n=4;
                        num4 = null;
                      } else if (num3 != null) {
                        n=3;
                        num3 = null;
                      } else if (num2 != null) {
                        n=2;
                        num2 = null;
                      } else if (num1 != null) {
                        n=1;
                        num1 = null;
                      }
                    });
                  }),
              _otpKeyboardInputButton(
                  label: '0',
                  onPressed: () {
                    _setCurrentDigit(0);
                  }),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: Gradients.redGradient,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    final otp = Otp(
                        mobile: '+91' + widget.mobile,
                        password: num1.toString() +
                            num2.toString() +
                            num3.toString() +
                            num4.toString());
                    final result = await OtpService.verifyOtp(otp);

                    if (result != null) {
                      if (result.statusCode == 200) {
                        await _sharedPrefsHelper.setToken(result.token);
                        await _sharedPrefsHelper.setAge(result.data.age);
                        await _sharedPrefsHelper.setEmail(result.data.email);
                        await _sharedPrefsHelper
                            .setFirstName(result.data.first_name);
                        await _sharedPrefsHelper.setGender(result.data.gender);
                        await _sharedPrefsHelper.setMobile(result.data.mobile);
                        await _sharedPrefsHelper.setUserId(result.data.id);

//                    saveSharedPreferences(token:result.token, user: result.data).then((bool commited){
//                        print("ADDING: ");
//                        getUser();

                        Navigator.pushReplacement(context,
                            CupertinoPageRoute(builder: (context) => MainPage()));
                      }else if(result.statusCode==400){
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Container(
                                child: AlertDialog(
                                  title: Center(
                                      child: Text(
                                        'Incorrect Otp',
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
                                            'You have entered incorrect otp. Please try again.',
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
//                    });
                    } else {}
//                    Navigator.pushNamed(context, '/home');
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _setCurrentDigit(int i) {
    setState(() {
      currentDigit = i;
      if (num1 == null) {
        n=2;
        num1 = currentDigit;
      } else if (num2 == null) {
        n=3;
        num2 = currentDigit;
      } else if (num3 == null) {
        n=4;
        num3 = currentDigit;
      } else if (num4 == null) {
        n=5;
        num4 = currentDigit;
      }
    });
  }

  Widget _otpResend() {
    return Container(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Didn\'t recieve the OTP?',
              style: TextStyle(fontSize: 15.0, color: Colors.grey[600]),
            ),
            _hideResendButton ? _getTimerText : _getResendButton,
          ],
        ),
      ),
    );
  }

  get _getTimerText {
    return Container(
      height: 32,
      child: new Offstage(
        offstage: !_hideResendButton,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new SizedBox(
              width: 5.0,
            ),
            OtpTimer(_controller, 15.0, Color.fromRGBO(231, 10, 47, 1))
          ],
        ),
      ),
    );
  }

  Future<Null> _startCountdown() async {
    setState(() {
      _hideResendButton = true;
    });
    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);
  }

  get _getResendButton {
    return new InkWell(
      child: new Container(
        padding: EdgeInsets.all(5.0),
        alignment: Alignment.center,
        child: new Text(
          "Resend OTP",
          style:
              new TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      onTap: () async {
        final user = User(
//            mobile: _getString(data)
            mobile: '+91' + widget.mobile);
        final result = await OtpService.sendOtp(user);

        if (result != null) {
        } else {}

        setState(() {
          _hideResendButton = true;
          _startCountdown();
        });
        // Resend you OTP via API or anything
      },
    );
  }

  Widget skipButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        InkResponse(
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Text(
              'Skip',
              style: TextStyle(
                  color: Color.fromRGBO(231, 10, 47, 1),
                  letterSpacing: 0.2,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                  decoration: TextDecoration.underline),
            ),
          ),
          onTap: () {},
        ),
      ],
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.cubicTo(size.width / 4, 3 * size.height / 4, 3 * size.width / 4,
        size.height / 4, size.width, size.height);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}

class ClippingClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
        size.width / 8, size.height / 2, size.width / 2, size.height / 2);
//    path.close();
    path.quadraticBezierTo(
        (size.width * 7) / 8, size.height / 2, size.width, 40);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}
