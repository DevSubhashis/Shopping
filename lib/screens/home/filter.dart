import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ppl/utils/constants.dart';
import 'package:ppl/localization/app_translations.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:ppl/models/brand_model.dart';
import 'package:ppl/models/category_model.dart';
import 'package:ppl/models/sub_category_model.dart';
import 'package:ppl/models/size_model.dart';
import 'package:ppl/models/color_model.dart';
import 'package:ppl/services/services.dart';
import 'package:ppl/screens/home/ProductList.dart';

ProgressDialog pr;

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  bool _isLoading = true;
  List<CategoryModel> categories = [];
  List<SubCategoryModel> subCategories = [];
  List<BrandModel> brands = [];
  List<ColorModel> allcolors = [];
  List<SizeModel> sizes = [];
  String categoryId;
  String sub_category_id;
  String brand_id;
  String color_id;
  String size_id;

  @override
  void initState() {
    super.initState();
    _fetchAllCategories();
    _fetchAllBrands();
    _fetchAllSize();
    _fetchAllColors();
  }

  _fetchAllCategories() async {
    final WebService _webService = WebService();
    final response =
        _webService.getCategories(GET_ALL_CATEGORIES + '?per_page=300');
    response.then((value) {
      setState(() {
        _isLoading = false;
        categories = value;
      });
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  _fetchSubCategoryByaCategory() async {
    final WebService _webService = WebService();
    var url = GET_SUB_CATEGORY + '?category_id=${categoryId}&per_page=300';
    final response = _webService.getSubCategoriesByParentId(url);
    response.then((value) {
      setState(() {
        _isLoading = false;
        subCategories = value;
      });
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  _fetchAllBrands() async {
    final WebService _webService = WebService();
    var url = GET_ALL_BRANDS + '?&per_page=300';
    final response = _webService.getAllBrands(url);
    response.then((value) {
      setState(() {
        _isLoading = false;
        brands = value;
      });
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  _fetchAllSize() async {
    final WebService _webService = WebService();
    final response = _webService.getAllSizes(GET_ALL_SIZES);
    response.then((value) {
      setState(() {
        _isLoading = false;
        sizes = value;
      });
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  _fetchAllColors() async {
    final WebService _webService = WebService();
    final response = _webService.getAllColors(GET_ALL_COLORS);
    response.then((value) {
      setState(() {
        _isLoading = false;
        allcolors = value;
      });
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Widget FormUI() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButtonFormField<String>(
                hint: Text(AppTranslations.of(context).text('select_category')),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                style: TextStyle(
                  fontFamily: 'MontserratRegular',
                  color: Colors.grey,
                ),
                isDense: true,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  size: 30.0,
                ),
                value: categoryId,
                onChanged: (String newValue) {
                  print(newValue);
                  setState(() {
                    categoryId = newValue;
                  });
                  _fetchSubCategoryByaCategory();
                },
                items: this.categories.map((CategoryModel item) {
                  return DropdownMenuItem<String>(
                    value: item.id.toString(),
                    child: Text(
                      item.title,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButtonFormField<String>(
                hint: Text(
                    AppTranslations.of(context).text('select_subcategory')),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                style: TextStyle(
                  fontFamily: 'MontserratRegular',
                  color: Colors.grey,
                ),
                isDense: true,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  size: 30.0,
                ),
                value: sub_category_id,
                onChanged: (String newValue) {
                  setState(() {
                    sub_category_id = newValue;
                  });
                },
                items: this.subCategories.map((SubCategoryModel item) {
                  return DropdownMenuItem<String>(
                    value: item.id.toString(),
                    child: Text(
                      item.title,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButtonFormField<String>(
                hint: Text(AppTranslations.of(context).text('select_brand')),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                style: TextStyle(
                  fontFamily: 'MontserratRegular',
                  color: Colors.grey,
                ),
                isDense: true,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  size: 30.0,
                ),
                value: brand_id,
                onChanged: (String newValue) {
                  setState(() {
                    brand_id = newValue;
                  });
                },
                items: this.brands.map((BrandModel item) {
                  return DropdownMenuItem<String>(
                    value: item.id.toString(),
                    child: Text(
                      item.title,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButtonFormField<String>(
                hint: Text(AppTranslations.of(context).text('select_color')),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                style: TextStyle(
                  fontFamily: 'MontserratRegular',
                  color: Colors.grey,
                ),
                isDense: true,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  size: 30.0,
                ),
                value: color_id,
                onChanged: (String newValue) {
                  setState(() {
                    color_id = newValue;
                  });
                },
                items: this.allcolors.map((ColorModel item) {
                  return DropdownMenuItem<String>(
                    value: item.id.toString(),
                    child: Text(
                      item.name,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButtonFormField<String>(
                hint: Text(AppTranslations.of(context).text('select_size')),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                style: TextStyle(
                  fontFamily: 'MontserratRegular',
                  color: Colors.grey,
                ),
                isDense: true,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  size: 30.0,
                ),
                value: size_id,
                onChanged: (String newValue) {
                  setState(() {
                    size_id = newValue;
                  });
                },
                items: this.sizes.map((SizeModel item) {
                  return DropdownMenuItem<String>(
                    value: item.id.toString(),
                    child: Text(
                      item.name,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButtonFormField<String>(
                hint: Text(AppTranslations.of(context).text('shipped_from')),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                style: TextStyle(
                  fontFamily: 'MontserratRegular',
                  color: Colors.grey,
                ),
                isDense: true,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  size: 30.0,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    size_id = newValue;
                  });
                },
                items: this.sizes.map((SizeModel item) {
                  return DropdownMenuItem<String>(
                    value: item.id.toString(),
                    child: Text(
                      item.name,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButtonFormField<String>(
                hint: Text(AppTranslations.of(context).text('shipping_option')),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                style: TextStyle(
                  fontFamily: 'MontserratRegular',
                  color: Colors.grey,
                ),
                isDense: true,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  size: 30.0,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    size_id = newValue;
                  });
                },
                items: this.sizes.map((SizeModel item) {
                  return DropdownMenuItem<String>(
                    value: item.id.toString(),
                    child: Text(
                      item.name,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButtonFormField<String>(
                hint: Text(AppTranslations.of(context).text('rating')),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                style: TextStyle(
                  fontFamily: 'MontserratRegular',
                  color: Colors.grey,
                ),
                isDense: true,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  size: 30.0,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    size_id = newValue;
                  });
                },
                items: this.sizes.map((SizeModel item) {
                  return DropdownMenuItem<String>(
                    value: item.id.toString(),
                    child: Text(
                      item.name,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButtonFormField<String>(
                hint: Text(AppTranslations.of(context).text('shoe_type')),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                style: TextStyle(
                  fontFamily: 'MontserratRegular',
                  color: Colors.grey,
                ),
                isDense: true,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  size: 30.0,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    size_id = newValue;
                  });
                },
                items: this.sizes.map((SizeModel item) {
                  return DropdownMenuItem<String>(
                    value: item.id.toString(),
                    child: Text(
                      item.name,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButtonFormField<String>(
                hint: Text(AppTranslations.of(context).text('condition')),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                style: TextStyle(
                  fontFamily: 'MontserratRegular',
                  color: Colors.grey,
                ),
                isDense: true,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  size: 30.0,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    size_id = newValue;
                  });
                },
                items: this.sizes.map((SizeModel item) {
                  return DropdownMenuItem<String>(
                    value: item.id.toString(),
                    child: Text(
                      item.name,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButtonFormField<String>(
                hint: Text(AppTranslations.of(context).text('payment_option')),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                style: TextStyle(
                  fontFamily: 'MontserratRegular',
                  color: Colors.grey,
                ),
                isDense: true,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  size: 30.0,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    size_id = newValue;
                  });
                },
                items: this.sizes.map((SizeModel item) {
                  return DropdownMenuItem<String>(
                    value: item.id.toString(),
                    child: Text(
                      item.name,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButtonFormField<String>(
                hint: Text(
                    AppTranslations.of(context).text('service_and_promotion')),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                style: TextStyle(
                  fontFamily: 'MontserratRegular',
                  color: Colors.grey,
                ),
                isDense: true,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  size: 30.0,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    size_id = newValue;
                  });
                },
                items: this.sizes.map((SizeModel item) {
                  return DropdownMenuItem<String>(
                    value: item.id.toString(),
                    child: Text(
                      item.name,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.45,
              //margin: EdgeInsets.only(top: 20.0),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: RaisedButton(
                textColor: Colors.orange,
                splashColor: Colors.orange,
                color: Colors.white,
                child: Text(
                  "Reset",
                  style: TextStyle(
                    fontFamily: 'CalibriRegular',
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                onPressed: () {
                  if (categoryId != null) {
                    setState(() {
                      categoryId = null;
                      sub_category_id = null;
                      brand_id = null;
                      color_id = null;
                      size_id = null;
                    });
                  }
                },
              ),
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.45,
              //margin: EdgeInsets.only(top: 20.0),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: RaisedButton(
                textColor: Colors.white,
                splashColor: Colors.white,
                color: PrimaryColor,
                child: Text(
                  "Apply",
                  style: TextStyle(
                    fontFamily: 'CalibriRegular',
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  if (categoryId != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductList(
                          categoryId: int.parse(categoryId),
                          sub_category_id: sub_category_id,
                          brand_id: brand_id,
                          color_id: color_id,
                          size_id: size_id,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ],
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
              AppTranslations.of(context).text('filter_products'),
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'CalibriBold',
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Form(
          child: FormUI(),
        ),
      ),
    );
  }
}
