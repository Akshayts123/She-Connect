import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:she_connect/API/listBlogCommentsAPI.dart';
import 'package:she_connect/API/readBlog_api.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/TextConst.dart';
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/MainWidgets/loading.dart';

import '../../API/blogAddComment_API.dart';

class ReadBlog extends StatefulWidget {
  final id;
  final date;
  const ReadBlog({Key? key, this.id, this.date}) : super(key: key);

  @override
  _ReadBlogState createState() => _ReadBlogState();
}

class _ReadBlogState extends State<ReadBlog> {
  TextEditingController commentController = new TextEditingController();

  var arrBlogs;
  var arrComments = [];
  var load = true;
  var cmmntLoad = false;
  var btTap = false;
  var FinalDateFormat;
  var formatted;
  @override
  void initState() {
    super.initState();
    this.readBlog();
    setState(() {});
  }

  Future<String> readBlog() async {
    print("_______BLOGS_______");
    var rsp = await readBlogAPI(widget.id);
    if (rsp["status"].toString() == "success") {
      await getComments();
      setState(() {
        arrBlogs = rsp["data"];
      });
    }
    setState(() {
      load = false;
    });
    return "success";
  }

  Future<String> addComment() async {
    var rsp = await addCommentBlogs(commentController.text, widget.id);
    if (rsp["status"].toString() == "success") {
      await getComments();
      // await getComments();
      // setState(() {
      //   arrBlogs = rsp["data"];
      // });
    }
    setState(() {
      cmmntLoad = false;
      commentTap = false;
      commentController.clear();
    });
    return "success";
  }

  Future<String> getComments() async {
    var rsp = await listBlogCommentsAPI(widget.id);
    if (rsp["status"].toString() == "success") {
      setState(() {
        arrComments = rsp["data"]["lists"];
      });
    }
    setState(() {
      load = false;
    });
    return "success";
  }

  var commentTap = false;
  var cancelTap = false;

