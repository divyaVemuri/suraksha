import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:suraksha/models/api_response.dart';
import 'package:suraksha/models/error.dart' as model;
import 'package:suraksha/models/otp.dart';
import 'package:suraksha/models/user.dart';

class OtpService {
  static const API = 'https://appdev.suraksha.care/api/';

  static const headers = {
//    'apiKey': '08d771e2-7c49-1789-0eaa-32aff09f1471',
    'Content-Type': 'application/json'
  };

  static Future<APIResponse<Object>> registerUser(User user) {
    print('inside register');

    print('request: ' + user.toJson().toString());
    return http.post(API + 'users/',
            headers: headers, body: json.encode(user.toJson()))
        .then((data) {
      print("status code: " + data.statusCode.toString());

      final jsonBody = json.decode(data.body).cast<String, dynamic>();

      print("body: " + jsonBody.toString());

      if (data.statusCode == 201) {

        User user = User.fromJson(jsonBody['data']);
        return APIResponse<User>(data: user, message: jsonBody['message'],statusCode: data.statusCode);

      } else if (data.statusCode == 422) {

        print('422');

        List<model.Error> list = jsonBody['errors'].map<model.Error>((json)=>model.Error.fromJson(json)).toList();

        print("error list "+list.toString());

        return APIResponse<List<model.Error>> (data: list,statusCode: data.statusCode);

      } else {
        return null;
      }
    }).catchError((e) {
      print("error:"+e);
      return null;
    });
  }

  static List<User> parseUser(String responseBody) {
    print("inisde parse: " + responseBody);
    final parsed = json.decode(responseBody).cast<String, dynamic>();
    print("parsed: " + parsed);
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  static Future<APIResponse<dynamic>> sendOtp(User user) {
    print("send otp");
    print("request: " + user.toJson().toString());
    return http
        .post(API + 'users/generate_login_otp',
            headers: headers, body: json.encode(user.toJson()))
        .then((data) {
      print("status code: " + data.statusCode.toString());
      final jsonBody = json.decode(data.body).cast<String, dynamic>();
      print("body: " + jsonBody.toString());
      if (data.statusCode == 200) {
//        User user = User.fromJson(jsonBody['data']);

        return APIResponse<User>(message: jsonBody['message'],statusCode: data.statusCode);
      } else if (data.statusCode == 404) {

        print('422');

        List<model.Error> list = jsonBody['errors'].map<model.Error>((json)=>model.Error.fromJson(json)).toList();

        print("error list "+list.toString());

        return APIResponse<List<model.Error>> (data: list,statusCode: data.statusCode);

      }else
        return null;
    }).catchError((e) => print(e));
  }

//  static Future<APIResponse<User>> verifyOtp(User user){
//    return http.post(API+'users/verify_login_otp',headers: headers, body: json.encode(user.toJson())).then((data){
//      if(data.statusCode==200){
//        final jsonBody=json.decode(data.body).cast<String,dynamic>();
//        User user = User.fromJson(jsonBody['data']);
//
//        return APIResponse<User>(data:user, message: jsonBody['message'] );
//      }else if(data.statusCode==404){
//        return  null;
//      }else return null;
//
//    }).catchError((_)=>null);
//  }

  static Future<APIResponse<dynamic>> verifyOtp(Otp otp) {
    print("verify otp api");
    print("request: " + otp.toJson().toString());

    return http
        .post(API + 'users/verify_login_otp',
            headers: headers, body: json.encode(otp.toJson()))
        .then((data) {
      print("status code: " + data.statusCode.toString());
      final jsonBody = json.decode(data.body).cast<String, dynamic>();
      print("body: " + jsonBody.toString());

      if (data.statusCode == 200) {
        User user = User.fromJson(jsonBody['data']);

        return APIResponse<User>(
            data: user, message: jsonBody['message'], token: jsonBody['token'],statusCode: data.statusCode);
      } else if (data.statusCode == 400) {
        print('404');

        List<model.Error> list = jsonBody['errors'].map<model.Error>((json)=>model.Error.fromJson(json)).toList();

        print("error list "+list.toString());

        return APIResponse<List<model.Error>> (data: list,statusCode: data.statusCode);
      } else
        return null;
    }).catchError((_) => null);
  }

/*
  Future<APIResponse<bool>> createNote(NoteInsert item) {
    return http.post(API + '/notes', headers: headers, body: json.encode(item.toJson())).then((data) {
      if (data.statusCode == 201) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occured');
    })
    .catchError((_) => APIResponse<bool>(error: true, errorMessage: 'An error occured'));
  }
   */
//  Future<APIResponse<List<NoteForListing>>> getNotesList() {
//    return http.get(API + '/notes', headers: headers).then((data) {
//      if (data.statusCode == 200) {
//        final jsonData = json.decode(data.body);
//        final notes = <NoteForListing>[];
//        for (var item in jsonData) {
//          notes.add(NoteForListing.fromJson(item));
//        }
//        return APIResponse<List<NoteForListing>>(data: notes);
//      }
//      return APIResponse<List<NoteForListing>>(error: true, errorMessage: 'An error occured');
//    })
//        .catchError((_) => APIResponse<List<NoteForListing>>(error: true, errorMessage: 'An error occured'));
//  }
}
