import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:she_connect/API/userProfile_api.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Helper/snackbar_toast_helper.dart';
import 'package:she_connect/MainWidgets/BottomNav.dart';
import 'package:she_connect/MainWidgets/loading.dart';

class ReferAFriend extends StatefulWidget {
  final back;
  const ReferAFriend({Key? key, this.back}) : super(key: key);

  @override
  _ReferAFriendState createState() => _ReferAFriendState();
}

class _ReferAFriendState extends State<ReferAFriend> {
  late String link;
  var arrData;
  var load = true;
  var ref;
  @override
  void initState() {
    super.initState();
    this.details();
    setState(() {});
  }

  Future<String> details() async {
    var rsp = await userprofile();
    if (rsp["status"].toString() == "success") {
      arrData = rsp["data"];
      if (arrData["shareLink"].toString() != "0") {
        link = arrData["shareLink"];
        var split = link.split('/');
        ref = split[3];
        setState(() {
          load = false;
        });
      }
    }

    return "success";
  }

  var back = "false";
  Future<bool> _onBackPressed() {
    if (widget.back.toString() == "true") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNav()),
      );
    }

    return Future<bool>.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          backgroundColor: BGgrey,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  if (widget.back.toString() == "true") {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => BottomNav()),
                    );
                  } else {
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.arrow_back,
                    color: Colors.black, size: 18)),
            title: const Text("Refer a friend", style: appBarTxtStyl),
          ),
          body: load == true
              ? loading()
              : RefreshIndicator(
                  onRefresh: details,
                  child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(children: [
                        Container(
                            color: Colors.white,
                            child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(children: [
                                        Expanded(
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                              const Text("Refer and Earn ₹100",
                                                  style: size22_600),
                                              h(15),
                                              const Text(
                                                  "They get ₹100 on signUp. You get ₹100 when they make their first order.",
                                                  style: size14_400Grey)
                                            ])),
                                        w(10),
                                        Image.asset("assets/Images/giftBox.png",
                                            height: 120)
                                      ]),
                                      h(20),
                                      copyContainer()
                                    ]))),
                        h(10),
                      ])),
                )),
    );
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
                "Invite your friends, earn much big. All you need to do is to login first.",
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

  Widget expnsion(String tit, String cont) {
    return const ExpansionTile(
      tilePadding: EdgeInsets.zero,
      // maintainState: false,
      title: Text(
        "What is SHE CONNECT invite friends Program?",
        style: size14_600,
      ),
      children: <Widget>[
        ListTile(
          title: Text(
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
            style: size14_400Grey,
          ),
        )
      ],
    );
  }

  shareApp() async {
    Share.share(
      "Hey! Check out this awesome app! " +
          link +
          ", Get ₹100 as bonus when you use my code " +
          ref +
          "!",
    );
  }

  Widget copyContainer() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: textFieldGrey),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Your Code:", style: size14_400Grey),
            load == true
                ? SizedBox(
                    child: CircularProgressIndicator(), height: 18, width: 18)
                : SelectableText(ref.toString(), style: size16_700),
            Wrap(
              spacing: 20,
              children: [
                GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(
                          text: "Hey! Check out this awesome app! " +
                              link +
                              ", Get ₹100 as bonus when you use my code " +
                              ref +
                              "!"));
                      showToastSuccess("Referral code copied to clipboard");
                    },
                    child: Icon(Icons.copy, size: 20, color: Colors.blueGrey)),
                GestureDetector(
                    onTap: () {
                      shareApp();
                    },
                    child: Icon(Icons.share_outlined,
                        size: 20, color: Colors.blueGrey))
              ],
            )
          ],
        ),
      ),
    );
  }
}
