import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:she_connect/API/ListCart_api.dart';
import 'package:she_connect/API/deleteCart_api.dart';
import 'package:she_connect/API/updateCart_api.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/TextConst.dart';
import 'package:she_connect/Helper/snackbar_toast_helper.dart';
import 'package:she_connect/MainWidgets/loading.dart';
import 'package:she_connect/Screens/CheckoutScreen.dart';
import 'package:she_connect/Screens/VerifyOTP.dart';
import 'package:she_connect/Screens/WishlistScreen.dart';
import 'package:she_connect/testpg.dart';

import '../Const/network.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  var arrCart = [];
  var load = true;
  var cartTotal = 0;
  var totalAMOUNT = 0;
  var totalNetAmount = 0;
  var noDiscountPrice = 0;
  var sellingPrice = 0;
  var SingleTotal = 0;
  var FullPrice = 0;
  var netAmt = 0;
  var quantity = 0;
  var price = 0;
  var discount = 0;
  var btTap = false;
  var totalAmt = 0;
  var cartItemsNew = [];
  var totalDiscount = 0;
  var totalDeliveryChrg = 0;
  var deliveryChrg;
  var neetttttttAmount;
  var arrCartLength;
  @override
  void initState() {
    super.initState();
    this.getCart();
    setState(() {});
  }

  Future<String> getCart() async {
    var rsp = await listCartApi();
    if (rsp["status"].toString() == "success") {
      setState(() {
        totalAMOUNT = rsp["data"]["totalCartAmount"];
        arrCart = rsp["data"]["lists"];
        print("````````````arrCart````````````");
        print(arrCart);
        print("``````````````arrCart``````````````");
      });

      _total();
      _cartAPI();
      _sellingPrice();
    }

    setState(() {
      load = false;
      btTap = false;
    });
    return "success";
  }

  void add() {
    setState(() {
      _n++;
    });
  }

  void minus() {
    setState(() {
      if (_n != 0) _n--;
    });
  }

  int _n = 0;
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MyHomePageModel>(context, listen: false);
    return load == true
        ? Container(color: Colors.white, child: loading())
        : Scaffold(
            appBar: AppBar(
                centerTitle: true,
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Wishlist()),
                        );
                      },
                      icon: const Icon(Icons.favorite_border,
                          color: Colors.black, size: 25))
                ],
                title: const Text("My Cart", style: appBarTxtStyl)),
            body: arrCart.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(children: [
                      h(10),
                      Expanded(
                          child: Scrollbar(
                              child: RefreshIndicator(
                        onRefresh: getCart,
                        child: ListView.separated(
                            scrollDirection: Axis.vertical,
                            physics: AlwaysScrollableScrollPhysics(),
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                            shrinkWrap: true,
                            itemCount: arrCart != null ? arrCart.length : 0,
                            itemBuilder: (context, index) {
                              final item = arrCart != null ? arrCart : null;
                              return CartItems(item, index);
                            }),
                      )))
                    ]))
                : Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/noItem.png",
                        width: 100,
                      ),
                      h(10),
                      Text("Your cart is empty!", style: size14_600Grey)
                    ],
                  )),
            bottomNavigationBar: arrCart.isEmpty
                ? Opacity(opacity: 0)
                : Container(
                    height: 60,
                    decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Colors.black12, width: 1)),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(rs + " " + totalAMOUNT.toString(),
                                  style: size20_400),
                              GestureDetector(
                                  onTap: () {
                                    // loginAlert();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CheckoutScreen(
                                              total: cartTotal.toString(),
                                              netAmt: netAmt.toString(),
                                              grossAmount: totalAmt,
                                              uncut: noDiscountPrice.toString(),
                                              products: cartItemsNew)),
                                    );
                                  },
                                  child: Container(
                                    width: 224,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        gradient: buttonGradient,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Text(
                                      "CONTINUE",
                                      style: size16_700W,
                                    ),
                                  ))
                            ]))));
  }

  CartItems(var item, int index) {
    final model = Provider.of<MyHomePageModel>(context, listen: false);

    return Stack(
      children: [
        Container(
            decoration: BoxDecoration(
                // boxShadow: [
                //   BoxShadow(
                //       color: (Colors.grey[300]!),
                //       spreadRadius: 1,
                //       blurRadius: 3,
                //       offset: const Offset(0, 1))
                // ],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black12),
                color: Colors.white),
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 125,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black12),
                            image: DecorationImage(
                                image: item[index]["product"]["image"] != null
                                    ? NetworkImage(baseUrl +
                                        catalogue +
                                        item[index]["product"]["image"])
                                    : AssetImage("assets/Images/LogoVector.png")
                                        as ImageProvider,
                                fit: BoxFit.cover)),
                      ),
                      w(15),
                      Expanded(
                          child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        item[index]["product"]["name"]
                                            .toString(),
                                        style: size16_400),
                                    h(5),
                                    item[index]["product"]["vendor"] != null
                                        ? Text(
                                            item[index]["product"]["vendor"]
                                                    ["name"]
                                                .toString(),
                                            style: size12_400)
                                        : Opacity(opacity: 0),
                                    // SelectVarient(),
                                    // gap(5),
                                    _CartIncrementDecrement(index, item),
                                    h(5),
                                    Wrap(spacing: 10, children: [
                                      Text(
                                          rs +
                                              item[index]["netAmount"]
                                                  .toString(),
                                          style: size16_400),
                                      Text(
                                          rs +
                                              item[index]["product"]
                                                      ["listPrice"]
                                                  .toString(),
                                          style: size16_400Grey)
                                    ])
                                  ])))
                    ]))),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
              onPressed: () async {
                deleteCartAlert(item, index);
              },
              icon: const Icon(Icons.close, size: 15)),
        )
      ],
    );
  }

  Widget SelectVarient() {
    return Wrap(spacing: 10, children: [
      Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.grey[200]),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              child: RichText(
                  text: const TextSpan(
                      text: 'Color:',
                      style: size10_600,
                      children: [
                    TextSpan(text: '  RED', style: size10_600)
                  ])))),
      Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.grey[200]),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              child: RichText(
                  text: const TextSpan(
                      text: 'Size:',
                      style: size10_600,
                      children: [TextSpan(text: '  M', style: size10_600)]))))
    ]);
  }

  Widget TimeSlot() {
    return GestureDetector(
        onTap: () {
          TimeSlotBottom();
        },
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey[200]),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                child: Row(mainAxisSize: MainAxisSize.min, children: const [
                  Text("Select Slot", style: size10_600),
                  Icon(Icons.arrow_right, size: 15)
                ]))));
  }

  _CartIncrementDecrement(int index, var item) {
    return SizedBox(
        height: 25,
        width: 100,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          SizedBox(
              height: 20,
              width: 20,
              child: GestureDetector(
                  onTap: () async {
                    setState(() {
                      btTap = true;
                    });
                    var qty = int.parse(item[index]["quantity"].toString());
                    if (qty <= 1) {
                      deleteCartAlert(item, index);
                    } else {
                      setState(() {
                        // qty = int.parse(qty.toString()) - 1;
                        qty = int.parse(qty.toString()) - 1;
                        // item[index]["quantity"] = qty;
                      });
                      var rsp = await UpdateCartApi(
                        item[index]["product"]["_id"],
                        -1,
                        item[index]["retailPrice"],
                        item[index]["_id"],
                        item[index]["netAmount"],
                      );
                      print(rsp);
                      setState(() {
                        getCart();
                      });
                    }

                    // minus();
                  },
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          shape: BoxShape.circle),
                      child: const Icon(Icons.remove, size: 15)))),
          Text(
            item[index]["quantity"].toString(),
            style: size14_600,
          ),
          SizedBox(
              height: 20,
              width: 20,
              child: GestureDetector(
                  onTap: () async {
                    setState(() {
                      btTap = true;
                    });
                    var qty = int.parse(item[index]["quantity"].toString());
                    setState(() {
                      // qty++;
                      // item[index]["quantity"] = qty;
                      qty = int.parse(qty.toString()) + 1;
                    });
                    var rsp = await UpdateCartApi(
                      item[index]["product"]["_id"],
                      1,
                      item[index]["retailPrice"],
                      item[index]["_id"],
                      item[index]["netAmount"],
                    );

                    setState(() {
                      getCart();
                    });
                    // add();
                  },
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          shape: BoxShape.circle),
                      child: const Icon(Icons.add, size: 15))))
        ]));
  }

  TimeSlotBottom() {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context) => Stack(children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    Container(
                        height: 60,
                        decoration: const BoxDecoration(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(10.0)),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(children: [
                              const Text(
                                "Select Slot",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 18),
                              ),
                              const Spacer(),
                              IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  })
                            ]))),
                    Row(children: [
                      Container(
                          child: Row(children: const [
                        Text("Date: ", style: size14_400Grey)
                        // _selectDate(context),
                      ]))
                    ]),
                    Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                            top: 10))
                  ]))
            ]));
  }

  void deleteCartAlert(var item, int index) {
    final model = Provider.of<MyHomePageModel>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: new BorderRadius.circular(12)),
        elevation: 10,
        title: Text('Remove Item', style: size18_700),
        content: StreamBuilder<Object>(
            stream: null,
            builder: (context, snapshot) {
              return Text('Are you sure you want to remove this item?',
                  style: size16_400grey);
            }),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.blueAccent, textStyle: size12_700W),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.red[400], textStyle: size12_700W),
            onPressed: () async {
              print(item[index]["_id"]);
              var rsp = await DeleteCartApi(item[index]["_id"]);
              print(rsp);
              if (rsp["status"].toString() == "success") {
                print("-----------------------------------");
                var rsp = await listCartApi();
                if (rsp["status"].toString() == "success") {
                  setState(() {
                    arrCartLength = rsp["data"]["lists"].length;
                    model.addCounter(arrCartLength);
                  });
                }
                print("-----------------------------------");
                setState(() {
                  showToastSuccess("Item Removed from cart");
                  // getCart();
                  Navigator.pop(context);
                  setState(() {
                    getCart();
                    arrCart.removeAt(index);
                  });
                });
              }
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  loginAlert() {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context) => Stack(children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                    Image.asset("assets/logo.png", scale: 6),
                    h(5),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("LOGIN", style: size16_700),
                          Text(" or ", style: size14_400Grey),
                          Text("SIGNUP", style: size16_700)
                        ]),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10)
                            ],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                prefixText: "+91  ",
                                labelText: "Phone Number",
                                labelStyle: const TextStyle(
                                    color: Colors.black26, fontSize: 15),
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide())))),
                    h(20),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const VerifyOTP()));
                        },
                        child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 30),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                gradient: buttonGradient,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Text("CONTINUE", style: size16_700W)))),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                    Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                            top: 10))
                  ]))
            ]));
  }

  void _total() {
    setState(() {
      cartTotal = 0;
    });
    for (var i = 0; i < arrCart.length; i++) {
      price = arrCart[i]["netAmount"];
      cartTotal = cartTotal +
          (int.parse(price.toString()) *
              int.parse(arrCart[i]["quantity"].toString()));
      SingleTotal = price * int.parse(arrCart[i]["quantity"].toString());
      setState(() {
        cartTotal;
      });
    }
  }

  void _sellingPrice() {
    setState(() {
      sellingPrice = 0;
    });
    for (var i = 0; i < arrCart.length; i++) {
      price = arrCart[i]["product"]["retailPrice"];
      discount = arrCart[i]["product"]["discountPrice"];
      sellingPrice = sellingPrice + (price - discount);
      // FullPrice = price * int.parse(arrCart[i]["quantity"].toString());
      // print("SELLING PRICE:" + sellingPrice.toString());

      setState(() {
        sellingPrice;
      });
    }
  }

  void _cartAPI() {
    cartItemsNew.clear();
    setState(() {
      totalAmt = 0;
      neetttttttAmount = 0;
    });
    for (var i = 0; i < arrCart.length; i++) {
      var map = arrCart[i];
      var retail = map["product"]["retailPrice"];
      var disc = map["product"]["discountPrice"];
      var sell = int.parse(retail.toString()) - int.parse(disc.toString());
      var netAmt = sell * int.parse(map["quantity"].toString());
      var sellingPrice = map["sellingPrice"];
      var qty = map["quantity"];
      neetttttttAmount =
          int.parse(sellingPrice.toString()) * int.parse(qty.toString());

      setState(() {
        cartItemsNew.add({
          'product': map["product"]["_id"],
          'quantity': map["quantity"],
          'sellingPrice': sell,
          'retailPrice': map["product"]["retailPrice"],
          'netAmount': netAmt,
          'discountAmount': map["product"]["discountPrice"],
          // 'productVarientId': "",
          // 'returnStatus': "REQUESTED",
        });
      });
      setState(() {
        load = false;
        totalAmt = netAmt + totalAmt;
        print("total amt: " + totalAmt.toString());
      });
    }
  }

  void netAmtCalc() {
    setState(() {
      netAmt = (totalAmt - totalDiscount) + totalDeliveryChrg;
      print("net amt:" + netAmt.toString());
    });
  }
}
