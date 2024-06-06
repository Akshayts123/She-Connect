import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:she_connect/API/getProductReview_API.dart';
import 'package:she_connect/API/productDetialsApi.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/MainWidgets/loading.dart';
import 'package:she_connect/Screens/ProductReview/addNewReview.dart';

class AllReview extends StatefulWidget {
  final id;
  final data;
  final Function refresh;
  const AllReview({Key? key, this.id, this.data, required this.refresh})
      : super(key: key);

  @override
  _AllReviewState createState() => _AllReviewState();
}

class _AllReviewState extends State<AllReview> {
  @override
  void initState() {
    super.initState();
    this.getHome();
    this.getReviews();
    setState(() {});
  }

  var arrReviews;
  var FinalDateFormat;
  var formatted;
  var load = true;
  var productDetials;
  Future<String> getHome() async {
    await getReviews();

    var rsp = await productDetailsApi(widget.id);
    if (rsp["status"].toString() == "success") {
      productDetials = rsp["data"];
    }
    setState(() {
      load = false;
    });

    return "success";
  }

  Future<String> getReviews() async {
    var rsp = await listAllReviewsAPI(widget.id);
    if (rsp["status"].toString() == "success") {
      arrReviews = rsp["data"]["lists"];
      for (var i = 0; i < arrReviews.length; i++) {
        var datee = arrReviews;
        setState(() {
          var date = arrReviews[i]["user"]["createdAt"];
          var parsedDate = DateTime.parse(date);
          var fr2 = DateFormat.MMMM().format(parsedDate);
          FinalDateFormat = "${parsedDate.day},$fr2-${parsedDate.year}";
          formatted = FinalDateFormat;
        });
      }
    }
    setState(() {});

    return "success";
  }

  Future<bool> _onBackPressed() async {
    bool goBack = false;
    widget.refresh();
    Navigator.pop(context);
    return goBack;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add, color: darkPink),
            elevation: 2,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddNewReview(
                        data: widget.data, refresh: getHome, id: widget.id)),
              );
            },
            backgroundColor: Colors.white),
        appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.refresh();
                },
                icon: const Icon(Icons.arrow_back,
                    color: Colors.black, size: 25)),
            title: const Text("All Reviews", style: appBarTxtStyl)),
        body: load == true ? loading() : ReviewRating(),
      ),
    );
  }

  Widget ReviewRating() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Text("Rating & Review", style: size20_400),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      productDetials["averageRating"].toString(),
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    w(5),
                    const Icon(
                      Icons.star,
                      color: Colors.black,
                      size: 25,
                    ),
                  ],
                ),
                Text(
                  productDetials["totalReviewCount"].toString() + " Reviews",
                  style: size14_400Grey,
                )
              ],
            ),
            h(30),
            Text(
              "Customer Reviews (" + arrReviews.length.toString() + ")",
              style: size16_700,
            ),
            h(15),
            Expanded(
              child: Scrollbar(
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (context, index) => h(20),
                  shrinkWrap: true,
                  itemCount: arrReviews != null ? arrReviews.length : 0,
                  itemBuilder: (context, index) {
                    final item = arrReviews != null ? arrReviews[index] : null;
                    return reviewList(item, index);
                  },
                ),
              ),
            ),
            h(30),
          ],
        ),
      ),
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
              Text(
                item["review"].toString(),
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
}
