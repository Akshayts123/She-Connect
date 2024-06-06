import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Helper/sharedPref.dart';

Future listAddressAPI() async {
  var idd = await getSharedPrefrence(TOKEN);
  print("token: " + idd);

  final response = await http.get(
    Uri.parse(baseUrl + listAddress),
    headers: {"accept": "*/*", 'Authorization': 'Bearer ' + idd},
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
