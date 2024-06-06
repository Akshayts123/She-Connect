import 'package:flutter/material.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/TextConst.dart';

import '../Const/network.dart';

class PostHome extends StatefulWidget {
  final posts;
  const PostHome({Key? key, this.posts}) : super(key: key);

  @override
  _PostHomeState createState() => _PostHomeState();
}

class _PostHomeState extends State<PostHome> {
  var arrPosts;
  var load = true;
  @override
  void initState() {
    super.initState();
    this.getHome();
    setState(() {
      load = false;
    });
  }

  Future<String> getHome() async {
    var rsp = widget.posts;
    arrPosts = rsp;
    setState(() {});
    return "success";
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 600) {
        return Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Container(
            height: 250,
            color: Colors.black,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => w(10),
              shrinkWrap: true,
              itemCount: arrPosts != null && arrPosts.length <= 4
                  ? arrPosts.length
                  : 4,
              itemBuilder: (context, index) {
                final item = arrPosts != null ? arrPosts[index] : null;
                return PostList(item, index);
              },
            ),
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.35,
            // width: MediaQuery.of(context).size.width * 0.,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => w(20),
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) {
                return PostListTablet(index);
              },
            ),
          ),
        );
      }
    });
  }

  PostList(var item, int index) {
    return Stack(
      children: [
        Container(
          height: 250,
          width: 179,
          // height: MediaQuery.of(context).size.height * 0.4,
          // width: MediaQuery.of(context).size.width * 0.40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black,
              border: Border.all(color: Colors.white30),
              image: DecorationImage(
                  image: NetworkImage(
                    baseUrl + "social-media/" + item["thumbImage"].toString(),
                  ),
                  fit: BoxFit.cover)),
        ),
        Positioned(
          top: 15,
          left: 10,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 15,
                backgroundImage: NetworkImage(
                    baseUrl + "vendor/" + item["vendor"]["image"].toString()),
              ),
              w(5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 130,
                    child: Text(
                      item["vendor"]["name"].toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: size12_700W,
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  PostListTablet(int index) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.33,
          width: MediaQuery.of(context).size.width * 0.25,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: liteGrey,
              border: Border.all(color: Colors.black12),
              image: const DecorationImage(
                  image: NetworkImage(
                    tstImg2,
                  ),
                  fit: BoxFit.cover)),
        ),
        Positioned(
          top: 15,
          left: 10,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 15,
                backgroundColor: liteGrey,
                backgroundImage: NetworkImage(PersonImg),
              ),
              w(5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: Text(
                      "New Garments Store ",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: size12_700W,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: Text(
                      "2 days ago",
                      maxLines: 1,
                      style: size12_400W,
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
