import 'package:badges/badges.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Helper/sharedPref.dart';
import 'package:she_connect/MainScreens/Cart.dart';
import 'package:she_connect/MainScreens/HomePage.dart';
import 'package:she_connect/MainScreens/ProfilePage.dart';
import 'package:she_connect/Screens/Posts/ViewAllPostsScreen.dart';
import 'package:she_connect/testpg.dart';
import '../Screens/DealsExpanded.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  int _currentIndex = 0;
  final GlobalKey _bottomNavigationKey = GlobalKey();

  final List<Widget> viewContainer = [
    const HomePage(),
    const AllPostsScreen(),
    DealsExpanded(back: "yes"),
    const ProfilePage(),
    const Cart(),
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<MyHomePageModel>(builder: (context, model, child) {
      int _counter = model.getCounter();
      return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          body: viewContainer[_currentIndex],
          bottomNavigationBar: SizedBox(
            height: 50,
            child: CustomNavigationBar(
              scaleFactor: 0.5,
              unSelectedColor: Colors.grey,
              strokeColor: darkPink,
              elevation: 0,
              iconSize: 30,
              blurEffect: false,
              selectedColor: darkPink,
              backgroundColor: Colors.white,
              key: _bottomNavigationKey,
              currentIndex: _currentIndex,
              onTap: (index) async {
                SharedPreferences prefrences =
                    await SharedPreferences.getInstance();

                setState(() {
                  _currentIndex = index;
                });
                if (_currentIndex != 2) {
                  prefrences.remove(CATID);
                  prefrences.remove(PRICELOW);
                  prefrences.remove(PRICEHIGH);
                  prefrences.remove(RATING);
                }
              },
              items: [
                CustomNavigationBarItem(
                  icon: Image.asset("assets/bottomIcons/home.png"),
                  selectedIcon: Image.asset("assets/bottomIcons/homeA.png"),
                ),
                CustomNavigationBarItem(
                  icon: Image.asset("assets/bottomIcons/post.png"),
                  selectedIcon: Image.asset("assets/bottomIcons/postA.png"),
                ),
                CustomNavigationBarItem(
                  icon: Image.asset("assets/bottomIcons/offer.png"),
                  selectedIcon: Image.asset("assets/bottomIcons/offerA.png"),
                ),
                CustomNavigationBarItem(
                  icon: Image.asset("assets/bottomIcons/profile.png"),
                  selectedIcon: Image.asset("assets/bottomIcons/profileA.png"),
                ),
                CustomNavigationBarItem(
                  icon: _counter.toString() != "0"
                      ? Badge(
                          badgeContent: Text(
                            _counter.toString(),
                            style: badgeTxt,
                          ),
                          child: Image.asset("assets/bottomIcons/cart.png"))
                      : Image.asset("assets/bottomIcons/cart.png"),
                  selectedIcon: _counter.toString() != "0"
                      ? Badge(
                          badgeContent: Text(
                            _counter.toString(),
                            style: badgeTxt,
                          ),
                          child: Image.asset("assets/bottomIcons/cartA.png"))
                      : Image.asset("assets/bottomIcons/cartA.png"),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Future<bool> _onBackPressed() async {
    bool goBack = false;
    HapticFeedback.mediumImpact();
    if (_currentIndex != 0) {
      if (_currentIndex == 2) {
        print("clear");
        SharedPreferences prefrences = await SharedPreferences.getInstance();

        await prefrences.remove(CATID);
        await prefrences.remove(PRICELOW);
        await prefrences.remove(PRICEHIGH);
        await prefrences.remove(RATING);
      }
      setState(() {
        _currentIndex = 0;
      });
    } else {
      print("Exit?");
      _showDialog();
    }
    return goBack;
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 10,
        title: const Text('Confirm Exit!'),
        titleTextStyle: const TextStyle(
            fontSize: 16,
            letterSpacing: 0.6,
            color: Color(0xff333333),
            fontWeight: FontWeight.bold),
        content: const Text('Are you sure you want to exit?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
