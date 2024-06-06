import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Helper/sharedPref.dart';
import 'package:she_connect/Helper/snackbar_toast_helper.dart';

Future palceOrderAPI(address, date, grossAmt, netAmt, discAmt, arrCartNew,
    modeOfPayment, deliveryChrg, coin) async {
  var idd = await getSharedPrefrence(ID);
  final json = jsonEncode({
    'user': idd.toString(),
    'billingAddress': address.toString(),
    'deliveryAddress': address.toString(),
    'date': date,
    'grossAmount': grossAmt.toString(),
    'netAmount': netAmt.toString(),
    'discountAmount': discAmt.toString(),
    'orderStatus': "NEW",
    'paymentStatus': "PAYMENT_PENDING",
    'paymentMode': modeOfPayment,
    'orderDetails': arrCartNew,
    'deliveryCharge': int.parse(deliveryChrg.toString()),
    'hasUsedCoins': coin,
    // 'returnStatus': "REQUESTED",
  });
  print("*******JSON*********");
  print(json);
  print("*******JSON*********");
  final response = await http.post(Uri.parse(baseUrl + placeOrder),
      headers: {"Content-Type": "application/json", "accept": "*/*"},
      body: json);
  var convertDataToJson;

  if (response.statusCode == 201) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = jsonDecode(response.body.toString());
    showToastError("Something went wrong!");
  }
  return convertDataToJson;
}

Future palceOrderWithCouponAPI(address, date, grossAmt, netAmt, discAmt,
    arrCartNew, modeOfPayment, deliveryChrg, coupon, coin) async {
  var idd = await getSharedPrefrence(ID);
  final json = jsonEncode({
    'user': idd.toString(),
    'billingAddress': address.toString(),
    'deliveryAddress': address.toString(),
    'coupon': coupon.toString(),
    'date': date,
    'grossAmount': grossAmt.toString(),
    'netAmount': netAmt.toString(),
    'discountAmount': discAmt.toString(),
    'orderStatus': "NEW",
    'paymentStatus': "PAYMENT_PENDING",
    'paymentMode': modeOfPayment,
    'orderDetails': arrCartNew,
    'hasUsedCoins': coin,
    'deliveryCharge': int.parse(deliveryChrg.toString()),
    // 'returnStatus': "REQUESTED",
  });
  print(json);
  final response = await http.post(Uri.parse(baseUrl + placeOrder),
      headers: {"Content-Type": "application/json", "accept": "*/*"},
      body: json);
  var convertDataToJson;

  if (response.statusCode == 201) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = jsonDecode(response.body.toString());
    showToastError("Something went wrong!");
  }
  return convertDataToJson;
}
