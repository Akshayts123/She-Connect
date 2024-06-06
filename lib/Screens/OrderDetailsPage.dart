import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:she_connect/API/orderTrackingAPI.dart';
import 'package:she_connect/API/singleOrderDetailPageAPI.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/TextConst.dart';
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/MainWidgets/BottomNav.dart';
import 'package:she_connect/MainWidgets/loading.dart';
import 'package:she_connect/Screens/Chat/NewChatCreatePage.dart';
import 'package:she_connect/Screens/ProductReviewPage.dart';
import 'package:she_connect/Screens/Return_OR_Exchange/SelectPickupAddress.dart';

import 'Return_OR_Exchange/RequestReturnORExchange.dart';

class OrderDetails extends StatefulWidget {
  final ordrID;
  final prd;
  const OrderDetails({Key? key, this.ordrID, this.prd}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  var arrOrder;
  var arrOrderDetail;
  var load = true;
  var FinalDateFormat;
  var orderDateFormated;
  var orderDateFinalFormatted;
  var FinalUpdatedDateFormat;
  var formatted;
  var updatedFormatted;
  var arrOrderTrack;
  @override
  void initState() {
    super.initState();
    this.getDetails();
    setState(() {});
  }

  Future<String> getDetails() async {
    await orderTrackFunction();
    var rsp = await singleOrderDetailAPI(widget.ordrID);
    if (rsp["status"].toString() == "success") {
      setState(() {
        arrOrder = rsp["data"];
        arrOrderDetail = rsp["data"]["orderDetails"];
        for (var i = 0; i < arrOrder.length; i++) {
          var datee = arrOrder;
          setState(() {
            var date = arrOrder["createdAt"];
            var updatedDate = arrOrder["updatedAt"];
            var parsedDate = DateTime.parse(date);
            var parsedUpdatedDate = DateTime.parse(updatedDate);
            var fr2 = DateFormat.MMMM().format(parsedDate);
            var fr3 = DateFormat.MMMM().format(parsedUpdatedDate);
            FinalDateFormat = "${parsedDate.day}-$fr2-${parsedDate.year}";
            FinalUpdatedDateFormat =
                "${parsedUpdatedDate.day}-$fr3-${parsedUpdatedDate.year}";
            formatted = FinalDateFormat;
            updatedFormatted = FinalUpdatedDateFormat;
          });
        }
      });
    }
    setState(() {
      load = false;
    });
    return "success";
  }

  Future<String> orderTrackFunction() async {
    // print("_______ORDER TRACKING_______");
    var rsp = await orderTrackingAPI(widget.ordrID);
    if (rsp["status"].toString() == "success") {
      arrOrderTrack = rsp["data"];
      for (var i = 0; i < arrOrderTrack.length; i++) {
        var map = arrOrderTrack[i];

        var date = map["createdAt"];
        var parsedDate = DateTime.parse(date);
        var fr2 = DateFormat.MMMM().format(parsedDate);
        orderDateFormated = "${parsedDate.day}-$fr2-${parsedDate.year}";
        orderDateFinalFormatted = orderDateFormated;
      }
    }
    setState(() {
      // load = false;
    });
    return "success";
  }

  var expanded = false;
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
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 25,
            )),
        title: const Text(
          "Order Details",
          style: appBarTxtStyl,
        ),
      ),
      body: load == true
          ? loading()
          : RefreshIndicator(
              onRefresh: getDetails,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  runSpacing: 10,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Order ID - " + arrOrder["orderId"].toString(),
                                style: size14_400Grey),
                            h(5),
                            const Divider(color: Colors.blueGrey),
                            ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              separatorBuilder: (context, index) => SizedBox(
                                height: 10,
                              ),
                              shrinkWrap: true,
                              itemCount: arrOrderDetail != null
                                  ? arrOrderDetail.length
                                  : 0,
                              itemBuilder: (context, index) {
                                final item = arrOrderDetail != null
                                    ? arrOrderDetail[index]
                                    : null;

                                return productDetail(item, index);
                              },
                            ),
                            // productDetail(),
                            const Divider(color: Colors.blueGrey),
                            // arrOrder["orderStatus"].toString() == "CANCELLED"
                            //     ? Opacity(opacity: 0)
                            //     : Container(
                            //         child: expanded == true
                            //             ? ordrTrackingExpanded()
                            //             : ordrTracking()),
                            ListView.separated(
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              separatorBuilder: (context, index) => SizedBox(
                                height: 15,
                              ),
                              shrinkWrap: true,
                              itemCount: arrOrderTrack != null
                                  ? arrOrderTrack.length
                                  : 0,
                              itemBuilder: (context, index) {
                                final item = arrOrderTrack != null
                                    ? arrOrderTrack[index]
                                    : null;
                                return orderTrackList(item, index);
                              },
                            )

                            // arrOrder["orderStatus"].toString() == "CANCELLED"
                            //     ? cancelledOrder()
                            //     : Opacity(opacity: 0)
                          ],
                        ),
                      ),
                    ),
                    arrOrder["orderStatus"].toString() == "COMPLETED"
                        ? writeReview()
                        : Opacity(opacity: 0),
                    // reOrderProduct(),
                    // RefundDetails(),
                    arrOrder["orderStatus"].toString() == "NEW"
                        ? cancelOrder()
                        : Opacity(opacity: 0),
                    shippingDetails(),
                    contactSellerButton(),
                    _orderDetails(),
                    arrOrder["orderStatus"].toString() == "COMPLETED"
                        ? returnExchange()
                        : Opacity(opacity: 0),
                    continueShoppingButton(),
                  ],
                ),
              ),
            ),
    );
  }

  RefundDetails() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Refund ID - RF239048792732",
              style: size14_400Grey,
            ),
            Divider(),
            Text(
              "Refund Completed",
              style: size14_700,
            ),
            h(10),
            Text(
              "36,500 has been refunded to your State Bank of India Account on 23-Aug-2021",
              style: size14_400Grey,
            )
          ],
        ),
      ),
    );
  }

  orderTrackList(var item, int index) {
    return Row(children: [
      Icon(Icons.circle, color: Colors.black, size: 5),
      w(5),
      Expanded(
        child: widget.prd == true
            ? Text(
                item["orderStatus"].toString() == "NEW"
                    ? "Order Placed" +
                        " (" +
                        item["product"]["name"].toString() +
                        ")"
                    : item["orderStatus"].toString() == "PROCESSING"
                        ? "Order Processed" + item["product"]["name"].toString()
                        : item["orderStatus"].toString() == "PACKED"
                            ? "Order Packed" +
                                item["product"]["name"].toString()
                            : item["orderStatus"].toString() == "SHIPPED"
                                ? "Order Shipped" +
                                    item["product"]["name"].toString()
                                : item["orderStatus"].toString() == "COMPLETED"
                                    ? "Delivered" +
                                        item["product"]["name"].toString()
                                    : item["orderStatus"].toString() ==
                                            "CANCELLED"
                                        ? "Cancelled" +
                                            item["product"]["name"].toString()
                                        : item["orderStatus"].toString(),
                style: item["orderStatus"].toString() == "COMPLETED"
                    ? size14_600Green
                    : size14_600,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            : Text(
                item["orderStatus"].toString() == "NEW"
                    ? "Order Placed"
                    : item["orderStatus"].toString() == "PROCESSING"
                        ? "Order Processed"
                        : item["orderStatus"].toString() == "PACKED"
                            ? "Order Packed"
                            : item["orderStatus"].toString() == "SHIPPED"
                                ? "Order Shipped"
                                : item["orderStatus"].toString() == "COMPLETED"
                                    ? "Delivered"
                                    : item["orderStatus"].toString() ==
                                            "CANCELLED"
                                        ? "Cancelled"
                                        : item["orderStatus"].toString(),
                style: item["orderStatus"].toString() == "COMPLETED"
                    ? size14_600Green
                    : size14_600,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
      ),
      Text(orderDateFinalFormatted.toString(), style: size14_600Grey),
      Icon(Icons.check, color: Colors.green, size: 20)
    ]);
  }

  ordrTracking() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: () async {
          print("tap");
          setState(() {
            expanded = true;
          });
        },
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text("Ordered", style: size14_600),
                  const Spacer(),
                  Text(formatted, style: size14_400Grey),
                  w(5),
                  const Icon(Icons.check, color: Colors.green, size: 18)
                ],
              ),
              h(5),
              Column(
                children: [
                  Container(height: 10, width: 1, color: Colors.blueGrey),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          expanded = true;
                        });
                      },
                      child: const Icon(Icons.add_circle_outline,
                          size: 20, color: Colors.blueGrey),
                    ),
                  ),
                  Container(height: 10, width: 1, color: Colors.blueGrey)
                ],
              ),
              h(5),
              Row(
                children: [
                  const Text("Delivered", style: size14_600),
                  const Spacer(),
                  const Text("Mon, 21-Aug-2021", style: size14_400Grey),
                  w(5),
                  const Icon(Icons.check, color: Colors.green, size: 18)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  cancelledOrder() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text("Ordered", style: size14_600),
                const Spacer(),
                Text(formatted, style: size14_400Grey),
                w(5),
                const Icon(Icons.check, color: Colors.green, size: 18)
              ],
            ),
            h(5),
            Row(
              children: [
                const Text("Cancelled", style: size14_600Red),
                const Spacer(),
                Text(updatedFormatted, style: size14_400Grey),
                w(5),
                const Icon(Icons.check, color: Colors.green, size: 18)
              ],
            ),
          ],
        ),
      ),
    );
  }

  ordrTrackingExpanded() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("Ordered", style: size14_600),
              const Spacer(),
              const Text("Sat, 15-Aug-2021", style: size14_400Grey),
              w(5),
              const Icon(Icons.check, color: Colors.green, size: 18)
            ],
          ),
          h(5),
          Row(
            children: [
              const Text("Packed", style: size14_600),
              const Spacer(),
              const Text("Sat, 15-Aug-2021", style: size14_400Grey),
              w(5),
              const Icon(Icons.check, color: Colors.green, size: 18)
            ],
          ),
          h(5),
          Row(
            children: [
              const Text("Shipped", style: size14_600),
              const Spacer(),
              const Text("Sat, 15-Aug-2021", style: size14_400Grey),
              w(5),
              const Icon(Icons.check, color: Colors.green, size: 18)
            ],
          ),
          h(5),
          Row(
            children: [
              const Text("Delivered", style: size14_600),
              const Spacer(),
              const Text("Mon, 21-Aug-2021", style: size14_400Grey),
              w(5),
              const Icon(Icons.check, color: Colors.green, size: 18)
            ],
          ),
        ],
      ),
    );
  }

  writeReview() {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductReview()),
          );
        },
        child: Container(
            color: Colors.white,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                child: Row(children: const [
                  Text("Write a product review", style: size16_600pink),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios_rounded,
                      size: 15, color: darkPink)
                ]))));
  }

  contactSellerButton() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatDetailsPage(
                      vendorID: arrOrder["vendor"]["_id"].toString(),
                      from: "order",
                      name: arrOrder["vendor"]["name"].toString(),
                      orderID: arrOrder["orderId"].toString())),
            );
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: darkPink)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
      ),
    );
  }

  reOrderProduct() {
    return GestureDetector(
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => ProductReview()),
          // );
        },
        child: Container(
            width: double.infinity,
            color: Colors.white,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                child: Text("Re-order this item ?", style: size16_600pink))));
  }

  cancelOrder() {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RqstReturnOrExchange(
                      refresh: getDetails,
                      data: arrOrder,
                      txt: "Cancellation",
                      id: widget.ordrID)));
        },
        child: Container(
            width: double.infinity,
            color: Colors.white,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                child: Text("Cancel Order",
                    textAlign: TextAlign.center, style: size16_600pink))));
  }

  shippingDetails() {
    return Container(
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Shipping Details", style: size14_700),
              Divider(color: Colors.blueGrey),
              Text(arrOrder["billingAddress"]["name"].toString(),
                  style: size14_600),
              SizedBox(height: 5),
              Text(
                  arrOrder["billingAddress"]["locality"].toString() +
                      ", " +
                      arrOrder["billingAddress"]["city"].toString(),
                  style: size14_400Grey),
              Text(arrOrder["billingAddress"]["city"].toString(),
                  style: size14_400Grey),
              // Text(arrOrder["billingAddress"]["name"].toString(),
              //     style: size14_400Grey),
              Text("Phone: " + arrOrder["billingAddress"]["phoneNo"].toString(),
                  style: size14_400Grey),
            ])));
  }

  Widget _orderDetails() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Order Details",
                style: size14_600,
              ),
              const Divider(color: Colors.blueGrey),
              ordrDetail("Total MRP", rs + arrOrder["netAmount"].toString()),
              ordrDetail("Discount on MRP",
                  "- " + rs + arrOrder["discountAmount"].toString()),
              arrOrder["hasUsedCoins"] == true
                  ? ordrDetail("Reward Points Used",
                      "- " + rs + arrOrder["usedRewardCoins"].toString())
                  : Opacity(opacity: 0),
              ordrDetail("Delivery Charge",
                  "+ " + rs + arrOrder["deliveryCharge"].toString()),
              const Divider(thickness: 2),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Text(
                      "TOTAL AMOUNT",
                      style: size14_600,
                    ),
                    Spacer(),
                    Text(
                      rs + arrOrder["totalAmountPaid"].toString(),
                      style: size14_600,
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.blueGrey),
              // Row(
              //   children: [
              //     const Icon(Icons.circle, size: 5, color: Colors.black),
              //     w(5),
              //     const Text(
              //       "UPI : 36,500",
              //       style: size14_400Grey,
              //     )
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }

  ordrDetail(String txt, String amt) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(
            txt,
            style: size14_400Grey,
          ),
          const Spacer(),
          Text(
            amt,
            style: size14_400Grey,
          ),
        ],
      ),
    );
  }

  productDetail(var item, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black12),
                image: DecorationImage(
                    image: NetworkImage(productCategoryImageURL +
                        item["product"]["image"].toString()),
                    fit: BoxFit.cover)),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item["product"]["name"].toString(),
                    style: size16_700,
                  ),
                  // h(5),
                  // RichText(
                  //   text: const TextSpan(
                  //       text: 'Color:',
                  //       style: size10_600,
                  //       children: [TextSpan(text: '  RED', style: size10_600)]),
                  // ),
                  h(5),
                  Text("Qty: " + item["quantity"].toString(),
                      style: size14_700),
                  h(5),
                  Text(rs + item["netAmount"].toString(), style: size16_400)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  returnExchange() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PickupAddress()),
        );
      },
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Column(
            children: [
              const Text("Return or Exchange?", style: size14_600Pink),
              h(5),
              const Text("Return or Exchange available till 12-Nov",
                  style: size14_400Grey)
            ],
          ),
        ),
        color: Colors.white,
      ),
    );
  }

  continueShoppingButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BottomNav()),
          );
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: darkPink)),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: MediaQuery.of(context).size.width * 0.15),
            child: const Text("Continue Shopping", style: size18_400Pink),
          ),
        ),
      ),
    );
  }
}
