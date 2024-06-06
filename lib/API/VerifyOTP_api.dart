import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';

Future verifyOTP(num, otp) async {
  print(num);
  print(otp);
  final json = {
    'mobileNo': num.toString(),
    'otpCode': otp.toString(),
  };

  final response = await http.post(Uri.parse(baseUrl + verifyOtp),
      // headers: {"Content-Type": "application/json"},
      body: json);
  var convertDataToJson;

  if (response.statusCode == 201) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = jsonDecode(response.body.toString());
    print("````````````````````" + response.body + "`````````````````````````");
  }
  return convertDataToJson;
}
