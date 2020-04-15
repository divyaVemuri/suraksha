
import 'dart:convert';

import 'package:suraksha/models/api_response.dart';
import 'package:suraksha/models/test_center.dart';
import 'package:http/http.dart' as http;

class TestCenterService{

  static const API = 'https://appdev.suraksha.care/api/';

  static Future<APIResponse<List<TestCenter>>> getTestCenterList(){
    print('Fetching test centers');
    var headers={
      'Content-Type': 'application/json',
    };

    return http.get(API+'master_data/test_centers',headers:headers ).then((data){
      final jsonbody=json.decode(data.body).cast<String,dynamic>();
      print('Status code: '+data.statusCode.toString());
      print('body: '+jsonbody.toString());

      if(data.statusCode==200){
        List<TestCenter> testCenterList=jsonbody['data'].map<TestCenter>((json)=>TestCenter.fromJson(json)).toList();
        return APIResponse<List<TestCenter>> (data: testCenterList,message: jsonbody['message']);

      }else{
        return null;
      }

    }).catchError((e)=>print("error: "+e.toString()));
  }
}