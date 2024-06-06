import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'SuccessLandingScreen.dart';

class PaymentSuccess extends StatefulWidget {
  final address;
  const PaymentSuccess({Key? key, this.address}) : super(key: key);

  @override
  _PaymentSuccessState createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  @override
  void initState() {
    super.initState();
    _loadWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Lottie.asset('assets/Images/success.json',
              width: 300, repeat: false)),
    );
  }

  _loadWidget() async {
    return Timer(Duration(seconds: 4), navigationHome);
  }

  void navigationHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => SuccessLanding(address: widget.address)),
    );
  }
}
