import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Helper/sharedPref.dart';

Future listCartApi() async {
  var idd = await getSharedPrefrence(ID);
  print("userID: " + idd);
  print(baseUrl + chkCoupon1 + idd + chkCoupon2 + idd);

  final response = await http.get(
    Uri.parse(baseUrl + chkCoupon1 + idd + chkCoupon2 + idd),
    // headers: {"Content-Type": "application/json"}, body: json
  );
  var convertDataToJson;

  if (response.statusCode == 200) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = 0;
    print("``````````````````" + response.body + "````````````````````````");
  }
  return convertDataToJson;
}
