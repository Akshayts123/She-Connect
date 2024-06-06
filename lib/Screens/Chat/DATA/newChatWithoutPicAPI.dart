import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Helper/sharedPref.dart';

Future createNewChatWithoutPicAPI(vendorId, subject, msg) async {
  var idd = await getSharedPrefrence(ID);
  print("userID: " + idd);
  final json = jsonEncode(<String, dynamic>{
    'vendor': vendorId,
    'customer': idd.toString(),
    'subject': subject,
    'status': "OPEN",
    'message': msg,
  });

  final response = await http.post(Uri.parse(baseUrl + "vendors/chat"),
      headers: {"Content-Type": "application/json"}, body: json);
  var convertDataToJson;

  if (response.statusCode == 201) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = jsonDecode(response.body.toString());
    print("``````````````````" + response.body + "``````````````````");
  }
  return convertDataToJson;
}
