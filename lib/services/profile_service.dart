import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:suraksha/models/address.dart';

import 'package:suraksha/models/api_response.dart';
import 'package:suraksha/models/error.dart' as model;
import 'package:suraksha/models/family_member.dart';
import 'package:suraksha/models/user.dart';

class ProfileService{

  static const API = 'https://appdev.suraksha.care/api/';


  static Future<APIResponse<User>> getUserProfile(String userId, String token){
    print("Getting user profile");
    var headers={
      'Content-Type': 'application/json',
    'Authorization':'jwt '+token
    };

    print('header: '+headers.toString());

    return http.get(API+"/users/"+userId,headers: headers).then((data){
      final jsonbody=json.decode(data.body).cast<String,dynamic>();
      print("status code "+data.statusCode.toString());


      if(data.statusCode==200){
        User user=User.fromJson(jsonbody['data']);

        return APIResponse<User>(data: user,message: jsonbody['message']);
      }else{
        return null;
      }

    }).catchError((e)=>print(e.toString()));
  }

//  static Future<APIResponse<User>> getUserProfile2(String userId, String token){
//    print("Getting user profile");
//    var headers={
//      'Content-Type': 'application/json',
//      'Authorization':'jwt '+token
//    };
//
//    print('header: '+headers.toString());
//
//    return http.get(API+"/users/"+userId,headers: headers).then((data){
//      final jsonbody=json.decode(data.body).cast<String,dynamic>();
//      print("status code "+data.statusCode.toString());
//
//
//      if(data.statusCode==200){
//        User user=User.fromJson2(jsonbody['data']);
//
//        return APIResponse<User>(data: user,message: jsonbody['message']);
//      }else{
//        return null;
//      }
//
//    }).catchError((e)=>print(e.toString()));
//  }



  static Future<APIResponse<Address>> addAddress(Address address, String token){
    print("add address api");
    print("request: "+address.toJson().toString());
    var headers={
      'Content-Type': 'application/json',
      'Authorization':'jwt '+token
    };
    return http.post(API+'users/address',headers: headers,body: json.encode(address.toJson())).then((data){
      print("status code: "+data.statusCode.toString());
      final jsonBody=json.decode(data.body).cast<String,dynamic>();
      print("body: "+jsonBody.toString());
      if(data.statusCode==201){
        Address createdAddress=Address.fromJson(jsonBody['data']);
        return APIResponse<Address>(data: createdAddress,message: jsonBody['message']);
      }else{
        return null;
      }
    }).catchError((_)=>null);
  }

  static Future<APIResponse<FamilyMember>> addFamilyMember(FamilyMember familyMember, String token){
    print("add family member api");
    print("request: "+familyMember.toJson().toString());
    var headers={
      'Content-Type': 'application/json',
      'Authorization':'jwt '+token
    };
    return http.post(API+'users/family_members',headers: headers,body: json.encode(familyMember.toJson())).then((data){
      print("status code: "+data.statusCode.toString());
      final jsonBody=json.decode(data.body).cast<String,dynamic>();
      print("body: "+jsonBody.toString());
      if(data.statusCode==201){
        FamilyMember newMember=FamilyMember.fromJson(jsonBody['data']);
        print('data:'+newMember.toJson().toString());
        return APIResponse<FamilyMember>(data: newMember,message: jsonBody['message']);
      }else{
        return null;
      }
    }).catchError((_)=>null);
  }


  static Future<APIResponse<List<Address>>> getAddresses2(String token){
    print("Getting address");
    var headers={
      'Content-Type': 'application/json',
      'Authorization':'jwt '+token
    };

    print('add header: '+headers.toString());

    return http.get(API+"/users/address",headers: headers).then((data){
      final jsonbody=json.decode(data.body).cast<String,dynamic>();
      print("add status code "+data.statusCode.toString());
      print("add body "+jsonbody.toString());

      if(data.statusCode==200){
        List<Address> list = jsonbody['data'].map<Address>((json)=>Address.fromJson(json)).toList();

        print("address list "+list.toString());

        return APIResponse<List<Address>> (data: list,message: jsonbody['message']);
      }else{
        return null;
      }

    }).catchError((e)=>print("error: "+e.toString()));
  }
  static Future<APIResponse<List<Address>>> getAddresses (String token) async{
    print("Getting addresses");
    var headers={
      'Content-Type': 'application/json',
      'Authorization':'jwt '+token
    };
    print("headers: "+headers.toString());


    try {
      print('adddd in try');
      final response = await http.get(API+"/users/address",headers: headers);
      print("adddd response is: " + response.toString());
      print('status code: '+response.statusCode.toString());

      if (response.statusCode == 200) {
        print("adddd status 200");
        print('adddd response body ' + response.body);
        List<Address> list = parseUser(response.body);
        print(list);
        return APIResponse<List<Address>> (data: list);
      } else {
        print("adddd error!!!!!!!!!!!");
        throw Exception("error");
      }
    } catch (e) {
      print("adddd error**");
      throw Exception(e.toString());
    }


  }


