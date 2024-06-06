import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Helper/snackbar_toast_helper.dart';
import 'package:she_connect/MainWidgets/loading.dart';
import 'package:she_connect/Screens/Posts/DATA/addPostLikeAPI.dart';
import 'package:she_connect/Screens/Posts/DATA/viewSinglePostComment_api.dart';
import 'package:she_connect/Screens/Posts/DATA/viewSinglePostDetails.dart';
import 'package:she_connect/Widgets/imageViewer.dart';

import 'DATA/AddCommentSocialMedia_API.dart';

class ViewPostComments extends StatefulWidget {
  final postId;
  final image;
  final full;

  final Function refresh;
  const ViewPostComments(
      {Key? key, this.postId, required this.refresh, this.image, this.full})
      : super(key: key);

  @override
  _ViewPostCommentsState createState() => _ViewPostCommentsState();
}

class _ViewPostCommentsState extends State<ViewPostComments> {
  bool enableBttn = false;
  var arrData;
  var arrComments;
  var load = true;
  var FinalDateFormat;
  var formatted;
  bool bttnLoad = false;

  @override
  void initState() {
    super.initState();
    this.getComments();
    setState(() {});
  }

  TextEditingController commentController = new TextEditingController();

  Future<String> reload() async {
    var rsp = await SinglePostDetailAPI(widget.postId);
    if (rsp["status"].toString() == "success") {
      setState(() {
        arrData = rsp["data"];
      });
    }
    return "success";
  }

