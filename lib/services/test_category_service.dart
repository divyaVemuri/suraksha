
import 'dart:convert';

import 'package:suraksha/models/api_response.dart';
import 'package:suraksha/models/test_category.dart';
import 'package:http/http.dart' as http;


class TestCategoryService{
  static const API = 'https://appdev.suraksha.care/api/';

  static Future<APIResponse<List<TestCategory>>> getTestCenterList(){
    print('Fetching test centers');
    var headers={
      'Content-Type': 'application/json',
    };

    return http.get(API+'master_data/test_categories?ordering=order,name',headers:headers ).then((data){
      final jsonbody=json.decode(data.body).cast<String,dynamic>();
      print('Status code: '+data.statusCode.toString());
      print('body: '+jsonbody.toString());

      if(data.statusCode==200){
        List<TestCategory> testCenterList=jsonbody['data'].map<TestCategory>((json)=>TestCategory.fromJson(json)).toList();
        return APIResponse<List<TestCategory>> (data: testCenterList,message: jsonbody['message']);

      }else{
        return null;
      }

    }).catchError((e)=>print("error: "+e.toString()));
  }
}