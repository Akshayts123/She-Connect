import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Helper/sharedPref.dart';

Future orderTrackingAPI(orderID) async {
  var idd = await getSharedPrefrence(ID);
  // print(baseUrl + orderTracking1 + idd + orderTracking2 + orderID);

  final response = await http.get(
    Uri.parse(baseUrl + orderTracking1 + idd + orderTracking2 + orderID),
    headers: {"accept": "*/*"},
  );
  var convertDataToJson;

  if (response.statusCode == 200) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = jsonDecode(response.body.toString());
  }
  return convertDataToJson;
}
