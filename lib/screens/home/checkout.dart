import 'package:flutter/material.dart';
import 'package:ppl/utils/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ppl/localization/app_translations.dart';
import 'package:ppl/screens/home/addresses.dart';
import 'package:ppl/providers/user.dart';
import 'package:provider/provider.dart';

class Checkout extends StatefulWidget {
  @override
  CheckoutState createState() => CheckoutState();
}

class CheckoutState extends State<Checkout> {
  bool isLogedin = false;

  static var subHeaderCustomStyle = TextStyle(
    color: Colors.black54,
    fontWeight: FontWeight.w700,
    fontFamily: "CalibriBold",
    fontSize: 16.0,
  );

  @override
  void initState() {
    super.initState();
    var user = Provider.of<UserModel>(context, listen: false);
    if (user.userData.isNotEmpty) {
      setState(() {
        isLogedin = true;
      });
    } else {
      setState(() {
        isLogedin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget addresscetion = new Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8.0),
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
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: InkWell(
          onTap: () {
            if (isLogedin) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddressesScreen()),
              );
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      AppTranslations.of(context).text('delivery_address'),
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
              Padding(
                padding: EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 0.0, bottom: 7.0),
                child: line(),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 0.0, bottom: 7.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Subhashis Routh",
                      style: TextStyle(
                        fontFamily: "CalibriRegular",
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "(+91) 8017221280",
                      style: TextStyle(
                        fontFamily: "CalibriRegular",
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "V 3/1 Vivekananada Park",
                      style: TextStyle(
                        fontFamily: "CalibriRegular",
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Kolkata - 700084",
                      style: TextStyle(
                        fontFamily: "CalibriRegular",
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Widget productsscetion = new Container(
      width: MediaQuery.of(context).size.width,
      //padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(top: 5.0),
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
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Shopee 24',
                style: subHeaderCustomStyle,
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(
            //       left: 15.0, right: 15.0, top: 0.0, bottom: 7.0),
            //   child: line(),
            // ),
            ListTile(
              leading: Image.network(
                "https://static.peachmode.com/media/images/product/7685/base/1518786674_FTR-UMNX-KUMBFOREVER-4178.jpg",
                width: 60,
                height: 60,
              ),
              trailing: Text(
                "x1",
                style: TextStyle(
                  fontFamily: "CalibriRegular",
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              title: Text(
                "Panasonic 6.2kg Fully-Automatic Top Loading Washing Machine (NA-F62A7CRB, Inox Black, Advanced Active Foam System)",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(
                  fontFamily: "CalibriRegular",
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                "৳12.00",
                style: TextStyle(
                  fontFamily: "CalibriRegular",
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),

            ListTile(
              leading: Image.network(
                "https://static.peachmode.com/media/images/product/7685/base/1518786674_FTR-UMNX-KUMBFOREVER-4178.jpg",
                width: 60,
                height: 60,
                fit: BoxFit.contain,
              ),
              trailing: Text(
                "x1",
                style: TextStyle(
                  fontFamily: "CalibriRegular",
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              title: Text(
                "Panasonic 6.2kg Fully-Automatic Top Loading Washing Machine (NA-F62A7CRB, Inox Black, Advanced Active Foam System)",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(
                  fontFamily: "CalibriRegular",
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                "৳12.00",
                style: TextStyle(
                  fontFamily: "CalibriRegular",
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    AppTranslations.of(context).text('shipping1'),
                    style: subHeaderCustomStyle,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 0.0, bottom: 7.0),
              child: line(),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        AppTranslations.of(context).text('standard_express'),
                        style: TextStyle(
                          fontFamily: "CalibriBold",
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "Receive by 22 Jul - 29 Jul",
                        style: TextStyle(
                          fontFamily: "CalibriRegular",
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "৳1.00",
                        style: TextStyle(
                          fontFamily: "CalibriRegular",
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 18.0,
                        color: Colors.black54,
                      ),
                    ],
                  ))
                ],
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.all(15.0),
            //   //child: Expanded(
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: <Widget>[
            //       Text(
            //         "Message",
            //         style: TextStyle(
            //           fontFamily: "CalibriRegular",
            //           fontSize: 15.0,
            //           fontWeight: FontWeight.w500,
            //           color: Colors.black,
            //         ),
            //       ),
            //       // TextField(
            //       //   decoration: InputDecoration(
            //       //     //border: InputBorder.none,
            //       //     hintText: 'Enter a search term',
            //       //   ),
            //       // ),
            //     ],
            //   ),
            //   //),
            // ),
            Padding(
              padding: EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 0.0, bottom: 7.0),
              child: line(),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              //child: Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    AppTranslations.of(context).text('order_total') +
                        " (3 " +
                        AppTranslations.of(context).text('items') +
                        ")",
                    style: TextStyle(
                      fontFamily: "CalibriRegular",
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "৳3.97",
                    style: TextStyle(
                      fontFamily: "CalibriRegular",
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              //),
            ),
          ],
        ),
      ),
    );

    Widget paymentSection = new Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 5.0),
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
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              //child: Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    AppTranslations.of(context).text('payment_option'),
                    style: subHeaderCustomStyle,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        AppTranslations.of(context)
                            .text('select_payment_method'),
                        style: TextStyle(
                          fontFamily: "CalibriRegular",
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.orange,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 18.0,
                        color: Colors.orange,
                      )
                    ],
                  ),
                ],
              ),
              //),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 0.0, bottom: 7.0),
              child: line(),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        AppTranslations.of(context)
                            .text('merchandise_subtotal'),
                        style: TextStyle(
                          fontFamily: "CalibriRegular",
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "৳325.25",
                        style: TextStyle(
                          fontFamily: "CalibriRegular",
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        AppTranslations.of(context).text('shipping_subtotal'),
                        style: TextStyle(
                          fontFamily: "CalibriRegular",
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "৳3.49",
                        style: TextStyle(
                          fontFamily: "CalibriRegular",
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        AppTranslations.of(context)
                            .text('Shipping_discount_subtotal'),
                        style: TextStyle(
                          fontFamily: "CalibriRegular",
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "-৳1.49",
                        style: TextStyle(
                          fontFamily: "CalibriRegular",
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        AppTranslations.of(context).text('total_payment'),
                        style: TextStyle(
                          fontFamily: "CalibriRegular",
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "৳327.45",
                        style: TextStyle(
                          fontFamily: "CalibriRegular",
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    Widget bottomSection = new Container(
      width: MediaQuery.of(context).size.width,
      height: 60.0,
      margin: const EdgeInsets.only(top: 5.0),
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
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    AppTranslations.of(context).text('total'),
                    style: TextStyle(
                      fontFamily: "CalibriRegular",
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "৳327.45",
                    style: TextStyle(
                      fontFamily: "CalibriRegular",
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.all(10.0),
                color: Colors.blue,
                child: InkWell(
                  onTap: () {
                    _showDialog(context);
                  },
                  child: Text(
                    AppTranslations.of(context).text('place_order'),
                    style: TextStyle(
                      fontFamily: "CalibriRegular",
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ))
          ],
        ),
      ),
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
                AppTranslations.of(context).text('checkout'),
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
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                addresscetion,
                productsscetion,
                productsscetion,
                paymentSection,
                SizedBox(height: 100)
              ],
            ),
          ),
        ),
        bottomSheet: bottomSection);
  }
}

/// Card Popup if success payment
_showDialog(BuildContext ctx) {
  showDialog(
    context: ctx,
    barrierDismissible: true,
    builder: (context) => SimpleDialog(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 30.0, right: 60.0, left: 60.0),
          color: Colors.white,
          child: Image.asset(
            "assets/images/checklist.png",
            height: 110.0,
            color: Colors.lightGreen,
          ),
        ),
        Center(
            child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            "Yuppy!!",
            style: TextStyle(
              fontFamily: "CalibriRegular",
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              color: Colors.orange,
            ),
          ),
        )),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0, bottom: 40.0),
            child: Text(
              AppTranslations.of(ctx).text('pay_success'),
              style: TextStyle(
                fontFamily: "CalibriRegular",
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Colors.orange,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget line() {
  return Container(
    height: 0.9,
    width: double.infinity,
    color: Colors.black12,
  );
}
