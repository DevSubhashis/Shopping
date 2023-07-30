import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:ppl/components/ReviewBlock.dart';
import 'package:ppl/components/Ribbon.dart';
import 'package:ppl/screens/home/allReview.dart';
import 'package:ppl/screens/home/cart.dart';
import 'package:ppl/utils/constants.dart';
import 'package:ppl/models/Product.dart';
import 'package:ppl/components/FeatureCard.dart';
import 'package:ppl/components/Qantity.dart';
import 'package:ppl/localization/app_translations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ppl/services/services.dart';
import 'package:ppl/models/product_model.dart';
import 'package:flutter/foundation.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:ppl/providers/user.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

final List<String> sliderimgList = [
  'https://static.peachmode.com/media/images/product/7685/base/1518786674_FTR-UMNX-KUMBFOREVER-4178.jpg',
  'https://static.peachmode.com/media/images/product/7685/base/1518786674_FTR-UMNX-KUMBFOREVER-4178.jpg',
  'https://static.peachmode.com/media/images/product/7685/base/1518786674_FTR-UMNX-KUMBFOREVER-4178.jpg',
  'https://static.peachmode.com/media/images/product/7685/base/1518786674_FTR-UMNX-KUMBFOREVER-4178.jpg',
  'https://static.peachmode.com/media/images/product/7685/base/1518786674_FTR-UMNX-KUMBFOREVER-4178.jpg',
];

final List<Product> similarProductList = [
  new Product(
      '1',
      'https://static.peachmode.com/media/images/product/7685/base/1518786674_FTR-UMNX-KUMBFOREVER-4178.jpg',
      'Apple Watch',
      '500',
      '4',
      true,
      '10',
      "Verry Good Watch"),
  new Product(
      '2',
      'https://static.peachmode.com/media/images/product/7685/base/1518786674_FTR-UMNX-KUMBFOREVER-4178.jpg',
      'Apple Watch',
      '500',
      '4',
      true,
      '10',
      "Verry Good Watch"),
  new Product(
      '1',
      'https://static.peachmode.com/media/images/product/7685/base/1518786674_FTR-UMNX-KUMBFOREVER-4178.jpg',
      'Apple Watch',
      '500',
      '4',
      true,
      '10',
      "Verry Good Watch"),
  new Product(
      '2',
      'https://static.peachmode.com/media/images/product/7685/base/1518786674_FTR-UMNX-KUMBFOREVER-4178.jpg',
      'Apple Watch',
      '500',
      '4',
      true,
      '10',
      "Verry Good Watch"),
];

ProgressDialog pr;

class ProductDetails extends StatefulWidget {
  final int productId;

  ProductDetails({Key key, this.productId}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  ProductModel product = new ProductModel(
    id: 1,
    title: 'Loading',
    description: 'Loading',
    maxPrice: '0.00',
    brand: 'Loading',
    category: 'Loading',
    subcategory: "Loading",
    imageList: [],
    productVariants: [],
    specifications: [],
    multipleColor: false,
    multipleSize: false,
  );

  Map selectedVariants;
  int productVariantId;
  Map selectedSize;
  int quantity = 1;
  List previewImages = [];
  bool _isLoading = true;
  bool isAtTop = true;

  var _scrollCrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchProductDetails();

    _scrollCrl.addListener(() {
      //if (_scrollCrl.position.atEdge) {
      if (_scrollCrl.position.pixels == 0) {
        // You're at the top.
        setState(() {
          isAtTop = true;
        });
      } else {
        setState(() {
          isAtTop = false;
        });
      }
      // }
    });
  }

