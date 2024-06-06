import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';

Future SinglePostComment(postID) async {
  print("postID: " + postID);
  print(baseUrl + ViewSingleSocialMediaPostComment + postID);

  final response = await http.get(
    Uri.parse(baseUrl + ViewSingleSocialMediaPostComment + postID),
    // headers: {"Content-Type": "application/json"}, body: json
  );
  var convertDataToJson;

  if (response.statusCode == 200) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = 0;
    print(
        "`````````````````````````" + response.body + "`````````````````````");
  }
  return convertDataToJson;
}
