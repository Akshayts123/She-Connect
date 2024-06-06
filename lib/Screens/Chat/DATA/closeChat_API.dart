import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';

Future closeChatAPI(id) async {
  print(baseUrl + closeChat + id);

  final json = jsonEncode(<String, dynamic>{
    'status': "CLOSED",
  });

  final response = await http.put(Uri.parse(baseUrl + closeChat + id),
      headers: {"accept": "*/*", 'Content-Type': 'application/json'},
      body: json);
  print(json);
  var convertDataToJson;

  if (response.statusCode == 200) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = jsonDecode(response.body.toString());
    print(
        "`````````````````````" + response.body + "``````````````````````````");
  }
  return convertDataToJson;
}