  _fetchProductDetails() async {
    final WebService _webService = WebService();
    // print("IDD " + widget.productId.toString());
    var URL = GET_PRODUCT_DETAILS + widget.productId.toString();
    final response = _webService.getProductDetails(URL);
    response.then((value) {
      setState(() {
        product = value;
        _isLoading = false;
      });
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _showDialogError(String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(AppTranslations.of(context).text('error')),
          content: Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text(AppTranslations.of(context).text('close')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addData() async {
    var user = Provider.of<UserModel>(context, listen: false);

    selectedVariants['product_id'] = product.id;
    selectedVariants['product_name'] = product.title;
    selectedVariants['product_variant_color'] =
        selectedVariants['product_color_title'];
    selectedVariants['product_variant_size'] =
        selectedSize['product_size_name'];
    selectedVariants['product_image'] = selectedVariants['images'].length > 0
        ? selectedVariants['images'][0]['file_url']
        : 'https://rimatour.com/wp-content/uploads/2017/09/No-image-found.jpg';
    selectedVariants['selling_price'] = selectedSize['price'];
    selectedVariants['maximum_retail_price'] = product.maxPrice;
    selectedVariants['discount'] = 0;
    selectedVariants['variant_id'] = productVariantId;
    selectedVariants['description'] = product.description;
    selectedVariants['brand'] = product.brand;
    selectedVariants['category'] = product.category;
    selectedVariants['subcategory'] = product.subcategory;
    selectedVariants['quantity'] = quantity;

    if (user.userData.isNotEmpty) {
      this._addCartDataRemote();
    } else {
      // user have not logged in, so add cart data locally

      final SharedPreferences prefs = await _prefs;
      String cart = prefs.getString('cart');
      //print(cart);
      if (cart == null) {
        var cartItems = new List(1);
        cartItems[0] = selectedVariants;
        prefs.setString('cart', json.encode(cartItems));
      } else {
        var cartItems = json.decode(cart) as List;
        cartItems.insert(0, selectedVariants);
        prefs.setString('cart', json.encode(cartItems));
      }

      Toast.show("Added to cart", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    }
  }

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _addToCart() {
    if (productVariantId != null) {
      this._addData();
    } else {
      if (product.multipleColor) {
        // this product have varients
        this._showDialogError(
            AppTranslations.of(context).text('product_varient_error'));
      } else {
        this._addData();
      }
    }
  }

  void _addCartDataRemote() async {
    pr.show();
    final WebService _webService = WebService();
    var user = Provider.of<UserModel>(context, listen: false);

    final SharedPreferences prefs = await _prefs;
    String cart = prefs.getString('cart');
    var cartItem = new List();
    Map singleItem = new Map();
    singleItem['product_id'] = selectedVariants['product_id'];
    singleItem['variant_id'] = selectedVariants['variant_id'];
    singleItem['quantity'] = selectedVariants['quantity'];
    if (cart == null) {
//      cartItem = new List();
      cartItem.add(singleItem);
    } else {
      // there is  Items in cart
      cartItem = json.decode(cart) as List;
      cartItem.insert(0, singleItem);
    }

    Map body = {"cart_items": cartItem};
    final response = _webService.addToCart(
        ADD_TO_CART, body, user.userData['auth']['_token']);
    response.then((value) async {
      // save all the cart items comming from server
      // save them in local storage
      final SharedPreferences prefs = await _prefs;
      prefs.setString('cart', json.encode(value));
      if (pr.isShowing()) {
        pr.hide();
      }
      Toast.show("Added to cart", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    }).catchError((onError) {
      if (pr.isShowing()) {
        pr.hide();
      }
    });
  }

  static var subHeaderCustomStyle = TextStyle(
    color: Colors.black54,
    fontWeight: FontWeight.w700,
    fontFamily: "CalibriBold",
    fontSize: 16.0,
  );

  static var descriptionText = TextStyle(
    fontFamily: "CalibriRegular",
    color: Colors.black45,
    letterSpacing: 0.3,
    wordSpacing: 0.5,
  );

  _showBottomSheet(String from) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter msetState) {
          return Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                        color: Color(0xFF656565).withOpacity(0.15),
                        blurRadius: 1.0,
                        spreadRadius: 0.2,
                      )
                    ]),
                    child: Wrap(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        for (var singlePreviewImage in previewImages)
                          Padding(
                            padding: EdgeInsets.all(10.00),
                            child: Image.network(
                              singlePreviewImage['file_url'],
                              width: 80,
                              height: 80,
                            ),
                          ),
                      ],
                    ),
                  ),
                  selectedSize != null
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(8.0),
                          decoration:
                              BoxDecoration(color: Colors.white, boxShadow: [
                            BoxShadow(
                              color: Color(0xFF656565).withOpacity(0.15),
                              blurRadius: 1.0,
                              spreadRadius: 0.2,
                            )
                          ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ' ' +
                                    AppTranslations.of(context).text('price') +
                                    ' : ' +
                                    selectedSize['price'].toString(),
                                style: subHeaderCustomStyle,
                              ),
                              Text(
                                ' ' +
                                    AppTranslations.of(context).text('stock') +
                                    ' : ' +
                                    selectedSize['stock'].toString(),
                                style: subHeaderCustomStyle,
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                        color: Color(0xFF656565).withOpacity(0.15),
                        blurRadius: 1.0,
                        spreadRadius: 0.2,
                      )
                    ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            AppTranslations.of(context).text('select_color') +
                                ' : ',
                            style: subHeaderCustomStyle,
                          ),
                        ),
                        Wrap(
                          children: <Widget>[
                            for (var singleVariant in product.productVariants)
                              InkWell(
                                  onTap: () {
                                    if (product.multipleSize) {
                                      msetState(() {
                                        selectedVariants = singleVariant;
                                        previewImages = singleVariant['images'];
                                      });
                                    } else {
                                      msetState(() {
                                        selectedVariants = singleVariant;
                                        previewImages = singleVariant['images'];
                                      });
                                      productVariantId =
                                          selectedVariants['product_sizes'][0]
                                              ['product_details_id'];
                                      selectedSize =
                                          selectedVariants['product_sizes'][0];
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(5.0),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.purple,
                                        width: selectedVariants != null &&
                                                singleVariant[
                                                        'product_color_code'] ==
                                                    selectedVariants[
                                                        'product_color_code']
                                            ? 3
                                            : 1,
                                      ),
                                    ),
                                    child: Text(
                                        singleVariant['product_color_title']),
                                  )

                                  // child: CircleAvatar(
                                  //   radius: 24.0,
                                  //   backgroundColor: selectedVariants !=
                                  //               null &&
                                  //           selectedVariants[
                                  //                   'product_color_code'] ==
                                  //               singleVariant[
                                  //                   'product_color_code']
                                  //       ? Color(0xffFDCF09)
                                  //       : Color(0xfff),
                                  //   child: CircleAvatar(
                                  //     radius: 20.0,
                                  //     backgroundColor: HexColor('#d5d5d5'),
                                  //     child: CircleAvatar(
                                  //       backgroundColor: HexColor(
                                  //         singleVariant[
                                  //                     'product_color_code'] !=
                                  //                 null
                                  //             ? singleVariant[
                                  //                 'product_color_code']
                                  //             : '#000000',
                                  //       ),
                                  //       radius: 15.0,
                                  //     ),
                                  //   ),
                                  // ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.only(top: 9.0),
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                        color: Color(0xFF656565).withOpacity(0.15),
                        blurRadius: 1.0,
                        spreadRadius: 0.2,
                      )
                    ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        selectedVariants != null && product.multipleSize == true
                            ? Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppTranslations.of(context)
                                              .text('select_size') +
                                          ' : ',
                                      style: subHeaderCustomStyle,
                                    ),
                                    InkWell(
                                      child: Text(
                                        AppTranslations.of(context)
                                                .text('size_chart') +
                                            ' > ',
                                        style: subHeaderCustomStyle,
                                      ),
                                      onTap: () {
                                        const url =
                                            'https://www.downeastbasics.com/pages/size-chart';
                                        launchURL(url);
                                      },
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        selectedVariants != null && product.multipleSize == true
                            ? Wrap(
                                children: <Widget>[
                                  for (var sizes
                                      in selectedVariants['product_sizes'])
                                    InkWell(
                                      onTap: () {
                                        productVariantId =
                                            sizes['product_details_id'];
                                        selectedSize = sizes;

                                        msetState(() {
                                          quantity =
                                              quantity; // this part, just re render the view, nothig else, here quantity not setting
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Container(
                                          // width: 300,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.8),
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                              sizes['product_size_name'],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: productVariantId ==
                                                        sizes[
                                                            'product_details_id']
                                                    ? Colors.white
                                                    : Colors.blueAccent,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  new Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(top: 9.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF656565).withOpacity(0.15),
                          blurRadius: 1.0,
                          spreadRadius: 0.2,
                        )
                      ],
                    ),
                    child: Qantity(
                        numberOfItems: quantity,
                        refreshQuantity: (newValue) {
                          msetState(() {
                            quantity = newValue;
                          });
                        }),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(top: 9.0),
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF656565).withOpacity(0.15),
                          blurRadius: 1.0,
                          spreadRadius: 0.2,
                        )
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        from == 'add_to_cart' || from == 'bottom'
                            ? SizedBox(
                                width: from == 'bottom'
                                    ? 150
                                    : MediaQuery.of(context).size.width,
                                height: 50,
                                child: RaisedButton(
                                  color: Colors.orange,
                                  elevation: 5.0,
                                  textColor: Colors.white,
                                  padding: const EdgeInsets.all(15.0),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    this._addToCart();
                                  },
                                  child: new Text(
                                    AppTranslations.of(context)
                                        .text('add_to_cart'),
                                    style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        from == 'buy_now' || from == 'bottom'
                            ? SizedBox(
                                width: from == 'bottom'
                                    ? 150
                                    : MediaQuery.of(context).size.width,
                                height: 50,
                                child: RaisedButton(
                                  color: Color(0xff1EBEA5),
                                  elevation: 5.0,
                                  textColor: Colors.white,
                                  padding: const EdgeInsets.all(15.0),
                                  onPressed: () => print("Button Pressed"),
                                  child: new Text(
                                    AppTranslations.of(context).text('buy_now'),
                                    style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
      }, // builder
    );
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(
      message: 'Please wait...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

    Widget sliderSection = !_isLoading
        ? new Container(
            height: 450.0,
            child: new Carousel(
                boxFit: BoxFit.cover,
                dotColor: Color(0xFF6991C7).withOpacity(0.8),
                dotSize: 5.5,
                dotSpacing: 16.0,
                dotBgColor: Colors.transparent,
                showIndicator: true,
                overlayShadow: true,
                overlayShadowColors: Colors.black.withOpacity(0.9),
                overlayShadowSize: 2.9,
                images: product.imageList
                    .map((item) => NetworkImage(item['file_url']))
                    .toList()),
          )
        : Container(height: 450.0);

    Widget productNameSection = new Positioned(
      bottom: 20,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: Text(
            //     'Product Blazer',
            //     style: TextStyle(
            //         color: Colors.white,
            //         fontWeight: FontWeight.w300,
            //         fontFamily: 'CalibriBold',
            //         fontSize: 20),
            //   ),
            // ),
            Container(
              margin: EdgeInsets.only(bottom: 20.0),
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
                          text: AppTranslations.of(context).text('free'),
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 22,
                            fontFamily: 'CalibriBold',
                            fontWeight: FontWeight.bold,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  AppTranslations.of(context).text('shipping'),
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
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Text(
                    '\৳${product.maxPrice.toString()} \n',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontFamily: 'CalibriBold',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(right: 10.0),
                //   child: Text(
                //     '\$55.99',
                //     textAlign: TextAlign.end,
                //     style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 16,
                //       fontFamily: 'CalibriBold',
                //       decoration: TextDecoration.lineThrough,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );

    Widget reviews = new ReviewBlock(
      date: "18 Nov 2018",
      details:
          "Dettol Refill is leaked and has got all out products sticky and dirty specially the tooth paste, 5 KG AASHIrwad AATA and other products.",
      changeRating: (rating) {},
      image:
          "https://static.peachmode.com/media/images/product/7685/base/1518786674_FTR-UMNX-KUMBFOREVER-4178.jpg",
    );

    Widget reviewSection = Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Color(0xFF656565).withOpacity(0.15),
            blurRadius: 1.0,
            spreadRadius: 0.2,
          )
        ]),
        child: Padding(
          padding: EdgeInsets.only(top: 20.0, left: 20.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  AppTranslations.of(context).text('reviews'),
                  style: subHeaderCustomStyle,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, top: 15.0, bottom: 15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        child: Padding(
                            padding: EdgeInsets.only(top: 2.0, right: 3.0),
                            child: Text(
                              AppTranslations.of(context).text('view_all'),
                              style: subHeaderCustomStyle.copyWith(
                                  color: Colors.indigoAccent, fontSize: 14.0),
                            )),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AllReview(),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0, top: 2.0),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 18.0,
                          color: Colors.black54,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      StarRating(
                        size: 25.0,
                        starCount: 5,
                        rating: 4.0,
                        color: Colors.yellow,
                      ),
                      SizedBox(width: 5.0),
                      Text('8 ' + AppTranslations.of(context).text('reviews'))
                    ]),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 0.0, right: 20.0, top: 15.0, bottom: 7.0),
              child: line(),
            ),
            reviews,
            Padding(
              padding: EdgeInsets.only(
                  left: 0.0, right: 20.0, top: 15.0, bottom: 7.0),
              child: line(),
            ),
            reviews,
            Padding(
              padding: EdgeInsets.only(
                  left: 0.0, right: 20.0, top: 15.0, bottom: 7.0),
              child: line(),
            ),
            reviews
          ]),
        ),
      ),
    );

    // Widget previewScetion = new
    // Container(
    //   width: MediaQuery.of(context).size.width,
    //   padding: const EdgeInsets.all(8.0),
    //   decoration: BoxDecoration(color: Colors.white, boxShadow: [
    //     BoxShadow(
    //       color: Color(0xFF656565).withOpacity(0.15),
    //       blurRadius: 1.0,
    //       spreadRadius: 0.2,
    //     )
    //   ]),
    //   child: Row(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: <Widget>[
    //       for (var singlePreviewImage in previewImages)
    //         Padding(
    //           padding: EdgeInsets.all(10.00),
    //           child: Image.network(
    //             singlePreviewImage['file_url'],
    //             width: 80,
    //             height: 80,
    //           ),
    //         ),
    //     ],
    //   ),
    // );

    // Widget colorSection = new Container(
    //   width: MediaQuery.of(context).size.width,
    //   padding: const EdgeInsets.all(8.0),
    //   decoration: BoxDecoration(color: Colors.white, boxShadow: [
    //     BoxShadow(
    //       color: Color(0xFF656565).withOpacity(0.15),
    //       blurRadius: 1.0,
    //       spreadRadius: 0.2,
    //     )
    //   ]),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: <Widget>[
    //       Padding(
    //         padding: const EdgeInsets.all(4.0),
    //         child: Text(
    //           AppTranslations.of(context).text('select_color') + ' : ',
    //           style: subHeaderCustomStyle,
    //         ),
    //       ),
    //       Row(
    //         children: <Widget>[
    //           for (var singleVariant in product.productVariants)
    //             InkWell(
    //               onTap: () {
    //                 setState(() {
    //                   selectedVariants = singleVariant;
    //                   previewImages = singleVariant['images'];
    //                 });

    //                 // if (singleVariant['product_sizes'][0]['product_size_id'] ==
    //                 //     null) {
    //                 //   setState(() {
    //                 //     previewImages = singleVariant['product_sizes'][0]
    //                 //         ['product_detail_images'];
    //                 //   });
    //                 // }
    //               },
    //               child: Padding(
    //                 padding: const EdgeInsets.all(2),
    //                 child: CircleAvatar(
    //                     backgroundColor:
    //                         HexColor(singleVariant['product_color_code']),
    //                     radius: 15.0),
    //               ),
    //             ),
    //         ],
    //       ),
    //     ],
    //   ),
    // );

    // Widget sizeSection = new
    // Container(
    //   width: MediaQuery.of(context).size.width,
    //   padding: const EdgeInsets.all(8.0),
    //   margin: const EdgeInsets.only(top: 9.0),
    //   decoration: BoxDecoration(color: Colors.white, boxShadow: [
    //     BoxShadow(
    //       color: Color(0xFF656565).withOpacity(0.15),
    //       blurRadius: 1.0,
    //       spreadRadius: 0.2,
    //     )
    //   ]),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: <Widget>[
    //       Padding(
    //         padding: const EdgeInsets.all(4.0),
    //         child: Text(
    //           AppTranslations.of(context).text('select_size') + ' : ',
    //           style: subHeaderCustomStyle,
    //         ),
    //       ),
    //       selectedVariants != null
    //           ? Row(
    //               children: <Widget>[
    //                 for (var sizes in selectedVariants['product_sizes'])
    //                   InkWell(
    //                     child: Padding(
    //                       padding: const EdgeInsets.all(8.0),
    //                       child: Container(
    //                         width: 30,
    //                         height: 30,
    //                         decoration: BoxDecoration(
    //                             color: Colors.black.withOpacity(0.8),
    //                             borderRadius: BorderRadius.circular(7)),
    //                         child: Padding(
    //                           padding: const EdgeInsets.all(2),
    //                           child: Text(
    //                             sizes['product_size_name'],
    //                             textAlign: TextAlign.center,
    //                             style: TextStyle(
    //                                 color: Colors.white, fontSize: 20),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //               ],
    //             )
    //           : Text("SASASA"),
    //     ],
    //   ),
    // );

    Widget detaailsSection = new Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(top: 9.0),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Color(0xFF656565).withOpacity(0.15),
          blurRadius: 1.0,
          spreadRadius: 0.2,
        )
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              AppTranslations.of(context).text('product_details') + ' : ',
              style: subHeaderCustomStyle,
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(left: 0.0, right: 20.0, top: 15.0, bottom: 7.0),
            child: line(),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              AppTranslations.of(context).text('description') + ' : ',
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              product.description,
              style: descriptionText,
            ),
          ),
          // Row(
          //   children: <Widget>[
          //     Padding(
          //       padding: const EdgeInsets.all(4.0),
          //       child: Text(
          //         AppTranslations.of(context).text('category') + ' : ',
          //         style: TextStyle(
          //           fontFamily: "Montserrat",
          //           fontSize: 15.0,
          //           fontWeight: FontWeight.w500,
          //           color: Colors.black,
          //         ),
          //       ),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.all(4.0),
          //       child: Text(
          //         product.subcategory,
          //         style: descriptionText,
          //       ),
          //     ),
          //   ],
          // ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  AppTranslations.of(context).text('brand') + ' : ',
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  product.brand,
                  style: descriptionText,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  AppTranslations.of(context).text('color') + ' : ',
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  product.productVariants.length.toString() +
                      ' ' +
                      AppTranslations.of(context).text('colors'),
                  style: descriptionText,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    Widget specificationSection = new Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(top: 9.0),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Color(0xFF656565).withOpacity(0.15),
          blurRadius: 1.0,
          spreadRadius: 0.2,
        )
      ]),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                AppTranslations.of(context).text('specifications') + ' : ',
                style: subHeaderCustomStyle,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 0.0, right: 20.0, top: 15.0, bottom: 7.0),
              child: line(),
            ),
            Column(
              children: <Widget>[
                for (var specification in product.specifications)
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          specification['key'] + " : ",
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Expanded(
                        //padding: const EdgeInsets.all(4.0),
                        child: Text(
                          specification['value'],
                          style: descriptionText,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );

    Widget variationSection = new Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 9.0),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Color(0xFF656565).withOpacity(0.15),
          blurRadius: 1.0,
          spreadRadius: 0.2,
        )
      ]),
      child: InkWell(
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    AppTranslations.of(context).text('select_variation') +
                        ' : ( ' +
                        product.productVariants.length.toString() +
                        ' ' +
                        AppTranslations.of(context).text('colors') +
                        ', ' +
                        product.productVariants[0]['product_sizes'].length
                            .toString() +
                        ' ' +
                        AppTranslations.of(context).text('size') +
                        ' )',
                    style: subHeaderCustomStyle,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 18.0,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            product.multipleColor
                ? Wrap(
                    children: <Widget>[
                      for (var singleVariant in product.productVariants)
                        for (int i = 0; i < singleVariant['images'].length; i++)
                          if (i == 0)
                            Padding(
                              padding: EdgeInsets.all(10.00),
                              child: Image.network(
                                singleVariant['images'][i]['file_url'],
                                width: 80,
                                height: 80,
                              ),
                            ),
                    ],
                  )
                : Container(),
          ],
        ),
        onTap: () {
          _showBottomSheet('bottom');
        },
      ),
    );

    Widget shiipingSection = new Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 9.0),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Color(0xFF656565).withOpacity(0.15),
          blurRadius: 1.0,
          spreadRadius: 0.2,
        )
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 15.0, top: 15.0),
            child: Text(
              AppTranslations.of(context).text('shipping1'),
              style: subHeaderCustomStyle,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 15.0, right: 20.0, top: 15.0, bottom: 7.0),
            child: line(),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0, bottom: 15.0, top: 15.0),
            child: Text(
              AppTranslations.of(context).text('free_shipping_text') + " \৳35",
              style: descriptionText,
            ),
          ),
        ],
      ),
    );

    Widget companySection = new Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 9.0),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Color(0xFF656565).withOpacity(0.15),
          blurRadius: 1.0,
          spreadRadius: 0.2,
        )
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 15.0, top: 15.0),
            child: Text(
              AppTranslations.of(context).text('shop'),
              style: subHeaderCustomStyle,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 15.0, right: 20.0, top: 15.0, bottom: 7.0),
            child: line(),
          ),
          Padding(
              padding: EdgeInsets.only(left: 15.0, bottom: 15.0, top: 15.0),
              child: Row(
                children: <Widget>[
                  Image.network(
                    "https://static.businessworld.in/article/article_extra_large_image/1583909849_QBjhqB_the_raymond_shop_vector_logo.png",
                    fit: BoxFit.contain,
                    width: 100,
                    height: 50,
                  ),
                  Text(
                    'The Raymond Shop',
                    style: subHeaderCustomStyle,
                  ),
                ],
              )),
        ],
      ),
    );

    Widget bottomScetion = Container(
      height: 52.0,
      child: Row(
        children: <Widget>[
          FlatButton(
            onPressed: () => {},
            color: Colors.lightBlue[400],
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // Replace with a Row for horizontal icon + text
              children: <Widget>[
                new SvgPicture.asset('assets/images/icon_chat_bubble.svg',
                    height: 20.0,
                    width: 20.0,
                    allowDrawingOutsideViewBox: true,
                    color: Colors.white),
                Text(
                  AppTranslations.of(context).text('chat_now'),
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 10.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          FlatButton(
            onPressed: () => {
              //this._addToCart(),
              _showBottomSheet('add_to_cart')
            },
            //color: Color(0xffEE4D2D),
            color: Colors.orange,
            //padding: EdgeInsets.all(2.0),
            //child: InkWell(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // Replace with a Row for horizontal icon + text
              children: <Widget>[
                Icon(
                  Icons.add_shopping_cart,
                  color: Colors.white,
                  size: 20.0,
                ),
                Text(
                  AppTranslations.of(context).text('add_to_cart'),
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 10.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            //),
          ),
          Expanded(
            child: FlatButton(
              onPressed: () => {
                _showBottomSheet('buy_now'),
              },
              color: Color(0xff1EBEA5),
              padding: EdgeInsets.all(19.5),
              child: Center(
                child: Text(
                  AppTranslations.of(context).text('buy_now'),
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );

    Widget productTop = Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(top: 9.0),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Color(0xFF656565).withOpacity(0.15),
          blurRadius: 1.0,
          spreadRadius: 0.2,
        )
      ]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                product.title,
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Center(
                  child: Image.asset(
                    'assets/images/badges.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                top: 26,
                left: 36,
                child: Text(
                  '10%\n' + AppTranslations.of(context).text('off'),
                  style: TextStyle(
                    fontFamily: "CalibriBold",
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );

    Widget similarProducts = Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 9.0),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Color(0xFF656565).withOpacity(0.15),
          blurRadius: 1.0,
          spreadRadius: 0.2,
        )
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 15.0, top: 15.0),
            child: Text(
              AppTranslations.of(context).text('similar_products'),
              style: subHeaderCustomStyle,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 15.0, right: 20.0, top: 15.0, bottom: 7.0),
            child: line(),
          ),
          Container(
            height: 230,
            margin: EdgeInsets.only(top: 10.0),
            padding: EdgeInsets.all(10.0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (i, index) {
                return FeaturedCard(
                  name: 'Winter Blazer',
                  price: 50.99,
                  picture:
                      'https://static.peachmode.com/media/images/product/7685/base/1518786674_FTR-UMNX-KUMBFOREVER-4178.jpg',
                );
              },
            ),
          )
        ],
      ),
    );

// Create a variable

    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      body: _isLoading
          ? circularProgress()
          : Stack(
              children: <Widget>[
                SingleChildScrollView(
                  controller: _scrollCrl,
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          sliderSection,
                          productNameSection,
                        ],
                      ),
                      productTop,
                      detaailsSection,
                      specificationSection,
                      product.multipleColor ? variationSection : Container(),
                      shiipingSection,
                      companySection,
                      reviewSection,
                      SizedBox(
                        height: 5,
                      ),
                      similarProducts,
                      SizedBox(
                        height: 100,
                      )
                    ],
                  ),
                ),
                Container(
                  color: isAtTop
                      ? Colors.transparent
                      : Colors.white.withOpacity(0.8),
                  height: 110,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 55,
                      ),
                      Row(
                        children: [
                          Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                child: Icon(
                                  Icons.arrow_back,
                                  size: 24.0,
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: isAtTop
                                ? Text("")
                                : SizedBox(
                                    width: 120.0,
                                    child: Text(
                                      '${product.title}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 26,
                                        fontFamily: 'CalibriBold',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                          ),
                          Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.favorite_border),
                            ),
                          ),
                          Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                child: Icon(Icons.shopping_cart),
                                onTap: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Cart()),
                                  )
                                },
                              ),
                            ),
                          ),
                          Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.share),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

      bottomSheet: _isLoading ? circularProgress() : bottomScetion,
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

Widget line() {
  return Container(
    height: 0.9,
    width: double.infinity,
    color: Colors.black12,
  );
}
