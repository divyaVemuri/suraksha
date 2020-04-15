class Otp{

  String mobile;
  String password;

  Otp({this.mobile, this.password});

  factory Otp.fromJson(Map<String, dynamic> json){
    return Otp(
      mobile: json['mobile'],
      password: json['password']
    );
  }

  Map<String,dynamic> toJson(){
    return{
      "mobile":mobile,
      "password":password,
     };
  }
}