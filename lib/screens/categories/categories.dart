import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ppl/models/category_model.dart';
import 'package:ppl/screens/home/ProductList.dart';
import 'package:ppl/services/services.dart';
import 'package:ppl/utils/constants.dart';
import 'package:ppl/localization/app_translations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoriesScreen extends StatefulWidget {
  final String from;
  CategoriesScreen({Key key, this.from}) : super(key: key);
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<CategoryModel> _categories = List<CategoryModel>();
  List subCategories = List();
  int selectedCatId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllCategories();
  }

  _fetchAllCategories() async {
    final WebService _webService = WebService();
    final response =
        _webService.getCategories(GET_ALL_CATEGORIES + '?per_page=300');
    response.then((value) {
      setState(() {
        _isLoading = false;
        _categories = value;
      });
      if (value != null && value.length > 0) {
        setState(() {
          subCategories = value[0].subCategories;
          selectedCatId = value[0].id;
        });
      }
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 1.4;
    return Scaffold(
      appBar: widget.from == 'home'
          ? PreferredSize(
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
                    AppTranslations.of(context).text('top_categories'),
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'CalibriBold',
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            )
          : null,
      body: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  width: 90.0,
                  // color: Colors.grey[200],
                  // padding: EdgeInsets.only(top: 10.0),
                  child: GridView.count(
                      crossAxisCount: 1,
                      childAspectRatio: (itemWidth / itemHeight),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      // padding: EdgeInsets.only(top: 10.0),
                      children: _categories
                          .map(
                            (item) => InkWell(
                              onTap: () {
                                setState(() {
                                  subCategories = item.subCategories;
                                  selectedCatId = item.id;
                                });
                              },
                              child: Container(
                                // margin: EdgeInsets.only(top: 10.0),
                                padding: EdgeInsets.only(left: 5.0, right: 5.0),
                                color: selectedCatId == item.id
                                    ? Colors.white
                                    : Colors.grey[200],
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.center,
                                      width: 65.0,
                                      height: 65.0,
                                      margin: EdgeInsets.only(top: 10.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromARGB(
                                                62, 168, 174, 201),
                                            offset: Offset(0, 9),
                                            blurRadius: 20,
                                          ),
                                        ],
                                      ),
                                      child: Container(
                                        width: 45.0,
                                        height: 45.0,
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
                                      height: 5.0,
                                    ),
                                    Text(
                                      item.title,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontFamily: "CalibriRegular",
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList()),
                ),
              ),
              Expanded(
                flex: 9,
                child: Container(
                  padding: EdgeInsets.only(top: 10.0),
                  child: GridView.count(
                      crossAxisCount: 3,
                      childAspectRatio: (itemWidth / itemHeight),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: subCategories
                          .map(
                            (item) => InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductList(
                                      categoryId: item['parent_category_id'],
                                      sub_category_id: item['id'].toString(),
                                      brand_id: null,
                                      color_id: null,
                                      size_id: null,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 5.0, right: 5.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: 30.0,
                                      height: 30.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(item['image']),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      item['title'],
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontFamily: "CalibriRegular",
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList()),
                ),
              ),
            ],
          ),
          if (_isLoading) circularProgress()
        ],
      ),
    );
  }

  circularProgress() {
    return Center(
      child: CircularProgressIndicator(
        valueColor:
            AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
      ),
    );
  }
}
