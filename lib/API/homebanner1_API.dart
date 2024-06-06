import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';

Future homeBanners1API() async {
  print(baseUrl + homeBannerTop);
  final response = await http.get(
    Uri.parse(baseUrl + homeBannerTop),
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
