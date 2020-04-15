import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Gradients {
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment(0.5, 0),
    end: Alignment(0.5, 1),
    stops: [
      0,
      1,
    ],
    colors: [
      Color.fromARGB(255, 70, 152, 223),
      Color.fromARGB(255, 48, 115, 210),
    ],
  );

  static const Gradient redGradient = LinearGradient(
    begin: Alignment(1, 2),
    end: Alignment(-1, 0),
//    begin: Alignment(5, -10),
//    end: Alignment(0.5, 1),
//    begin: Alignment(-1, 0.5),
//    end: Alignment(0.5, 0.5),
    stops: [
      0,
      1,
    ],
    colors: [
      Color.fromRGBO( 225, 69, 90,1),
      Color.fromRGBO( 191, 0, 36,1),
//      Color.fromARGB(255, 222, 0, 65),
//      Color.fromARGB(255, 191, 0, 36),
    ],
  );

  static const Gradient pinkGradient = LinearGradient(
    begin: Alignment(1, 2),
    end: Alignment(-1, 0),
    stops: [
      0,
      1,
    ],
    colors: [
      Color.fromARGB(255, 255, 152, 187),
      Color.fromARGB(255, 255, 89, 145),
    ],
  );

  static const Gradient greyGradient = LinearGradient(
//    begin: Alignment(0.5, 0),
//    end: Alignment(0.5, 1),
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [
      0,
      1,
    ],
    colors: [
      Color.fromARGB(255, 192, 196, 202),
      Color.fromARGB(255, 240, 245, 252),
    ],
  );

  static const Gradient opaque = LinearGradient(
//    begin: Alignment(0.5, 0),
//    end: Alignment(0.5, 1),
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    stops: [
      0.3,
      1
    ],
    colors: [
//      Colors.white,
//      Colors.transparent,
//    Colors.red,
//      Colors.blue
      Color.fromRGBO(255, 255, 255, 1),
      Color.fromRGBO(255, 255, 255, -1),

//      Color.fromARGB(255, 225, 69, 90),
//      Color.fromRGBO(255, 255, 255, 0),
//      Color.fromRGBO(255, 240, 245, 0),
    ],
  );
}
