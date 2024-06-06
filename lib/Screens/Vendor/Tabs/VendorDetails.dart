import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:she_connect/API/vendorProductDetail_API.dart';
import 'package:she_connect/API/viewSingleVendorDetail_api.dart';
import 'package:she_connect/API/viewVendorOffersAPI.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/TextConst.dart';
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Helper/snackbar_toast_helper.dart';
import 'package:she_connect/MainWidgets/loading.dart';
import 'package:she_connect/Screens/Chat/NewChatCreatePage.dart';
import 'package:she_connect/Screens/Posts/viewSinglePostScreen.dart';
import 'package:she_connect/Screens/Product/ProductDetailsPage.dart';
import 'package:she_connect/Screens/Vendor/Tabs/DATA/addVendorReview.dart';
import 'package:she_connect/Screens/Vendor/Tabs/DATA/followVendor.dart';
import 'package:she_connect/Screens/Vendor/Tabs/DATA/viewVendorPostsAPI.dart';
import 'package:she_connect/Screens/Vendor/Tabs/DATA/viewVendorReviewsAPI.dart';
import 'package:she_connect/Screens/Vendor/Tabs/viewAllReviewsOfVendor.dart';

class VendorDetails extends StatefulWidget {
  final data;
  const VendorDetails({Key? key, this.data}) : super(key: key);

  @override
  _VendorDetailsState createState() => _VendorDetailsState();
}

class _VendorDetailsState extends State<VendorDetails> {
  TextEditingController reviewController = new TextEditingController();
  var finalRating = 1.0;
  var reviewTap = false;
  var btTap = false;
  var FinalDateFormat;
  var formatted;
  var arrReviews = [];
  var isSelected = 1;

  final dataKeyProducts = new GlobalKey();
  final dataKeyServices = new GlobalKey();
  final dataKeyPosts = new GlobalKey();
  final dataKeyReviews = new GlobalKey();
  final dataKeyOffers = new GlobalKey();
  final dataKeyOverview = new GlobalKey();

  var load = true;
  var arrVendoProducts;
  var arrVendoPosts;
  var arrVendorOffers;
  var vendorDetails;
  var isTap = false;
  var day;
  var finalDay;
  @override
  void initState() {
    super.initState();
    this.reload();
    setState(() {});
  }

  Future<String> vendorProductDetail() async {
    var rsp = await vendorProductDetailsAPI(widget.data["_id"].toString());

    if (rsp["status"].toString() == "success") {
      arrVendoProducts = rsp["data"]["lists"];
      DateTime date = DateTime.now();
      day = date.weekday;
    }

    setState(() {
      // load = false;
    });
    return "success";
  }

  Future<String> vendorPosts() async {
    var rsp = await singleVendorPostsAPI(widget.data["_id"].toString());

    if (rsp["status"].toString() == "success") {
      arrVendoPosts = rsp["data"]["lists"];
    }

    setState(() {
      // load = false;
    });
    return "success";
  }

  Future<String> vendorOffers() async {
    var rsp = await viewVendorOffersAPI(widget.data["_id"].toString());
    if (rsp["status"].toString() == "success") {
      arrVendorOffers = rsp["data"]["lists"];
    }

    setState(() {
      // load = false;
    });
    return "success";
  }

  Future<String> reviewAPI() async {
    var rsp = await viewVendorReviewsAPI((widget.data["_id"].toString()));
    if (rsp["status"].toString() == "success") {
      arrReviews = rsp["data"];

      for (var i = 0; i < arrReviews.length; i++) {
        var datee = arrReviews;
        setState(() {
          var date = arrReviews[i]["createdAt"];
          var parsedDate = DateTime.parse(date);
          var fr2 = DateFormat.MMMM().format(parsedDate);
          FinalDateFormat = "${parsedDate.day},$fr2-${parsedDate.year}";
          formatted = FinalDateFormat;
        });
      }
    }

    setState(() {
      // load = false;
    });
    return "success";
  }

