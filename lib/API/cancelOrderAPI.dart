import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';

Future cancelOrderAPI(id) async {
  final json = jsonEncode(<String, dynamic>{
    'orderId': id.toString(),
  });
  final response = await http.post(Uri.parse(baseUrl + cancelOrder),
      headers: {"Content-Type": "application/json"}, body: json);
  var convertDataToJson;

  if (response.statusCode == 201) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = jsonDecode(response.body.toString());
  }
  return convertDataToJson;
}
