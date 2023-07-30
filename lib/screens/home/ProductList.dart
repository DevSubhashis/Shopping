import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ppl/models/product_model.dart';
import 'package:ppl/components/ProductSingle.dart';
import 'package:ppl/presentation/custom_icons_icons.dart';
import 'package:ppl/screens/home/cart.dart';
import 'package:ppl/screens/home/productDetails.dart';
import 'package:ppl/utils/constants.dart';
import 'package:badges/badges.dart';
import 'package:ppl/localization/app_translations.dart';
import 'package:ppl/services/services.dart';
import 'package:ppl/screens/home/filter.dart';

class ProductList extends StatefulWidget {
  final int categoryId;
  final String sub_category_id;
  final String brand_id;
  final String color_id;
  final String size_id;
  ProductList({
    Key key,
    this.categoryId,
    this.sub_category_id,
    this.brand_id,
    this.color_id,
    this.size_id,
  }) : super(key: key);

  @override
  ProductListState createState() => ProductListState();
}

class ProductListState extends State<ProductList> {
  List<ProductModel> products = List<ProductModel>();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllProductsByCategory();
  }

  _fetchAllProductsByCategory() async {
    Map body = {};
    body['category_id'] = widget.categoryId;
    if (widget.sub_category_id != null) {
      body['sub_category_id'] = int.parse(widget.sub_category_id);
    }
    if (widget.brand_id != null) {
      body['brand_id'] = int.parse(widget.brand_id);
    }

    var colorList = new List(1);
    colorList[0] = widget.color_id;
    if (widget.color_id != null) {
      body['product_color_id'] = colorList;
    }

    var sizeList = new List(1);
    sizeList[0] = widget.size_id;
    if (widget.size_id != null) {
      body['product_size_id'] = sizeList;
    }

    // body = {
    //   "category_id": widget.categoryId,
    //   "sub_category_id": widget.sub_category_id,
    //   "brand_id": widget.brand_id,
    // };

    print(body);
    final WebService _webService = WebService();
    final response =
        _webService.getAllProductsByCategory(GET_ALL_PRODUCTS, body);
    response.then((value) {
      print(value);
      setState(() {
        isLoading = false;
        products = value;
      });
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 55.0),
        child: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0.5,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: colors,
              ),
            ),
          ),
          centerTitle: false,
          // leading: Image.asset(
          //   'assets/images/icon.png',
          //   fit: BoxFit.contain,
          //   width: 30.0,
          // ),
          title: Container(
            height: 35.0,
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: AppTranslations.of(context).text('ppl_search'),
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(25.7),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(25.7),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            Badge(
              position: BadgePosition.topRight(top: 0, right: 3),
              animationDuration: Duration(milliseconds: 300),
              animationType: BadgeAnimationType.slide,
              badgeContent: Text(
                3.toString(),
                style: TextStyle(color: Colors.white),
              ),
              child: IconButton(
                splashColor: Colors.white,
                icon: SvgPicture.asset(
                  'assets/images/icon_shopping_cart.svg',
                  color: Colors.white,
                  fit: BoxFit.contain,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Cart()),
                  );
                },
              ),
            ),
            IconButton(
              splashColor: Colors.white,
              icon: SvgPicture.asset(
                'assets/images/icon_chat_bubble.svg',
                color: Colors.white,
                fit: BoxFit.contain,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: SafeArea(
          child: Stack(
        children: [
          isLoading
              ? circularProgress()
              : products.length > 0
                  ? GridView.count(
                      scrollDirection: Axis.vertical,
                      crossAxisCount: 2,
                      children: products
                          .map(
                            (item) => ProductSingle(
                              id: item.id,
                              imageUrl: item.imageList.length > 0
                                  ? item.imageList[0]['file_url']
                                  : 'https://rimatour.com/wp-content/uploads/2017/09/No-image-found.jpg',
                              name: item.title,
                              price: item.maxPrice,
                              // rating: '4',
                              // isInDiscount: true,
                              // discount: '10',
                              decription: item.description,
                            ),
                          )
                          .toList(),
                    )
                  : Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Sorry matching products could not be found."),
                          ]),
                    ),
          if (products.length > 0)
            Positioned(
              bottom: 50,
              right: 25,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FilterScreen(),
                    ),
                  );
                },
                child: Icon(Icons.filter_list),
              ),
            )
        ],
      )),
    );
  }

  circularProgress() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(SecondaryColor),
      ),
    );
  }
}
