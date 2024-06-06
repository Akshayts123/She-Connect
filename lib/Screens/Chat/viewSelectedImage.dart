import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Helper/sharedPref.dart';
import 'package:she_connect/Helper/snackbar_toast_helper.dart';

class viewSelectedImage extends StatefulWidget {
  final image;
  final chatID;
  final Function refresh;
  const viewSelectedImage(
      {Key? key, this.image, this.chatID, required this.refresh})
      : super(key: key);

  @override
  _viewSelectedImageState createState() => _viewSelectedImageState();
}

class _viewSelectedImageState extends State<viewSelectedImage> {
  // File? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.1),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
        ),
      ),
      body: Container(
        // height: MediaQuery.of(context).size.height * 0.3,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.black54,
            image: DecorationImage(
                fit: BoxFit.cover,
                image: Image.file(
                  File(widget.image!.path).absolute,
                ).image)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var img = widget.image;
          var stream = new http.ByteStream(img!.openRead());
          stream.cast();
          var length = await img.length();
          var uri = Uri.parse(baseUrl + "vendors/chatMessage");
          var request = http.MultipartRequest("POST", uri);
          request.headers
              .addAll({'accept': '*/*', 'Content-Type': 'multipart/form-data'});
          var idd = await getSharedPrefrence(ID);
          request.fields["commentedCustomer"] = idd.toString();
          request.fields["chat"] = widget.chatID.toString();
          var multiport = new http.MultipartFile("file", stream, length,
              filename: basename(img.path),
              contentType: MediaType('image', 'jpeg'));
          request.files.add(await multiport);
          var rsp = await request.send();
          var rspd = await http.Response.fromStream(rsp);
          final rspData = json.decode(rspd.body);
          var converted;
          if (rsp.statusCode == 201) {
            widget.refresh();
            Navigator.pop(context);
          } else {
            print(rspData);

            showToastError("Something went wrong!");
            print("failed");
          }
        },
        backgroundColor: darkPink,
        child: Icon(Icons.send),
      ),
    );
  }
}
