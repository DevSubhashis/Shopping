import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ppl/localization/app_translations.dart';
import 'package:ppl/screens/profile/my_purchases.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Notifications(),
    );
  }
}

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade50,
      child: ListView(
        children: <Widget>[
          InkWell(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.all(10.0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/promotion.png',
                        fit: BoxFit.contain,
                        width: 40.0,
                      ),
                      SizedBox(
                        width: 12.0,
                      ),
                      Text(
                        'Promotions',
                        style: TextStyle(
                          fontFamily: 'CalibriBold',
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18.0,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.all(10.0),
              color: Colors.white,
              margin: EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/alert.png',
                        fit: BoxFit.contain,
                        width: 40.0,
                      ),
                      SizedBox(
                        width: 12.0,
                      ),
                      Text(
                        'Alerts',
                        style: TextStyle(
                          fontFamily: 'CalibriBold',
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18.0,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.all(10.0),
              color: Colors.white,
              margin: EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/information.png',
                        fit: BoxFit.contain,
                        width: 40.0,
                      ),
                      SizedBox(
                        width: 12.0,
                      ),
                      Text(
                        'PPL Update',
                        style: TextStyle(
                          fontFamily: 'CalibriBold',
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18.0,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0, left: 10.0, bottom: 5.0),
            child: Text(
              'Order Updates',
              style: TextStyle(
                fontFamily: 'CalibriBold',
                fontSize: 18.0,
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Row(
              children: <Widget>[
                Image.asset(
                  'assets/images/demo_product2.png',
                  fit: BoxFit.cover,
                  width: 70.0,
                ),
                SizedBox(
                  width: 12.0,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        AppTranslations.of(context).text('product_shipped'),
                        style: TextStyle(
                          fontFamily: 'CalibriRegular',
                          fontSize: 14.0,
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                        style: TextStyle(
                            fontFamily: 'CalibriRegular',
                            fontSize: 12.0,
                            height: 1.5),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        '2 ' + AppTranslations.of(context).text('days_ago'),
                        style: TextStyle(
                            fontFamily: 'CalibriRegular',
                            fontSize: 14.0,
                            color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 25.0,
          ),
          InkWell(
            onTap: () {},
            child: Row(
              children: <Widget>[
                Image.asset(
                  'assets/images/demo_product.png',
                  fit: BoxFit.cover,
                  width: 70.0,
                ),
                SizedBox(
                  width: 12.0,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        AppTranslations.of(context).text('product_delivered'),
                        style: TextStyle(
                          fontFamily: 'CalibriRegular',
                          fontSize: 14.0,
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                        style: TextStyle(
                            fontFamily: 'CalibriRegular',
                            fontSize: 12.0,
                            height: 1.5),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        '4 ' + AppTranslations.of(context).text('days_ago'),
                        style: TextStyle(
                            fontFamily: 'CalibriRegular',
                            fontSize: 14.0,
                            color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 25.0,
          ),
          InkWell(
            onTap: () {},
            child: Row(
              children: <Widget>[
                Image.asset(
                  'assets/images/demo_product3.png',
                  fit: BoxFit.cover,
                  width: 70.0,
                ),
                SizedBox(
                  width: 12.0,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        AppTranslations.of(context).text('product_delivered'),
                        style: TextStyle(
                          fontFamily: 'CalibriRegular',
                          fontSize: 14.0,
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                        style: TextStyle(
                            fontFamily: 'CalibriRegular',
                            fontSize: 12.0,
                            height: 1.5),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        '25 ' + AppTranslations.of(context).text('days_ago'),
                        style: TextStyle(
                            fontFamily: 'CalibriRegular',
                            fontSize: 14.0,
                            color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
