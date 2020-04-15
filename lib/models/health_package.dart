import 'package:suraksha/models/test.dart';
import 'package:suraksha/models/test_center.dart';

class HealthPackage{
  dynamic id;
  dynamic finalPrice;
  dynamic name;
  dynamic description;
  dynamic price;
  dynamic discountPercentage;
  dynamic includedHealthTests;
  dynamic testCenters;

  HealthPackage({this.id, this.finalPrice, this.name, this.description,
      this.price, this.discountPercentage, this.includedHealthTests,
      this.testCenters});


  factory HealthPackage.fromJson(Map<String, dynamic> json){

    List<Test> testList=[];
    if(json!=null && json['included_health_tests']!=null){
      testList=json['included_health_tests']
          .map<Test>((json)=>Test.fromJson(json)).toList();
    }

    List<TestCenter> testCenterList = [];
    if (json != null && json['test_centers'] != null) {
      testCenterList = json['test_centers']
          .map<TestCenter>((json) => TestCenter.fromJson(json))
          .toList();
    }

    return HealthPackage(
      id: json!=null? json['id']:null,
      finalPrice: json!=null? json['final_price']:null,
      name: json!=null? json['name']:null,
      description: json!=null? json['description']:null,
      price: json!=null? json['price']:null,
      discountPercentage: json!=null? json['discount_percentage']:null,
      includedHealthTests: json!=null? testList:null,
      testCenters: json!=null?testCenterList:null
    );
  }

  Map<String,dynamic> toJson(){
    return{
      'id':id,
      'final_price':finalPrice,
      'name':name,
      'description':description,
      'price':price,
      'discount_percentage': discountPercentage,
      'included_health_tests':includedHealthTests,
      'test_centers':testCenters
    };
  }
}
