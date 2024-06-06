import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';

Future singleVendorPostsAPI(vID) async {
  print(baseUrl + viewSingleVendorPosting + vID);

  final response = await http.get(
    Uri.parse(baseUrl + viewSingleVendorPosting + vID),
    headers: {"Content-Type": "application/json"},
  );
  var convertDataToJson;

  if (response.statusCode == 200) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = 0;
    print("``````````````````" + response.body + "````````````````````````");
  }
  return convertDataToJson;
}
