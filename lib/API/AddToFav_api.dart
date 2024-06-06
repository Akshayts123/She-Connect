import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Helper/sharedPref.dart';

Future AddToFavAPI(pID) async {
  print(pID);
  var idd = await getSharedPrefrence(ID);

  final json = jsonEncode(<String, dynamic>{
    'type': "PRODUCT",
    'user': idd.toString(),
    'product': pID.toString(),
    "isFavorite": true
  });
  print("==============================");
  print(json);
  print("==============================");
  final response = await http.post(Uri.parse(baseUrl + addFav),
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