  bool isReadmore = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: load == true
          ? Opacity(opacity: 0)
          : Container(
              decoration: const BoxDecoration(
                gradient: buttonGradient,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Share the story",
                    style: size22_600W,
                  ),
                  w(10),
                  const Icon(
                    Icons.share_outlined,
                    color: Colors.white,
                    size: 15,
                  )
                ],
              ),
              height: MediaQuery.of(context).size.height * 0.08,
            ),
      body: load == true
          ? loading()
          : SafeArea(
              child: CustomScrollView(
                slivers: <Widget>[
                  //2
                  SliverAppBar(
                    expandedHeight: MediaQuery.of(context).size.height * 0.4,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image.network(
                        arrBlogs["imagePath"].toString(),
                        fit: BoxFit.cover,
                      ),
                    ),
                    leading: Stack(
                      children: [
                        Align(
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20,
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.black,
                                  size: 25,
                                )),
                          ),
                          alignment: Alignment.center,
                        ),
                      ],
                    ),
                  ),
                  //3
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            arrBlogs["name"].toString(),
                            style: size20_400,
                          ),
                          _gap(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Posted on: " + widget.date.toString(),
                                style: size12_400Grey,
                              ),
                            ],
                          ),
                          _gap(20),
                          Text(arrBlogs["description"].toString()),
                          _gap(10),
                          CommentsSection(),
                          _gap(40),
                          Divider(
                            color: Colors.grey[200],
                            thickness: 10,
                          ),
                          _gap(15),
                          // MoreStories(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  MoreStories() {
    return Column(
      children: [
        const Center(
          child: Text(
            "MORE STORIES",
            style: size16_700,
          ),
        ),
        _gap(30),
        ListView.separated(
          scrollDirection: Axis.vertical,
          separatorBuilder: (context, index) => h(15),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) {
            return moreStoriesList(index);
          },
        )
      ],
    );
  }

  moreStoriesList(int index) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: (Colors.grey[300]!),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
          color: Colors.white,
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
                image: const DecorationImage(
                    image: NetworkImage(blg), fit: BoxFit.cover)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Technology has something to say.",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: size16_700,
                ),
                h(10),
                const Text(
                  "This is a sample text which should narrate the brief of the blog content.",
                  style: size14_400Grey,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: const [
                    Text(
                      "Posted on 13-Sep-2021",
                      style: size12_400Grey,
                    ),
                    Spacer(),
                    Text(
                      "4 Min Read",
                      style: size12_400Grey,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  CommentsSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Expanded(
              child: Divider(
                  color: Colors.black, indent: 10, endIndent: 10, thickness: 1),
            ),
            Text(
              "COMMENTS",
              style: size16_700,
            ),
            Expanded(
              child: Divider(
                  color: Colors.black, indent: 10, endIndent: 10, thickness: 1),
            ),
          ],
        ),
        _gap(10),
        arrComments.length != 0
            ? ListView.separated(
                scrollDirection: Axis.vertical,
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: arrComments != null ? arrComments.length : 0,
                itemBuilder: (context, index) {
                  final item = arrComments != null ? arrComments[index] : null;
                  return CommentsList(item, index);
                },
              )
            : Text("No comments to show. Add new", style: size14_700),
        _gap(10),
        commentTap == true ? addNewComment() : addButton()
      ],
    );
  }

  Widget addNewComment() {
    return Container(
      child: Column(
        children: [
          Container(
            child: TextFormField(
              style: size14_600,
              controller: commentController,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              maxLength: 200,
              textInputAction: TextInputAction.done,
              decoration: new InputDecoration(
                  labelText: "Add your comment",
                  labelStyle: size14_400Grey,
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
                      borderSide:
                          const BorderSide(color: Colors.black12, width: 1.0))),
            ),
          ),
          GestureDetector(
            onTap: () async {
              if (commentController.text.length <= 0) {
                setState(() {
                  commentTap = false;
                });
              } else {
                setState(() {
                  setState(() {
                    cmmntLoad = true;
                  });
                  commentController.text.length <= 0
                      ? commentTap = false
                      : addComment();
                });
              }
            },
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: cmmntLoad == true
                    ? Center(
                        child: SpinKitThreeBounce(
                        color: darkPink,
                        size: 20,
                      ))
                    : Text(
                        commentController.text.length <= 0
                            ? "Cancel"
                            : "Post Comment".toUpperCase(),
                        style: size16_600pink,
                      ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: darkPink)),
            ),
          )
        ],
      ),
    );
  }

  Widget addButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          commentTap = true;
        });
      },
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "ADD COMMENT",
            style: size16_600pink,
          ),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: darkPink)),
      ),
    );
  }

  CommentsList(var item, int index) {
    var parsedDate = DateTime.parse(item["createdAt"]);
    var fr2 = DateFormat.MMMM().format(parsedDate);
    FinalDateFormat = "${parsedDate.day} $fr2, ${parsedDate.year}";
    formatted = FinalDateFormat;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(chatImageBaseUrlUser +
                  item["customer"]["imageUrl"].toString()),
              radius: 18,
            ),
            w(5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["customer"]["name"].toString(),
                  style: size16_700,
                ),
                Text(
                  formatted.toString(),
                  style: size12_400Grey,
                )
              ],
            )
          ],
        ),
        _gap(5),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: buildText(item["comment"].toString()),
        ),
        h(3),
        item["comment"].toString().length >= 60
            ? Row(
                children: [
                  Spacer(),
                  GestureDetector(
                    child: Text(
                      (isReadmore ? 'Read Less' : 'Read More').toUpperCase(),
                      style: size14_600Pink,
                    ),
                    onTap: () {
                      setState(() {
                        isReadmore = !isReadmore;
                      });
                    },
                  ),
                ],
              )
            : Opacity(opacity: 0),
        // TextButton(
        //     onPressed: () {
        //       setState(() {
        //         isReadmore = !isReadmore;
        //       });
        //     },
        //     child: Text((isReadmore ? 'Read Less' : 'Read More')))
      ],
    );
  }

  _gap(double h) {
    return SizedBox(
      height: h,
    );
  }

  Widget buildText(String text) {
    // if read more is false then show only 3 lines from text
    // else show full text
    final lines = isReadmore ? null : 3;
    return Text(
      text,
      style: size16_400,
      maxLines: lines,

      // overflow properties is used to show 3 dot in text widget
      // so that user can understand there are few more line to read.
      overflow: isReadmore ? TextOverflow.visible : TextOverflow.ellipsis,
    );
  }
}
