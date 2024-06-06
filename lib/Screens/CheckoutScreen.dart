import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:she_connect/API/PlaceOrder_api.dart';
import 'package:she_connect/API/checkCartAfterApplyCoupon_API.dart';
import 'package:she_connect/API/findDeliveryChargeAPI.dart';
import 'package:she_connect/API/listAddress_api.dart';
import 'package:she_connect/API/userProfile_api.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/TextConst.dart';
import 'package:she_connect/Helper/sharedPref.dart';
import 'package:she_connect/Helper/snackbar_toast_helper.dart';
import 'package:she_connect/MainWidgets/loading.dart';
import 'package:she_connect/Screens/Address/AddNewAddress.dart';
import 'package:she_connect/Screens/Address/SelectAddress.dart';
import 'package:she_connect/Screens/ApplyCouponScreen.dart';
import 'package:she_connect/Screens/Payment/PaymentSuccess.dart';
import 'package:she_connect/Screens/Payment/paymentGateway.dart';
import 'package:she_connect/Screens/Payment/paymentGatewayWithCoupon.dart';

class CheckoutScreen extends StatefulWidget {
  final total;
  final products;
  final uncut;
  final grossAmount;
  final netAmt;

  const CheckoutScreen(
      {Key? key,
      this.total,
      this.products,
      this.uncut,
      this.grossAmount,
      this.netAmt})
      : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedIndex = 1;
  var paymentType = "CASH_ON_DELIVERY";
  bool isCheck = false;
  var arrAddress = [];
  var result;
  var load = true;
  var defaultAddress;
  var pincode;
  var date;
  var newCartData;
  var email;
  var name;
  var phone;
  var walletBlnc = 0;
  var arrDetails;
  var isApplied = false;
  var coupon;
  var uniqueVendor = [];
  var totalAmount = 0;
  int count = 0;
  var btTap = false;
  int? _groupValue;
  var productsArray = [];
  var arrCartNew;
  bool coinApplied = false;
  var moreBalance;
  var usedCoins = 0;
  var FinalBalance = 0;
  var xxxx = 0;
  var totalDeliveryChrg = 0;
  var finalDeliveryCharge = 0;
  bool noDelivery = false;
  var arrVendorsIDList = [];
  @override
  void initState() {
    super.initState();
    DateTime dateToday = DateTime.now();
    date = dateToday.toIso8601String();
    getAddress();
    setState(() {});
  }

  @override
  Future<String> getAddress() async {
    var rsp = await listAddressAPI();
    if (rsp["status"].toString() == "success") {
      await chkcart();
      await details();

      setState(() {
        arrAddress = rsp["data"];
        count = int.parse(arrAddress.length.toString()) - 1;
      });
      for (var i = 0; i < arrAddress.length; i++) {
        var map = arrAddress[i];
        if (map["isDefaultAddress"] == true) {
          setState(() {
            defaultAddress = map["_id"];
            pincode = map["pincode"];
          });
          _deliveryCharge();
        }
      }
    }
    setState(() {
      load = false;
    });
    return "success";
  }

  Future<String> details() async {
    var rsp = await userprofile();
    if (rsp != 0) {
      setState(() {
        arrDetails = rsp["data"];
        name = arrDetails['name'].toString();
        email = arrDetails['email'].toString();
        phone = arrDetails['phone'].toString();
        walletBlnc = arrDetails['walletBalance'];
        xxxx = arrDetails['walletBalance'];
      });
    }
    setState(() {
      load = false;
    });
    return "success";
  }

  Future<String> chkcart() async {
    productsArray.clear();
    var cp = await getSharedPrefrence(COUPON);
    coupon = cp;
    var rsp = await checkCartAfterCouponAPI();
    if (rsp["status"].toString() == "success") {
      newCartData = rsp["data"];
      totalAmount = int.parse(newCartData["totalCartAmount"].toString()) -
          int.parse(newCartData["discount"].toString()) +
          int.parse(finalDeliveryCharge.toString());
      arrCartNew = newCartData["lists"];

      for (var i = 0; i < arrCartNew.length; i++) {
        var map = arrCartNew[i];
        var retail = map["retailPrice"];
        var disc = map["discountAmount"];
        var sell = map["sellingPrice"];
        var netAmount = map["netAmount"];
        setState(() {
          productsArray.add({
            'product': map["product"]["_id"],
            'quantity': map["quantity"],
            'sellingPrice': sell,
            'retailPrice': retail,
            'netAmount': netAmount,
            'discountAmount': disc,
            // 'productVarientId': "",
            // 'returnStatus': "REQUESTED",
          });
        });
      }
    }
    setState(() {
      load = false;
    });
    return "success";
  }

