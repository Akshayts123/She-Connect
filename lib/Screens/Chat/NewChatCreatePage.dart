import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Helper/sharedPref.dart';
import 'package:she_connect/Helper/snackbar_toast_helper.dart';
import 'package:she_connect/MainWidgets/loading.dart';
import 'package:she_connect/Screens/Chat/DATA/newChatWithoutPicAPI.dart';
import 'package:she_connect/Screens/Chat/chatScreen.dart';

class ChatDetailsPage extends StatefulWidget {
  final name;
  final orderID;
  final from;
  final vendorID;
  const ChatDetailsPage(
      {Key? key, this.name, this.orderID, this.from, this.vendorID})
      : super(key: key);

  @override
  _ChatDetailsPageState createState() => _ChatDetailsPageState();
}

class _ChatDetailsPageState extends State<ChatDetailsPage> {
  var imageTap = false;

  TextEditingController subjectController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  final _picker = ImagePicker();
  bool load = true;
  File? image;
  bool btTap = false;

  Future<String> reee() async {
    return "success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 25,
            )),
        title: Text("Contact " + widget.name, style: appBarTxtStyl),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Wrap(
            runSpacing: 15,
            children: [
              widget.from == "order"
                  ? Text("Order ID: " + widget.orderID, style: size14_700)
                  : Opacity(opacity: 0),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextFormField(
                  controller: subjectController,
                  decoration: new InputDecoration(
                    labelText: "Subject",
                    labelStyle: TextStyle(color: Colors.black26, fontSize: 15),
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10),
                      borderSide: new BorderSide(),
                    ),
                  ),
                ),
              ),
              TextFormField(
                maxLines: 4,
                controller: descriptionController,
                decoration: new InputDecoration(
                  labelText: "Description",
                  labelStyle: TextStyle(color: Colors.black26, fontSize: 15),
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                    borderSide: new BorderSide(),
                  ),
                ),
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    _openImagePicker(context);
                    setState(() {
                      imageTap = true;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: darkPink),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      child: Text("Add Attachment", style: size14_600W),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  child: image == null
                      ? Opacity(opacity: 0)
                      : load == true
                          ? const loading()
                          : AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.black54,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: Image.file(
                                          File(image!.path).absolute,
                                        ).image)),
                              ),
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: InkWell(
          onTap: () async {
            btTap = true;
            if (imageTap == false) {
              var rsp = await createNewChatWithoutPicAPI(
                  widget.vendorID.toString(),
                  subjectController.text.toString(),
                  descriptionController.text.toString());
              print(rsp);
              if (rsp["status"].toString() == "OPEN") {
                btTap = false;

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => chatScreen(
                          refresh: reee,
                          chatId: rsp["data"]["_id"],
                          name: widget.name,
                          orderID: widget.orderID,
                          from: widget.from,
                          image: false,
                          subject: subjectController.text.toString())),
                );
              } else {
                print(rsp);
                btTap = false;
                showToastError("Something went wrong!");
                print("failed");
              }
            } else {
              btTap = true;
              var img = image;
              var stream = new http.ByteStream(img!.openRead());
              stream.cast();
              var length = await img.length();

              var uri = Uri.parse(baseUrl + "vendors/chat");
              var request = http.MultipartRequest("POST", uri);
              request.headers.addAll(
                  {'accept': '*/*', 'Content-Type': 'multipart/form-data'});
              var idd = await getSharedPrefrence(ID);

              request.fields["vendor"] = widget.vendorID.toString();
              request.fields["customer"] = idd.toString();
              request.fields["subject"] = subjectController.text.toString();
              request.fields["status"] = "OPEN";
              // request.fields["relatedOrderId"] = orderID.toString();
              request.fields["message"] = descriptionController.text.toString();

              var multiport = new http.MultipartFile("file", stream, length,
                  filename: basename(img.path));
              request.files.add(await multiport);

              var rsp = await request.send();
              var rspd = await http.Response.fromStream(rsp);
              final rspData = json.decode(rspd.body);

              var converted;
              if (rsp.statusCode == 201) {
                btTap = false;
                print(rspData);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => chatScreen(
                          refresh: reee,
                          chatId: rspData["data"]["_id"],
                          name: widget.name,
                          orderID: widget.orderID,
                          from: widget.from,
                          image: true,
                          subject: subjectController.text.toString())),
                );
                print("image uploaded!");
              } else {
                print(rspData);

                btTap = false;
                showToastError("Something went wrong!");
                print("failed");
              }
            }
          },
          child: Container(
            alignment: Alignment.center,
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: darkPink),
            child: btTap == true
                ? Center(
                    child: SpinKitThreeBounce(
                    color: Colors.white,
                    size: 18,
                  ))
                : Text("Submit", style: size16_600W),
          ),
        ),
      ),
    );
  }

  Future getImage() async {
    final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
        maxWidth: 1000,
        maxHeight: 1000);

    if (pickedFile != null) {
      image = File(pickedFile.path);

      // uploadImage();
      setState(() {
        load = false;
      });
    } else {
      print("error");
    }
  }

  Future getVideo() async {
    final pickedFile = await _picker.pickVideo(
        source: ImageSource.gallery, maxDuration: Duration(seconds: 60));

    if (pickedFile != null) {
      image = File(pickedFile.path);

      // uploadImage();
      setState(() {
        load = false;
      });
    } else {
      print("error");
    }
  }

  Future getImageCam() async {
    final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
        maxHeight: 1000,
        maxWidth: 1000);

    if (pickedFile != null) {
      image = File(pickedFile.path);

      // uploadImage();
      setState(() {
        load = false;
      });
    } else {
      print("error");
    }
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Select Image",
                  style: size16_700,
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () async {
                    print("camera");
                    getImageCam();
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.photo_camera,
                        size: 20.0,
                        // color: themeColor,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                      ),
                      Text(
                        "Camera",
                        style: size14_600,
                      ),
                    ],
                  ),
                ),
                h(20),
                InkWell(
                  onTap: () async {
                    getImage();
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.image,
                        size: 20.0,
                        // color: themeColor,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                      ),
                      Text("Gallery", style: size14_600)
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
