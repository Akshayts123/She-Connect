import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';

Future viewFullProductsAPI(id) async {
  print("oxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxox");

  print(baseUrl + fullProducts + id + activeCondition);
  final response = await http.get(
    Uri.parse(baseUrl + fullProducts + id + activeCondition),
    headers: {"accept": "*/*"},
  );
  var convertDataToJson;

  if (response.statusCode == 200) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = 0;
    print("`````````````````````" + response.body + "```````````````````");
  }
  return convertDataToJson;
}
