import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:suraksha/models/user.dart';
import 'package:suraksha/pages/home.dart';
import 'package:suraksha/pages/login/verify_otp.dart';
import 'package:suraksha/services/otp_service.dart';
import 'package:suraksha/values/gradients.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;

  final mobileController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
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
                form()
              ],
            ),
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

  String validateName(String value) {
    if (value.length == 0)
      return 'Mandatory element';
    else
      return null;
  }

  Widget form() {
    return Container(
      height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          MediaQuery.of(context).padding.bottom,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          skipButton(),
          caption(),
          _inputFields,

          _signUpRow(context),

          _loginLink()
        ],
      ),
    );
  }

  Widget skipButton() {
    return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.all(10),
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
            InkResponse(
              child: Container(
                child: Text(
                  'Skip',
                  style: TextStyle(
                      color: Color.fromRGBO(231, 10, 47, 1),
                      letterSpacing: 0.2,
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0,
                      decoration: TextDecoration.underline),
                ),
              ),
              onTap: () {
                Navigator.push(
                    context, CupertinoPageRoute(builder: (context) => Home()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget caption() {
    return Expanded(
      flex: 2,
      child: Container(
        padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Create',
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5),
            ),
            Text(
              'Account',
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5),
            )
          ],
        ),
      ),
    );
  }

  get _inputFields {
    return Expanded(
      flex: 5,
      child: Form(
        key: _key,
        autovalidate: _validate,
        child: Container(
          padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.text,
                validator: validateName,
                controller: nameController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  labelText: "Name",
                  labelStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 15.0,
                      letterSpacing: 1.0),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 0.5, color: Colors.grey[400]),
                  ),
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                validator: validateMobile,
                controller: mobileController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  labelText: "Mobile",
                  labelStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 15.0,
                      letterSpacing: 1.0),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 0.5, color: Colors.grey[400]),
                  ),
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: emailController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  labelText: "Email",
                  labelStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 15.0,
                      letterSpacing: 1.0),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 0.5, color: Colors.grey[400]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signUpRow(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Sign Up',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5),
            ),
            Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                gradient: Gradients.redGradient,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: () async {
                  print('sign up pressed');

                  if (_key.currentState.validate()) {
                    final user = User(
                        first_name: nameController.text,
                        mobile: '+91' + mobileController.text,
                        email: emailController.text);

                    final result = await OtpService.registerUser(user);

                    if (result != null) {
                      if (result.statusCode == 201) {
//                        Navigator.pushNamed(context, '/verifyOtp', arguments: {
//                          'number': '+91' + mobileController.text
//                        });

                        Navigator.push(context, CupertinoPageRoute(builder: (context)=>VerifyOtp('+91'+mobileController.text)));
                      } else if (result.statusCode == 422) {
                        createDialog(context);
                      }
                    } else {
                      print(null);
                    }
                  } else {
                    print('error in validation');
                    //error in validation
                    setState(() {
                      _validate = true;
                    });
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  createDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Container(
            child: AlertDialog(
              title: Center(
                  child: Text(
                'Account already exists!',
                style: TextStyle(color: Color.fromRGBO(55, 121, 248, 1)),
              )),
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.all(30),
                        child: Image.asset('assets/error.png')),
                    Container(
                      padding: EdgeInsets.all(20),
                      alignment: Alignment.center,
                      child: Text(
                        'The number that you have entered is already registered. Please log in.',
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

  Widget _loginLink() {
    return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
        child: InkResponse(
          child: Text(
            'Login',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                decoration: TextDecoration.underline,
                letterSpacing: 1.5),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

class ClippingClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 8, size.height / 2, size.width / 2, size.height / 2);
    path.quadraticBezierTo(
        (size.width * 7) / 8, size.height / 2, size.width, 80);

    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}
