import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Helper/snackbar_toast_helper.dart';
import 'package:she_connect/Screens/Vendor/Tabs/DATA/addVendorReview.dart';
import 'package:she_connect/Screens/Vendor/Tabs/DATA/viewVendorReviewsAPI.dart';
import 'package:she_connect/Screens/Vendor/Tabs/viewAllReviewsOfVendor.dart';

class ReviewsTabVendor extends StatefulWidget {
  final vID;
  final avg;
  final Function refresh;
  const ReviewsTabVendor({Key? key, this.vID, this.avg, required this.refresh})
      : super(key: key);

  @override
  _ReviewsTabVendorState createState() => _ReviewsTabVendorState();
}

class _ReviewsTabVendorState extends State<ReviewsTabVendor> {
  TextEditingController reviewController = new TextEditingController();
  var finalRating = 1.0;
  var reviewTap = false;
  var btTap = false;
  var load = true;
  var FinalDateFormat;
  var formatted;
  var arrReviews = [];
  @override
  void initState() {
    super.initState();
    this.reload();
    setState(() {});
  }

  Future<String> reload() async {
    var rsp = await viewVendorReviewsAPI(widget.vID.toString());
    if (rsp["status"].toString() == "success") {
      arrReviews = rsp["data"];
    }

    setState(() {
      load = false;
    });
    return "success";
  }

  @override
  Widget build(BuildContext context) {
    return load == true
        ? SpinKitThreeBounce(color: darkPink, size: 25)
        : Container(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.avg.toString(),
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
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
                          child: Text(
                              "No reviews found. Be the first to review!",
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
                                              vID: widget.vID)),
                                );
                              },
                              child:
                                  Text("View All Reviews", style: size14_400))
                        ])
                      : Opacity(opacity: 0),
                  Divider(),
                  h(20),
                  reviewTap == true ? addNewReview() : addButton()
                ],
              ),
            ),
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
                    var rsp = await addVendorReviewAPI(widget.vID, finalRating,
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
                    widget.refresh();
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
    var parsedDate = DateTime.parse(item["createdAt"]);
    var fr2 = DateFormat.MMMM().format(parsedDate);
    FinalDateFormat = "${parsedDate.day} $fr2, ${parsedDate.year}";
    formatted = FinalDateFormat;
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
}
