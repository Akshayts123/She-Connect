import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Helper/sharedPref.dart';
import 'package:she_connect/MainWidgets/BottomNav.dart';

import 'Login_Register/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          child: Center(
            child: SvgPicture.asset("assets/logo.svg"),
          ),
        ),
        Positioned(
          bottom: 70,
          right: MediaQuery.of(context).size.width * 0.4,
          left: MediaQuery.of(context).size.width * 0.4,
          child: SpinKitThreeBounce(
            color: darkPink,
            size: 25,
          ),
        )
      ],
    ));
  }

  _loadWidget() async {
    var token = await getSharedPrefrence(TOKEN);
    print(token);

    return Timer(const Duration(seconds: 2),
        token != null ? navigationHome : navigationLogin);
  }

  void navigationLogin() {
    print("loginn");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => Login()));
  }

  void navigationHome() {
    print("homepagee");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const BottomNav()),
    );
  }
}