  static List<Address> parseUser(String responseBody) {
    print("pu response body : "+responseBody.toString());
    final parsed = json.decode(responseBody);//.cast<Map<String, dynamic>>();
    final data=parsed['data'].cast<Map<String, dynamic>>();
    print("pu parsed body : "+parsed.toString());
    print("pu data body : "+data.toString());
    print("parsetype"+parsed.runtimeType.toString());
    print("datatype"+data.runtimeType.toString());

    return data.map<Address>((json) => Address.fromJson(json)).toList();
  }

  static Future<APIResponse<List<FamilyMember>>> getFamilyMembers(String token){
    print("Getting family");
    var headers={
      'Content-Type': 'application/json',
      'Authorization':'jwt '+token
    };

    print('add header: '+headers.toString());

    return http.get(API+"/users/family_members",headers: headers).then((data){
      final jsonbody=json.decode(data.body).cast<String,dynamic>();
      print("add status code "+data.statusCode.toString());
      print("add body "+jsonbody.toString());

      if(data.statusCode==200){
        List<FamilyMember> list = jsonbody['data'].map<FamilyMember>((json)=>FamilyMember.fromJson(json)).toList();

        print("address list "+list.toString());

        return APIResponse<List<FamilyMember>> (data: list,message: jsonbody['message']);
      }else{
        return null;
      }

    }).catchError((e)=>print("error: "+e.toString()));
  }

  static Future<APIResponse<dynamic>> updateFamilyMember(String token, FamilyMember update) {

    var headers={
      'Content-Type': 'application/json',
      'Authorization':'jwt '+token
    };


    print("Updating family member");
//    print("request: " + user.toJson().toString());

    print("request update: " + update.toJson().toString());
    return http
        .patch(API + 'users/family_members/'+update.id,
        headers: headers, body: json.encode(update.toJson()))
        .then((data) {
      print("status code: " + data.statusCode.toString());
      final jsonBody = json.decode(data.body).cast<String, dynamic>();
      print("body: " + jsonBody.toString());
      if (data.statusCode == 200) {
        FamilyMember updatedFamilyMember=FamilyMember.fromJson(jsonBody['data']);

//        User user = User.fromJson(jsonBody['data']);
        print("Service: data: "+updatedFamilyMember.toJson().toString());



        return APIResponse<FamilyMember>(data: updatedFamilyMember, message: jsonBody['message'],statusCode: data.statusCode);
      } else if (data.statusCode == 404) {

        print('422');

        List<model.Error> list = jsonBody['errors'].map<model.Error>((json)=>model.Error.fromJson(json)).toList();

        print("error list "+list.toString());

        return APIResponse<List<model.Error>> (statusCode: data.statusCode);

      }else
        return null;
    }).catchError((e) => print(e));
  }

  static Future<APIResponse<dynamic>> updateUser(String token,User user, User update) {

    var headers={
    'Content-Type': 'application/json',
    'Authorization':'jwt '+token
  };


    print("Updating user");
    print("request: " + user.toJson().toString());

    print("request update: " + update.toJson2().toString());
    return http
        .patch(API + 'users/'+user.id,
        headers: headers, body: json.encode(update.toJson2()))
        .then((data) {
      print("status code: " + data.statusCode.toString());
      final jsonBody = json.decode(data.body).cast<String, dynamic>();
      print("body: " + jsonBody.toString());
      if (data.statusCode == 200) {
        User user = User.fromJson(jsonBody['data']);



        return APIResponse<User>(data: user, message: jsonBody['message'],statusCode: data.statusCode);
      } else if (data.statusCode == 404) {

        print('422');

        List<model.Error> list = jsonBody['errors'].map<model.Error>((json)=>model.Error.fromJson(json)).toList();

        print("error list "+list.toString());

        return APIResponse<List<model.Error>> (statusCode: data.statusCode);

      }else
        return null;
    }).catchError((e) => print(e));
  }
}