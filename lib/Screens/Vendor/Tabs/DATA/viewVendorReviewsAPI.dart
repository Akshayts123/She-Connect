import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';

Future viewVendorReviewsAPI(vID) async {
  print(baseUrl + viewVendorReviews + vID);

  final response = await http.get(
    Uri.parse(baseUrl + viewVendorReviews + vID),
    headers: {"Content-Type": "application/json"},
  );
  var convertDataToJson;

  if (response.statusCode == 200) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = 0;
    print("``````````````````" + response.body + "````````````````````````");
  }
  return convertDataToJson;
}
