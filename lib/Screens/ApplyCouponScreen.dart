import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:she_connect/API/checkCoupon_API.dart';
import 'package:she_connect/API/couponList_api.dart';
import 'package:she_connect/API/getCartID_API.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Helper/sharedPref.dart';
import 'package:she_connect/Helper/snackbar_toast_helper.dart';
import 'package:she_connect/MainWidgets/loading.dart';

class ApplyCoupon extends StatefulWidget {
  final Function rfrsh;
  const ApplyCoupon({Key? key, required this.rfrsh}) : super(key: key);

  @override
  _ApplyCouponState createState() => _ApplyCouponState();
}

class _ApplyCouponState extends State<ApplyCoupon> {
  var arrList;
  var cartID;
  var load = true;
  var addressIDD;
  var tap = false;
  var type;
  var FinalDateFormat;
  var formatted;
  @override
  void initState() {
    super.initState();
    this.getCoupons();
    setState(() {});
  }

  Future<String> getCoupons() async {
    var rsp = await CouponListAPI();
    if (rsp["status"].toString() == "success") {
      await getCartID();
      arrList = rsp["data"]["lists"];
    }
    setState(() {
      load = false;
    });
    return "success";
  }

  Future<String> getCartID() async {
    var rsp = await getCartIdAPI();
    if (rsp["status"].toString() == "success") {
      cartID = rsp["data"][0]["_id"];
    }
    setState(() {
      load = false;
    });
    return "success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: BGgrey,
        appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back,
                    color: Colors.black, size: 25)),
            title: const Text("Apply Coupon", style: appBarTxtStyl)),
        body: load == true
            ? Center(child: loading())
            : arrList.length == 0
                ? Center(child: Text("No Coupons Available!"))
                : LayoutBuilder(builder: (context, snapshot) {
                    if (snapshot.maxWidth < 600) {
                      return Scrollbar(
                          child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Container(
                                  color: Colors.white,
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 20),
                                      child: applicable()))));
                    } else {
                      return Scrollbar(
                          child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Wrap(
                                runSpacing: 20,
                                children: [
                                  Container(
                                      color: Colors.white,
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 30),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text("Applicable",
                                                    style: size16_700),
                                                SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.01),
                                                applicableTablet()
                                              ]))),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01),
                                  Container(
                                      color: Colors.white,
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 30),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text("Not Applicable",
                                                    style: size16_700),
                                                SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.02),
                                                notApplicableTablet()
                                              ])))
                                ],
                              )));
                    }
                  }));
  }

  applicable() {
    return ListView.separated(
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) => const Divider(
              height: 30,
              thickness: 2,
              color: BGgrey,
            ),
        shrinkWrap: true,
        itemCount: arrList != null ? arrList.length : 0,
        itemBuilder: (context, index) {
          final item = arrList != null ? arrList[index] : null;
          return applicableList(item, index);
        });
  }

  applicableTablet() {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 5,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 3),
      itemBuilder: (BuildContext context, int index) {
        return applicableGrid(index);
      },
    );
  }

  notApplicableTablet() {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 3,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2.7),
      itemBuilder: (BuildContext context, int index) {
        return notApplicableGrid(index);
      },
    );
  }

  applicableList(var item, int index) {
    var parsedDate = DateTime.parse(item["validTo"]);
    var fr2 = DateFormat.MMMM().format(parsedDate);
    FinalDateFormat = "${parsedDate.day} $fr2, ${parsedDate.year}";
    formatted = FinalDateFormat;
    return item["isActive"] == true
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(children: [
              Expanded(
                  flex: 3,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(item["couponCode"].toString().toUpperCase(),
                                style: size18_700Pink),
                            w(20),
                            Text(item["name"].toString(), style: size12_400Grey)
                          ],
                          crossAxisAlignment: CrossAxisAlignment.end,
                        ),
                        SizedBox(height: 15),
                        Text(
                            item["couponCategory"] == "SINGLE_PRODUCT"
                                ? "This Coupon is only applicable for particular products"
                                : item["couponCategory"] == "SINGLE_CATEGORY"
                                    ? "This Coupon is only applicable for particular category of products"
                                    : item["couponCategory"] == "ALL_CATEGORY"
                                        ? "This Coupon is applicable for all category of products"
                                        : "This Coupon is applicable for all products",
                            style: size14_400Grey),
                        SizedBox(height: 10),
                        Text("Valid till: " + formatted, style: size12_700),
                        SizedBox(height: 10),
                        GestureDetector(
                            onTap: () async {
                              alertTC(item["description"]);
                            },
                            child: Text("View T&C", style: size14_600Pink))
                      ])),
              const SizedBox(width: 20),
              Expanded(
                  child: applyCouponButton(
                      cartID: cartID, item: item, refresh: widget.rfrsh))
            ]))
        : Opacity(
            opacity: 0.2,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(children: [
                  Expanded(
                      flex: 3,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                    item["couponCode"].toString().toUpperCase(),
                                    style: size18_700),
                                SizedBox(width: 20),
                                Text("You save     50", style: size12_400Grey)
                              ],
                              crossAxisAlignment: CrossAxisAlignment.end,
                            ),
                            SizedBox(height: 15),
                            Text(item["description"].toString(),
                                style: size14_400Grey),
                            SizedBox(height: 10),
                            Text("View T&C", style: size14_600Pink)
                          ])),
                  const SizedBox(width: 20),
                  Expanded(child: Text("Apply Coupon", style: size14_600Pink))
                ])),
          );
  }

  applicableGrid(int index) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: (Colors.grey[300]!),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black12)),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Row(children: [
            Expanded(
                flex: 3,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: const [
                        Text("FIRSTFREE", style: size18_700),
                        SizedBox(width: 20),
                        Text("You save     50", style: size12_400Grey)
                      ]),
                      const SizedBox(height: 15),
                      const Text(
                          "Get first delivery free for puchase of 100 and above",
                          style: size14_400Grey),
                      const SizedBox(height: 10),
                      const Text("View T&C", style: size14_600Pink)
                    ])),
            const SizedBox(width: 20),
            const Expanded(child: Text("Apply Coupon", style: size14_600Pink))
          ])),
    );
  }

  notApplicableList(int index) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: const [
            Text("FIRSTFREE", style: size18_700),
            SizedBox(width: 20),
            Text("You save     50", style: size12_400Grey)
          ]),
          const SizedBox(height: 15),
          const Text("Get first delivery free for puchase of 100 and above",
              style: size14_400Grey),
          const SizedBox(height: 10),
          const Text("View T&C", style: size14_600Pink),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
                child: Text("Shop for 950 more to apply offer",
                    style: size12_400)),
            // SizedBox(width: MediaQuery.of(context).size.width * 0.2),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black54),
                ),
                child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    child: Text("Shop Now", style: size12_400)))
          ])
        ]));
  }

  notApplicableGrid(int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: (Colors.grey[300]!),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: const [
            Text("FIRSTFREE", style: size18_700),
            SizedBox(width: 20),
            Text("You save 50", style: size12_400Grey)
          ]),
          const SizedBox(height: 15),
          const Text("Get first delivery free for puchase of 100 and above",
              style: size14_400Grey),
          const SizedBox(height: 10),
          const Text("View T&C", style: size14_600Pink),
          const SizedBox(height: 10),
          Row(
            children: [
              Text("Shop for 950 more to apply offer", style: size12_400),
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black54),
                  ),
                  child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      child: Text("Shop Now", style: size12_400))),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          )
        ]),
      ),
    );
  }

  void alertTC(text) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: new BorderRadius.circular(12)),
        elevation: 10,
        title: Row(
          children: [
            Text('Terms & Conditions', style: appBarTxtStyl),
            Spacer(),
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.close, size: 18))
          ],
        ),
        content: StreamBuilder<Object>(
            stream: null,
            builder: (context, snapshot) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(text, style: size14_400),
                    h(10),
                  ],
                ),
              );
            }),
      ),
    );
  }
}

class applyCouponButton extends StatefulWidget {
  final cartID;
  final item;
  final refresh;
  const applyCouponButton({Key? key, this.cartID, this.item, this.refresh})
      : super(key: key);

  @override
  _applyCouponButtonState createState() => _applyCouponButtonState();
}

class _applyCouponButtonState extends State<applyCouponButton> {
  var tap = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: tap == true
          ? Center(child: SpinKitThreeBounce(color: darkPink, size: 15))
          : Text("Apply Coupon", style: size14_600Pink),
      onTap: () async {
        setState(() {
          tap = true;
        });
        var rsp = await checkCouponAPI(
          widget.item["couponCode"].toString(),
          widget.cartID,
        );
        if (rsp["status"].toString() == "success") {
          var iddd = rsp["data"]["_id"];
          var code = rsp["data"]["couponCode"];
          await setSharedPrefrence(COUPON, iddd);
          showToastSuccess("Coupon Applied!");
          setState(() {
            tap = false;
          });
          Navigator.pop(context, iddd);
          widget.refresh();
        } else {
          showToastError(rsp["error"].toString());
          setState(() {
            tap = false;
          });
        }
      },
    );
  }
}
