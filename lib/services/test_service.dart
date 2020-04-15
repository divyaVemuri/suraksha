
import 'dart:convert';

import 'package:suraksha/models/api_response.dart';
import 'package:suraksha/models/test.dart';
import 'package:suraksha/models/test_category.dart';
import 'package:http/http.dart' as http;


class TestService{
  static const API = 'https://appdev.suraksha.care/api/';

  static Future<APIResponse<List<Test>>> getTestList(String testCentre, String testCategory){

    print('Fetching tests by category');
    print('category: '+testCategory);
    if(testCentre!=null) {
      print('test cneter: ' + testCentre);


      var headers = {
        'Content-Type': 'application/json',
      };

      return http.get(API +
          'health_tests/tests?test_center=$testCentre&category=$testCategory',
          headers: headers).then((data) {
        final jsonbody = json.decode(data.body).cast<String, dynamic>();
        print('Status code: ' + data.statusCode.toString());
        print('body id: ' + jsonbody['data'][1]['id'].toString());

        print('body: ' + jsonbody['data'][1]['is_available'].toString());

        if (data.statusCode == 200) {
          List<Test> testList = jsonbody['data'].map<Test>((json) =>
              Test.fromJson(json)).toList();
          return APIResponse<List<Test>>(
              data: testList, message: jsonbody['message']);
        } else {
          return null;
        }
      }).catchError((e) => print("error: " + e.toString()));
    }

  }
}