import 'package:suraksha/models/test_center.dart';

class User{
  String id;
  String mobile;
  String first_name;
  String gender;
  String email;
  int age;
  String favouriteLocationId;
  TestCenter favouriteLocation;



  User({this.id, this.mobile, this.first_name, this.gender, this.email,
      this.age, this.favouriteLocationId, this.favouriteLocation});

  Map<String,dynamic> toJson2(){
    return{
      "id":id,
      "mobile":mobile,
      "first_name":first_name,
      "gender":gender,
      "email":email,
      "age":age,
      "favorite_test_center":favouriteLocationId,
    };
  }
  Map<String,dynamic> toJson(){
    return{
      "id":id!=null?id:null,
      "mobile":mobile!=null?mobile:null,
      "first_name":first_name!=null?first_name:null,//first_name,
      "gender":gender!=null?gender:null,//gender,
      "email":email!=null?email:null,//email,
      "age":age!=null?age:null,//age,
      "favorite_test_center":favouriteLocation!=null?favouriteLocation.toJson():null,
    };
  }


  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json!=null && json['id']!=null?json['id']:null,//json['id'],
      mobile: json!=null && json['mobile']!=null?json['mobile']:null,//json['mobile'],
      first_name: json!=null && json['first_name']!=null?json['first_name']:null,//json['first_name'],
      gender: json!=null && json['gender']!=null?json['gender']:null,//json['gender'],
      email: json!=null && json['email']!=null?json['email']:null,//son['email'],
      age: json!=null && json['age']!=null?json['age']:null,//json['age'],
//      favouriteLocationId:json['favorite_test_center']['id'],
      favouriteLocation: json!=null && json['favorite_test_center']!=null?
      TestCenter.fromJson(json['favorite_test_center']):null
    );
  }
}