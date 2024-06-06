import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Helper/sharedPref.dart';

// var idd;
Future userprofile() async {
  var idd = await getSharedPrefrence(ID);
  print(baseUrl + updateUser + idd);
  var requestUrl = baseUrl + updateUser + idd;
  print(requestUrl);
  var response = await http.get(Uri.parse(requestUrl));
  var convertDataToJson = json.decode(response.body.toString());

  return convertDataToJson;
}
