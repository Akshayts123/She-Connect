import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:she_connect/API/ListAllPosts_api.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/TextConst.dart';
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/MainWidgets/loading.dart';
import 'package:she_connect/Screens/Posts/DATA/addPostLikeAPI.dart';
import 'package:she_connect/Screens/Posts/viewSinglePostScreen.dart';

class AllPostsScreen extends StatefulWidget {
  const AllPostsScreen({Key? key}) : super(key: key);

  @override
  _AllPostsScreenState createState() => _AllPostsScreenState();
}

class _AllPostsScreenState extends State<AllPostsScreen> {
  var arrPosts = [];
  var load = true;
  var FinalDateFormat;
  var formatted;
  bool isGridView = false;
  @override
  void initState() {
    super.initState();
    this.getPosts();
    // initDynamicLinks();
    setState(() {});
  }

  Future<String> getPosts() async {
    print("_______POSTS_______");
    var rsp = await listPostsApi();
    if (rsp["status"].toString() == "success") {
      setState(() {
        arrPosts = rsp["data"]["lists"];
      });
      setState(() {
        load = false;
      });
    }
    return "success";
  }

  bool isLiked = false;
  bool _visible = true;

  sharePost(link) async {
    Share.share("Hey! Check out this post! " + link + "!");
  }

  // Future<void> initDynamicLinks() async {
  //   FirebaseDynamicLinks.instance.onLink(
  //       onSuccess: (PendingDynamicLinkData? dynamicLink) async {
  //     final Uri? deeplink = dynamicLink!.link;
  //
  //     if (deeplink != null) {
  //       handleMyLink(deeplink);
  //     }
  //   }, onError: (OnLinkErrorException e) async {
  //     print("We got error $e");
  //   });
  // }

  void handleMyLink(Uri url) {
    List<String> sepeatedLink = [];

    /// osama.link.page/Hellow --> osama.link.page and Hellow
    sepeatedLink.addAll(url.path.split('/'));

    print("The Token that i'm interesed in is ${sepeatedLink[1]}");
    // Get.to(()=>ProductDetailScreen(sepeatedLink[1]));
  }

