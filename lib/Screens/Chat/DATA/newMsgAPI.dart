import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Helper/sharedPref.dart';

Future newMsgAPI(chatID, msg) async {
  var idd = await getSharedPrefrence(ID);
  print("userID: " + idd);
  final json = jsonEncode(<String, dynamic>{
    'commentedCustomer': idd.toString(),
    'chat': chatID.toString(),
    'message': msg.toString(),
  });

  final response = await http.post(Uri.parse(baseUrl + newMessage),
      headers: {"Content-Type": "application/json"}, body: json);
  var convertDataToJson;

  if (response.statusCode == 201) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = jsonDecode(response.body.toString());
    print("```````````````````" + response.body + "````````````````");
  }
  return convertDataToJson;
}
