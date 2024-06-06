import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:she_connect/API/ListCart_api.dart';
import 'package:she_connect/API/viewAddress_API.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/TextConst.dart';
import 'package:she_connect/MainWidgets/BottomNav.dart';
import 'package:she_connect/Screens/ReferAFriend/ReferAFriend.dart';
import 'package:she_connect/testpg.dart';

class SuccessLanding extends StatefulWidget {
  final address;

  const SuccessLanding({Key? key, this.address}) : super(key: key);

  @override
  _SuccessLandingState createState() => _SuccessLandingState();
}

class _SuccessLandingState extends State<SuccessLanding> {
  var arrAddress;
  var arrCartLength;

  @override
  void initState() {
    super.initState();
    getCart();
    setState(() {});
  }

  Future<String> getCart() async {
    final model = Provider.of<MyHomePageModel>(context, listen: false);

    var arrayData = await viewAddressAPI(widget.address);

    if (arrayData["status"].toString() == "success") {
      setState(() {
        var rsppppp = arrayData["data"];
        arrAddress = rsppppp;
      });
      print('arrAddress');
      print(arrAddress);
      print('arrAddress');
      var rsp = await listCartApi();
      if (rsp["status"].toString() == "success") {
        setState(() {
          arrCartLength = rsp["data"]["lists"].length;
          model.addCounter(arrCartLength);
        });
      }
    }

    setState(() {});
    return "success";
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNav()),
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: textFieldGrey,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0.1),
          child: AppBar(elevation: 0, backgroundColor: textFieldGrey),
        ),
        body: SingleChildScrollView(
          child: Wrap(
            runSpacing: 8,
            children: [
              success(),
              // fail(),
              // ExpctedDelivery(),
              // tryPaymentAgain(),
              addressDetails(),
              wallet(),
              // backToMainMenu(),
              invite()
            ],
          ),
        ),
      ),
    );
  }

  success() {
    return Container(
      width: double.infinity,
      color: textFieldGrey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/Images/Icons/success.png",
                height: 90, width: 90),
            h(15),
            const Text("Order Confirmed", style: size22_400),
            h(7),
            const Text(
              "Order ID SC0248893849384",
              style: size14_400Grey,
            )
          ],
        ),
      ),
    );
  }

  Widget tryPaymentAgain() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: const [
            Text(
              "Try payment again",
              style: size16_600pink,
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: darkPink,
            )
          ],
        ),
      ),
    );
  }

  Widget backToMainMenu() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: const [
            Text(
              "Return back to main menu",
              style: size16_600pink,
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: darkPink,
            )
          ],
        ),
      ),
    );
  }

  fail() {
    return Container(
      width: double.infinity,
      color: textFieldGrey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/Images/Icons/cancel.png",
                height: 110, width: 110),
            h(15),
            const Text("Something went wrong!", style: size22_600),
          ],
        ),
      ),
    );
  }

  ExpctedDelivery() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Expected Delivery",
              style: size18_400,
            ),
            h(14),
            ListView.separated(
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const SizedBox(
                height: 0,
              ),
              shrinkWrap: true,
              itemCount: 2,
              itemBuilder: (context, index) {
                return orderedItemsList(index);
              },
            )
          ],
        ),
      ),
    );
  }

  orderedItemsList(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 115,
            width: 115,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black12),
                image: const DecorationImage(
                    image: const NetworkImage(bagImg), fit: BoxFit.cover)),
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
                  const Text("In 4-7 Working Days", style: size16_400Green),
                  const Text(
                    "Surene tote Bag",
                    style: size16_700,
                  ),
                  gap(5),
                  // TimeSlot(),
                  SelectVarient(),
                  h(5),
                  const Text(
                    "Qty: 2",
                    style: size14_700,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  gap(double h) {
    return SizedBox(
      height: h,
    );
  }

  Widget SelectVarient() {
    return Wrap(
      spacing: 10,
      children: [
        RichText(
          text: const TextSpan(text: 'Color:', style: size10_600, children: [
            TextSpan(
              text: '  RED',
              style: size10_600,
            )
          ]),
        ),
        RichText(
          text: const TextSpan(text: 'Size:', style: size10_600, children: [
            TextSpan(
              text: '  M',
              style: size10_600,
            )
          ]),
        ),
      ],
    );
  }

  addressDetails() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Row(
          children: [
            Expanded(child: Image.asset("assets/Images/Icons/successHome.png")),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Home Delivery", style: size16_700),
                  h(5),
                  Text(
                    "Order will be delivered to the address provided by you.",
                    style: size12_400,
                  ),
                  h(10),
                  GestureDetector(
                    onTap: () {
                      ViewAddress();
                    },
                    child: const Text(
                      "View Address",
                      style: size14_600Pink,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  wallet() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Row(
          children: [
            Expanded(
                child:
                    Image.asset("assets/Images/Icons/wallet.png", height: 25)),
            const Expanded(
              flex: 3,
              child: Text("You earned    0.00", style: size16_700),
            ),
            Expanded(
              child: Container(),
            )
          ],
        ),
      ),
    );
  }

  invite() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Invite Friends & Earn",
                        style: size16_700,
                      ),
                      const Text(
                        "You will get 100 for every friend",
                        style: size12_400,
                      ),
                      h(15),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ReferAFriend(back: "true")),
                          );
                        },
                        child: const Text(
                          "Invite Now",
                          style: size16_600pink,
                        ),
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  child: CircleAvatar(
                      radius: 35,
                      backgroundImage:
                          AssetImage("assets/Images/Icons/invite.png")),
                ),
              ],
            ),
            h(40),
            _button(),
          ],
        ),
      ),
    );
  }

  _button() {
    return GestureDetector(
      onTap: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNav()),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: buttonGradient, borderRadius: BorderRadius.circular(10)),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            "CONTINUE SHOPPING",
            style: size16_700W,
          ),
        ),
      ),
    );
  }

  ViewAddress() {
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      height: 60,
                      decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20.0)),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            Text(
                              arrAddress[0]["typeOfAddress"].toString(),
                              style: size18_700,
                            ),
                            const Spacer(),
                            IconButton(
                                icon: const Icon(Icons.clear, size: 18),
                                onPressed: () {
                                  Navigator.pop(context);
                                })
                          ],
                        ),
                      ),
                    ),
                    Text(arrAddress[0]["name"].toString(), style: size14_600),
                    h(10),
                    Text(
                        arrAddress[0]["locality"].toString() +
                            ", " +
                            arrAddress[0]["city"].toString(),
                        style: size14_400Grey),
                    Text(arrAddress[0]["city"].toString(),
                        style: size14_400Grey),
                    Text(
                      arrAddress[0]["state"].toString(),
                      style: size14_400Grey,
                    ),
                    Text(
                      "Phone : " + arrAddress[0]["phoneNo"].toString(),
                      style: size14_400Grey,
                    ),
                    h(20),
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
}
