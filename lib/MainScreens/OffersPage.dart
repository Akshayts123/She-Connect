import 'package:flutter/material.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Screens/OffersScreen.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class OffersPage extends StatefulWidget {
  const OffersPage({Key? key}) : super(key: key);

  @override
  _OffersPageState createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(title: Text("Offers", style: appBarTxtStyl), actions: [
        //   IconButton(
        //       onPressed: () {}, icon: Icon(Icons.favorite_border, size: 18)),
        //   IconButton(
        //       onPressed: () {},
        //       icon: Icon(Icons.shopping_cart_outlined, size: 18))
        // ]),
        body: Column(children: [
      DefaultTabController(
          length: 4,
          child: Expanded(
              child: Column(children: [
            TabBar(
                isScrollable: true,
                labelColor: darkPink,
                // padding: const EdgeInsets.all(5),
                indicator: DotIndicator(
                    color: darkPink,
                    distanceFromCenter: 16,
                    radius: 3,
                    paintingStyle: PaintingStyle.fill),
                labelStyle: const TextStyle(
                    color: darkPink,
                    fontSize: 15,
                    fontFamily: 'Segoe',
                    fontWeight: FontWeight.w900),
                unselectedLabelStyle: const TextStyle(
                    color: Color(0xff141215),
                    fontSize: 13,
                    fontFamily: 'Segoe',
                    fontWeight: FontWeight.w500),
                tabs: const [
                  Tab(text: "Today's Deals"),
                  Tab(text: "Ending Soon"),
                  Tab(text: "50% + Discount"),
                  Tab(text: "Hand Picked")
                ]),
            const Expanded(
                child: TabBarView(children: [
              OffersScreenTab(),
              OffersScreenTab(),
              OffersScreenTab(),
              OffersScreenTab()
            ]))
          ])))
    ]));
  }
}
