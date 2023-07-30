class SizeModel {
  int id;
  String name;
  String description;
  bool active;

  SizeModel({
    this.id,
    this.name,
    this.description,
    this.active
  });

  factory SizeModel.fromJson(Map<String, dynamic> json) {
    return SizeModel(
      id: json['product_size_id'],
      name: json['product_size_name'],
      description: json['product_size_description'],
      active: json['active']
    );
  }

}
