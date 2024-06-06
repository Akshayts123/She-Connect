import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Helper/sharedPref.dart';
import 'package:she_connect/Helper/snackbar_toast_helper.dart';

Future readBlogAPI(prdID) async {
  var idd = await getSharedPrefrence(TOKEN);
  print("blog id: " + prdID);
  final response = await http.get(
    Uri.parse(baseUrl + readBlog + prdID),
    headers: {"accept": "*/*", 'Authorization': 'Bearer ' + idd},
  );
  var convertDataToJson;

  if (response.statusCode == 200) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = 0;
    showToastError("Something went wrong!");
    print("____________________" + response.body + "____________________");
  }
  return convertDataToJson;
}
