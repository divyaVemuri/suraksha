class FamilyMember{

  String id;
  String firstName;
  String gender;
  int age;
  String relationshipName;

  FamilyMember({this.id, this.firstName, this.gender, this.age,
      this.relationshipName});

  factory FamilyMember.fromJson(Map<String, dynamic> json){
    return FamilyMember(
        id:json['id'],
        firstName:json['first_name'],
        gender:json['gender'],
        age:json['age'],
        relationshipName:json['relationship_name'],

    );
  }

  Map<String,dynamic> toJson(){
    return{
      'id':id,
      'first_name':firstName,
      'gender':gender,
      'age':age,
      'relationship_name':relationshipName,
    };
  }
}