class CategoryModel {
  final int id;
  final String logo;
  final String title;
  final String description;
  final List subCategories;

  CategoryModel({
    this.id,
    this.logo,
    this.title,
    this.description,
    this.subCategories,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      logo: json['image'] ?? json['cover'],
      title: json['title'],
      description: json['description'],
      subCategories: json['sub_categories'] ?? [],
    );
  }
}
