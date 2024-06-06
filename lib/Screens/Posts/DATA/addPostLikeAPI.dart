import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Helper/sharedPref.dart';

Future addPostLikeAPI(pID) async {
  var idd = await getSharedPrefrence(ID);
  final json = jsonEncode(<String, dynamic>{
    'post': pID.toString(),
    'isLiked': true,
    'user': idd.toString(),
  });

  final response = await http.post(Uri.parse(baseUrl + likePost),
      headers: {"Content-Type": "application/json"}, body: json);
  var convertDataToJson;

  if (response.statusCode == 201) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = 0;
    print("`````````````````" + response.body + "```````````````````");
  }
  return convertDataToJson;
}

Future unlikePostAPI(pID) async {
  var idd = await getSharedPrefrence(ID);
  final json = jsonEncode(<String, dynamic>{
    'post': pID.toString(),
    'isLiked': false,
    'user': idd.toString(),
  });

  final response = await http.post(Uri.parse(baseUrl + likePost),
      headers: {"Content-Type": "application/json"}, body: json);
  var convertDataToJson;

  if (response.statusCode == 201) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = 0;
    print("`````````````````" + response.body + "```````````````````");
  }
  return convertDataToJson;
}
