class Product {
  String id;
  String imageUrl;
  String name;
  String price;
  String rating;
  bool isInDiscount;
  String discount;
  String decription;

  Product(String id, String imageUrl, String name, String price, String rating,
      bool isInDiscount, String discount, String decription) {
    this.id = id;
    this.imageUrl = imageUrl;
    this.name = name;
    this.price = price;
    this.rating = rating;
    this.isInDiscount = isInDiscount;
    this.discount = discount;
    this.decription = decription;
  }
}
