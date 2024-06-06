import 'package:flutter/material.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/TextConst.dart';
import 'package:she_connect/MainWidgets/loading.dart';
import 'package:she_connect/Screens/Wallet/DATA/getWalletAPI.dart';
import 'package:she_connect/Screens/Wallet/WalletHistory.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  var load = true;
  var arrHistory;

  @override
  void initState() {
    super.initState();
    this.getWallet();
    setState(() {});
  }

  Future<String> getWallet() async {
    var rsp = await getWalletAPI();
    if (rsp["status"].toString() == "success") {
      arrHistory = rsp["data"];
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
            title: const Text("Wallet", style: appBarTxtStyl)),
        body: load == true
            ? loading()
            : RefreshIndicator(
                onRefresh: getWallet,
                child: Column(children: [
                  Container(
                      color: Colors.white,
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 40),
                                child: Column(children: [
                                  const Text("Wallet Balance",
                                      style: size16_400),
                                  h(5),
                                  Text(
                                      rs +
                                          arrHistory[0]["closingBalance"]
                                              .toString(),
                                      style: size22_600)
                                ])),
                          ),
                          const Divider(
                            color: Colors.blueGrey,
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child:
                                  const Text("HISTORY", style: size14_600Pink))
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      )),
                  Container(
                    color: Colors.white,
                    child: Divider(
                      color: Colors.blueGrey,
                    ),
                  ),
                  WalletHistory(data: arrHistory)
                ]),
              ));
  }

  invite() {
    return Container(
        margin: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(children: [
              Row(children: [
                Expanded(
                    flex: 3,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Invite Friends & Earn",
                              style: size16_700),
                          const Text("You will get 100 for every friend",
                              style: size12_400),
                          h(15),
                          const Text("Invite Now", style: size16_600pink)
                        ])),
                const Expanded(
                    child: CircleAvatar(
                        radius: 35,
                        backgroundImage:
                            AssetImage("assets/Images/Icons/invite.png")))
              ])
            ])));
  }

  Widget loginBox() {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.15, vertical: 40),
        child: Column(
          children: [
            const Text(
              "Login. Explore",
              style: size20_400,
            ),
            h(20),
            const Text(
                "There are enough reasons to celebrate with SHE CONNECT. Explore now.",
                textAlign: TextAlign.center,
                style: size16_400),
            h(20),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(color: darkPink, width: 1),
                  borderRadius: BorderRadius.circular(10)),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text("Login", style: size18_400Pink),
              ),
            )
          ],
        ),
      ),
      color: Colors.white,
    );
  }
}
