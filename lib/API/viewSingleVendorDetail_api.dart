import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';

import '../Helper/sharedPref.dart';

Future singleVendorDetailAPI(id) async {
  var idd = await getSharedPrefrence(ID);

  print(baseUrl + singleVendorDetail + id + "?appUser=" + idd);
  final response = await http.get(
    Uri.parse(baseUrl + singleVendorDetail + id + "?appUser=" + idd),
    headers: {"accept": "*/*"},
  );
  var convertDataToJson;

  if (response.statusCode == 200) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = 0;
    print("```````````````````" + response.body + "````````````````````");
  }
  return convertDataToJson;
}
