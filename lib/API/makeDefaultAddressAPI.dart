import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Helper/sharedPref.dart';

Future makeDefaultAddressAPI(addressID) async {
  var idd = await getSharedPrefrence(ID);

  var requestUrl = baseUrl + editAddress + addressID;
  var response = await http.put(Uri.parse(requestUrl),
      headers: {"accept": "*/*", "Content-Type": "application/json"},
      body: jsonEncode(
          <String, dynamic>{"user": idd.toString(), 'isDefaultAddress': true}));

  var convertDataToJson = json.decode(response.body.toString());
  return convertDataToJson;
}
