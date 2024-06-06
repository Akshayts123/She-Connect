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
import 'package:she_connect/Helper/sharedPref.dart';

// var netAmt;
// var idd;
Future UpdateCartApi(prdID, qty, amt, cartID, netAmt) async {
  print("quantity: " + qty.toString());
  var idd = await getSharedPrefrence(ID);
  var requestUrl = baseUrl + UpdateCart + cartID;
  final json = jsonEncode(<String, dynamic>{
    "product": prdID.toString(),
    'quantity': int.parse(qty.toString()),
    "retailPrice": int.parse(amt.toString()),
    'netAmount': netAmt,
    "user": idd.toString()
  });
  print(json);
  final response = await http.put(Uri.parse(requestUrl),
      headers: {"accept": "*/*", "Content-Type": "application/json"},
      body: json);
  print(netAmt);
  var convertDataToJson;

  if (response.statusCode == 200) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = jsonDecode(response.body.toString());

    // convertDataToJson = 0;
    print(
        "````````````````````" + response.body + "``````````````````````````");
  }
  //
  return convertDataToJson;
}
