class TestCategory {
  dynamic id;
  dynamic name;
  dynamic order;

  TestCategory({this.id, this.name, this.order});

  factory TestCategory.fromJson(Map<String, dynamic> json) {
    return TestCategory(
      id: json != null && json['id'] != null ? json['id'] : null,
      name: json != null && json['name'] != null ? json['name'] : null,
      order: json != null && json['order'] != null ? json['order'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'order': order,
    };
  }
}
