class SubCategoryModel {
  final int id;
  final String image;
  final String title;
  final String description;
  final int parentCategoryId;
  final bool active;


  SubCategoryModel({
    this.id,
    this.image,
    this.title,
    this.description,
    this.parentCategoryId,
    this.active,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['id'],
      image: json['image'],
      title: json['title'],
      description: json['description'],
      parentCategoryId: json['parent_category_id'],
      active: json['active'],
    );
  }
}
