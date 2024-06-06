import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Helper/snackbar_toast_helper.dart';

Future topRatedVendorsAPI() async {
  final response = await http.get(Uri.parse(baseUrl + topRatedVendors));
  var convertDataToJson;

  if (response.statusCode == 200) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = 0;
    showToastError("Something went wrong!");
    print("``````````````````" + response.body + "````````````````````````");
  }
  return convertDataToJson;
}