  void _deliveryCharge() async {
    setState(() {
      totalDeliveryChrg = 0;
      finalDeliveryCharge = 0;
    });
    for (var i = 0; i < arrCartNew.length; i++) {
      var map = arrCartNew[i];
      var vendorID = map["product"]["vendor"]["_id"];
      setState(() {
        arrVendorsIDList.add(vendorID);
      });

      uniqueVendor = arrVendorsIDList.toSet().toList();
    }

    for (var i = 0; i < uniqueVendor.length; i++) {
      var map = uniqueVendor[i];
      var rsp = await findDeliveryChargeAPI(pincode.toString(), map.toString());

      if (rsp["status"].toString() == "error") {
        setState(() {
          noDelivery = true;
        });
      } else {
        var charges = rsp["data"]["deliveryCharge"];
        totalDeliveryChrg = charges + totalDeliveryChrg;
        finalDeliveryCharge = totalDeliveryChrg;
        noDelivery = false;
      }
    }

    setState(() {});
    totalAmount = int.parse(totalAmount.toString()) +
        int.parse(finalDeliveryCharge.toString());
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
            title: const Text("Checkout", style: appBarTxtStyl)),
        body: load == true
            ? loading()
            : RefreshIndicator(
                onRefresh: getAddress,
                child: SingleChildScrollView(
                    child: Wrap(runSpacing: 10, children: [
                  SavedAddress(),
                  _applyCoupon(),
                  _rewardPoints(),
                  _expectedDelivery(),
                  totalAmount == 0 ? Opacity(opacity: 0) : _paymentMethod(),
                  // _ScheduleSlot(),
                  _orderDetials()
                ])),
              ),
        bottomNavigationBar: load == true
            ? Opacity(opacity: 0)
            : noDelivery == true
                ? Container(
                    height: 60,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(color: darkPink, width: 2),
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                          "Seller dosen't deliver to this location. Please change your pincode or try later.",
                          style: size12_700W,
                          textAlign: TextAlign.center),
                    ),
                  )
                : Container(
                    color: Colors.white,
                    height: 60,
                    child: GestureDetector(
                        onTap: () async {
                          if (arrAddress.length == 0) {
                            showToastSuccess(
                                "Please add a delivery address to proceed!");
                          } else {
                            if (newCartData["discount"] != 0) {
                              print(
                                  "*************WITH COUPON*******************");
                              setState(() {
                                btTap = true;
                              });
                              if (_selectedIndex == 1) {
                                print(totalAmount);
                                var rsp = await palceOrderWithCouponAPI(
                                    defaultAddress,
                                    date,
                                    newCartData["totalCartAmount"].toString(),
                                    totalAmount.toString(),
                                    newCartData["discount"].toString(),
                                    productsArray,
                                    paymentType,
                                    finalDeliveryCharge,
                                    coupon.toString(),
                                    coinApplied);
                                print(rsp);
                                if (rsp["status"].toString() == "success") {
                                  SharedPreferences prefrences =
                                      await SharedPreferences.getInstance();

                                  await prefrences.remove(COUPON);
                                  showToastSuccess("Order Placed!");
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PaymentSuccess(
                                            address: defaultAddress)),
                                  );
                                } else {
                                  setState(() {
                                    btTap = false;
                                  });
                                }
                              } else {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            paymentPageWithCoupon(
                                                total: totalAmount,
                                                phone: phone,
                                                email: email,
                                                defaultAddress: defaultAddress,
                                                date: date,
                                                grossAmt:
                                                    newCartData[
                                                            "totalCartAmount"]
                                                        .toString(),
                                                products: productsArray,
                                                modeOfPayment: paymentType,
                                                netAmt: totalAmount.toString(),
                                                discount:
                                                    newCartData["discount"]
                                                        .toString(),
                                                delivery: finalDeliveryCharge,
                                                coupon: coupon,
                                                coin: coinApplied)));
                              }
                            } else {
                              print(
                                  "*************WITHOUT COUPON*******************");
                              setState(() {
                                btTap = true;
                              });
                              if (_selectedIndex == 1) {
                                var rsp = await palceOrderAPI(
                                    defaultAddress,
                                    date,
                                    newCartData["totalCartAmount"].toString(),
                                    totalAmount.toString(),
                                    newCartData["discount"].toString(),
                                    productsArray,
                                    paymentType,
                                    finalDeliveryCharge,
                                    coinApplied);
                                print(rsp);
                                if (rsp["status"].toString() == "success") {
                                  SharedPreferences prefrences =
                                      await SharedPreferences.getInstance();

                                  await prefrences.remove(COUPON);
                                  showToastSuccess("Order Placed!");
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PaymentSuccess(
                                            address: defaultAddress)),
                                  );
                                } else {
                                  setState(() {
                                    btTap = false;
                                  });
                                }
                              } else {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => paymentPage(
                                            total: totalAmount,
                                            phone: phone,
                                            email: email,
                                            defaultAddress: defaultAddress,
                                            date: date,
                                            discount: newCartData["discount"]
                                                .toString(),
                                            grossAmt:
                                                newCartData["totalCartAmount"]
                                                    .toString(),
                                            netAmt: totalAmount.toString(),
                                            products: productsArray,
                                            modeOfPayment: paymentType,
                                            delivery: finalDeliveryCharge,
                                            coin: coinApplied)));
                              }
                            }
                          }
                        },
                        child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                gradient: buttonGradient,
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 40),
                                child: btTap == true
                                    ? Center(
                                        child: SpinKitThreeBounce(
                                        color: Colors.white,
                                        size: 25,
                                      ))
                                    : Text(
                                        totalAmount == 0
                                            ? "CHECKOUT"
                                            : "PROCEED TO PAYMENT",
                                        style: size16_700W))))));
  }

  SavedAddress() {
    return load == true
        ? LinearProgressIndicator(
            color: darkPink,
          )
        : arrAddress.length == 0
            ? _addAddressButton()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: Text("Delivery Addresses", style: size14_600),
                  ),
                  ListView.separated(
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => h(5),
                      shrinkWrap: true,
                      itemCount: arrAddress != null ? arrAddress.length : 0,
                      itemBuilder: (context, index) {
                        final item =
                            arrAddress != null ? arrAddress[index] : null;
                        return SavedAddressList(item, index);
                      }),
                  h(3),
                  count.toString() != "0"
                      ? Row(
                          children: [
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SelectAddress(
                                          fromCheck: true,
                                          refresh: getAddress)),
                                );
                              },
                              child: Text("+ " + count.toString() + " more",
                                  style: size14_700),
                            ),
                            w(20)
                          ],
                        )
                      : Opacity(opacity: 0)
                ],
              );
  }

  Widget SavedAddressList(var item, int index) {
    return item["isDefaultAddress"] == true
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12)),
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(item["typeOfAddress"].toString(),
                                  style: size16_700),
                              item["isDefaultAddress"] == true
                                  ? Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: green),
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 3),
                                          child: Text("DEFAULT",
                                              style: size12_400W)))
                                  : Opacity(opacity: 0),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          Text(item["name"].toString(), style: size14_600),
                          const SizedBox(height: 5),
                          Text(
                              item["flatNo"].toString() +
                                  ", " +
                                  item["locality"].toString(),
                              style: size14_400),
                          Text(
                              item["city"].toString() +
                                  ", " +
                                  item["pincode"].toString(),
                              style: size14_400),
                          Text(
                              "Landmark: " + item["nearestLandmark"].toString(),
                              style: size14_400),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(item["state"].toString() + ",   ",
                                    style: size14_400),
                                Text("Phone : " + item["phoneNo"].toString(),
                                    style: size14_400),
                              ])
                        ]))))
        : Opacity(opacity: 0);
  }

  Widget _addAddressButton() {
    return Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddNewAddress(
                        refresh: getAddress,
                        name: arrDetails["name"],
                        mob: phone)));
          },
          child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[400]!)),
              child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text("+ Add New Address", style: size14_600Pink))),
        ));
  }

  Widget _applyCoupon() {
    return newCartData["discount"] != 0
        ? GestureDetector(
            onTap: () {
              showToastSuccess("Coupon already applied!");
            },
            child: Container(
                color: Colors.white,
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(children: [
                          Image.asset("assets/appliedCoupon.png", height: 20),
                          const SizedBox(width: 10),
                          Text("Coupon Applied!", style: size14_600Green),
                          const Spacer(),
                          Icon(Icons.check_circle,
                              color: Colors.green, size: 18),
                        ])))),
          )
        : GestureDetector(
            onTap: () async {
              result = await Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => ApplyCoupon(rfrsh: chkcart)));
            },
            child: Container(
                color: Colors.white,
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(children: [
                          Image.asset("assets/coupon.png", height: 20),
                          const SizedBox(width: 10),
                          // result.isNotEmpty
                          //     ? Text(
                          //         "000000000",
                          //         style: size14_600,
                          //       )
                          //     :
                          Text("Apply Coupon", style: size14_600),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_ios_sharp, size: 15)
                        ])))),
          );
  }

  Widget _rewardPoints() {
    return Container(
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  coinApplied == true
                      ? Image.asset(
                          "assets/Images/coinApplied.png",
                          height: 20,
                        )
                      : Image.asset("assets/Images/coin.png", height: 20),
                  w(10),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    xxxx == 0
                        ? Text(
                            rs + walletBlnc.toString(),
                            style: size14_600,
                          )
                        : Text(
                            coinApplied == true
                                ? rs + FinalBalance.toString()
                                : rs + xxxx.toString(),
                            style: size14_600,
                          ),
                    Text(
                        coinApplied == true
                            ? " Reward Points Used"
                            : " Reward Points",
                        style: size14_600)
                  ]),
                  const Spacer(),
                  coinApplied == true
                      ? Icon(Icons.check_circle, size: 18, color: Colors.green)
                      : GestureDetector(
                          onTap: () {
                            if (walletBlnc != 0) {
                              if (totalAmount <= walletBlnc) {
                                setState(() {
                                  coinApplied = true;
                                });
                                setState(() {
                                  xxxx = int.parse(walletBlnc.toString()) -
                                      int.parse(totalAmount.toString());
                                  FinalBalance =
                                      int.parse(walletBlnc.toString()) -
                                          int.parse(xxxx.toString());
                                  totalAmount = 0;
                                  // var x = int.parse(xxxx.toString()) -
                                  //     int.parse(walletBlnc.toString());
                                  // walletBlnc = int.parse(walletBlnc.toString()) -
                                  //     int.parse(totalAmount.toString());
                                });
                                print(FinalBalance);
                                showToastSuccess("Coin Applied!");
                              } else {
                                setState(() {
                                  coinApplied = true;
                                });
                                setState(() {
                                  totalAmount =
                                      int.parse(totalAmount.toString()) -
                                          int.parse(walletBlnc.toString());
                                  xxxx = walletBlnc;
                                  FinalBalance = walletBlnc;
                                });
                                print("total after reward points: " +
                                    totalAmount.toString());
                                showToastSuccess("Coin Applied!");
                              }
                            } else {
                              showToastSuccess(
                                  "You don't have any wallet balance.");
                            }
                          },
                          child: const Text("Apply", style: size16_600pink))
                ]))));
  }

  Widget _expectedDelivery() {
    return Container(
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(children: const [
                  Text("Expected Delivery", style: size14_600),
                  Spacer(),
                  Text("3-7 Working Days", style: size12_400Grey)
                ]))));
  }

  Widget _ScheduleSlot() {
    return Container(
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(children: const [
                  Text("Scheduled Slot", style: size14_600),
                  Spacer(),
                  Text("25th Nov (11 am- 12 pm)", style: size12_400Grey)
                ]))));
  }

  Widget _orderDetials() {
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
                      const SizedBox(
                        height: 10,
                      ),
                      ordrDetail("Total MRP",
                          rs + newCartData["totalCartAmount"].toString()),
                      coinApplied == true
                          ? ordrDetail("Reward Points Used",
                              rs + FinalBalance.toString())
                          : Opacity(opacity: 0),
                      ordrDetail("Coupon Discount",
                          rs + newCartData["discount"].toString()),
                      ordrDetail(
                          "Delivery Charge", rs + totalDeliveryChrg.toString()),
                      const Divider(thickness: 2),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(children: [
                            Text("TOTAL AMOUNT", style: size14_600),
                            Spacer(),
                            Text(rs + totalAmount.toString(), style: size14_600)
                          ]))
                    ]))));
  }

  ordrDetail(String txt, String amt) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(children: [
          Text(txt, style: size14_400),
          const Spacer(),
          Text(amt, style: size14_400)
        ]));
  }

  _paymentMethod() {
    return Container(
        width: double.infinity,
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                "Payment Method",
                style: size14_600,
              ),
              Row(children: [
                Radio<int>(
                    groupValue: _selectedIndex,
                    activeColor: radioClr,
                    // toggleable: true,
                    value: 1,
                    onChanged: (value) {
                      setState(() {
                        paymentType = "CASH_ON_DELIVERY".toUpperCase();
                        buttonValue(value!);
                      });
                    }),
                Text("Cash On Delivery", style: size16_400)
              ]),
              Row(children: [
                Radio<int>(
                    groupValue: _selectedIndex,
                    activeColor: radioClr,
                    // toggleable: true,
                    value: 2,
                    onChanged: (value) {
                      setState(() {
                        paymentType = "ONLINE_PAYMENT".toUpperCase();
                        buttonValue(value!);
                      });
                    }),
                Text("Debit/ Credit Card", style: size16_400)
              ]),
            ])));
  }

  void buttonValue(int v) {
    setState(() {
      _selectedIndex = v;
    });
  }
}
