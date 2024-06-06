import 'package:flutter/material.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/TextConst.dart';
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Screens/Posts/viewSinglePostScreen.dart';
import 'package:she_connect/Screens/Product/ProductDetailsPage.dart';

class ProductsTabVendor extends StatefulWidget {
  final data;
  final posts;

  ProductsTabVendor({Key? key, this.data, this.posts}) : super(key: key);

  @override
  _ProductsTabVendorState createState() => _ProductsTabVendorState();
}

class _ProductsTabVendorState extends State<ProductsTabVendor> {
  @override
  void initState() {
    print(widget.posts);
    super.initState();
  }

  Future<String> vendorPosts() async {
    var rsp = await widget.posts;

    setState(() {
      // load = false;
    });
    return "success";
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, snapshot) {
      if (snapshot.maxWidth < 600) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.data.length > 0
                ? SizedBox(
                    height: 270,
                    child: Scrollbar(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context, index) => w(20),
                          shrinkWrap: true,
                          itemCount:
                              widget.data != null ? widget.data.length : 0,
                          itemBuilder: (context, index) {
                            final item =
                                widget.data != null ? widget.data[index] : null;

                            return ProductItemsList(item, index);
                          },
                        ),
                      ),
                    ),
                  )
                : Opacity(opacity: 0),
            widget.posts.length <= 0
                ? Opacity(opacity: 0)
                : Text("Posts", style: size16_700),
            widget.posts.length <= 0 ? Opacity(opacity: 0) : h(30),
            widget.posts.length > 0
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.45,
                    child: Scrollbar(
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) => w(10),
                        shrinkWrap: true,
                        itemCount:
                            widget.posts != null ? widget.posts.length : 0,
                        itemBuilder: (context, index) {
                          final item =
                              widget.posts != null ? widget.posts[index] : null;
                          return PostList(item, index);
                        },
                      ),
                    ),
                  )
                : Opacity(opacity: 0),
            const Text("Offers", style: size16_700),
            h(30),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.16,
              child: Scrollbar(
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => w(10),
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Offer(index);
                  },
                ),
              ),
            ),
          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Scrollbar(
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => w(10),
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return ProductItemsListTablet(index);
                  },
                ),
              ),
            ),
            const Text("Posts", style: size16_700),
            h(30),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.32,
              child: Scrollbar(
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => w(10),
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return PostListTablet(index);
                  },
                ),
              ),
            ),
            const Text("Offers", style: size16_700),
            h(30),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
              child: Scrollbar(
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => w(10),
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return OfferTablet(index);
                  },
                ),
              ),
            ),
          ],
        );
      }
    });
  }

  PostList(var item, int index) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewPostComments(
                      full: item,
                      postId: item["_id"].toString(),
                      refresh: vendorPosts,
                      image: item["thumbImage"].toString())),
            );
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: liteGrey,
                border: Border.all(color: Colors.black12),
                image: DecorationImage(
                    image: NetworkImage(
                      vendorSocialMediaPostImgBaseURL +
                          item["thumbImage"].toString(),
                    ),
                    fit: BoxFit.cover)),
          ),
        ),
        Positioned(
          top: 15,
          left: 10,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: liteGrey,
                backgroundImage: NetworkImage(
                    baseUrl + "vendor/" + item["vendor"]["image"].toString()),
              ),
              const SizedBox(
                width: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
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
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.22,
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
              const SizedBox(
                width: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: const Text(
                      "New Garments Store",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: size12_700W,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: const Text(
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

  ProductItemsList(var item, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ProductDetailsPage(pID: item["_id"].toString())),
        );
      },
      child: Container(
        width: 178,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 213,
                  width: 178,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black12),
                      image: DecorationImage(
                          image: NetworkImage(
                              productImage + item["image"].toString()),
                          fit: BoxFit.cover)),
                ),
                // const Positioned(
                //   bottom: 15,
                //   right: 10,
                //   child: Icon(
                //     Icons.favorite,
                //     color: Colors.white,
                //   ),
                // ),
                Positioned(
                  bottom: 15,
                  left: 10,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: liteGrey),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 3),
                      child: Row(
                        children: [
                          Text(
                            item["avgRating"].toString(),
                            style: size12_400,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.black,
                            size: 13,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            h(8),
            Text(
              item["name"].toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: size14_400,
            ),
            Row(
              children: [
                Text(
                  rs + item["retailPrice"].toString(),
                  style: size16_400,
                ),
                SizedBox(
                  width: 10,
                ),
                item["listPrice"].toString() == "0"
                    ? Opacity(opacity: 0)
                    : Text(
                        rs + item["listPrice"].toString(),
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.lineThrough),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ProductItemsListTablet(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.2,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black12),
                      image: const DecorationImage(
                          image: NetworkImage(
                            tstImg,
                          ),
                          fit: BoxFit.cover)),
                ),
                // const Positioned(
                //   bottom: 15,
                //   right: 10,
                //   child: Icon(
                //     Icons.favorite,
                //     color: Colors.white,
                //   ),
                // ),
                Positioned(
                  bottom: 15,
                  left: 10,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: liteGrey),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 3),
                      child: Row(
                        children: const [
                          Text(
                            "4.2",
                            style: size12_400,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.black,
                            size: 13,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Text(
              "Bestima Cotton Bedsheeaa ansj abnxsjx xasxbn...",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: size14_700,
            ),
            const Text(
              "Bestima Cotton Bedsheeaa ansj abnxsjx xasxbn...",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: size12_400,
            ),
            Row(
              children: const [
                Text(
                  rs + "399",
                  style: size16_400,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  rs + "699",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.lineThrough),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Offer(int index) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: const EdgeInsets.only(right: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey,
          ),
          color: liteGrey),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Free Delivery on First Order.",
                    style: size14_600,
                  ),
                  Text(
                    "On order over 500/-",
                    style: size12_400Grey,
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Use Code",
                    style: size13_400,
                  ),
                  Text(
                    "FIRSTBUY".toUpperCase(),
                    style: size14_600,
                  ),
                  const Text(
                    "T&C",
                    style: size12_400Grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  OfferTablet(int index) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      margin: const EdgeInsets.only(right: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey,
          ),
          color: liteGrey),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Free Delivery on First Order.",
                    style: size14_600,
                  ),
                  Text(
                    "On order over 500/-",
                    style: size12_400Grey,
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "Use Code",
                    style: size13_400,
                  ),
                  Text(
                    "FIRSTBUY".toUpperCase(),
                    style: size14_600,
                  ),
                  const Text(
                    "T&C",
                    style: size12_400Grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget Heading(String HeadTxt, GestureTapCallback onTapp) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Text(
            HeadTxt,
            style: size16_700,
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              onTapp();
            },
            child: const Text(
              "View All",
              style: size12_400,
            ),
          ),
        ],
      ),
    );
  }
}
