import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/TextConst.dart';
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Screens/Blog/ReadBlogScreen.dart';

class BlogHome extends StatefulWidget {
  final blogs;
  const BlogHome({Key? key, this.blogs}) : super(key: key);

  @override
  _BlogHomeState createState() => _BlogHomeState();
}

class _BlogHomeState extends State<BlogHome> {
  var arrPosts;
  var load = true;
  var FinalDateFormat;
  var formatted;
  @override
  void initState() {
    super.initState();
    this.getHome();
    setState(() {
      load = false;
    });
  }

  Future<String> getHome() async {
    var rsp = widget.blogs;
    setState(() {
      arrPosts = rsp;
    });
    return "success";
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 600) {
        return Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Container(
            height: 230,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => w(10),
              shrinkWrap: true,
              itemCount: arrPosts != null && arrPosts.length <= 4
                  ? arrPosts.length
                  : 4,
              itemBuilder: (context, index) {
                final item = arrPosts != null ? arrPosts[index] : null;
                return BlogList(item, index);
              },
            ),
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: double.infinity,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => w(20),
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) {
                return BlogListtablet(index);
              },
            ),
          ),
        );
      }
    });
  }

  BlogList(var item, int index) {
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
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 198,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: liteGrey,
                  border: Border.all(color: Colors.black12),
                  image: DecorationImage(
                      image: NetworkImage(baseUrl +
                          "blog" +
                          "/" +
                          item["imagePath"].toString()),
                      fit: BoxFit.cover)),
            ),
            Padding(
              padding: EdgeInsets.only(left: 0, right: 10),
              child: Text(item["description"].toString(),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: size16_400),
            )
          ],
        ),
      ),
    );
  }

  BlogListtablet(int index) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: liteGrey,
                  border: Border.all(color: Colors.black12),
                  image: const DecorationImage(
                      image: NetworkImage(blg), fit: BoxFit.cover)),
            ),
            const Padding(
                padding: EdgeInsets.only(left: 15, right: 10),
                child: Text("How fashion industry became this big?",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: size16_400))
          ]),
    );
  }
}
