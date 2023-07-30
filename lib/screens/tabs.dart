import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ppl/localization/app_translations.dart';
import 'package:ppl/presentation/custom_icons_icons.dart';
import 'package:ppl/providers/user.dart';
import 'package:ppl/screens/categories/categories.dart';
import 'package:ppl/screens/mall/ppl_mall.dart';
import 'package:ppl/screens/profile/account_settings.dart';
import 'package:ppl/screens/profile/edit_profile.dart';
import 'package:ppl/screens/profile/my_profile.dart';
import 'package:ppl/screens/notifications/notifications.dart';
import 'package:ppl/screens/profile/sign_in.dart';
import 'package:ppl/screens/profile/sign_up.dart';
import 'package:ppl/utils/constants.dart';
import 'package:gradient_bottom_navigation_bar/gradient_bottom_navigation_bar.dart';
import 'package:badges/badges.dart';
import 'package:ppl/screens/home/home.dart';
import 'package:ppl/screens/home/cart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  // bool isLogedin = false;
  int currentTabIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    CategoriesScreen(from: 'tab'),
    PPLMallScreen(),
    NotificationsScreen(),
    MyProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   var user = Provider.of<UserModel>(context, listen: false);
    //   print("********1111111111111******");
    //   print(user.userData);
    //   if (user.userData.isNotEmpty) {
    //     setState(() {
    //       isLogedin = true;
    //     });
    //   } else {
    //     setState(() {
    //       isLogedin = false;
    //     });
    //   }
    // });
  }

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            // Size(double.infinity, currentTabIndex == 4 ? 120.0 : 55.0),
            Size(double.infinity, currentTabIndex == 4 ? 0.0 : 55.0),
        child: Consumer<UserModel>(builder: (context, user, child) {
          // print(user.userData);
          return AppBar(
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
            title: currentTabIndex == 3
                ? Container(
                    child: Text(
                      AppTranslations.of(context).text('notifications'),
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'CalibriBold',
                        fontSize: 16.0,
                      ),
                    ),
                  )
                : currentTabIndex == 4
                    ? Container()
                    // Container(
                    //     child: Text(
                    //       AppTranslations.of(context).text('my_profile'),
                    //       style: TextStyle(
                    //         color: Colors.white,
                    //         fontFamily: 'CalibriBold',
                    //         fontSize: 16.0,
                    //       ),
                    //     ),
                    //   )
                    : Container(
                        height: 35.0,
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintText:
                                AppTranslations.of(context).text('ppl_search'),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                          ),
                        ),
                      ),
            actions: <Widget>[
              // currentTabIndex == 4
              //     ? IconButton(
              //         splashColor: Colors.white,
              //         icon: SvgPicture.asset(
              //           'assets/images/icon_settings.svg',
              //           color: Colors.white,
              //           fit: BoxFit.contain,
              //         ),
              //         onPressed: () {
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => AccountSettingsScreen()),
              //           );
              //         },
              //       )
              //     : Container(),
              currentTabIndex != 4
                  ? Badge(
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
                    )
                  : Container(),

              currentTabIndex != 4
                  ? IconButton(
                      splashColor: Colors.white,
                      icon: SvgPicture.asset(
                        'assets/images/icon_chat_bubble.svg',
                        color: Colors.white,
                        fit: BoxFit.contain,
                      ),
                      onPressed: () {},
                    )
                  : Container(),
            ],
            // bottom: currentTabIndex == 4
            //     ? PreferredSize(
            //         preferredSize: Size.fromHeight(0),
            //         child: Padding(
            //           padding: EdgeInsets.only(
            //               left: 10.0, bottom: 10.0, right: 10.0),
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: <Widget>[
            //               user.userData.isNotEmpty
            //                   ? InkWell(
            //                       onTap: () {
            //                         Navigator.push(
            //                           context,
            //                           MaterialPageRoute(
            //                             builder: (context) => EditProfileScreen(
            //                                 userData: user.userData['auth']),
            //                           ),
            //                         );
            //                       },
            //                       child: Row(
            //                         children: <Widget>[
            //                           ClipOval(
            //                             child: Image.network(
            //                               user.userData['auth']['user']
            //                                   ['profile_picture'],
            //                               height: 55.0,
            //                               width: 55.0,
            //                               fit: BoxFit.cover,
            //                             ),
            //                           ),
            //                           SizedBox(
            //                             width: 10.0,
            //                           ),
            //                           Column(
            //                             crossAxisAlignment:
            //                                 CrossAxisAlignment.start,
            //                             children: <Widget>[
            //                               Text(
            //                                 '${user.userData['auth']['user']['first_name']} ${user.userData['auth']['user']['last_name']}',
            //                                 style: TextStyle(
            //                                   color: Colors.white,
            //                                   fontFamily: 'CalibriRegular',
            //                                   fontSize: 16.0,
            //                                 ),
            //                               ),
            //                               SizedBox(
            //                                 height: 5.0,
            //                               ),
            //                               Text(
            //                                 user.userData['auth']['user']
            //                                     ['mobile'],
            //                                 style: TextStyle(
            //                                   color: Colors.white,
            //                                   fontFamily: 'CalibriRegular',
            //                                   fontSize: 12.0,
            //                                 ),
            //                               ),
            //                             ],
            //                           ),
            //                         ],
            //                       ),
            //                     )
            //                   : Container(
            //                       height: 45.0,
            //                       width: 45.0,
            //                       decoration: BoxDecoration(
            //                         color: Colors.white,
            //                         borderRadius: BorderRadius.circular(50.0),
            //                       ),
            //                       child: Center(
            //                         child: FaIcon(
            //                           FontAwesomeIcons.userAlt,
            //                           color: PrimaryColor,
            //                         ),
            //                       ),
            //                     ),
            //               user.userData.isEmpty
            //                   ? Container(
            //                       child: Row(
            //                         children: <Widget>[
            //                           Container(
            //                             height: 35.0,
            //                             decoration: BoxDecoration(
            //                               color: Colors.white,
            //                               borderRadius:
            //                                   BorderRadius.circular(5.0),
            //                             ),
            //                             child: FlatButton(
            //                               onPressed: () {
            //                                 Navigator.push(
            //                                   context,
            //                                   MaterialPageRoute(
            //                                     builder: (context) =>
            //                                         SigninScreen(),
            //                                   ),
            //                                 );
            //                               },
            //                               splashColor: PrimaryColor,
            //                               child: Text(
            //                                 AppTranslations.of(context)
            //                                     .text('login'),
            //                                 style: TextStyle(
            //                                   fontFamily: 'CalibriRegular',
            //                                   fontSize: 12.0,
            //                                   color: PrimaryColor,
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                           SizedBox(
            //                             width: 10.0,
            //                           ),
            //                           Container(
            //                             height: 35.0,
            //                             decoration: BoxDecoration(
            //                               border: Border.all(
            //                                 color: Colors.white,
            //                                 width: 1.0,
            //                               ),
            //                               borderRadius:
            //                                   BorderRadius.circular(5.0),
            //                             ),
            //                             child: FlatButton(
            //                               onPressed: () {
            //                                 Navigator.push(
            //                                   context,
            //                                   MaterialPageRoute(
            //                                     builder: (context) =>
            //                                         SignupScreen(),
            //                                   ),
            //                                 );
            //                               },
            //                               splashColor: Colors.white,
            //                               child: Text(
            //                                 AppTranslations.of(context)
            //                                     .text('signup'),
            //                                 style: TextStyle(
            //                                   fontFamily: 'CalibriRegular',
            //                                   fontSize: 12.0,
            //                                   color: Colors.white,
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                     )
            //                   : Container(),
            //             ],
            //           ),
            //         ),
            //       )
            //     : PreferredSize(
            //         preferredSize: Size.fromHeight(0),
            //         child: Container(),
            //       ),
          );
        }),
      ),
      body: IndexedStack(
        index: currentTabIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: GradientBottomNavigationBar(
        backgroundColorStart: PrimaryColor,
        backgroundColorEnd: SecondaryColor,
        fixedColor: TabActiveColor,
        type: BottomNavigationBarType.fixed,
        onTap: onTapped,
        currentIndex: currentTabIndex,
        items: [
          BottomNavigationBarItem(
            activeIcon: Icon(
              CustomIcons.home,
              size: 22.0,
            ),
            icon: Icon(
              CustomIcons.home,
              size: 22.0,
            ),
            title: Text(
              AppTranslations.of(context).text('home'),
              style: TextStyle(
                fontSize: 12.0,
                fontFamily: "CalibriRegular",
              ),
            ),
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              CustomIcons.th_large,
              size: 22.0,
            ),
            icon: Icon(
              CustomIcons.th_large,
              size: 22.0,
            ),
            title: Text(
              AppTranslations.of(context).text('categories'),
              style: TextStyle(
                fontSize: 12.0,
                fontFamily: "CalibriRegular",
              ),
            ),
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(CustomIcons.local_mall),
            icon: Icon(CustomIcons.local_mall),
            title: Text(
              AppTranslations.of(context).text('mall'),
              style: TextStyle(
                fontSize: 12.0,
                fontFamily: "CalibriRegular",
              ),
            ),
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              CustomIcons.notifications,
              size: 26.0,
            ),
            icon: Icon(
              CustomIcons.notifications,
              size: 26.0,
            ),
            title: Text(
              AppTranslations.of(context).text('notifications'),
              style: TextStyle(
                fontSize: 12.0,
                fontFamily: "CalibriRegular",
              ),
            ),
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(CustomIcons.user_1),
            icon: Icon(CustomIcons.user_1),
            title: Text(
              AppTranslations.of(context).text('me'),
              style: TextStyle(
                fontSize: 12.0,
                fontFamily: "CalibriRegular",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
