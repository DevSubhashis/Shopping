import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ppl/providers/user.dart';
import 'package:ppl/screens/profile/account_settings.dart';
import 'package:ppl/screens/profile/my_purchases.dart';
import 'package:ppl/screens/profile/my_wishlist.dart';
import 'package:ppl/screens/profile/recently_viewed.dart';
import 'package:ppl/screens/profile/refer_friend.dart';
import 'package:ppl/localization/app_translations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:badges/badges.dart';
import 'package:ppl/screens/profile/sign_in.dart';
import 'package:ppl/screens/profile/sign_up.dart';
import 'package:ppl/utils/constants.dart';
import 'package:ppl/screens/profile/edit_profile.dart';
import 'package:ppl/screens/home/cart.dart';

class MyProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyProfile(),
    );
  }
}

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<UserModel>(builder: (context, user, child) {
        //  String u = user.userData['auth'];
        //  print(u);

        return ListView(
          //padding: EdgeInsets.all(10.0),
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              //color: Colors.brown,
              decoration: user.userData.isNotEmpty
                  ? BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          user.userData['auth']['user']['cover_picture'],
                        ),
                        fit: BoxFit.cover,
                      ),
                    )
                  : BoxDecoration(color: Colors.brown),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(
                          AppTranslations.of(context).text('my_profile'),
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'CalibriBold',
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      IconButton(
                        splashColor: Colors.white,
                        icon: SvgPicture.asset(
                          'assets/images/icon_settings.svg',
                          color: Colors.white,
                          fit: BoxFit.contain,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AccountSettingsScreen()),
                          );
                        },
                      ),
                      Badge(
                        position: BadgePosition.topRight(top: 0, right: 3),
                        animationDuration: Duration(milliseconds: 300),
                        animationType: BadgeAnimationType.slide,
                        badgeContent: Text(
                          3.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        child: IconButton(
                          splashColor: Colors.white,
                          icon: SvgPicture.asset(
                            'assets/images/icon_shopping_cart.svg',
                            color: Colors.white,
                            fit: BoxFit.contain,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Cart()),
                            );
                          },
                        ),
                      ),
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
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: 2.0, bottom: 10.0, right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            user.userData.isNotEmpty
                                ? InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditProfileScreen(
                                                  userData:
                                                      user.userData['auth']),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        ClipOval(
                                          child: Image.network(
                                            user.userData['auth']['user']
                                                ['profile_picture'],
                                            height: 55.0,
                                            width: 55.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              '${user.userData['auth']['user']['first_name']} ${user.userData['auth']['user']['last_name']}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'CalibriRegular',
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              user.userData['auth']['user']
                                                  ['mobile'],
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'CalibriRegular',
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                : Row(
                                    children: [
                                      Container(
                                        height: 45.0,
                                        width: 45.0,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                        ),
                                        child: Center(
                                          child: FaIcon(
                                            FontAwesomeIcons.userAlt,
                                            color: PrimaryColor,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 90.0)
                                    ],
                                  ),
                            user.userData.isEmpty
                                ? Container(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          height: 35.0,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          child: FlatButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SigninScreen(),
                                                ),
                                              );
                                            },
                                            splashColor: PrimaryColor,
                                            child: Text(
                                              AppTranslations.of(context)
                                                  .text('login'),
                                              style: TextStyle(
                                                fontFamily: 'CalibriRegular',
                                                fontSize: 12.0,
                                                color: PrimaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Container(
                                          height: 35.0,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          child: FlatButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SignupScreen(),
                                                ),
                                              );
                                            },
                                            splashColor: Colors.white,
                                            child: Text(
                                              AppTranslations.of(context)
                                                  .text('signup'),
                                              style: TextStyle(
                                                fontFamily: 'CalibriRegular',
                                                fontSize: 12.0,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (user.userData.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            Text(
                              '00',
                              style: TextStyle(
                                  fontFamily: 'CalibriRegular',
                                  fontSize: 14.0,
                                  color: Colors.white),
                            ),
                            Text(
                              'My Wishlist',
                              style: TextStyle(
                                  fontFamily: 'CalibriRegular',
                                  fontSize: 14.0,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Column(
                          children: [
                            Text(
                              '18',
                              style: TextStyle(
                                  fontFamily: 'CalibriRegular',
                                  fontSize: 14.0,
                                  color: Colors.white),
                            ),
                            Text(
                              'Followed Store',
                              style: TextStyle(
                                  fontFamily: 'CalibriRegular',
                                  fontSize: 14.0,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                      ],
                    ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyPurchasesScreen(activeTabIndex: 3),
                  ),
                );
              },
              child: Container(
                height: 45,
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        FaIcon(
                          FontAwesomeIcons.listAlt,
                          size: 24.0,
                          color: Colors.indigo,
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        Text(
                          AppTranslations.of(context).text('my_purchase'),
                          style: TextStyle(
                            fontFamily: 'CalibriRegular',
                            fontSize: 14.0,
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
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Divider(),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MyPurchasesScreen(activeTabIndex: 0),
                        ),
                      ),
                    },
                    color: Colors.lightBlue[400],
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.payment,
                          color: Colors.white,
                          size: 20.0,
                        ),
                        Text(
                          AppTranslations.of(context).text('to_pay'),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MyPurchasesScreen(activeTabIndex: 1),
                        ),
                      ),
                    },
                    color: Colors.orange,
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.local_shipping,
                          color: Colors.white,
                          size: 20.0,
                        ),
                        Text(
                          AppTranslations.of(context).text('to_ship'),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MyPurchasesScreen(activeTabIndex: 2),
                        ),
                      ),
                    },
                    color: Color(0xff1EBEA5),
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.receipt,
                          color: Colors.white,
                          size: 20.0,
                        ),
                        Text(
                          AppTranslations.of(context).text('to_receive'),
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
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Divider(),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                height: 45,
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        FaIcon(
                          FontAwesomeIcons.qrcode,
                          size: 24.0,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        Text(
                          AppTranslations.of(context).text('my_qr_code'),
                          style: TextStyle(
                            fontFamily: 'CalibriRegular',
                            fontSize: 14.0,
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
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Divider(),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecentlyViewedScreen()),
                );
              },
              child: Container(
                height: 45,
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        FaIcon(
                          FontAwesomeIcons.history,
                          size: 24.0,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        Text(
                          AppTranslations.of(context).text('recently_viewed'),
                          style: TextStyle(
                            fontFamily: 'CalibriRegular',
                            fontSize: 14.0,
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
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Divider(),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                height: 45,
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        FaIcon(
                          FontAwesomeIcons.wallet,
                          size: 24.0,
                          color: Colors.deepOrange,
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        Text(
                          AppTranslations.of(context).text('ppl_pay'),
                          style: TextStyle(
                            fontFamily: 'CalibriRegular',
                            fontSize: 14.0,
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
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Divider(),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReferFriendScreen()),
                );
              },
              child: Container(
                height: 45,
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        FaIcon(
                          FontAwesomeIcons.mailBulk,
                          size: 24.0,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        Text(
                          AppTranslations.of(context).text('refer_friend'),
                          style: TextStyle(
                            fontFamily: 'CalibriRegular',
                            fontSize: 14.0,
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
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Divider(),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyWishlistScreen()),
                );
              },
              child: Container(
                height: 45,
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        FaIcon(
                          FontAwesomeIcons.heart,
                          size: 24.0,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        Text(
                          AppTranslations.of(context).text('my_wishlist'),
                          style: TextStyle(
                            fontFamily: 'CalibriRegular',
                            fontSize: 14.0,
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
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Divider(),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                height: 45,
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        FaIcon(
                          FontAwesomeIcons.star,
                          size: 24.0,
                          color: Colors.cyan,
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        Text(
                          AppTranslations.of(context).text('my_rating'),
                          style: TextStyle(
                            fontFamily: 'CalibriRegular',
                            fontSize: 14.0,
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
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Divider(),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                height: 45,
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        FaIcon(
                          FontAwesomeIcons.book,
                          size: 24.0,
                          color: Colors.cyan,
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        Text(
                          AppTranslations.of(context).text('my_vouchers'),
                          style: TextStyle(
                            fontFamily: 'CalibriRegular',
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '00',
                          style: TextStyle(
                            fontFamily: 'CalibriRegular',
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 18.0,
                          color: Colors.grey,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Divider(),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                height: 45,
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        FaIcon(
                          FontAwesomeIcons.wallet,
                          size: 24.0,
                          color: Colors.cyan,
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        Text(
                          AppTranslations.of(context).text('e_wallet'),
                          style: TextStyle(
                            fontFamily: 'CalibriRegular',
                            fontSize: 14.0,
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
            Divider(color: Colors.black12, height: 10, thickness: 10),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AccountSettingsScreen()),
                );
              },
              child: Container(
                height: 45,
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        FaIcon(
                          FontAwesomeIcons.user,
                          size: 24.0,
                          color: Colors.cyan,
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        Text(
                          AppTranslations.of(context).text('account_setting'),
                          style: TextStyle(
                            fontFamily: 'CalibriRegular',
                            fontSize: 14.0,
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
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Divider(),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                height: 45,
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        FaIcon(
                          FontAwesomeIcons.questionCircle,
                          size: 24.0,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        Text(
                          AppTranslations.of(context).text('help_center'),
                          style: TextStyle(
                            fontFamily: 'CalibriRegular',
                            fontSize: 14.0,
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
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Divider(),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                height: 45,
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        FaIcon(
                          FontAwesomeIcons.headphones,
                          size: 24.0,
                          color: Colors.deepPurple,
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        Text(
                          AppTranslations.of(context).text('chat_with_ppl'),
                          style: TextStyle(
                            fontFamily: 'CalibriRegular',
                            fontSize: 14.0,
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
            // Padding(
            //   padding: EdgeInsets.only(left: 10.0, right: 10.0),
            //   child: Divider(),
            // ),
          ],
        );
      }),
    );
  }
}
