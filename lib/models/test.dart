import 'package:suraksha/models/test_category.dart';
import 'package:suraksha/models/test_center.dart';

class Test {
  dynamic id;
  dynamic finalPrice;
  dynamic name;
  dynamic aliasName;
  dynamic gender;
  dynamic description;
  dynamic testAwareness;
  dynamic understandingTestResults;
  dynamic price;
  dynamic discountPercentage;

  dynamic isAvailable;
  TestCategory category;
  List<TestCenter> testCenters;

  Test(
      {this.id,
      this.finalPrice,
      this.name,
      this.aliasName,
      this.gender,
      this.description,
      this.testAwareness,
      this.understandingTestResults,
      this.price,
      this.discountPercentage,
      this.isAvailable,
      this.category,
      this.testCenters});

  factory Test.fromJson(Map<String, dynamic> json) {
    List<TestCenter> testCenterList = [];
    if (json != null && json['test_centers'] != null) {
      testCenterList = json['test_centers']
          .map<TestCenter>((json) => TestCenter.fromJson(json))
          .toList();
    }

    return Test(
      id: json != null && json['id'] != null ? json['id'] : null,
      finalPrice: json != null && json['final_price'] != null
          ? json['final_price']
          : null,
      name: json != null && json['name'] != null ? json['name'] : null,
      aliasName: json != null && json['alias_name'] != null
          ? json['alias_name']
          : null,
      gender: json != null && json['gender'] != null ? json['gender'] : null,
      description: json != null && json['description'] != null
          ? json['description']
          : null,
      testAwareness: json != null && json['test_awareness'] != null
          ? json['test_awareness']
          : null,
      understandingTestResults:
          json != null && json['understanding_test_results'] != null
              ? json['understanding_test_results']
              : null,
      price: json != null && json['price'] != null ? json['price'] : null,
      discountPercentage: json != null && json['discount_percentage'] != null
          ? json['discount_percentage']
          : null,
      category: json != null && json['category'] != null
          ? TestCategory.fromJson(json['category'])
          : null,
      testCenters:
          json != null && json['test_centers'] != null ? testCenterList : null,
      isAvailable: json != null && json['is_available'] != null
          ? json['is_available']
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'finalPrice': finalPrice,
      'name': name,
      'aliasName': aliasName,
      'gender': gender,
      'description': description,
      'testAwareness': testAwareness,
      'understandingTestResults': understandingTestResults,
      'price': price,
      'discountPercentage': discountPercentage,
      'category': category,
      'testCenters': testCenters,
      'isAvailable': isAvailable,
    };
  }
}
