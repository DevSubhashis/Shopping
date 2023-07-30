class BrandModel {
  final int id;
  final String logo;
  final String title;
  final String description;

  BrandModel({
    this.id,
    this.logo,
    this.title,
    this.description,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'],
      logo: json['brand_logo'],
      title: json['title'],
      description: json['description'],
    );
  }
}
