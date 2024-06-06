import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Helper/sharedPref.dart';

// Future<void> uploadImage() async {
//   var img = image;
//   var stream = new http.ByteStream(img!.openRead());
//   stream.cast();
//
//   var length = await img.length();
//
//   var uri = Uri.parse(baseUrl + "customer-media/image/update");
//   var request = http.MultipartRequest("POST", uri);
//   request.headers
//       .addAll({'accept': '*/*', 'Content-Type': 'multipart/form-data'});
//   var idd = await getSharedPrefrence(ID);
//
//   request.fields["id"] = idd;
//
//   var multiport = new http.MultipartFile("file", stream, length,
//       filename: basename(img.path));
//
//   request.files.add(await multiport);
//
//   var rsp = await request.send();
//   var rspd = await http.Response.fromStream(rsp);
//   final rspData = json.decode(rspd.body);
//   print("______________________");
//   print(rspData);
//   print("______________________");
//   var converted;
//   if (rsp.statusCode == 201) {
//     // converted = jsonDecode(rsp.toString());
//     // print();
//     print("image uploaded!");
//   } else {
//     print("failed");
//   }
// }

Future createPostAPI(desc) async {
  var idd = await getSharedPrefrence(ID);
  print("userID: " + idd);

  final json = jsonEncode(<String, dynamic>{
    'description': desc,
    'userType': "AppUser",
    'customer': idd.toString(),
    'file': "",
  });

  final response = await http.post(Uri.parse(baseUrl + addSocialMediaPost),
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
