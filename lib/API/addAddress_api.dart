import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Helper/sharedPref.dart';

Future addAddressAPI(
    name, phone, locality, city, state, pin, flatNo, landmrk, type, def) async {
  var idd = await getSharedPrefrence(ID);
  print("userID: " + idd);
  final json = jsonEncode(<String, dynamic>{
    'user': idd.toString(),
    'name': name,
    'phoneNo': phone,
    'locality': locality,
    'city': city,
    'state': state,
    'pincode': int.parse(pin.toString()),
    'flatNo': flatNo,
    'nearestLandmark': landmrk,
    'isDefaultAddress': def,
    'typeOfAddress': type.toString(),
    // 'location': "61e7e9ffc18e79258c263f0b",
  });

  final response = await http.post(Uri.parse(baseUrl + addAddress),
      headers: {"Content-Type": "application/json"}, body: json);
  var convertDataToJson;

  if (response.statusCode == 201) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = jsonDecode(response.body.toString());
    print("````````````````````````````````" +
        response.body +
        "````````````````````````````");
  }
  return convertDataToJson;
}
