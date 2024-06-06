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

class UploadPost extends StatefulWidget {
  final Function refresh;

  const UploadPost({Key? key, required this.refresh}) : super(key: key);

  @override
  _UploadPostState createState() => _UploadPostState();
}

class _UploadPostState extends State<UploadPost> {
  File? image;
  bool load = true;
  bool isTap = false;

  final _picker = ImagePicker();
  TextEditingController descController = new TextEditingController();
  void enableTap() {
    setState(() {
      isTap = true;
    });
  }

  void disableTap() {
    setState(() {
      isTap = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 18,
            )),
        title: Text(
          "Upload new post",
          style: size16_600W,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                child: image == null
                    ? AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white54)),
                          child: Text(
                            "No Image Selected!",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white54),
                          ),
                          // child: Image.asset(
                          //     "assets/Images/Icons/profile.png"),
                        ),
                      )
                    : load == true
                        ? loading()
                        : AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: Image.file(
                                        File(image!.path).absolute,
                                      ).image)),
                            ),
                          ),
              ),
            ),
            h(10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        print("camera");
                        getImageCam();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.white)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: 15,
                              ),
                              w(10),
                              Text("Camera", style: size12_700W)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  w(15),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        getImage();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.white)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.photo_library_outlined,
                                color: Colors.white,
                                size: 15,
                              ),
                              w(10),
                              Text("Gallery", style: size12_700W)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            h(10),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: size14_600W,
                  controller: descController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  maxLength: 200,
                  textInputAction: TextInputAction.newline,
                  decoration: new InputDecoration(
                      labelText: "Description",
                      labelStyle: size12_700W,
                      alignLabelWithHint: true,
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                        borderSide: new BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: textFieldGrey)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: textFieldGrey, width: 1.0))),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                enableTap();

                print("upladinggg");
                var img = image;
                var stream = new http.ByteStream(img!.openRead());
                stream.cast();
                var length = await img.length();
                var uri = Uri.parse(baseUrl + addSocialMediaPost);
                var request = http.MultipartRequest("POST", uri);
                request.headers.addAll(
                    {'accept': '*/*', 'Content-Type': 'multipart/form-data'});
                var idd = await getSharedPrefrence(ID);
                request.fields["customer"] = idd;
                request.fields["description"] = descController.text.toString();
                request.fields["userType"] = "AppUser";
                var multiport = new http.MultipartFile('file', stream, length,
                    filename: basename(img.path));
                request.files.add(await multiport);
                var rsp = await request.send();
                var rspd = await http.Response.fromStream(rsp);
                final rspData = json.decode(rspd.body);
                print("______________________");
                print(rspData["data"]);
                print("______________________");
                var converted;
                if (rsp.statusCode == 201) {
                  // converted = jsonDecode(rsp.toString());
                  // print();
                  showToastSuccess("Image Uploaded!");
                  print("image uploaded!");
                  widget.refresh();
                  Navigator.pop(context);
                } else {
                  disableTap();

                  print("failed");
                }
                // var rsp = await createPostAPI(
                //   descController.text.toString(),
                // );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      gradient: buttonGradient,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: isTap == true
                        ? SpinKitRing(
                            color: Colors.white,
                            size: 25,
                            lineWidth: 4,
                          )
                        : Text(
                            "Upload",
                            style: size16_700W,
                          ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future getImage() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 100);

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
    final pickedFile =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 100);

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
}
