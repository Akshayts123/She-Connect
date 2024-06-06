import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Helper/sharedPref.dart';

Future addCommentBlogs(comment, blogID) async {
  print(blogID);
  var idd = await getSharedPrefrence(ID);

  final json = jsonEncode(<String, dynamic>{
    'comment': comment,
    'customer': idd.toString(),
    'blog': blogID.toString(),
    "isActive": true
  });
  final response = await http.post(Uri.parse(baseUrl + blogAddComment),
      headers: {"Content-Type": "application/json"}, body: json);
  var convertDataToJson;

  if (response.statusCode == 201) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = 0;
    print("`````````````````" + response.body + "`````````````````````");
  }
  return convertDataToJson;
}
