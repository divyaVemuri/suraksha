class Error{

  String field;
  String message;

  Error({this.field, this.message});

  factory Error.fromJson(Map<String, dynamic> json){
    return Error(
      field: json['field'],
      message:json['message'],

    );
  }

}