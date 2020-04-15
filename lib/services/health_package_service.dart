
import 'dart:convert';

import 'package:suraksha/models/api_response.dart';
import 'package:suraksha/models/health_package.dart';
import 'package:http/http.dart' as http;


class HealthPacakgeService{
  static const API = 'https://appdev.suraksha.care/api/';

  static Future<APIResponse<List<HealthPackage>>> getHealthPackageList(String testCenters, String testCategory){
    print('Fetching health packages');
    var headers={
      'Content-Type': 'application/json',
    };

    return http.get(API+'health_packages/packages?test_centers=$testCenters&included_health_tests__category=$testCategory',headers:headers ).then((data){
      final jsonbody=json.decode(data.body).cast<String,dynamic>();
      print('Status code: '+data.statusCode.toString());
      print('body: '+jsonbody.toString());

      if(data.statusCode==200){
        List<HealthPackage> helalthPackageList=jsonbody['data'].map<HealthPackage>((json)=>HealthPackage.fromJson(json)).toList();
        return APIResponse<List<HealthPackage>> (data: helalthPackageList,message: jsonbody['message']);

      }else{
        return null;
      }

    }).catchError((e)=>print("error: "+e.toString()));
  }
}