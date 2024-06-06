import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Helper/snackbar_toast_helper.dart';

Future generateOTP(num, sign) async {
  print(num);
  final json = {
    'mobileNo': num.toString(),
    'userType': "AppUser",
    'hashValue': sign.toString(),
  };
  print("=================");
  print(json);
  print("=================");

  final response = await http.post(Uri.parse(baseUrl + getOTP), body: json);
  var convertDataToJson;

  if (response.statusCode == 201) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = 0;
    showToastError("Unable to send Otp at this moment please try again later!");
    print("``````````````````" + response.body + "`````````````````");
  }
  return convertDataToJson;
}
