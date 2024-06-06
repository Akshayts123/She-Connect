import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Helper/sharedPref.dart';

Future AddCommentsSocialMedia(pID, comment) async {
  var idd = await getSharedPrefrence(ID);
  print("postID: " + pID);
  print("userID: " + idd);
  print("comment: " + comment);
  final json = jsonEncode(<String, dynamic>{
    'post': pID,
    'user': idd.toString(),
    'comment': comment.toString(),
  });

  final response = await http.post(Uri.parse(baseUrl + addSocialMediaComment),
      headers: {"Content-Type": "application/json"}, body: json);
  var convertDataToJson;

  if (response.statusCode == 201) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = 0;
    print("`````````````````````" + response.body + "```````````````````````");
  }
  return convertDataToJson;
}
