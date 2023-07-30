import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ppl/utils/constants.dart';
import 'package:ppl/localization/app_translations.dart';

class MyPurchasesScreen extends StatefulWidget {
  final int activeTabIndex;
  MyPurchasesScreen({Key key, @required this.activeTabIndex}) : super(key: key);

  @override
  _MyPurchasesScreenState createState() => _MyPurchasesScreenState();
}

class _MyPurchasesScreenState extends State<MyPurchasesScreen> {
  int initialTabIndex = 0;

  @override
  void initState() {
    super.initState();
    initialTabIndex = widget.activeTabIndex;
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
              AppTranslations.of(context).text('my_purchase'),
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            DefaultTabController(
              length: 6,
              initialIndex: initialTabIndex,
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
                          AppTranslations.of(context).text('to_pay'),
                          style: TextStyle(fontFamily: 'CalibriRegular'),
                        ),
                      ),
                      Tab(
                        child: Text(
                          AppTranslations.of(context).text('to_ship'),
                          style: TextStyle(fontFamily: 'CalibriRegular'),
                        ),
                      ),
                      Tab(
                        child: Text(
                          AppTranslations.of(context).text('to_receive'),
                          style: TextStyle(fontFamily: 'CalibriRegular'),
                        ),
                      ),
                      Tab(
                        child: Text(
                          AppTranslations.of(context).text('completed'),
                          style: TextStyle(fontFamily: 'CalibriRegular'),
                        ),
                      ),
                      Tab(
                        child: Text(
                          AppTranslations.of(context).text('cancelled'),
                          style: TextStyle(fontFamily: 'CalibriRegular'),
                        ),
                      ),
                      Tab(
                        child: Text(
                          AppTranslations.of(context).text('returned_refund'),
                          style: TextStyle(fontFamily: 'CalibriRegular'),
                        ),
                      ),
                    ]),
              ),
            ),
            ListView(
              padding: EdgeInsets.all(10.0),
              shrinkWrap: true,
              physics: ScrollPhysics(),
              children: <Widget>[
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
                              'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                              style: TextStyle(
                                fontFamily: 'CalibriRegular',
                                fontSize: 14.0,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              'Ordered on 18-May-2019',
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
                              'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                              style: TextStyle(
                                fontFamily: 'CalibriRegular',
                                fontSize: 14.0,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              'Ordered on 18-May-2019',
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
                              'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                              style: TextStyle(
                                fontFamily: 'CalibriRegular',
                                fontSize: 14.0,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              'Ordered on 18-May-2019',
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
          ],
        ),
      ),
    );
  }
}
