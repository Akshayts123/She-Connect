import 'package:flutter/material.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/TextConst.dart';

class OffersScreenTab extends StatefulWidget {
  const OffersScreenTab({Key? key}) : super(key: key);

  @override
  _OffersScreenTabState createState() => _OffersScreenTabState();
}

class _OffersScreenTabState extends State<OffersScreenTab> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, snapshot) {
      if (snapshot.maxWidth < 600) {
        return Container(
            child: GridView.builder(
                // physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 5,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 5,
                    childAspectRatio: MediaQuery.of(context).size.width * 0.5,
                    mainAxisExtent: MediaQuery.of(context).size.height * 0.35),
                itemBuilder: (BuildContext context, int index) {
                  return OffersList(index);
                }));
      } else {
        return Container(
            child: GridView.builder(
                // physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 11,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 5,
                    childAspectRatio: MediaQuery.of(context).size.width * 0.5,
                    mainAxisExtent: MediaQuery.of(context).size.height * 0.28),
                itemBuilder: (BuildContext context, int index) {
                  return TabletOffersList(index);
                }));
      }
    });
  }

  OffersList(int index) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.5,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Stack(children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.23,
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black12),
                      image: const DecorationImage(
                          image: NetworkImage(tstImg), fit: BoxFit.cover)),
                ),
                const Positioned(
                    bottom: 8,
                    right: 10,
                    child: Icon(Icons.favorite, color: Colors.white)),
                Positioned(
                    bottom: 10,
                    left: 10,
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: liteGrey),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 3),
                            child: Row(children: const [
                              Text("4.2", style: size12_400),
                              Icon(Icons.star, color: Colors.black, size: 13)
                            ]))))
              ]),
              const Text(
                "Bestima Cotton Bedsheeaa ansj abnxsjx xasxbn...",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: size14_700,
              ),
              Row(
                children: [
                  const Text(
                    rs + "399",
                    style: size16_400,
                  ),
                  w(10),
                  const Text(
                    rs + "699",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.lineThrough),
                  ),
                ],
              ),
              const Text("33% Discount", style: size16_400Green)
            ])));
  }

  TabletOffersList(int index) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.3,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Stack(children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.18,
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black12),
                      image: const DecorationImage(
                          image: NetworkImage(tstImg), fit: BoxFit.cover)),
                ),
                const Positioned(
                    bottom: 8,
                    right: 10,
                    child: Icon(Icons.favorite, color: Colors.white)),
                Positioned(
                    bottom: 10,
                    left: 10,
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: liteGrey),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 3),
                            child: Row(children: const [
                              Text("4.2", style: size12_400),
                              Icon(Icons.star, color: Colors.black, size: 13)
                            ]))))
              ]),
              const Text("Bestima Cotton Bedsheeaa ansj abnxsjx xasxbn...",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: size14_700),
              Row(
                children: [
                  const Text(rs + "399", style: size16_400),
                  w(10),
                  const Text(
                    rs + "699",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.lineThrough),
                  ),
                ],
              ),
              const Text("33% Discount", style: size16_400Green)
            ])));
  }
}
