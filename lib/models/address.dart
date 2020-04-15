class Address{

  String id;
  int pincode;
  String state;
  String city;
  String landmark;
  String houseDetails;
  String areaDetails;
  String addressType;
  String mobileUserInfo;


  Address({this.id, this.pincode, this.state, this.city, this.landmark,
      this.houseDetails, this.areaDetails, this.addressType,
      this.mobileUserInfo});

  factory Address.fromJson(Map<String, dynamic> json){
    return Address(
      id:json['id'],
      pincode:json['pincode_number'],
      state:json['state'],
      city:json['city'],
      landmark:json['landmark'],
      houseDetails:json['house_details'],
      areaDetails:json['area_details'],
      addressType:json['address_type'],
      mobileUserInfo:json['mobile_user_info']
    );
  }

  Map<String,dynamic> toJson(){
    return{
      'id':id,
      'pincode_number':pincode,
      'state':state,
      'city':city,
      'landmark':landmark,
      'house_details':houseDetails,
      'area_details':areaDetails,
      'address_type':addressType,
      'mobile_user_info':mobileUserInfo
    };
  }
}