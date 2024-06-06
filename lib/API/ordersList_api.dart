import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Helper/sharedPref.dart';

Future listOrdersAPI() async {
  var idd = await getSharedPrefrence(TOKEN);

  print(baseUrl + ordersList);

  final response = await http.get(
    Uri.parse(baseUrl + ordersList),
    headers: {"accept": "*/*", 'Authorization': 'Bearer ' + idd},
  );
  var convertDataToJson;

  if (response.statusCode == 200) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = 0;
    print("`````````````" + response.body + "````````````````");
  }
  return convertDataToJson;
}
