import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:she_connect/API/PlaceOrder_api.dart';
import 'package:she_connect/Helper/sharedPref.dart';
import 'package:she_connect/Helper/snackbar_toast_helper.dart';

import 'PaymentSuccess.dart';

class paymentPageWithCoupon extends StatefulWidget {
  final id;
  final total;
  final phone;
  final email;
  final defaultAddress;
  final date;
  final grossAmt;
  final modeOfPayment;
  final products;
  final coupon;
  final netAmt;
  final delivery;
  final discount;
  final coin;

  paymentPageWithCoupon({
    this.id,
    this.total,
    this.phone,
    this.email,
    this.defaultAddress,
    this.date,
    this.grossAmt,
    this.products,
    this.modeOfPayment,
    this.coupon,
    this.netAmt,
    this.delivery,
    this.discount,
    this.coin,
  });
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<paymentPageWithCoupon> {
  late Razorpay _razorpay;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(child: Center(child: CircularProgressIndicator())),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    openCheckout();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': int.parse(widget.total.toString()) * 100,
      'name': 'SHE CONNECT',
      'description': 'Order Payment - #193',
      'prefill': {
        'contact': widget.phone.toString(),
        'email': widget.email.toString()
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    var rsp = await palceOrderWithCouponAPI(
        widget.defaultAddress,
        widget.date,
        widget.grossAmt,
        widget.netAmt,
        widget.discount,
        widget.products,
        widget.modeOfPayment,
        widget.delivery,
        widget.coupon,
        widget.coin);

    if (rsp["status"].toString() == "success") {
      SharedPreferences prefrences = await SharedPreferences.getInstance();

      await prefrences.remove(COUPON);
      showToastSuccess("Order Placed!");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PaymentSuccess()),
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showToastError("Payment Failed!");
    Navigator.pop(context);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName.toString(),
        toastLength: Toast.LENGTH_SHORT);
    Navigator.pop(context);
  }
}
