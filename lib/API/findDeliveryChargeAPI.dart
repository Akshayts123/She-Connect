import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';

Future findDeliveryChargeAPI(pin, vendorID) async {
  // print(baseUrl +
  //     deliveryCharge +
  //     pin.toString() +
  //     deliveryCharge2 +
  //     vendorID.toString());
  // print("``````````````````");

  final response = await http.get(
    Uri.parse(baseUrl + deliveryCharge + pin + deliveryCharge2 + vendorID),
    headers: {"accept": "*/*"},
  );
  var convertDataToJson;

  if (response.statusCode == 200) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = jsonDecode(response.body.toString());
  }
  return convertDataToJson;
}
