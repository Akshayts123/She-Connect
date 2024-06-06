import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/TextConst.dart';
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/MainWidgets/loading.dart';

import '../../API/listAllBlogs_api.dart';
import 'ReadBlogScreen.dart';

class BlogsScreen extends StatefulWidget {
  const BlogsScreen({Key? key}) : super(key: key);

  @override
  _BlogsScreenState createState() => _BlogsScreenState();
}

class _BlogsScreenState extends State<BlogsScreen> {
  var arrBlogs = [];
  var load = true;
  var FinalDateFormat;
  var formatted;
  @override
  void initState() {
    super.initState();
    this.getPosts();
    setState(() {});
  }

  Future<String> getPosts() async {
    var rsp = await listAllBlogsAPI();
    if (rsp["status"].toString() == "success") {
      setState(() {
        arrBlogs = rsp["data"]["lists"];
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
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back,
                    color: Colors.black, size: 25)),
            title: const Text("Blogs", style: appBarTxtStyl)),
        body: load == true
            ? loading()
            : LayoutBuilder(builder: (context, snapshot) {
                if (snapshot.maxWidth < 600) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Scrollbar(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListView.separated(
                            scrollDirection: Axis.vertical,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 25),
                            shrinkWrap: true,
                            itemCount: arrBlogs != null ? arrBlogs.length : 0,
                            itemBuilder: (context, index) {
                              final item =
                                  arrBlogs != null ? arrBlogs[index] : null;
                              return list(item, index);
                            }),
                      ),
                    ),
                  );
                } else {
                  return Scrollbar(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ListView.separated(
                          scrollDirection: Axis.vertical,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 30),
                          shrinkWrap: true,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return listTab(index);
                          }),
                    ),
                  );
                }
              }));
  }

  list(var item, int index) {
    var parsedDate = DateTime.parse(item["createdAt"]);
    var fr2 = DateFormat.MMMM().format(parsedDate);
    FinalDateFormat = "${parsedDate.day} $fr2, ${parsedDate.year}";
    formatted = FinalDateFormat;
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ReadBlog(id: item["_id"], date: formatted)));
        },
        child: Container(
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: (Colors.grey[300]!),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 1))
                ],
                color: Colors.white,
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(10)),
            child: Column(children: [
              Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      image: DecorationImage(
                          image: NetworkImage(baseUrl +
                              "blog" +
                              "/" +
                              item["imagePath"].toString()),
                          fit: BoxFit.cover))),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item["name"].toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: size16_700),
                        const SizedBox(height: 10),
                        Text(item["description"].toString(),
                            style: size14_400Grey,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 5),
                        Row(children: [
                          Text("Posted on: " + formatted.toString(),
                              style: size12_400Grey),
                          Spacer(),
                          // Text("4 Min Read", style: size12_400Grey)
                        ])
                      ]))
            ])));
  }

  listTab(int index) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ReadBlog()));
        },
        child: Container(
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: (Colors.grey[300]!),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 3))
                ],
                color: Colors.white,
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(10)),
            child: Column(children: [
              Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      image: const DecorationImage(
                          image: NetworkImage(blg), fit: BoxFit.cover))),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Technology has something to say.",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: size16_700),
                        const SizedBox(height: 10),
                        const Text(
                            "This is a sample text which should narrate the brief of the blog content.",
                            style: size14_400Grey,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 5),
                        Row(children: [
                          Text("Posted on 13-Sep-2021", style: size12_400Grey),
                          Spacer(),
                          Text("4 Min Read", style: size12_400Grey)
                        ])
                      ]))
            ])));
  }
}
