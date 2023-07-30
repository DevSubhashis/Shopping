import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:ppl/components/ProductCard.dart';
import 'package:ppl/components/FeatureCard.dart';
import 'package:ppl/components/TextHeader.dart';
import 'package:ppl/models/brand_model.dart';
import 'package:ppl/models/category_model.dart';
import 'package:ppl/models/product_model.dart';
import 'package:ppl/screens/home/ProductList.dart';
import 'package:ppl/localization/app_translations.dart';
import 'package:ppl/services/services.dart';
import 'package:ppl/utils/constants.dart';
import 'package:kumi_popup_window/kumi_popup_window.dart';
import 'package:ppl/components/Ribbon.dart';
import 'dart:async';

final List<String> dealsList = [
  'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/big-sale-discount-poster-flyer-promotion-template-design-d88d8b8bb3715341fd6da3839b155c5e_screen.jpg?ts=1561450218',
  'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/12.12-sale-discount-poster-flyer-design-template-6df8c44a9a928c5d6927511e7e6eb3a4_screen.jpg?ts=1574504776',
  'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/12.12-sale-digital-display-promotion-video-design-template-d7fe47f9be68057507702577db263377_screen.jpg?ts=1574303682',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQkg2ID-dkMJRm4LymzhBK7_cxVOPBOyLDOVA&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS4ItxWr9A8FUMDbbnWTZXx3JOsV29rumGOxw&usqp=CAU'
];

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  List<CategoryModel> categoryCovers = [];
  List<CategoryModel> categories = [];
  List<BrandModel> brands = [];
  List<ProductModel> products = [];

  @override
  void initState() {
    super.initState();
    fetchHomeData();
  }

  showFlashDialog() {
    showPopupWindow(
      context,
      gravity: KumiPopupGravity.center,
      //curve: Curves.elasticOut,
      bgColor: Colors.black.withOpacity(0.8),
      clickOutDismiss: true,
      clickBackDismiss: true,
      customAnimation: false,
      customPop: false,
      customPage: false,
      //targetRenderBox: (btnKey.currentContext.findRenderObject() as RenderBox),
      //needSafeDisplay: true,
      underStatusBar: false,
      underAppBar: true,
      offsetX: 0,
      offsetY: 0,
      duration: Duration(milliseconds: 200),
      onShowStart: (pop) {
        print("showStart");
      },
      onShowFinish: (pop) {
        print("showFinish");
      },
      onDismissStart: (pop) {
        print("dismissStart");
      },
      onDismissFinish: (pop) {
        print("dismissFinish");
      },
      onClickOut: (pop) {
        //print("onClickOut");
        pop.dismiss(context);
      },
      onClickBack: (pop) {
        //print("onClickBack");
        pop.dismiss(context);
      },

      childFun: (pop) {
        return Container(
          key: GlobalKey(),
          padding: EdgeInsets.all(10),
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Image.network(
                "https://rukminim1.flixcart.com/flap/480/480/image/084789479074d2b2.jpg?q=50",
                fit: BoxFit.cover,
              ),
              Positioned(
                right: -10.0,
                top: -20.0,
                child: InkResponse(
                  onTap: () {
                    pop.dismiss(context);
                  },
                  child: CircleAvatar(
                    child: Icon(Icons.close),
                    backgroundColor: Colors.blue,
                  ),
                ),
              ),
              Positioned(
                bottom: -25,
                right: 0,
                child: InkResponse(
                  onTap: () {
                    // Navigator.of(context).pop();
                    pop.dismiss(context);
                  },
                  child: ClipPath(
                    clipper: Ribbon(),
                    child: Container(
                      width: 200.0,
                      height: 50.0,
                      padding: EdgeInsets.all(8.0),
                      color: Colors.lightBlue,
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                              text: AppTranslations.of(context).text('shop'),
                              style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 22,
                                fontFamily: 'CalibriBold',
                                fontWeight: FontWeight.bold,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: " " +
                                      AppTranslations.of(context).text('now'),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  fetchHomeData() {
    WebService api = WebService();
    final response = api.callGetWithoutToken(GET_HOME_DATA_URL);
    response.then((value) {
      // print(value.body);
      setState(() {
        isLoading = false;
      });
      Map decodedData = json.decode(value.body);
      final int statusCode = decodedData['serverResponse']['code'];
      final Map resultObj = decodedData['result'];
      if (statusCode == 200) {
        List catCoverList = resultObj['category_covers'];
        List catList = resultObj['categories'];
        List brandList = resultObj['brands'];
        List productList = resultObj['products'];
        List<CategoryModel> catCoverObjs = catCoverList
            .map((catCoverJson) => CategoryModel.fromJson(catCoverJson))
            .toList();
        List<CategoryModel> catObjs = catList
            .map((catCoverJson) => CategoryModel.fromJson(catCoverJson))
            .toList();
        List<BrandModel> brandObjs = brandList
            .map((brandJson) => BrandModel.fromJson(brandJson))
            .toList();
        List<ProductModel> productObjs = productList
            .map((productJson) => ProductModel.fromJson(productJson))
            .toList();
        setState(() {
          categoryCovers = catCoverObjs;
          categories = catObjs;
          brands = brandObjs;
          products = productObjs;
          isLoading = false;
        });
        new Timer(const Duration(seconds: 4), showFlashDialog);
      } else if (statusCode == 400) {
      } else {}
    }).catchError((onError) {
      print(onError);
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget sliderSection = Container(
      height: 200.0,
      width: double.infinity,
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
        images: categoryCovers.map((item) {
          return NetworkImage(item.logo);
        }).toList(),
      ),
    );

    Widget categorySection = Container(
      height: 270.0,
      color: Colors.white,
      child: GridView.count(
          scrollDirection: Axis.horizontal,
          crossAxisCount: 2,
          children: categories
              .map(
                (item) => Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductList(
                                categoryId: item.id,
                                sub_category_id: null,
                                brand_id: null,
                                color_id: null,
                                size_id: null,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              width: 80.0,
                              height: 80.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40.0),
                                color: Colors.grey.shade300,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(62, 168, 174, 201),
                                    offset: Offset(0, 9),
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                              child: Container(
                                width: 60.0,
                                height: 60.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(item.logo),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 7.0,
                            ),
                            Text(
                              '${item.title}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "CalibriRegular",
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
              .toList()),
    );

    Widget brandsSection() {
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
          children: brands.map((item) {
            return Container(
              padding: EdgeInsets.all(15.0),
              width: 280.0,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.0,
                  color: Colors.grey.shade300,
                ),
              ),
              child: Image.network(
                item.logo,
                fit: BoxFit.contain,
              ),
            );
          }).toList(),
        ),
      );
    }

    Widget dealsOfDaySection = Container(
      height: 200.0,
      color: Colors.white,
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: dealsList
              .map(
                (item) => InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductList(),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.only(right: 10),
                    width: MediaQuery.of(context).size.width * .45,
                    child: Image.network(item, fit: BoxFit.cover),
                  ),
                ),
              )
              .toList()),
    );

    Widget bannerSection = Container(
      height: 120.0,
      color: Colors.transparent,
      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Image.network(
          "https://assets.myntassets.com/w_980,c_limit,fl_progressive,dpr_2.0/assets/images/2020/4/4/e08290b0-0ed7-4aa8-be85-262f98af86641586012559610-3--1-.jpg",
          fit: BoxFit.fitHeight),
    );

    Widget featureSection = Container(
      height: 230,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return FeaturedCard(
            name: products[index].title,
            price: double.parse(products[index].maxPrice),
            picture: products[index].imageList[0]['file_url'],
            id: products[index].id,
          );
        },
      ),
    );

    Widget recentSection = Container(
        height: 100,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (i, index) {
              return ProductCard(
                brand: 'SantosBrand',
                name: 'Lux Blazer',
                price: 24.00,
                onSale: true,
                picture:
                    'https://asset1.cxnmarksandspencer.com/is/image/mands/SD_04_T74_9725E_JQ_X_EC_0',
              );
            }));

    return Scaffold(
      //body:  Column(children: <Widget>[sliderSection, categorySection, dealsOfDaySection ]));
      body: SafeArea(
        child: isLoading
            ? circularProgress()
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    if (categoryCovers.length > 0) sliderSection,
                    TextHeader(
                        textString:
                            AppTranslations.of(context).text('top_categories'),
                        type: 'top_categories'),
                    categorySection,
                    // TextHeader(
                    //     textString: AppTranslations.of(context)
                    //         .text('deals_of_the_day')),
                    // dealsOfDaySection,
                    bannerSection,
                    TextHeader(
                        textString:
                            AppTranslations.of(context).text('trending_brands'),
                        type: 'trending_brands'),
                    brandsSection(),
                    TextHeader(
                        textString: AppTranslations.of(context)
                            .text('feature_products'),
                        type: 'feature_products'),
                    featureSection,
                    // TextHeader(
                    //     textString: AppTranslations.of(context)
                    //         .text('recent_products')),
                    // recentSection
                  ],
                ),
              ),
      ),
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
