import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:she_connect/API/viewSingleVendorDetail_api.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/MainWidgets/loading.dart';
import 'package:she_connect/Screens/Vendor/Tabs/DATA/viewVendorReviewsAPI.dart';

class viewAllReviewsOfVendor extends StatefulWidget {
  final vID;
  const viewAllReviewsOfVendor({Key? key, this.vID}) : super(key: key);

  @override
  _viewAllReviewsOfVendorState createState() => _viewAllReviewsOfVendorState();
}

class _viewAllReviewsOfVendorState extends State<viewAllReviewsOfVendor> {
  @override
  void initState() {
    super.initState();
    this.reload();
    setState(() {});
  }

  var FinalDateFormat;
  var formatted;
  var vendorDetails;
  var arrReviews = [];
  var load = true;

  Future<String> reload() async {
    var rsp = await singleVendorDetailAPI(widget.vID);
    await reviews();
    if (rsp["status"].toString() == "success") {
      vendorDetails = rsp["data"];
    }

    setState(() {
      load = false;
    });
    return "success";
  }

  Future<String> reviews() async {
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 25,
            )),
      ),
      body: load == true
          ? loading()
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: (Colors.grey[400]!),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: Offset(0, 3),
                                    )
                                  ],
                                  color: liteGrey,
                                  border: Border.all(color: Colors.black12),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        vendorDetails["image"].toString(),
                                      ),
                                      fit: BoxFit.cover)),
                            ),
                            Text(
                              vendorDetails["name"].toString(),
                              style: size16_700,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Column(
                            children: [
                              Text(vendorDetails["averageRating"].toString(),
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold)),
                              Text(arrReviews.length.toString() + " Reviews",
                                  style: size16_400)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Divider(height: 60),
                  Expanded(
                    child: Center(
                      child: Scrollbar(
                        child: ListView.separated(
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
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
                      ),
                    ),
                  )
                ],
              ),
            ),
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
              item["description"] == ""
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
