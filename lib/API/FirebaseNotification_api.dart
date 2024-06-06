import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';

Future Notification_api(idd, firebaseToken) async {
  print(num);
  final json = {
    'appType': 'Customer',
    'user': idd.toString(),
    'userType': "AppUser",
    'firebaseId': firebaseToken.toString(),
  };

  final response = await http.post(Uri.parse(baseUrl + FirebaseNotification),
      // headers: {"Content-Type": "application/json"},
      body: json);
  var convertDataToJson;

  if (response.statusCode == 201) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = 0;
    print("```````````````````````" + response.body + "````````````````````");
  }
  return convertDataToJson;
}
