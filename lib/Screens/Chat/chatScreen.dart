import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Helper/snackbar_toast_helper.dart';
import 'package:she_connect/MainWidgets/loading.dart';
import 'package:she_connect/Screens/Chat/DATA/closeChat_API.dart';
import 'package:she_connect/Screens/Chat/DATA/getChatsAPI.dart';
import 'package:she_connect/Screens/Chat/viewSelectedImage.dart';
import 'package:she_connect/Widgets/imageViewer.dart';

import 'DATA/newMsgAPI.dart';

class chatScreen extends StatefulWidget {
  final name;
  final subject;
  final from;
  final orderID;
  final chatId;
  final image;
  final Function refresh;
  const chatScreen(
      {Key? key,
      this.name,
      this.subject,
      this.from,
      this.orderID,
      this.chatId,
      required this.refresh,
      this.image})
      : super(key: key);

  @override
  _chatScreenState createState() => _chatScreenState();
}

class _chatScreenState extends State<chatScreen> {
  // var isClosed = false;
  final _picker = ImagePicker();
  File? image;
  TextEditingController msgController = new TextEditingController();
  Timer? timer;
  var FinalDateFormat;
  var formatted;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => getChat());
    this.getChat();
    setState(() {});
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  var arrChat;
  var load = true;
  Future<String> getChat() async {
    var rsp = await getChatsAPI(widget.chatId);
    if (rsp["status"].toString() == "success") {
      arrChat = rsp["data"];
      // print(arrChat[0]["chat"]["status"]);
    }
    setState(() {
      load = false;
    });
    return "success";
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Text(widget.name, style: appBarTxtStyl),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
                widget.refresh();
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 25,
              )),
          actions: [
            IconButton(
                onPressed: () {
                  NewBottomSheet();
                },
                icon: Icon(Icons.info_outline, color: Colors.black, size: 25))
          ],
        ),
        body: load == true
            ? loading()
            : Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      // reverse: true,
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          h(20),
                          ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 15),
                            shrinkWrap: true,
                            itemCount:
                                arrChat.length != null ? arrChat.length : 0,
                            itemBuilder: (context, index) {
                              final item =
                                  arrChat != null ? arrChat[index] : null;

                              return chat(item, index);
                            },
                          ),
                          h(60)
                        ],
                      ),
                    ),
                  ),
                  arrChat[0]["chat"]["status"].toString() == "OPEN"
                      ? Align(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 5, left: 5, right: 5),
                            child: Container(
                              color: Colors.white,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xffE9E9E9),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 0),
                                        child: TextFormField(
                                          cursorColor: Colors.black,
                                          controller: msgController,
                                          keyboardType: TextInputType.multiline,
                                          autofocus: false,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 1),
                                          decoration: new InputDecoration(
                                            border: InputBorder.none,
                                            suffixIcon: IconButton(
                                              icon: Icon(Icons.attach_file),
                                              color: Colors.black,
                                              onPressed: () {
                                                _openImagePicker(context);
                                              },
                                            ),
                                            hintStyle: TextStyle(fontSize: 14),
                                            hintText: "Type your message...",
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  w(5),
                                  GestureDetector(
                                    onTap: () async {
                                      if (msgController.text.isNotEmpty) {
                                        var rsp = await newMsgAPI(
                                            arrChat[0]["chat"]["_id"],
                                            msgController.text.toString());
                                        print(rsp);
                                        setState(() {
                                          msgController.clear();
                                          getChat();
                                        });
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.black45, width: 2)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(Icons.send, size: 18),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          alignment: Alignment.bottomCenter,
                        )
                      : Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              color: Colors.grey[200],
                              // height: 30,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Text(
                                  "This chat has been closed! You can no longer message in this chat.",
                                  style: size14_400Grey,
                                  textAlign: TextAlign.center,
                                ),
                              )),
                        )
                ],
              ),
      ),
    );
  }

  chat(var item, int index) {
    var parsedDate = DateTime.parse(item["createdAt"]);
    var fr2 = DateFormat.MMMM().format(parsedDate);
    FinalDateFormat = "${parsedDate.day} $fr2, ${parsedDate.year}";
    formatted = FinalDateFormat;
    return Row(
      children: [
        item["isCustomer"] == false
            ? CircleAvatar(
                backgroundColor: Colors.grey[200],
                radius: 20,
                backgroundImage: NetworkImage(chatImageBaseUrl +
                    item["chat"]["vendor"]["image"].toString()),
              )
            : Opacity(opacity: 0),
        w(10),
        item["fileType"].toString() == "image/jpeg"
            ? Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImageViewer(
                              img: chatImageBaseUrl + item["file"].toString())),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: item["isCustomer"] == true
                            ? Colors.grey[200]
                            : Colors.white,
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(10)),
                    height: 200,
                    width: 100,
                    child: Image.network(
                        chatImageBaseUrl + item["file"].toString()),
                  ),
                ),
              )
            : Expanded(
                child: Container(
                    decoration: BoxDecoration(
                        color: item["isCustomer"] == true
                            ? Colors.grey[200]
                            : Colors.white,
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(10)),
                    // color: item ? Colors.blue : Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item["message"].toString()),
                          h(5),
                          Row(
                            children: [
                              item["isCustomer"] == true
                                  ? Spacer()
                                  : Opacity(opacity: 0),
                              Text(formatted,
                                  style: TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Segoe',
                                      color: Colors.black)),
                            ],
                          )
                        ],
                      ),
                    )),
              ),
        w(10),
        item["isCustomer"] == true
            ? CircleAvatar(
                backgroundColor: Colors.grey[900],
                radius: 20,
                backgroundImage: NetworkImage(chatImageBaseUrlUser +
                    item["commentedCustomer"]["imageUrl"].toString()),
              )
            : Opacity(opacity: 0)
      ],
    );
  }

  NewBottomSheet() {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context) => Stack(children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    h(20),
                    Row(
                      children: [
                        Text("Subject : ", style: size16_700),
                        Text(widget.subject.toString(), style: size16_400),
                      ],
                    ),
                    h(10),
                    widget.from == "order"
                        ? Row(
                            children: [
                              Text("Order ID : ", style: size16_700),
                              Text("#" + widget.orderID, style: size16_400),
                            ],
                          )
                        : Opacity(opacity: 0),
                    widget.image == true
                        ? ExpansionTile(
                            title:
                                Text("View Attached File", style: size16_700),
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ImageViewer(
                                              img: chatImageBaseUrl +
                                                  arrChat[0]["file"],
                                            )),
                                  );
                                },
                                child: Image.network(
                                    chatImageBaseUrl +
                                        arrChat[0]["file"].toString(),
                                    height: 150,
                                    width: 150),
                              )
                            ],
                            tilePadding: EdgeInsets.zero)
                        : Opacity(opacity: 0),
                    arrChat[0]["chat"]["status"].toString() == "OPEN"
                        ? ElevatedButton(
                            onPressed: () async {
                              var rsp =
                                  await closeChatAPI(widget.chatId.toString());
                              print(rsp);
                              if (rsp["status"].toString() == "CLOSED") {
                                showToastError("Chat Closed!");
                                getChat();
                                Navigator.pop(context);
                              }
                            },
                            child: Text("Close Chat"),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.red, textStyle: size16_600W),
                          )
                        : Opacity(opacity: 0),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                          top: 10),
                    ),
                  ],
                ),
              ),
            ]));
  }

  Future<bool> _onBackPressed() async {
    bool goBack = false;
    Navigator.pop(context);
    await widget.refresh();
    return goBack;
  }

  Future getImage() async {
    final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
        maxWidth: 1000,
        maxHeight: 1000);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => viewSelectedImage(
                image: image, chatID: widget.chatId, refresh: getChat)),
      );
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
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => viewSelectedImage(
                image: image, chatID: widget.chatId, refresh: getChat)),
      );
      // uploadImage();
      setState(() {
        load = false;
      });
    } else {
      print("error");
    }
  }

  Future getVideoCam() async {
    final pickedFile = await _picker.pickVideo(
        source: ImageSource.camera, maxDuration: Duration(seconds: 60));

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
            height: 150,
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Select File",
                  style: size16_700,
                ),
                h(15),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: InkWell(
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
                        ),
                      ),
                    ),
                    w(10),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: InkWell(
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
                        ),
                      ),
                    ),
                  ],
                ),
                // h(15),
                // Row(
                //   children: [
                //     Expanded(
                //       child: Container(
                //         decoration: BoxDecoration(
                //             border: Border.all(color: Colors.black12),
                //             borderRadius: BorderRadius.circular(10)),
                //         child: Padding(
                //           padding: const EdgeInsets.symmetric(
                //               horizontal: 15, vertical: 10),
                //           child: InkWell(
                //             onTap: () async {
                //               getVideo();
                //               Navigator.pop(context);
                //             },
                //             child: Row(
                //               children: <Widget>[
                //                 Icon(
                //                   Icons.video_collection,
                //                   size: 20.0,
                //                   // color: themeColor,
                //                 ),
                //                 Padding(
                //                   padding: EdgeInsets.symmetric(
                //                     horizontal: 10.0,
                //                   ),
                //                 ),
                //                 Text("Video", style: size14_600)
                //               ],
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //     w(10),
                //     Expanded(
                //       child: Container(
                //         decoration: BoxDecoration(
                //             border: Border.all(color: Colors.black12),
                //             borderRadius: BorderRadius.circular(10)),
                //         child: Padding(
                //           padding: const EdgeInsets.symmetric(
                //               horizontal: 15, vertical: 10),
                //           child: InkWell(
                //             onTap: () async {
                //               getVideoCam();
                //               Navigator.pop(context);
                //             },
                //             child: Row(
                //               children: <Widget>[
                //                 Icon(
                //                   Icons.videocam,
                //                   size: 20.0,
                //                   // color: themeColor,
                //                 ),
                //                 Padding(
                //                   padding: EdgeInsets.symmetric(
                //                     horizontal: 10.0,
                //                   ),
                //                 ),
                //                 Text("Video Camera", style: size14_600)
                //               ],
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                // h(15),
                // Row(
                //   children: [
                //     Expanded(
                //       child: Container(
                //         decoration: BoxDecoration(
                //             border: Border.all(color: Colors.black12),
                //             borderRadius: BorderRadius.circular(10)),
                //         child: Padding(
                //           padding: const EdgeInsets.symmetric(
                //               horizontal: 15, vertical: 10),
                //           child: InkWell(
                //             onTap: () async {
                //               getVideoCam();
                //               Navigator.pop(context);
                //             },
                //             child: Row(
                //               children: <Widget>[
                //                 Icon(
                //                   Icons.keyboard_voice,
                //                   size: 20.0,
                //                   // color: themeColor,
                //                 ),
                //                 Padding(
                //                   padding: EdgeInsets.symmetric(
                //                     horizontal: 10.0,
                //                   ),
                //                 ),
                //                 Text("Audio", style: size14_600)
                //               ],
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //     Expanded(child: SizedBox())
                //   ],
                // ),
              ],
            ),
          );
        });
  }
}
