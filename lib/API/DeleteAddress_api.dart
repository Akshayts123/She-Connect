import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Helper/snackbar_toast_helper.dart';

Future deleteAddressAPI(AddressID) async {
  print("address id: " + AddressID);
  print(baseUrl + deleteAddress);
  final json = {
    'id': AddressID.toString(),
  };

  final response =
      await http.delete(Uri.parse(baseUrl + deleteAddress), body: json);
  var convertDataToJson;

  if (response.statusCode == 200) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = 0;
    showToastError("Something went wrong!");
    print(
        "``````````````````````" + response.body + "````````````````````````");
  }
  return convertDataToJson;
}
