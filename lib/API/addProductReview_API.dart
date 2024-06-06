import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Helper/sharedPref.dart';

Future AddProductReviewAPI(pID, review, rating) async {
  print(pID);
  var idd = await getSharedPrefrence(ID);
  print("userID: " + idd);
  print("prdID: " + pID);
  final json = jsonEncode(<String, dynamic>{
    'product': pID.toString(),
    'user': idd.toString(),
    'review': review.toString(),
    'rating': rating,
  });

  final response = await http.post(Uri.parse(baseUrl + addProductReview),
      headers: {"Content-Type": "application/json"}, body: json);
  var convertDataToJson;

  if (response.statusCode == 201) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = 0;
    print("````````````````````````````````" +
        response.body +
        "````````````````````````````````");
  }
  return convertDataToJson;
}
