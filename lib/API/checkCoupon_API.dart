import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Helper/sharedPref.dart';

Future checkCouponAPI(code, cartID) async {
  var idd = await getSharedPrefrence(ID);

  final json = jsonEncode(<String, dynamic>{
    'couponCode': code.toString(),
    'userId': idd.toString(),
    'cartId': cartID.toString()
  });
  final response = await http.post(Uri.parse(baseUrl + checkCoupon),
      headers: {"Content-Type": "application/json"}, body: json);
  var convertDataToJson;

  if (response.statusCode == 201) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = jsonDecode(response.body.toString());
  }
  return convertDataToJson;
}
