import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suraksha/models/test_category.dart';
import 'package:suraksha/pages/book_a_test/select_test.dart';
import 'package:suraksha/pages/book_a_test/test_category.dart' as prefix0;
import 'package:suraksha/pages/book_a_test/test_details.dart';
import 'package:suraksha/pages/book_a_test/upload_prescription.dart' as prefix1;
import 'package:suraksha/pages/book_a_test/view_available_centers.dart';
import 'package:suraksha/pages/cart.dart';
import 'package:suraksha/pages/commons/app_bar.dart';
import 'package:suraksha/pages/health_package/health_package_details.dart';
import 'package:suraksha/pages/health_package/select_health_package.dart';
import 'package:suraksha/pages/home.dart';
import 'package:suraksha/pages/main_page.dart';
import 'package:suraksha/pages/map_demo.dart';
import 'package:suraksha/pages/test/app_bar_test.dart';
import 'package:suraksha/pages/test/cart_test.dart';
import 'package:suraksha/pages/test/map_demo_test.dart';
import 'package:suraksha/pages/test/my_profile.dart';
import 'package:suraksha/pages/login/register.dart';
import 'package:suraksha/pages/test/sample.dart';
import 'package:suraksha/pages/test_category.dart';
import 'package:suraksha/pages/upload_prescription.dart';
import 'package:suraksha/resource/shared_preference_helper.dart';

void main() async{

  await SharedPrefsHelper().initialize();

  runApp(MaterialApp(
    routes: {
    '/': (context) =>CartTest(),
    '/signUp': (context) => Register(),
    '/home': (context) => Home(),
    '/map': (context) => MapDemo(),
    '/profile': (context) => MyProfile()
  },
    debugShowCheckedModeBanner: false,
  ));

}

Future<bool> clearSharedPreferences() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.clear();
}