  // buildDynamicLinks(String title, String image, String docId) async {
  //   String url = "http://osam.page.link";
  //   final DynamicLinkParameters parameters = DynamicLinkParameters(
  //     uriPrefix: url,
  //     link: Uri.parse('$url/$docId'),
  //     androidParameters: AndroidParameters(
  //       packageName: "com.sheconnect.app",
  //       minimumVersion: 0,
  //     ),
  //     iosParameters: IosParameters(
  //       bundleId: "Bundle-ID",
  //       minimumVersion: '0',
  //     ),
  //     socialMetaTagParameters: SocialMetaTagParameters(
  //         description: '', imageUrl: Uri.parse("$image"), title: title),
  //   );
  //   final ShortDynamicLink dynamicUrl = await parameters.buildShortLink();
  //
  //   String? desc = '${dynamicUrl.shortUrl.toString()}';
  //
  //   await Share.share(
  //     desc,
  //     subject: title,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        // leading: IconButton(
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //     icon: const Icon(
        //       Icons.arrow_back,
        //       color: Colors.white,
        //       size: 18,
        //     )),
        actions: [
          isGridView == true
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isGridView = false;
                    });
                  },
                  icon: Icon(CupertinoIcons.list_bullet_below_rectangle))
              : IconButton(
                  onPressed: () {
                    setState(() {
                      isGridView = true;
                    });
                  },
                  icon: Icon(CupertinoIcons.square_grid_2x2_fill))
        ],
        title: const Text(
          "POSTS",
          style: appBarTxtStyl,
        ),
      ),
      body: load == true
          ? Container(color: Colors.white, child: loading())
          : arrPosts.length == 0
              ? Center(
                  child: Text(
                    "No posts available!",
                    style: size14_600,
                  ),
                )
              : LayoutBuilder(builder: (context, snapshot) {
                  if (snapshot.maxWidth < 600) {
                    return Scrollbar(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: isGridView ? PostGridView() : postListView(),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.15,
                      ),
                      child: Scrollbar(
                        child: ListView.separated(
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 30,
                          ),
                          shrinkWrap: true,
                          itemCount: arrPosts != null ? arrPosts.length : 0,
                          itemBuilder: (context, index) {
                            final item =
                                arrPosts != null ? arrPosts[index] : null;
                            return PostListTablet(item, index);
                          },
                        ),
                      ),
                    );
                  }
                }),
    );
  }

  postListView() {
    return RefreshIndicator(
      onRefresh: getPosts,
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (context, index) => const SizedBox(
          height: 30,
        ),
        shrinkWrap: true,
        itemCount: arrPosts != null ? arrPosts.length : 0,
        itemBuilder: (context, index) {
          final item = arrPosts != null ? arrPosts[index] : null;
          return PostList(item, index);
        },
      ),
    );
  }

  PostList(var item, int index) {
    var parsedDate = DateTime.parse(item["createdAt"]);
    var fr2 = DateFormat.MMMM().format(parsedDate);
    FinalDateFormat = "${parsedDate.day} $fr2, ${parsedDate.year}";
    formatted = FinalDateFormat;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ViewPostComments(
                  full: item,
                  postId: item["_id"].toString(),
                  refresh: getPosts,
                  image: item["thumbImage"].toString())),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              item["vendor"] == null
                  ? CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[300],
                    )
                  : CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      backgroundImage: NetworkImage(baseUrl +
                          "vendor/" +
                          item["vendor"]["image"].toString()),
                      radius: 20,
                    ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: item["vendor"] == null
                    ? Text("aaa")
                    : Text(item["vendor"]["name"].toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: size12_700),
              )
            ],
          ),
          _gap(20),
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black12),
                  image: DecorationImage(
                      image: NetworkImage(baseUrl +
                          "social-media/" +
                          item["thumbImage"].toString()),
                      fit: BoxFit.cover)),
            ),
          ),
          _gap(10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                likeButton(item: item, refresh: getPosts),
                w(10),
                Text(
                  item["likeCount"].toString() + " likes",
                  style: size12_400,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewPostComments(
                              full: item,
                              postId: item["_id"].toString(),
                              refresh: getPosts,
                              image: item["thumbImage"].toString())),
                    );
                  },
                  child: const Icon(
                    Icons.messenger_outline,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                GestureDetector(
                  onTap: () {
                    sharePost(item["sharePost"]);
                  },
                  child: const Icon(
                    Icons.share_outlined,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          _gap(5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["description"].toString(),
                  style: size14_600,
                ),
                _gap(5),
                Text(
                  item["commentCount"].toString() + " comments",
                  style: size12_400Grey,
                ),
                _gap(5),
                Text(
                  formatted.toString(),
                  style: size12_400Grey,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  PostGridView() {
    return RefreshIndicator(
      onRefresh: getPosts,
      child: GridView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: arrPosts != null ? arrPosts.length : 0,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 10,
            childAspectRatio: 0.45),
        itemBuilder: (BuildContext context, int index) {
          final item = arrPosts != null ? arrPosts[index] : null;
          return PostGrid(item, index);
        },
      ),
    );
  }

  PostGrid(var item, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ViewPostComments(
                  full: item,
                  postId: item["_id"].toString(),
                  refresh: getPosts,
                  image: item["thumbImage"].toString())),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  backgroundImage: NetworkImage(
                      baseUrl + "vendor/" + item["vendor"]["image"].toString()),
                  radius: 20),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  item["vendor"]["name"].toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: size12_700,
                ),
              )
            ],
          ),
          _gap(20),
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black12),
                  image: DecorationImage(
                      image: NetworkImage(baseUrl +
                          "social-media/" +
                          item["thumbImage"].toString()),
                      fit: BoxFit.cover)),
            ),
          ),
          _gap(10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                likeButton(item: item, refresh: getPosts),
                w(10),
                Text(
                  item["likeCount"].toString() + " likes",
                  style: size12_400,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewPostComments(
                              full: item,
                              postId: item["_id"].toString(),
                              refresh: getPosts,
                              image: item["thumbImage"].toString())),
                    );
                  },
                  child: const Icon(
                    Icons.messenger_outline,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                GestureDetector(
                  onTap: () {
                    sharePost(item["sharePost"]);
                  },
                  child: const Icon(
                    Icons.share_outlined,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          _gap(5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["description"].toString(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: size14_600,
                ),
                _gap(5),
                Text(
                  item["commentCount"].toString() + " comments",
                  style: size12_400Grey,
                ),
                _gap(5),
                Text(
                  formatted.toString(),
                  style: size12_400Grey,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  PostListTablet(var item, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            CircleAvatar(
              backgroundImage: NetworkImage(PersonImg),
              radius: 20,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "New Garments Store",
              style: size12_700,
            )
          ],
        ),
        _gap(20),
        GestureDetector(
          onDoubleTap: () {
            setState(() {
              isLiked = !isLiked;
            });
          },
          child: Center(
            child: Container(
              height: 450,
              width: 450,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white54),
                  image: DecorationImage(
                      image: NetworkImage(baseUrl +
                          "social-media/" +
                          item["thumbImage"].toString()),
                      fit: BoxFit.cover)),
            ),
          ),
        ),
        _gap(20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.red : Colors.black,
                size: 30,
              ),
              const SizedBox(
                width: 10,
              ),
              const Text(
                "12 likes",
                style: size14_600,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewPostComments(
                            full: item,
                            postId: item["_id"].toString(),
                            refresh: getPosts,
                            image: item["thumbImage"].toString())),
                  );
                },
                child: const Icon(
                  Icons.messenger_outline,
                  color: Colors.black,
                  size: 30,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              const Icon(
                Icons.share_outlined,
                color: Colors.black,
                size: 30,
              ),
            ],
          ),
        ),
        _gap(5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item["description"].toString(),
                style: size16_700,
              ),
              _gap(5),
              const Text(
                "View all 10 comments",
                style: size14_400Grey,
              ),
              _gap(5),
              const Text(
                "1 day ago",
                style: size12_400Grey,
              ),
            ],
          ),
        )
      ],
    );
  }

  _gap(double h) {
    return SizedBox(
      height: h,
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
            widget.refresh();
            setState(() {
              tap = false;
            });
          }
        } else {
          var rsp = await unlikePostAPI(widget.item["_id"].toString());
          if (rsp["status"].toString() == "success") {
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
