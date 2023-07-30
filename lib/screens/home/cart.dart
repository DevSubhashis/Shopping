import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ppl/localization/app_translations.dart';
import 'package:ppl/models/CartItem.dart';
import 'package:ppl/components/CartSingle.dart';
import 'package:ppl/providers/user.dart';
import 'package:ppl/services/services.dart';
import 'package:ppl/utils/constants.dart';
import 'package:ppl/screens/home/checkout.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// final List<CartItem> cartItems = [
//   new CartItem(
//     'Shirt',
//     'https://static.peachmode.com/media/images/product/7685/base/1518786674_FTR-UMNX-KUMBFOREVER-4178.jpg',
//     1,
//   ),
//   new CartItem(
//     'Shirt',
//     'https://static.peachmode.com/media/images/product/7685/base/1518786674_FTR-UMNX-KUMBFOREVER-4178.jpg',
//     1,
//   ),
//   new CartItem(
//     'Shirt',
//     'https://static.peachmode.com/media/images/product/7685/base/1518786674_FTR-UMNX-KUMBFOREVER-4178.jpg',
//     1,
//   ),
//   new CartItem(
//     'Shirt',
//     'https://static.peachmode.com/media/images/product/7685/base/1518786674_FTR-UMNX-KUMBFOREVER-4178.jpg',
//     1,
//   ),
//   new CartItem(
//     'Shirt',
//     'https://static.peachmode.com/media/images/product/7685/base/1518786674_FTR-UMNX-KUMBFOREVER-4178.jpg',
//     1,
//   )
// ];

class Cart extends StatefulWidget {
  @override
  CartState createState() => CartState();
}

class CartState extends State<Cart> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isLoading = false;
  List cartItems = [];
  bool isAllSelected = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var user = Provider.of<UserModel>(context, listen: false);
      setState(() {
        isLoading = true;
      });
      if (user.userData.isNotEmpty) {
        getAllCartItems(user);
      } else {
        getAllCartItemsLocal();
      }
    });
  }

  getAllCartItemsLocal() async {
    final SharedPreferences prefs = await _prefs;
    String cart = prefs.getString('cart');
    if (cart != null) {
      var localCartItems = json.decode(cart) as List;
      if (localCartItems.length > 0) {
        cartItems.addAll(localCartItems);
      }
      print("================From Local");
      print(cartItems);
      print("================");
    }
    setState(() {
      isLoading = false;
    });
  }

  getAllCartItems(user) {
    WebService api = WebService();
    final response =
        api.callGetAPI(GET_CART_ITEMS, user.userData['auth']['_token']);
    response.then((value) {
      // print(value.body);
      setState(() {
        isLoading = false;
      });
      var decodedData = jsonDecode(value.body);
      final int statusCode = decodedData['serverResponse']['code'];
      final String message = decodedData['serverResponse']['message'];
      if (statusCode == 400) {
      } else if (statusCode == 401) {
        this._showDialogError(message);
        user.doRemoveUser();
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        // print(decodedData['result']['cart_items']);
        if (decodedData['result'] != null &&
            decodedData['result']['cart_items'] != null) {
          cartItems.addAll(decodedData['result']['cart_items']);
          setState(() {});
          print("================From Server");
          print(cartItems);
          print("================");
        }
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
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
          title: new Text(AppTranslations.of(context).text('error')),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(AppTranslations.of(context).text('close')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void doSomething(bool i) {}

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
              AppTranslations.of(context).text('shopping_cart'),
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'CalibriBold',
                fontSize: 16.0,
              ),
            ),
          ),
          actions: <Widget>[
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
        child: isLoading
            ? circularProgress()
            : cartItems.length > 0
                ? ListView(
                    scrollDirection: Axis.vertical,
                    children: cartItems
                        .map(
                          (item) =>
                              CartSingle(item: item, callback: doSomething),
                        )
                        .toList(),
                  )
                : EmptyCart(),
      ),
      bottomNavigationBar: cartItems.length > 0
          ? Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Checkbox(
                          onChanged: (bool value) {
                            doSomething(value);
                            setState(() {
                              isAllSelected = value;
                            });
                          },
                          value: isAllSelected,
                          checkColor: Colors.greenAccent,
                          activeColor: Colors.red,
                        ),
                        Text(
                          "All",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'CalibriRegular',
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: ListTile(
                      title: new Text(
                        AppTranslations.of(context).text('total'),
                        style:
                            TextStyle(fontFamily: 'CalibriBold', fontSize: 18),
                      ),
                      subtitle: new Text(
                        "৳100",
                        style:
                            TextStyle(fontFamily: 'CalibriBold', fontSize: 18),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: new MaterialButton(
                      height: 40,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Checkout()),
                        );
                      },
                      child: new Text(
                        AppTranslations.of(context).text('checkout'),
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'CalibriRegular',
                          fontSize: 16,
                        ),
                      ),
                      color: Colors.blue,
                    ),
                  )
                ],
              ),
            )
          : null,
    );
  }

  circularProgress() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height / 5,
            bottom: MediaQuery.of(context).size.height / 5),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(SecondaryColor),
        ),
      ),
    );
  }
}

class EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty_cart.png',
            fit: BoxFit.contain,
            width: 75.0,
            height: 75.0,
          ),
          Container(
            margin: EdgeInsets.only(top: 15.0),
            child: Text(
              AppTranslations.of(context).text('empty_cart_message'),
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'CalibriRegular',
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
