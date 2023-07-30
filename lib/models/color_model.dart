class ColorModel {
  int id;
  String name;
  String code;
  bool active;

  ColorModel({
    this.id,
    this.name,
    this.code,
    this.active
  });

  factory ColorModel.fromJson(Map<String, dynamic> json) {
    return ColorModel(
      id: json['product_color_id'],
      name: json['product_color_name'],
      code: json['product_color_code'],
      active: json['active']
    );
  }

}
