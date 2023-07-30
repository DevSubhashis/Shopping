import 'package:flutter/material.dart';
import 'package:ppl/components/ProductSingle.dart';
import 'package:ppl/models/Product.dart';
import 'package:ppl/utils/constants.dart';
import 'package:ppl/localization/app_translations.dart';
import 'package:ppl/models/product_model.dart';
import 'package:ppl/services/services.dart';

class RecentlyViewedScreen extends StatefulWidget {
  @override
  _RecentlyViewedScreenState createState() => _RecentlyViewedScreenState();
}

class _RecentlyViewedScreenState extends State<RecentlyViewedScreen> {
  List<ProductModel> products = List<ProductModel>();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
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
          title: Container(
            child: Text(
              AppTranslations.of(context).text('recently_viewed'),
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'CalibriBold',
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ),
      body: GridView.count(
        scrollDirection: Axis.vertical,
        crossAxisCount: 2,
        children: products
            .map(
              (item) => ProductSingle(
                id: item.id,
                imageUrl: item.imageList[0]['file_url'],
                name: item.title,
                price: item.maxPrice,
                // rating: '4',
                // isInDiscount: true,
                // discount: '10',
                decription: item.description,
              ),
            )
            .toList(),
      ),
    );
  }
}