  Future<String> reload() async {
    var rsp = await singleVendorDetailAPI(widget.data["_id"].toString());
    await vendorProductDetail();
    await vendorPosts();
    await reviewAPI();
    await vendorOffers();
    if (rsp["status"].toString() == "success") {
      vendorDetails = rsp["data"];
      if (vendorDetails["timings"] != null) {
        if (day.toString() == "1") {
          finalDay = vendorDetails["timings"]["Mon"];
        }
        if (day.toString() == "2") {
          finalDay = vendorDetails["timings"]["Tue"];
        }
        if (day.toString() == "3") {
          finalDay = vendorDetails["timings"]["Wed"];
        }
        if (day.toString() == "4") {
          finalDay = vendorDetails["timings"]["Thus"];
        }
        if (day.toString() == "5") {
          finalDay = vendorDetails["timings"]["Fri"];
        }
        if (day.toString() == "6") {
          finalDay = vendorDetails["timings"]["Sat"];
        }
        if (day.toString() == "7") {
          finalDay = vendorDetails["timings"]["Sun"];
        }
      }
    }

    setState(() {
      load = false;
      isTap = false;
    });
    return "success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load == true
          ? loading()
          : SafeArea(
              child: RefreshIndicator(
                onRefresh: reload,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      expandedHeight: MediaQuery.of(context).size.height * 0.4,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Image.network(
                          vendorDetails["image"].toString(),
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
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10, top: 20, bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _topSection(),
                            Divider(height: 15, color: Colors.black45),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    arrVendoProducts.length <= 0
                                        ? Opacity(opacity: 0)
                                        : GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isSelected = 1;
                                              });
                                              Scrollable.ensureVisible(
                                                  dataKeyProducts
                                                      .currentContext!);
                                            },
                                            child: Text(
                                                "Products" +
                                                    " (" +
                                                    arrVendoProducts.length
                                                        .toString() +
                                                    ") ",
                                                style: size14_700)),
                                    arrVendoProducts.length <= 0
                                        ? Opacity(opacity: 0)
                                        : w(20),
                                    // Text("Service", style: size14_700),
                                    // w(20),
                                    arrVendoPosts.length <= 0
                                        ? Opacity(opacity: 0)
                                        : GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isSelected = 3;
                                              });
                                              Scrollable.ensureVisible(
                                                  dataKeyPosts.currentContext!);
                                            },
                                            child: Text(
                                                "Posts" +
                                                    " (" +
                                                    arrVendoPosts.length
                                                        .toString() +
                                                    ") ",
                                                style: size14_700)),
                                    arrVendoPosts.length <= 0
                                        ? Opacity(opacity: 0)
                                        : w(20),
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isSelected = 4;
                                          });
                                          Scrollable.ensureVisible(
                                              dataKeyReviews.currentContext!);
                                        },
                                        child: Text(
                                            "Reviews" +
                                                " (" +
                                                arrReviews.length.toString() +
                                                ") ",
                                            style: size14_700)),
                                    w(20),
                                    arrVendorOffers.length <= 0
                                        ? Opacity(opacity: 0)
                                        : GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isSelected = 5;
                                              });
                                              Scrollable.ensureVisible(
                                                  dataKeyReviews
                                                      .currentContext!);
                                            },
                                            child: Text(
                                                "Offers " +
                                                    "(" +
                                                    arrVendorOffers.length
                                                        .toString() +
                                                    ")",
                                                style: size14_700)),
                                    arrVendorOffers.length <= 0
                                        ? Opacity(opacity: 0)
                                        : w(20),
                                    widget.data["description"] == null
                                        ? Opacity(opacity: 0)
                                        : GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isSelected = 6;
                                              });
                                              Scrollable.ensureVisible(
                                                  dataKeyReviews
                                                      .currentContext!);
                                            },
                                            child: Text("Overview",
                                                style: size14_700)),
                                  ],
                                ),
                              ),
                            ),
                            Divider(height: 15, color: Colors.black45),
                            h(20),
                            FullScroll(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  FullScroll() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        arrVendoProducts.length <= 0
            ? Opacity(opacity: 0)
            : Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  "Products",
                  style: size16_700,
                  key: dataKeyProducts,
                ),
              ),
        h(20),
        arrVendoProducts.length > 0
            ? SizedBox(
                height: 280,
                child: Scrollbar(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) => w(20),
                      shrinkWrap: true,
                      itemCount: arrVendoProducts != null
                          ? arrVendoProducts.length
                          : 0,
                      itemBuilder: (context, index) {
                        final item = arrVendoProducts != null
                            ? arrVendoProducts[index]
                            : null;

                        return ProductItemsList(item, index);
                      },
                    ),
                  ),
                ),
              )
            : Opacity(opacity: 0),
        arrVendoProducts.length <= 0 ? Opacity(opacity: 0) : _div(),
        // -----------------------------------------------------------------

        arrVendoPosts.length <= 0
            ? Opacity(opacity: 0)
            : Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  "Posts",
                  style: size16_700,
                  key: dataKeyPosts,
                ),
              ),
        arrVendoPosts.length <= 0 ? Opacity(opacity: 0) : h(20),
        arrVendoPosts.length > 0
            ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.45,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Scrollbar(
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) => w(10),
                      shrinkWrap: true,
                      itemCount:
                          arrVendoPosts != null ? arrVendoPosts.length : 0,
                      itemBuilder: (context, index) {
                        final item =
                            arrVendoPosts != null ? arrVendoPosts[index] : null;
                        return PostList(item, index);
                      },
                    ),
                  ),
                ),
              )
            : Opacity(opacity: 0),
        arrVendoPosts.length <= 0 ? Opacity(opacity: 0) : _div(),
        // -----------------------------------------------------------------

        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            "Reviews",
            style: size16_700,
            key: dataKeyReviews,
          ),
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      vendorDetails["averageRating"].toString(),
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    w(5),
                    const Icon(
                      Icons.star,
                      color: Colors.black,
                      size: 25,
                    ),
                  ],
                ),
                h(30),
                Text(
                  "Customer Reviews (" + arrReviews.length.toString() + ")",
                  style: size16_700,
                ),
                h(15),
                arrReviews.length != 0
                    ? Container(
                        child: ListView.separated(
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) => h(20),
                          shrinkWrap: true,
                          itemCount:
                              arrReviews != null && arrReviews.length <= 7
                                  ? arrReviews.length
                                  : 7,
                          itemBuilder: (context, index) {
                            final item =
                                arrReviews != null ? arrReviews[index] : null;

                            return reviewList(item, index);
                          },
                        ),
                      )
                    : Center(
                        child: Text("No reviews found. Be the first to review!",
                            style: size14_400Grey)),
                h(10),
                arrReviews.length != 0 && arrReviews.length > 7
                    ? Row(children: [
                        Spacer(),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        viewAllReviewsOfVendor(
                                            vID: (widget.data["_id"]
                                                .toString()))),
                              );
                            },
                            child: Text("View All Reviews", style: size14_400))
                      ])
                    : Opacity(opacity: 0),
                Divider(),
                h(20),
                reviewTap == true ? addNewReview() : addButton()
              ],
            ),
          ),
        ),
        // -----------------------------------------------------------------
        arrVendorOffers.length <= 0 ? Opacity(opacity: 0) : _div(),

        arrVendorOffers.length <= 0
            ? Opacity(opacity: 0)
            : Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  "Offers",
                  style: size16_700,
                  key: dataKeyOffers,
                ),
              ),
        arrVendorOffers.length <= 0 ? Opacity(opacity: 0) : h(20),
        arrVendorOffers.length > 0
            ? SizedBox(
                height: 120,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 10),
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) => w(10),
                    shrinkWrap: true,
                    itemCount:
                        arrVendorOffers != null ? arrVendorOffers.length : 0,
                    itemBuilder: (context, index) {
                      final item = arrVendorOffers != null
                          ? arrVendorOffers[index]
                          : null;
                      return OffersList(item, index);
                    },
                  ),
                ),
              )
            : Opacity(opacity: 0),
        arrVendorOffers.length <= 0 ? Opacity(opacity: 0) : _div(),
        // ------------------------------------------------------------------
        widget.data["description"] == null
            ? Opacity(opacity: 0)
            : Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  "Overview",
                  style: size16_700,
                  key: dataKeyOverview,
                ),
              ),
        widget.data["description"] == null ? Opacity(opacity: 0) : h(20),
        widget.data["description"] == null
            ? Opacity(opacity: 0)
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(widget.data["description"].toString(),
                    style: size14_400),
              )
      ],
    );
  }

  _topSection() {
    return LayoutBuilder(builder: (context, snapshot) {
      if (snapshot.maxWidth < 600) {
        return SizedBox(
          height: 250,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      vendorDetails["name"].toString(),
                      style: bottomNavPrice,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        if (vendorDetails["isFollowed"] == false) {
                          var rsp = await followVendorAPI(vendorDetails["_id"]);
                          if (rsp["status"].toString() == "success") {
                            setState(() {
                              isTap = true;
                              // reload();
                            });
                          }
                        } else {
                          var rsp =
                              await unfollowVendorAPI(vendorDetails["_id"]);
                          if (rsp["status"].toString() == "success") {
                            setState(() {
                              isTap = true;
                              // reload();
                            });
                          }
                        }
                        reload();
                      },
                      child: isTap == true
                          ? Center(
                              child: SpinKitThreeBounce(
                                color: darkPink,
                                size: 18,
                              ),
                            )
                          : Container(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 6),
                                child: Text(
                                    vendorDetails["isFollowed"] == true
                                        ? "Following"
                                        : "Follow",
                                    style: vendorDetails["isFollowed"] == true
                                        ? size16_600pink
                                        : size16_600W),
                              ),
                              decoration: BoxDecoration(
                                  color: vendorDetails["isFollowed"] == true
                                      ? Colors.white
                                      : darkPink,
                                  border: Border.all(color: darkPink),
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                    )
                  ],
                ),
                h(15),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) => w(10),
                    shrinkWrap: true,
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return tagsList(index);
                    },
                  ),
                ),
                h(15),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatDetailsPage(
                              vendorID: vendorDetails["_id"].toString(),
                              from: "vendor",
                              name: vendorDetails["name"].toString())),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: darkPink)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.message, size: 15),
                          w(5),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Text("Contact Seller", style: size14_700),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                h(10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    child: Row(
                      children: [
                        Text(vendorDetails["averageRating"].toString(),
                            style: size22_600),
                        Icon(
                          Icons.star,
                          color: Colors.black,
                          size: 15,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          height: 18,
                          width: 1,
                          color: Colors.grey[400],
                        ),
                        Text(
                          arrReviews.length.toString() + " Reviews",
                          style: size12_400Grey,
                        )
                      ],
                    ),
                  ),
                ),
                h(5),
                Text(
                  vendorDetails["address"].toString(),
                  style: size14_400Grey,
                ),
                Text(
                  vendorDetails["city"].toString(),
                  style: size14_400Grey,
                ),
                h(10),
                vendorDetails["timings"] != null
                    ? Row(
                        children: [
                          Text(
                            "Hours : ",
                            style: size14_700,
                          ),
                          Text(
                            finalDay.toString(),
                            style: size14_400Grey,
                          ),
                        ],
                      )
                    : Opacity(opacity: 0),
              ],
            ),
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    "Louis Vuitton",
                    style: bottomNavPrice,
                  ),
                  w(50),
                  Container(
                    alignment: Alignment.center,
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      child: Text(
                        "Follow",
                        style: size16_600pink,
                      ),
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(color: darkPink),
                        borderRadius: BorderRadius.circular(10)),
                  )
                ],
              ),
              h(15),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => w(10),
                  shrinkWrap: true,
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return tagsList(index);
                  },
                ),
              ),
              h(15),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 3),
                      child: Row(
                        children: const [
                          Text(
                            "4.2",
                            style: size14_600,
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
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 18,
                    width: 1,
                    color: Colors.grey[400],
                  ),
                  const Text(
                    "146 Ratings",
                    style: size12_400Grey,
                  )
                ],
              ),
              h(5),
              const Text(
                "International ladies brand store",
                style: size14_400Grey,
              ),
              h(10),
              Row(
                children: const [
                  Text(
                    "Hours:",
                    style: size14_700,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Open",
                      style: size13_400Green,
                    ),
                  ),
                  Text(
                    "Closes 8PM",
                    style: size14_400Grey,
                  ),
                ],
              ),
            ],
          ),
        );
      }
    });
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

  OffersList(var item, int index) {
    return GestureDetector(
      onTap: () {
        offerFullView(item);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200],
            border: Border.all(color: Colors.black38)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item["name"].toString(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: size16_700),
              h(5),
              Text(item["description"].toString(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: size16_400),
              Expanded(
                child: Text("T&C : " + item["termsAndCondtion"].toString(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: size14_400),
              ),
            ],
          ),
        ),
      ),
    );
  }

  tagsList(int index) {
    return Container(
      alignment: Alignment.center,
      child: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 12,
        ),
        child: Text(
          "Premium",
          style: size12_400,
        ),
      ),
      decoration: BoxDecoration(
          border: Border.all(color: darkPink),
          borderRadius: BorderRadius.circular(10)),
    );
  }

  Widget addButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          reviewTap = true;
        });
      },
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "ADD REVIEW",
            style: size16_600pink,
          ),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: darkPink)),
      ),
    );
  }

  Widget addNewReview() {
    return Container(
      child: Column(
        children: [
          ratingBar(),
          h(10),
          Container(
            child: TextFormField(
              style: size14_600,
              controller: reviewController,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              maxLength: 200,
              textInputAction: TextInputAction.done,
              decoration: new InputDecoration(
                  labelText: "Add your Review",
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
          h(10),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      reviewTap = false;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Cancel".toUpperCase(),
                        style: size16_600pink,
                      ),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: darkPink)),
                  ),
                ),
              ),
              w(20),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    setState(() {
                      btTap = true;
                    });
                    var rsp = await addVendorReviewAPI(
                        widget.data["_id"].toString(),
                        finalRating,
                        reviewController.text.toString());
                    print(rsp);
                    if (rsp["status"].toString() == "success") {
                      setState(() {
                        showToastSuccess("Review Added!");
                        reviewController.clear();
                        btTap = false;
                        reviewTap = false;
                      });
                    }
                    reload();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: btTap == true
                          ? Center(
                              child: SpinKitThreeBounce(
                              color: Colors.white,
                              size: 18,
                            ))
                          : Text(
                              "Post Review".toUpperCase(),
                              style: size16_600W,
                            ),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: darkPink,
                        border: Border.all(color: darkPink)),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  ratingBar() {
    return RatingBar.builder(
      initialRating: 1,
      itemSize: 25,
      minRating: 1,
      glow: true,
      unratedColor: BGgrey,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) =>
          Icon(CupertinoIcons.star_fill, size: 15, color: Colors.yellow[800]!),
      onRatingUpdate: (rating) {
        setState(() {
          finalRating = rating;
        });
        print("rating: " + finalRating.toString());
      },
    );
  }

  reviewList(var item, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: liteGrey),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            child: Row(
              children: [
                Text(
                  item["rating"].toString(),
                  style: size12_400,
                ),
                Icon(
                  Icons.star,
                  color: Colors.blueGrey,
                  size: 12,
                )
              ],
            ),
          ),
        ),
        w(20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              item["description"].toString() == ""
                  ? Opacity(opacity: 0)
                  : Text(
                      item["description"],
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: size16_400,
                    ),
              h(5),
              Row(
                children: [
                  Text(
                    item["user"]["name"].toString(),
                    style: size13_400,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      width: 1,
                      height: 15,
                      color: Colors.grey[400],
                    ),
                  ),
                  Text(
                    formatted,
                    style: size13_400,
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _div() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child:
          Container(height: 5, color: Colors.grey[300], width: double.infinity),
    );
  }

  void offerFullView(item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: new BorderRadius.circular(12)),
        elevation: 10,
        title: Text(item["name"].toString(), style: size16_700),
        content: StreamBuilder<Object>(
            stream: null,
            builder: (context, snapshot) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(item["description"].toString(), style: size16_400),
                  h(10),
                  Text("Terms & Conditions :", style: size14_400),
                  h(5),
                  Text(item["termsAndCondtion"].toString(), style: size14_400),
                  SizedBox(
                    height: 10,
                  ),
                ],
              );
            }),
      ),
    );
  }
}
