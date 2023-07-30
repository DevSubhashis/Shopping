import 'dart:convert';
import 'dart:developer';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:ppl/components/ProductSingle.dart';
import 'package:ppl/components/TextHeader.dart';
import 'package:ppl/models/Product.dart';
import 'package:ppl/models/category_model.dart';
import 'package:ppl/utils/constants.dart';
import 'package:ppl/localization/app_translations.dart';
import 'package:ppl/models/product_model.dart';
import 'package:ppl/services/services.dart';

class Category {
  String name;
  String icon;

  Category(String name, String icon) {
    this.name = name;
    this.icon = icon;
  }
}

final List<Category> categoryist = [
  Category('Book', 'assets/images/nike.jpg'),
  Category('Camera', 'assets/images/samsung.png'),
  Category('Fashion', 'assets/images/xiaomi.png'),
  Category('Book', 'assets/images/nike.jpg'),
  Category('Camera', 'assets/images/samsung.png'),
  Category('Fashion', 'assets/images/xiaomi.png'),
  Category('Book', 'assets/images/nike.jpg'),
  Category('Camera', 'assets/images/samsung.png'),
  Category('Fashion', 'assets/images/xiaomi.png'),
  Category('Book', 'assets/images/nike.jpg'),
  Category('Camera', 'assets/images/samsung.png'),
  Category('Fashion', 'assets/images/xiaomi.png'),
  Category('Book', 'assets/images/nike.jpg'),
  Category('Camera', 'assets/images/samsung.png'),
  Category('Fashion', 'assets/images/xiaomi.png'),
  Category('Book', 'assets/images/nike.jpg'),
  Category('Camera', 'assets/images/samsung.png'),
  Category('Fashion', 'assets/images/xiaomi.png'),
  Category('Book', 'assets/images/nike.jpg'),
  Category('Camera', 'assets/images/samsung.png'),
  Category('Fashion', 'assets/images/xiaomi.png'),
];

class PPLMallScreen extends StatefulWidget {
  @override
  _PPLMallScreenState createState() => _PPLMallScreenState();
}

class _PPLMallScreenState extends State<PPLMallScreen> {
  List<ProductModel> products = List<ProductModel>();
  bool _isLoading = true;
  List<CategoryModel> categoryCovers = [];

  @override
  void initState() {
    super.initState();
    WebService api = WebService();
    final response = api.callGetWithoutToken(GET_HOME_DATA_URL);
    response.then((value) {
      // print(value.body);
      setState(() {
        _isLoading = false;
      });
      Map decodedData = json.decode(value.body);
      final int statusCode = decodedData['serverResponse']['code'];
      final Map resultObj = decodedData['result'];
      if (statusCode == 200) {
        List catCoverList = resultObj['category_covers'];
        // log(catCoverList.toString());
        List<CategoryModel> catCoverObjs = catCoverList
            .map((catCoverJson) => CategoryModel.fromJson(catCoverJson))
            .toList();
        setState(() {
          categoryCovers = catCoverObjs;
          _isLoading = false;
        });
      } else if (statusCode == 400) {
      } else {}
    }).catchError((onError) {
      print(onError);
      setState(() {
        _isLoading = false;
      });
    });
    _fetchAllProducts();
  }

  _fetchAllProducts() async {
    final WebService _webService = WebService();
    final response = _webService.getAllProducts(GET_ALL_PRODUCTS);
    response.then((value) {
      print(value);
      setState(() {
        _isLoading = false;
        products = value;
      });
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            DefaultTabController(
              length: 6,
              initialIndex: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: colors,
                  ),
                ),
                child: TabBar(
                    isScrollable: true,
                    unselectedLabelColor: Colors.black,
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                    tabs: [
                      Tab(
                        child: Text(
                          AppTranslations.of(context).text('popular'),
                          style: TextStyle(fontFamily: 'CalibriRegular'),
                        ),
                      ),
                      Tab(
                        child: Text(
                          AppTranslations.of(context).text('automotive'),
                          style: TextStyle(fontFamily: 'CalibriRegular'),
                        ),
                      ),
                      Tab(
                        child: Text(
                          AppTranslations.of(context)
                              .text('beauty_personal_care'),
                          style: TextStyle(fontFamily: 'CalibriRegular'),
                        ),
                      ),
                      Tab(
                        child: Text(
                          AppTranslations.of(context).text('cameras_&_drones'),
                          style: TextStyle(fontFamily: 'CalibriRegular'),
                        ),
                      ),
                      Tab(
                        child: Text(
                          AppTranslations.of(context)
                              .text('computer_&_preipherals'),
                          style: TextStyle(fontFamily: 'CalibriRegular'),
                        ),
                      ),
                      Tab(
                        child: Text(
                          AppTranslations.of(context).text('hobbies_&_books'),
                          style: TextStyle(fontFamily: 'CalibriRegular'),
                        ),
                      )
                    ]),
              ),
            ),
            if (categoryCovers.length > 0)
              Container(
                height: 200.0,
                child: Carousel(
                  boxFit: BoxFit.cover,
                  dotColor: Color(0xFF6991C7).withOpacity(0.8),
                  dotSize: 5.5,
                  dotSpacing: 16.0,
                  dotBgColor: Colors.transparent,
                  showIndicator: true,
                  overlayShadow: true,
                  overlayShadowColors: Colors.white.withOpacity(0.9),
                  overlayShadowSize: 2.9,
                  images: categoryCovers
                      .map((item) => NetworkImage(item.logo))
                      .toList(),
                ),
              ),
            SizedBox(
              height: 10.0,
            ),
            TextHeader(
                textString: AppTranslations.of(context).text('trending_shop')),
            categorySection(),
            bannerSection,
            SizedBox(
              height: 8.0,
            ),
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10.0),
              child: Text(
                AppTranslations.of(context).text('just_for_you'),
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.blue, fontFamily: 'CalibriBold'),
              ),
            ),
            if (products.length > 0) productSection(),
          ],
        ),
      ),
    );
  }

  Widget categorySection() {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return Container(
      height: 180.0,
      color: Colors.white,
      child: GridView.count(
        scrollDirection: Axis.horizontal,
        crossAxisCount: 2,
        padding: EdgeInsets.all(10.0),
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: (itemWidth / itemHeight),
        children: categoryist.map((item) {
          return Container(
            padding: EdgeInsets.all(15.0),
            width: 280.0,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.0,
                color: Colors.grey.shade300,
              ),
            ),
            child: Image.asset(
              item.icon,
              fit: BoxFit.contain,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget bannerSection = Container(
    height: 120.0,
    color: Colors.transparent,
    margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
    child: Image.network(
        "https://assets.myntassets.com/w_980,c_limit,fl_progressive,dpr_2.0/assets/images/2020/4/4/e08290b0-0ed7-4aa8-be85-262f98af86641586012559610-3--1-.jpg",
        fit: BoxFit.fitHeight),
  );

  Widget productSection() {
    return GridView.count(
      scrollDirection: Axis.vertical,
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      children: products.map((item) {
        return ProductSingle(
          id: item.id ?? 0,
          imageUrl: item.imageList.length > 0
              ? item.imageList[0]['file_url'] ?? ''
              : '',
          name: item.title ?? '',
          price: item.maxPrice.toString() ?? '',
          // rating: '4',
          // isInDiscount: true,
          // discount: '10',
          decription: item.description ?? '',
        );
        // log("---------------");
        // log(item.toString());
        // log("---------------");
      }).toList(),
    );
  }
}
