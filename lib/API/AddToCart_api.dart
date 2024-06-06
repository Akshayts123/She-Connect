import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Helper/sharedPref.dart';

Future addToCartApi(pID, qty, amt, varientID) async {
  var idd = await getSharedPrefrence(ID);
  final json = jsonEncode(<String, dynamic>{
    'product': pID.toString(),
    'quantity': int.parse(qty.toString()),
    'retailPrice': int.parse(amt.toString()),
    'user': idd.toString(),
    'productVarientId': varientID.toString(),
  });

  final response = await http.post(Uri.parse(baseUrl + addToCart),
      headers: {"Content-Type": "application/json"}, body: json);
  var convertDataToJson;

  if (response.statusCode == 201) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = jsonDecode(response.body.toString());
  }
  return convertDataToJson;
}

Future addToCartApiNovarient(pID, qty, amt) async {
  var idd = await getSharedPrefrence(ID);
  final json = jsonEncode(<String, dynamic>{
    'product': pID.toString(),
    'quantity': int.parse(qty.toString()),
    'retailPrice': int.parse(amt.toString()),
    'user': idd.toString(),
  });
  print(json);
  final response = await http.post(Uri.parse(baseUrl + addToCart),
      headers: {"Content-Type": "application/json"}, body: json);
  var convertDataToJson;

  if (response.statusCode == 201) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = 0;
    print("`````````````````" + response.body + "```````````````````");
  }
  return convertDataToJson;
}
