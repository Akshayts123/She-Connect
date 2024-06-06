import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';

Future searchAPI(letter) async {
  print(baseUrl + search + letter);
  final response = await http.get(
    Uri.parse(baseUrl + search + letter),
    headers: {"accept": "*/*"},
  );
  var convertDataToJson;

  if (response.statusCode == 200) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = 0;
    print("````````````````````````````````" +
        response.body +
        "````````````````````````````````");
  }
  return convertDataToJson;
}
