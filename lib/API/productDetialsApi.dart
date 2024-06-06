import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Helper/snackbar_toast_helper.dart';

import '../Helper/sharedPref.dart';

Future productDetailsApi(prdID) async {
  var idd = await getSharedPrefrence(ID);

  print(
    "product id: " + prdID,
  );
  print(baseUrl + productDetails + prdID + "?appUser=" + idd);
  final response = await http
      .get(Uri.parse(baseUrl + productDetails + prdID + "?appUser=" + idd));
  var convertDataToJson;

  if (response.statusCode == 200) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = 0;
    showToastError("Something went wrong!");
    print("____________________" + response.body + "____________________");
  }
  return convertDataToJson;
}