  Future<String> getComments() async {
    var rsp = await SinglePostComment(widget.postId);
    if (rsp["status"].toString() == "success") {
      setState(() {
        arrComments = rsp["data"]["lists"];
        for (var i = 0; i < arrComments.length; i++) {
          setState(() {
            var date = arrComments[i]["createdAt"];
            var parsedDate = DateTime.parse(date);
            var fr2 = DateFormat.MMMM().format(parsedDate);
            FinalDateFormat = "${parsedDate.day}-$fr2-${parsedDate.year}";
            formatted = FinalDateFormat;
          });
        }
      });
    }

    setState(() {
      load = false;
    });
    return "success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
                widget.refresh();
              },
              icon:
                  const Icon(Icons.arrow_back, color: Colors.black, size: 18))),
      body: load == true
          ? Container(color: Colors.white, child: loading())
          : Stack(
              children: [
                Scrollbar(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(baseUrl +
                                    "vendor/" +
                                    widget.full["vendor"]["image"].toString()),
                                radius: 15,
                              ),
                              w(10),
                              Expanded(
                                child: Text(
                                  widget.full["vendor"]["name"].toString(),
                                  style: size12_700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AspectRatio(
                          aspectRatio: 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ImageViewer(
                                            img: baseUrl +
                                                "social-media/" +
                                                widget.image.toString(),
                                          )),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(baseUrl +
                                            "social-media/" +
                                            widget.image.toString()),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.black12)),
                                // height: MediaQuery.of(context).size.height * 0.5,
                                width: MediaQuery.of(context).size.width * 0.9,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                            children: [
                              Text(widget.full["description"].toString(),
                                  style: size14_600),
                            ],
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 20, vertical: 10),
                        //   child: Row(
                        //     children: [
                        //       likeButton(item: widget.full, refresh: reload),
                        //       w(5),
                        //       Text(
                        //           widget.full["likeCount"].toString() +
                        //               " likes",
                        //           style: size12_400),
                        //       Spacer(),
                        //       const Icon(
                        //         Icons.share_outlined,
                        //         color: Colors.black,
                        //         size: 25,
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        Divider(
                          color: Colors.black54,
                          endIndent: 20,
                          indent: 20,
                        ),
                        arrComments.length == 0
                            ? Container(
                                child: Center(
                                  child: Text(
                                    "No comments available!",
                                    style: size14_600,
                                  ),
                                ),
                              )
                            : Comments(),
                        h(50)
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 50,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage:
                                AssetImage("assets/Images/Icons/profile.png"),
                            radius: 12,
                          ),
                          w(10),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextFormField(
                                  cursorColor: Colors.black54,
                                  controller: commentController,
                                  showCursor: true,
                                  onChanged: (v) {
                                    if (commentController.text.length >= 1) {
                                      setState(() {
                                        enableBttn = true;
                                      });
                                    }
                                  },
                                  autofocus: false,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                        fontSize: 14, color: Colors.black87),
                                    hintText: "Add your comment..",
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          enableBttn == true
                              ? GestureDetector(
                                  onTap: () async {
                                    if (commentController.text.length >= 1) {
                                      setState(() {
                                        bttnLoad = true;
                                      });
                                      var rsp = await AddCommentsSocialMedia(
                                        widget.postId,
                                        commentController.text.toString(),
                                      );
                                      print(rsp);
                                      if (rsp["status"].toString() ==
                                          "success") {
                                        setState(() {
                                          bttnLoad = false;
                                        });
                                        showToastSuccess("Comment posted!");
                                        getComments();
                                        commentController.clear();
                                        enableBttn = false;
                                      }
                                    } else {
                                      showToastSuccess(
                                          "Please write a comment to continue.");
                                    }
                                  },
                                  child: bttnLoad == true
                                      ? SizedBox(
                                          child: CircularProgressIndicator(),
                                          height: 15,
                                          width: 15,
                                        )
                                      : Text(
                                          "Post",
                                          style: size14_600,
                                        ),
                                )
                              : Text(
                                  "Post",
                                  style: size14_400Grey,
                                )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
      // bottomNavigationBar: Container(
      //   height: 50,
      //   color: Colors.grey[900],
      //   child: Padding(
      //     padding: const EdgeInsets.only(left: 20),
      //     child: Row(
      //       children: [
      //         const CircleAvatar(
      //           backgroundImage: NetworkImage(PersonImg),
      //           radius: 12,
      //         ),
      //         w(10),
      //         Expanded(
      //           child: Container(
      //             decoration: BoxDecoration(
      //                 color: Colors.grey[900],
      //                 borderRadius: BorderRadius.circular(10)),
      //             child: Padding(
      //               padding: const EdgeInsets.symmetric(horizontal: 20),
      //               child: TextFormField(
      //                 cursorColor: Colors.white54,
      //                 showCursor: true,
      //                 autofocus: false,
      //                 style:
      //                     TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      //                 decoration: const InputDecoration(
      //                   border: InputBorder.none,
      //                   hintStyle:
      //                       TextStyle(fontSize: 14, color: Colors.white70),
      //                   hintText: "Comment as..",
      //                   focusedBorder: InputBorder.none,
      //                   enabledBorder: InputBorder.none,
      //                   errorBorder: InputBorder.none,
      //                   disabledBorder: InputBorder.none,
      //                 ),
      //               ),
      //             ),
      //           ),
      //         )
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  Comments() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) => const SizedBox(
          height: 20,
        ),
        shrinkWrap: true,
        itemCount: arrComments != null ? arrComments.length : 0,
        itemBuilder: (context, index) {
          final item = arrComments != null ? arrComments[index] : null;
          return CommentsList(item, index);
        },
      ),
    );
  }

  CommentsList(var item, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(
              chatImageBaseUrlUser + item["user"]["imageUrl"].toString()),
          radius: 15,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item["user"]["name"].toString(),
                style: size12_700,
              ),
              Text(item["comment"].toString(), style: size12_400),
              Text(formatted.toString(), style: size12_400)
            ],
          ),
        )
      ],
    );
  }
}

class likeButton extends StatefulWidget {
  final item;
  final Function refresh;
  const likeButton({Key? key, this.item, required this.refresh})
      : super(key: key);

  @override
  _likeButtonState createState() => _likeButtonState();
}

class _likeButtonState extends State<likeButton> {
  var tap = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          tap = true;
        });
        if (widget.item["isLiked"] == false) {
          var rsp = await addPostLikeAPI(widget.item["_id"].toString());
          if (rsp["status"].toString() == "success") {
            print(rsp);
            widget.refresh();
            setState(() {
              tap = false;
            });
          }
        } else {
          var rsp = await unlikePostAPI(widget.item["_id"].toString());
          if (rsp["status"].toString() == "success") {
            print(rsp);

            setState(() {
              tap = false;
            });
            widget.refresh();
          }
        }
      },
      child: tap == true
          ? SpinKitPumpingHeart(color: Colors.red, size: 24)
          : Icon(
              widget.item["isLiked"] == true
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: widget.item["isLiked"] == true ? Colors.red : Colors.black,
            ),
    );
  }
}
