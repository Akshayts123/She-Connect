import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Helper/sharedPref.dart';

Future followVendorAPI(vID) async {
  print(vID);
  var idd = await getSharedPrefrence(ID);

  final json = jsonEncode(<String, dynamic>{
    'userId': idd.toString(),
    'vendorId': vID.toString(),
    "isFollowed": true
  });
  print("==============================");
  print(json);
  print("==============================");
  final response = await http.post(Uri.parse(baseUrl + followVendor),
      headers: {"Content-Type": "application/json"}, body: json);
  var convertDataToJson;

  if (response.statusCode == 201) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = 0;
    print("````````````````````````" +
        response.body +
        "`````````````````````````");
  }
  return convertDataToJson;
}

Future unfollowVendorAPI(vID) async {
  print(vID);
  var idd = await getSharedPrefrence(ID);

  final json = jsonEncode(<String, dynamic>{
    'userId': idd.toString(),
    'vendorId': vID.toString(),
    "isFollowed": false
  });
  print("==============================");
  print(json);
  print("==============================");
  final response = await http.post(Uri.parse(baseUrl + followVendor),
      headers: {"Content-Type": "application/json"}, body: json);
  var convertDataToJson;

  if (response.statusCode == 201) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = 0;
    print("````````````````````````" +
        response.body +
        "`````````````````````````");
  }
  return convertDataToJson;
}
