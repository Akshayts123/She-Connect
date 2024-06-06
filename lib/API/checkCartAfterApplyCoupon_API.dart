import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Helper/sharedPref.dart';

Future checkCartAfterCouponAPI() async {
  var idd = await getSharedPrefrence(ID);

  final json = jsonEncode(<String, dynamic>{'user': idd.toString()});

  final response = await http.get(
    Uri.parse(baseUrl + chkCoupon1 + idd + chkCoupon2 + idd),
    headers: {"Content-Type": "application/json"},
  );
  var convertDataToJson;

  if (response.statusCode == 201) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = jsonDecode(response.body.toString());
  }
  return convertDataToJson;
}
