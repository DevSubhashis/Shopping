class ProductModel {
  final int id;
  final String title;
  final String description;
  final String maxPrice;
  final String brand;
  final String category;
  final String subcategory;
  final List imageList;
  final List productVariants;
  final List specifications;
  final bool multipleColor;
  final bool multipleSize;

  ProductModel({
    this.id,
    this.title,
    this.description,
    this.maxPrice,
    this.brand,
    this.category,
    this.subcategory,
    this.imageList,
    this.productVariants,
    this.specifications,
    this.multipleColor,
    this.multipleSize,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['product_id'],
      title: json['title'],
      description: json['description'],
      maxPrice: json['maximum_retail_price'],
      brand: json['brand'],
      category: json['category'],
      subcategory: json['sub_category'],
      imageList: json['product_images'],
      productVariants: json['product_variants'],
      specifications: json['specification'],
      multipleColor: json['multiple_color'],
      multipleSize: json['multiple_size'],
    );
  }
}
