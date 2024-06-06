//
// Future registerUserAPI(name, email, mob) async {
//   print(name);
//   print(email);
//   print(mob);
//   final json = {
//     'name': name.toString(),
//     'email': email.toString(),
//     'phone': mob.toString(),
//   };
//
//   final response = await http.post(Uri.parse(baseUrl + register),
//       // headers: {"Content-Type": "application/json"},
//       body: json);
//   var convertDataToJson;
//
//   if (response.statusCode == 201) {
//     convertDataToJson = jsonDecode(response.body.toString());
//   } else {
//     convertDataToJson = 0;
//     var rsp = response.body;
//     showToastError("Please enter a valid email address.");
//     print("````````````````````````````````" +
//         response.body +
//         "````````````````````````````````");
//   }
//   return convertDataToJson;
// }
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';

// var idd;
Future DeleteCartApi(cartID) async {
  print(cartID);

  var requestUrl = baseUrl + deleteCart;
  var response = await http.delete(Uri.parse(requestUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(<String, String>{
        "id": cartID.toString(),
      }));

  var convertDataToJson = json.decode(response.body.toString());
  return convertDataToJson;
}
