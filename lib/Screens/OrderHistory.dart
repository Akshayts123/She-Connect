import 'package:flutter/material.dart';
import 'package:she_connect/API/ordersList_api.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/TextConst.dart';
import 'package:she_connect/MainWidgets/shimmer.dart';
import 'package:she_connect/Screens/OrderDetailsPage.dart';

import '../Const/network.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  var arrOrders;
  var img;
  var load = true;
  var orderCount;
  bool doublePrd = false;
  @override
  void initState() {
    super.initState();
    this.getOrders();
    setState(() {});
  }

  Future<String> getOrders() async {
    var rsp = await listOrdersAPI();
    if (rsp["status"].toString() == "success") {
      setState(() {
        arrOrders = rsp["data"]["lists"];
      });
    }
    setState(() {
      load = false;
    });
    return "success";
  }

  int? _groupValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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
            "My Orders",
            style: appBarTxtStyl,
          ),
          // bottom: PreferredSize(
          //   preferredSize: const Size.fromHeight(50),
          //   child: Padding(
          //     padding:
          //         const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //     child: Row(
          //       children: [
          //         const Text("Last 6 months", style: size14_600),
          //         const Spacer(),
          //         GestureDetector(
          //           child: const Text("Change", style: size14_600Pink),
          //           onTap: () {
          //             orderTimeBottom();
          //           },
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ),
        body: load == true
            ? shimmerOrdersList()
            : arrOrders.isNotEmpty
                ? LayoutBuilder(builder: (context, snapshot) {
                    if (snapshot.maxWidth < 600) {
                      return Scrollbar(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: RefreshIndicator(
                            onRefresh: getOrders,
                            child: ListView.separated(
                              scrollDirection: Axis.vertical,
                              physics: const AlwaysScrollableScrollPhysics(),
                              separatorBuilder: (context, index) => Divider(
                                color: Colors.grey[300],
                                endIndent: 20,
                                indent: 20,
                                thickness: 1,
                              ),
                              shrinkWrap: true,
                              itemCount:
                                  arrOrders != null ? arrOrders.length : 0,
                              itemBuilder: (context, index) {
                                final item =
                                    arrOrders != null ? arrOrders[index] : null;
                                return orderList(item, index);
                              },
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Scrollbar(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 30,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 3.6),
                            itemBuilder: (BuildContext context, int index) {
                              return orderGrid(index);
                            },
                          ),
                        ),
                      );
                    }
                  })
                : Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/Images/noOrders.png",
                        width: 300,
                      ),
                      h(20),
                      Text("No order history available!", style: size14_600)
                    ],
                  )));
  }

  orderList(var item, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: GestureDetector(
        onTap: () {
          setState(() {
            doublePrd = item["orderDetails"].length > 1 ? true : false;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrderDetails(
                    ordrID: item["_id"].toString(), prd: doublePrd)),
          );
        },
        child: Container(
          color: Colors.white,
          child: Row(
            children: [
              Container(
                height: 96,
                width: 80,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(
                          baseUrl +
                              catalogue +
                              item["orderDetails"][0]["product"]["image"]
                                  .toString(),
                        ),
                        fit: BoxFit.cover)),
              ),
              w(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                              item["orderDetails"][0]["product"]["name"]
                                  .toString(),
                              style: size16_700),
                        ),
                        item["orderDetails"].length > 1
                            ? Text("  (" +
                                item["orderDetails"].length.toString() +
                                " products) ")
                            : Opacity(opacity: 0)
                      ],
                    ),
                    h(5),
                    item["orderStatus"] == "CANCELLED"
                        ? Text("Cancelled", style: size14_600Red)
                        : item["orderStatus"].toString() == "COMPLETED"
                            ? Opacity(opacity: 0)
                            : Text(
                                "Delivery " +
                                    item["orderDetails"][0]["product"]
                                            ["expectedDelivery"]
                                        .toString(),
                                style: size14_400Grey,
                              ),
                    item["orderStatus"].toString() == "COMPLETED"
                        ? Text("Delivered", style: size14_600Green)
                        : item["orderStatus"].toString() == "PROCESSING"
                            ? Text("Order is under processing",
                                style: size14_400)
                            : item["orderStatus"].toString() == "NEW"
                                ? Opacity(opacity: 0)
                                : item["orderStatus"].toString() == "CANCELLED"
                                    ? Opacity(opacity: 0)
                                    : item["orderStatus"].toString() == "PACKED"
                                        ? Text("Your order is packed",
                                            style: size14_400)
                                        : item["orderStatus"].toString() ==
                                                "SHIPPED"
                                            ? Text("Your order is shipped",
                                                style: size14_400)
                                            : Text(
                                                item["orderStatus"].toString())
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: Colors.grey,
              )
            ],
          ),
        ),
      ),
    );
  }

  orderGrid(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OrderDetails()),
          );
        },
        child: Container(
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
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                          image: NetworkImage(
                            tstImg,
                          ),
                          fit: BoxFit.cover)),
                ),
                w(10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Anarkali Long Wear", style: size16_700),
                    h(5),
                    const Text(
                      "Delivery by 17-Nov-2021",
                      style: size14_400Grey,
                    )
                  ],
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: Colors.grey,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  noOrders() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: (Colors.grey[300]!),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/Images/Icons/cart.png",
              height: 100,
              color: BGgrey,
            ),
            h(10),
            const Text(
              "No recent orders",
              style: size16_400,
            ),
            h(10),
            const Text(
              "Start shopping",
              style: size16_600pink,
            )
          ],
        ),
      ),
    );
  }

  orderTimeBottom() {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context) => Stack(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      height: 60,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                            top: const Radius.circular(10.0)),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            const Text(
                              "Order Time",
                              style: size18_700,
                            ),
                            const Spacer(),
                            IconButton(
                                icon: const Icon(Icons.clear),
                                iconSize: 18,
                                onPressed: () {
                                  Navigator.pop(context);
                                })
                          ],
                        ),
                      ),
                    ),
                    radioType("Last 6 months"),
                    radioType("2021"),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                          top: 10),
                    ),
                  ],
                ),
              ),
            ]));
  }

  radioType(String txt) {
    return Row(
      children: [
        Radio<int>(
          groupValue: _groupValue,
          activeColor: radioClr,
          toggleable: true,
          value: 1,
          onChanged: (int? value) {
            setState(() {
              _groupValue = value;
            });
          },
        ),
        Text(
          txt,
          style: size16_400,
        )
      ],
    );
  }
}
