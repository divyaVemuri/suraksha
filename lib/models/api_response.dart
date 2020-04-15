import 'package:suraksha/models/error.dart' as prefix0;

class APIResponse<T> {
  T data;
  String message;
  List<prefix0.Error> error;
  String errorMessage;
  String token;
  int statusCode;


  APIResponse({this.data, this.message, this.error, this.errorMessage,
      this.token, this.statusCode});

//  APIResponse({this.data, this.message, this.error, this.errorMessage});

  factory APIResponse.fromJson(Map<String, dynamic> json){
    return APIResponse(
      data: json['data'],
      message:json['message'],

    );
  }

}