import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Helper/snackbar_toast_helper.dart';

Future productSort_API(id) async {
  print(baseUrl + sortLowToHigh + id + activeCondition);
  final response =
      await http.get(Uri.parse(baseUrl + sortLowToHigh + id + activeCondition));
  var convertDataToJson;

  if (response.statusCode == 200) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = 0;
    showToastError("Something went wrong!");
    print("````````````````````````````````" +
        response.body +
        "````````````````````````````````");
  }
  return convertDataToJson;
}
