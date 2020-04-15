class TestCenter {
  String id;
  String name;
  String address;
  String location;
  double longitude;
  double latitude;
  double distance;

  TestCenter(
      {this.id,
      this.name,
      this.address,
      this.location,
      this.longitude,
      this.latitude,
      this.distance});

//  factory TestCenter.fromJson(Map<String, dynamic> json) {
//    return TestCenter(
//        id: json['id'],
//        name: json['name'],
//        address: json['address'],//json['address'],
//        location: json['location'],//json['location'],
//        longitude: json['longitude'],//json['longitude'],
//        latitude: json['latitude'],//json['latitude']);
//    );
//  }

  factory TestCenter.fromJson(Map<String, dynamic> json) {
    return TestCenter(
      id: json != null && json['id'] != null ? json['id'] : null,
      name: json != null && json['name'] != null ? json['name'] : null,
      address: json != null && json['address'] != null ? json['address'] : null,
      location:
          json != null && json['location'] != null ? json['location'] : null,
      longitude:
          json != null && json['longitude'] != null ? json['longitude'] : null,
      latitude:
          json != null && json['latitude'] != null ? json['latitude'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id != null ? id : null,
      'name': name != null ? name : null, //name,
      'address': address != null ? address : null, //address,
      'location': location != null ? location : null, //location,
      'longitude': longitude != null ? longitude : null, //longitude,
      'latitude': latitude != null ? latitude : null, //latitude,
      'distance': distance != null ? distance : null, //distance
    };
  }
}
